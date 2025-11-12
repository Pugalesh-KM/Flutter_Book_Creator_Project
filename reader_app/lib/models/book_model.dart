import 'page_model.dart';

class BookModel {
  final String title;
  final List<PageModel> pages;

  BookModel({required this.title, required this.pages});

  factory BookModel.fromJson(Map<String, dynamic> json) {
    final pages = (json['pages'] as List)
        .map((e) => PageModel.fromJson(e))
        .toList();
    return BookModel(title: json['title'], pages: pages);
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'pages': pages.map((e) => e.toJson()).toList(),
  };
}
