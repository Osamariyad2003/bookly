import logging
import os
import tempfile
import uuid
from flask_jwt_extended import JWTManager, create_access_token, jwt_required, get_jwt_identity
from flask_sqlalchemy import SQLAlchemy

from multiprocessing import Pool
import PyPDF2
import bcrypt
from flask import Flask, request, jsonify
from fpdf import FPDF
from transformers import AutoTokenizer, AutoModelForSeq2SeqLM

app = Flask(__name__)

logging.basicConfig(level=logging.INFO)

MAX_TOKENS = 16384
CHUNK_SIZE = 16000
BATCH_SIZE = 8
NUM_PROCESSES = 8

# Configure SQLite
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///app1.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    password = db.Column(db.String(120), nullable=False)
    email = db.Column(db.String(120), nullable=False)
    phone = db.Column(db.String(15), nullable=False)

    def __repr__(self):
        return f'<User {self.username}>'


def load_longt5():
    """
    Loads and returns the LongT5 tokenizer and model.
    """
    tokenizer = AutoTokenizer.from_pretrained("google/long-t5-tglobal-base")
    model = AutoModelForSeq2SeqLM.from_pretrained("google/long-t5-tglobal-base")
    return tokenizer, model

def extract_text_from_pdf(file_path: str) -> tuple[str, int]:
    try:
        with open(file_path, 'rb') as file:
            reader = PyPDF2.PdfReader(file)
            text = "".join(page.extract_text() or "" for page in reader.pages)
            word_count = len(text.split())  # Count words
        # Re-encode to avoid weird characters
        return text.encode('utf-8', errors='ignore').decode('utf-8'), word_count
    except Exception as e:
        logging.error(f"Error extracting text from PDF: {str(e)}")
        raise

def chunk_text(text: str, chunk_size: int = CHUNK_SIZE) -> list[str]:
    """
    Splits text into chunks of approximately `chunk_size` characters.
    """
    return [text[i:i + chunk_size] for i in range(0, len(text), chunk_size)]

def summarize_chunks_in_batches(chunks, tokenizer, model, batch_size=BATCH_SIZE):
    """
    Summarizes chunks in batches to improve efficiency.
    """
    summaries = []
    for i in range(0, len(chunks), batch_size):
        batch = chunks[i:i + batch_size]
        inputs = tokenizer(
            ["summarize: " + chunk for chunk in batch],
            return_tensors="pt",
            padding=True,
            truncation=True,
            max_length=MAX_TOKENS
        )
        outputs = model.generate(
            inputs.input_ids,
            max_length=500,
            min_length=100,
            no_repeat_ngram_size=3
        )
        summaries.extend(tokenizer.batch_decode(outputs, skip_special_tokens=True))
    return summaries

def summarize_chunk_parallel(args):
    """
    Wrapper for parallel processing of a single chunk.
    """
    chunk, tokenizer, model = args
    return summarize_chunks_in_batches([chunk], tokenizer, model)[0]

def combine_and_summarize(summaries, tokenizer, model):
    """
    Combines chunk summaries and re-summarizes if necessary.
    """
    combined_text = " ".join(summaries)
    if len(combined_text.split()) > MAX_TOKENS:
        return summarize_chunks_in_batches([combined_text], tokenizer, model)[0]
    return combined_text
def generate_pdf(summary_text: str, output_file: str) -> None:
    """
    Converts the final summary into a PDF.
    """
    try:
        pdf = FPDF()
        pdf.set_auto_page_break(auto=True, margin=15)
        pdf.add_page()
        pdf.set_font('Arial', '', 12)
        pdf.multi_cell(0, 10, summary_text)
        pdf.output(output_file)
    except Exception as e:
        logging.error(f"Error creating PDF: {str(e)}")
        raise

@app.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')
    email = data.get('email')      # Add name field
    phone = data.get('phone')    # Add phone field

    if not username or not password or not email or not phone:
        return jsonify({"error": "Username, password, name, and phone are required"}), 400

    # Validate phone format (basic example)
    if not phone.isdigit() or len(phone) < 8 or len(phone) > 15:
        return jsonify({"error": "Phone number must be numeric and between 8 to 15 characters"}), 400

    # Check if the username already exists
    if User.query.filter_by(username=username).first():
        return jsonify({"error": "Username already exists"}), 400

    # Hash the password
    hashed_password = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())

    # Insert the user into the database
    new_user = User(username=username, password=hashed_password.decode('utf-8'), email=email, phone=phone)
    db.session.add(new_user)
    db.session.commit()

    return jsonify({"message": "User registered successfully"}), 201

