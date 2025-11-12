import '../models/book_model.dart';

class ReaderState {
  final BookModel? book;
  final int currentPageIndex;
  final bool isLoading;
  final String? error;

  ReaderState({
    this.book,
    this.currentPageIndex = 0,
    this.isLoading = false,
    this.error,
  });

  ReaderState copyWith({
    BookModel? book,
    int? currentPageIndex,
    bool? isLoading,
    String? error,
  }) {
    return ReaderState(
      book: book ?? this.book,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
