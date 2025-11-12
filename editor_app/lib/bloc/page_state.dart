import '../models/page_model.dart';

class PageState {
  final BookModel book;
  final int currentIndex;

  PageState({required this.book, required this.currentIndex});

  PageModel get currentPage => book.pages[currentIndex];

  PageState copyWith({BookModel? book, int? currentIndex}) {
    return PageState(book: book ?? this.book, currentIndex: currentIndex ?? this.currentIndex);
  }
}
