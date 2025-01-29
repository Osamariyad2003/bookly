
import 'dart:io';
import 'package:bookly/core/dio_helper.dart';
import 'package:bookly/features/summrize/controller/summary_state.dart';
import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';




class SummaryCubit extends Cubit<SummaryState> {
  String? filePath; // File path for the uploaded PDF
  String summaryRange = 'Full'; // Default range for summarization
  String summaryTheme = ''; // Theme for the summary
  String summaryResult = '';
  File? outputFile;
  var pdf = pw.Document();


  SummaryCubit() : super(SummaryInitial());

  void pickFile(String? pickedFilePath) {
    filePath = pickedFilePath;
    if (filePath != null) {
      emit(SummaryFilePicked(filePath: filePath!));
    } else {
      emit(SummaryError(errorMessage: "No file selected."));
    }
  }

  /// Update the range for summarization
  void updateRange(String range) {
    summaryRange = range;
    emit(SummaryRangeUpdated(summaryRange: range));
  }

  void updateTheme(String theme) {
    summaryTheme = theme;
    emit(SummaryThemeUpdated(summaryTheme: theme));
  }

  Future<void> summarize() async {
    if (filePath == null) {
      emit(SummaryError(errorMessage: "No file selected."));
      return;
    }

    if (summaryTheme.isEmpty) {
      emit(SummaryError(errorMessage: "No theme selected."));
      return;
    }

    emit(SummaryLoading());
    try {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(filePath!),
        "type": summaryRange,
      });

      // Send POST request to the backend
      Response response = await DioHelper.postData(
          url: 'http://192.168.1.78:5000/summarize', data: formData);

      if (response.statusCode == 200) {
        if (response.data.containsKey('summary')) {
          summaryResult = response.data['summary'];
          emit(SummarySuccess());
        } else {
          emit(SummaryError(
              errorMessage: "Invalid response format from server."));
        }
      } else {
        // Handle non-200 responses
        emit(SummaryError(
          errorMessage: response.data['error'] ?? "Unknown error occurred.",
        ));
      }
    } catch (e) {
      emit(SummaryError(errorMessage: "Failed to generate summary: $e"));
    }
  }



  Future<void> downloadSummary() async {
    if (summaryResult.isEmpty) {
      emit(SummaryError(errorMessage: "No summary available to download."));
      return;
    }

    emit(SummaryLoading());

    try {
      // 1. Request storage permission on Android (optional, but often needed)
      if (Platform.isAndroid) {
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          throw Exception("Storage permission denied");
        }
      }

      // 2. Create a PDF document in memory
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Padding(
            padding: const pw.EdgeInsets.all(20),
            child: pw.Text(
              summaryResult,
              style: pw.TextStyle(fontSize: 14),
            ),
          ),
        ),
      );

      // 3. Determine where to save the file
      late String filePath;
      if (Platform.isAndroid) {
        // Use external_path to get the public Downloads directory
        final downloadsPath = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS,
        );
        filePath = "$downloadsPath/summary.pdf";
      } else if (Platform.isIOS) {
        // iOS does not have a shared Downloads folder; use the app’s Documents directory
        final directory = await getApplicationDocumentsDirectory();
        filePath = "${directory.path}/summary.pdf";
      } else {
        // Fallback for other platforms (e.g., desktop, web)
        final directory = await getApplicationDocumentsDirectory();
        filePath = "${directory.path}/summary.pdf";
      }

      // 4. Write the PDF bytes to the file
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      emit(SummaryDownload(downloadPath: filePath));
    } catch (e) {
      emit(SummaryError(errorMessage: "Failed to download summary as PDF: $e"));
    }
  }}