@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')

    if not username or not password:
        return jsonify({"error": "Username and password are required"}), 400

    user = User.query.filter_by(username=username).first()

    if not user or not bcrypt.checkpw(password.encode('utf-8'), user.password.encode('utf-8')):
        return jsonify({"error": "Invalid credentials"}), 401

    access_token = create_access_token(identity={"username": username})
    return jsonify({"access_token": access_token}), 200

@app.route('/protected', methods=['GET'])
@jwt_required()
def protected():
    current_user = get_jwt_identity()
    return jsonify({"message": f"Welcome, {current_user['username']}!"}), 200
@app.route('/user', methods=['GET'])
@jwt_required()
def get_user_data():
    """
    Get data for the currently authenticated user.
    We assume your token identity looks like {"username": "someusername"}
    and we use that username to query the DB.
    """
    # Extract the user identity from the JWT
    current_user = get_jwt_identity()  # e.g. {"username": "someusername"}

    # Retrieve the user from the database using the 'username' from JWT
    user_record = User.query.filter_by(username=current_user['username']).first()

    if not user_record:
        return jsonify({"error": "User not found"}), 404

    # Avoid returning sensitive info like passwords
    user_data = {
        "id": user_record.id,
        "username": user_record.username,
        "email": user_record.email,
        "phone": user_record.phone
    }

    return jsonify(user_data), 200

@app.route('/summarize', methods=['POST'])
def summarize_pdf():
    try:
        if 'file' not in request.files:
            return jsonify({"error": "Missing file"}), 400

        file = request.files['file']

        # Load LongT5 model and tokenizer
        tokenizer, model = load_longt5()

        # Save uploaded file in a temporary directory
        with tempfile.TemporaryDirectory() as temp_dir:
            temp_pdf_path = os.path.join(temp_dir, "uploaded.pdf")
            file.save(temp_pdf_path)

            # Extract text and word count
            text, word_count = extract_text_from_pdf(temp_pdf_path)

            # Split text into manageable chunks
            chunks = chunk_text(text, chunk_size=CHUNK_SIZE)

            # Summarize chunks in parallel
            with Pool(processes=NUM_PROCESSES) as pool:
                chunk_summaries = pool.map(
                    summarize_chunk_parallel,
                    [(chunk, tokenizer, model) for chunk in chunks]
                )

            # Combine summaries and finalize
            final_summary = combine_and_summarize(chunk_summaries, tokenizer, model)

        # Return the summary as JSON
        return jsonify({"summary": final_summary}), 200

    except Exception as e:
        logging.error(f"Summarization error: {e}")
        return jsonify({"error": f"An unexpected error occurred: {str(e)}"}), 500


if __name__ == '__main__':
    with app.app_context():  # Ensure the application context is set up
        db.create_all()      # Create database tables
    app.run(host=os.getenv('FLASK_RUN_HOST', '0.0.0.0'),
            port=int(os.getenv('FLASK_RUN_PORT', 5000)),
            debug=True)



