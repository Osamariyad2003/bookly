class Books {
  List<BookModel>? books;

  Books({this.books});

  Books.fromJson(Map<String, dynamic> json) {
    if (json['books'] != null) {
      books = <BookModel>[]; // Initialize the list of BookModel
      json['books'].forEach((v) {
        books!.add(BookModel.fromJson(v)); // Create BookModel objects from JSON
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.books != null) {
      data['books'] = this.books!.map((v) => v.toJson()).toList(); // Convert list of BookModel to JSON
    }
    return data;
  }
}


class BookModel {
  int? rank;
  String? publisher;
  String? description;
  String? price;
  String? title;
  String? author;

  String? bookImage;
  String? amazonProductUrl;
  String? bookReviewLink;
  List<BuyLinks>? buyLinks;

  BookModel({this.rank,
        this.publisher,
        this.description,
        this.price,
        this.title,
        this.author,
        this.bookImage,
        this.amazonProductUrl,
        this.bookReviewLink,
        this.buyLinks,});

  BookModel.fromJson(Map<String, dynamic> json) {
    rank = json['rank'];
    publisher = json['publisher'];
    description = json['description'];
    price = json['price'];
    title = json['title'];
    author = json['author'];
    bookImage = json['book_image'];
    amazonProductUrl = json['amazon_product_url'];
    bookReviewLink = json['book_review_link'];
    if (json['buy_links'] != null) {
      buyLinks = <BuyLinks>[];
      json['buy_links'].forEach((v) {
        buyLinks!.add(new BuyLinks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rank'] = this.rank;
    data['publisher'] = this.publisher;
    data['description'] = this.description;
    data['price'] = this.price;
    data['title'] = this.title;
    data['author'] = this.author;
    data['book_image'] = this.bookImage;

    data['amazon_product_url'] = this.amazonProductUrl;
    data['book_review_link'] = this.bookReviewLink;
    if (this.buyLinks != null) {
      data['buy_links'] = this.buyLinks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BuyLinks {
  String? name;
  String? url;

  BuyLinks({this.name, this.url});

  BuyLinks.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }
}