# # # Database Configuration
# # DB_SERVER = os.getenv('DB_SERVER', 'booklyusers.database.windows.net')
# # DB_NAME = os.getenv('DB_NAME', 'Users')
# # DB_USER = os.getenv('DB_USER', 'Osama_Bookly')
# # DB_PASSWORD = os.getenv('DB_PASSWORD', 'Admin2003@')
# # connection_string = (
# #     f"DRIVER={{ODBC Driver 18 for SQL Server}};"
# #     f"SERVER={DB_SERVER};DATABASE={DB_NAME};UID={DB_USER};PWD={DB_PASSWORD};"
# #     "Encrypt=yes;TrustServerCertificate=no;Timeout=60;"
# # )
# # try:
# #     conn = pyodbc.connect(connection_string)
# #     logging.info("Database connection established.")
# # except pyodbc.OperationalError as e:
# #     logging.error(f"OperationalError: {str(e)}")
# #     raise
# # except Exception as e:
# #     logging.error(f"General database connection error: {str(e)}")
# #     raise
# #
# #
# # # Azure AD Configuration
# # CLIENT_ID = os.getenv('CLIENT_ID', 'f93200c0-9783-492e-89fb-f0a78d353854')
# # CLIENT_SECRET = os.getenv('CLIENT_SECRET', 'j4k8Q~N0oTzQs~1hsVU0YwZi_h38jYQ4UoPKJcye')
# # TENANT_ID = os.getenv('TENANT_ID', '4376abc9-687d-4290-9df5-e8adaf08413c')
# # AUTHORITY = f'https://login.microsoftonline.com/{TENANT_ID}'
#
# MAX_TOKENS = 16384  # LongT5's input token limit
# CHUNK_SIZE = 16000  # Approx chunk size
#
# def load_longt5():
#     """
#     Loads and returns the LongT5 tokenizer and model.
#     (No code runs on import; only when this function is called explicitly.)
#     """
#     tokenizer = AutoTokenizer.from_pretrained("google/long-t5-tglobal-base")
#     model = AutoModelForSeq2SeqLM.from_pretrained("google/long-t5-tglobal-base")
#     return tokenizer, model
#
# def extract_text_from_pdf(file_path: str) -> tuple[str, int]:
#     """
#     Extracts text and word count from a PDF.
#     """
#     try:
#         with open(file_path, 'rb') as file:
#             reader = PyPDF2.PdfReader(file)
#             text = "".join(page.extract_text() or "" for page in reader.pages)
#             word_count = len(text.split())  # Count words
#         # Re-encode to avoid weird characters
#         return text.encode('utf-8', errors='ignore').decode('utf-8'), word_count
#     except Exception as e:
#         logging.error(f"Error extracting text from PDF: {str(e)}")
#         raise
#
# def chunk_text(text: str, chunk_size: int = CHUNK_SIZE) -> list[str]:
#     """
#     Splits text into chunks of approximately `chunk_size` characters.
#     """
#     return [text[i:i + chunk_size] for i in range(0, len(text), chunk_size)]
#
# def summarize_chunk(chunk: str, tokenizer, model) -> str:
#     """
#     Summarizes a single chunk of text using LongT5.
#     """
#
#     try:
#         inputs = tokenizer(
#             "summarize: " + chunk,
#             return_tensors="pt",
#             max_length=MAX_TOKENS,
#             truncation=True
#         )
#         # Tweak generation parameters as needed
#         outputs = model.generate(
#             inputs.input_ids,
#             max_length=500,
#             min_length=100,
#             no_repeat_ngram_size=3
#         )
#         return tokenizer.decode(outputs[0], skip_special_tokens=True)
#     except Exception as e:
#         logging.error(f"Error summarizing chunk: {str(e)}")
#         raise
#
# def combine_and_summarize(summaries: list[str], tokenizer, model) -> str:
#     """
#     Combines chunk summaries and optionally re-summarizes them if too long.
#     """
#     combined_text = " ".join(summaries)
#     # If combined text is longer than LongT5 can handle again, do another pass
#     if len(combined_text.split()) > MAX_TOKENS:
#         return summarize_chunk(combined_text, tokenizer, model)
#     return combined_text
#
# def generate_pdf(summary_text: str, output_file: str) -> None:
#     """
#     Converts the final summary into a PDF.
#     """
#     try:
#         pdf = FPDF()
#         pdf.set_auto_page_break(auto=True, margin=15)
#         pdf.add_page()
#         pdf.set_font('Arial', '', 12)
#         pdf.multi_cell(0, 10, summary_text)
#         pdf.output(output_file)
#     except Exception as e:
#         logging.error(f"Error creating PDF: {str(e)}")
#         raise
#
#
#
#
#
#
# # @app.route('/login', methods=['POST'])
# # def login():
# #     try:
# #         data = request.json
# #         email = data.get('email')
# #         password = data.get('password')
# #
# #         if not email or not password:
# #             return jsonify({"error": "Email and Password are required"}), 400
# #         cursor = conn.cursor()
# #         cursor.execute("SELECT id, pass FROM Users WHERE email = ?", (email,))
# #         user = cursor.fetchone()
# #
# #         if not user:
# #             return jsonify({"error": "Invalid email or password"}), 401
# #
# #         user_id, hashed_password = user
# #
# #         # Verify the password
# #         if not bcrypt.checkpw(password.encode('utf-8'), hashed_password.encode('utf-8')):
# #             return jsonify({"error": "Invalid email or password"}), 401
# #
# #         # Generate a session token (or use JWT for production)
# #         session_token = str(uuid.uuid4())
# #
# #         return jsonify({
# #             "message": "Login successful",
# #             "user_id": user_id,
# #             "session_token": session_token
# #         }), 200
# #     except Exception as e:
# #         logging.error(f"Login error: {str(e)}")
# #         return jsonify({"error": str(e)}), 500
# #
# # @app.route('/register', methods=['POST'])
# # def register():
# #     try:
# #         data = request.json
# #         name = data.get('name')
# #         email = data.get('email')
# #         phone = data.get('phone')
# #         password = data.get('pass')
# #         summ_time = data.get('Summtime', 4)
# #
# #         if not all([name, email, phone, password]):
# #             return jsonify({"error": "Name, email, phone, and password are required"}), 400
# #         if '@' not in email:
# #             return jsonify({"error": "Invalid email format"}), 400
# #
# #         hashed_password = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())
# #         user_id = str(uuid.uuid4())
# #
# #         cursor = conn.cursor()
# #         cursor.execute(
# #             """
# #             INSERT INTO Users (id, name, email, phone, pass, Summtime)
# #             VALUES (?, ?, ?, ?, ?, ?)
# #             """,
# #             (user_id, name, email, phone, hashed_password.decode('utf-8'), summ_time)
# #         )
# #         conn.commit()
# #         return jsonify({"message": "User registered successfully"}), 201
# #     except Exception as e:
# #         logging.error(f"Registration error: {str(e)}")
# #         return jsonify({"error": str(e)}), 500
# # @app.route('/users', methods=['GET'])
# # def get_users():
# #     try:
# #         cursor = conn.cursor()
# #         cursor.execute("SELECT id, name, email, phone, pass, Summtime FROM Users")
# #         users = [
# #             {
# #                 "id": row[0],
# #                 "name": row[1],
# #                 "email": row[2],
# #                 "phone": row[3],
# #                 "password": row[4],
# #                 "Summtime": row[5]
# #             }
# #             for row in cursor.fetchall()
# #         ]
# #         return jsonify(users), 200
# #     except Exception as e:
# #         logging.error(f"Error retrieving users: {str(e)}")
# #         return jsonify({"error": str(e)}), 500
#
# @app.route('/summarize', methods=['POST'])
# def summarize_pdf():
#     try:
#         if 'file' not in request.files or 'type' not in request.form:
#             return jsonify({"error": "Missing file or summary type"}), 400
#
#         file = request.files['file']
#         summary_type = request.form['type']  # Not used but kept for flexibility
#
#         # Save the uploaded file in a temporary directory
#         with tempfile.TemporaryDirectory() as temp_dir:
#             temp_pdf_path = os.path.join(temp_dir, "uploaded.pdf")
#             file.save(temp_pdf_path)
#
#             # Extract text and word count
#             text, word_count = extract_text_from_pdf(temp_pdf_path)
#
#             # Chunk the text if necessary
#             chunks = chunk_text(text, chunk_size=16000)
#
#             # Summarize each chunk
#             chunk_summaries = [summarize_chunk(chunk) for chunk in chunks]
#
#             # Combine and finalize the summary
#             final_summary = combine_and_summarize(chunk_summaries)
#
#             # Save the summary to a PDF
#             output_file_path = os.path.join(temp_dir, "summary.pdf")
#             generate_pdf(final_summary, output_file_path)
#
#         # Return the summary and a link to the generated PDF
#         return jsonify({
#             "summary": final_summary,
#         }), 200
#
#     except Exception as e:
#         logging.error(f"Summarization error: {e}")
#         return jsonify({"error": f"An unexpected error occurred: {str(e)}"}), 500
#
#
#     except Exception as e:
#         logging.error(f"Summarization error: {e}")
#         return jsonify({"error": f"An unexpected error occurred: {str(e)}"}), 500
#
#     except Exception as e:
#         logging.error(f"Summarization error: {e}")
#         return jsonify({"error": f"An unexpected error occurred: {str(e)}"}), 500
#
# if __name__ == '__main__':
#     app.run(host=os.getenv('FLASK_RUN_HOST', '0.0.0.0'),
#             port=int(os.getenv('FLASK_RUN_PORT', 5000)),
#             debug=True)
#
#
#
#
