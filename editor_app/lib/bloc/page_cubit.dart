
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/page_model.dart';
import 'page_state.dart';

class PageCubit extends Cubit<PageState> {
  PageCubit(super.initial);

  factory PageCubit.initial() {
    final p1 = PageModel.sample(title: 'Page 1');
    final book = BookModel(title: 'Untitled Book', pages: [p1]);
    return PageCubit(PageState(book: book, currentIndex: 0));
  }

  BookModel get book => state.book;
  PageModel get currentPage => state.currentPage;

  void addWidget(WidgetData w) {
    final updated = currentPage.copyWith(widgets: [...currentPage.widgets, w]);
    _replacePage(updated);
  }

  void removeWidgetAt(int idx) {
    final list = List<WidgetData>.from(currentPage.widgets)..removeAt(idx);
    _replacePage(currentPage.copyWith(widgets: list));
  }

  void moveWidget(int oldIndex, int newIndex) {
    final list = List<WidgetData>.from(currentPage.widgets);
    if (newIndex > oldIndex) newIndex -= 1;
    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);
    _replacePage(currentPage.copyWith(widgets: list));
  }

  void updateTitle(String title) => _replacePage(currentPage.copyWith(pageTitle: title));

  void updateSize(int x, int y) => _replacePage(currentPage.copyWith(pageSizeX: x, pageSizeY: y));

  void toggleLayout() {
    final layout = currentPage.layout == PageLayout.twoColumns ? PageLayout.oneColumn : PageLayout.twoColumns;
    _replacePage(currentPage.copyWith(layout: layout));
  }

  void addPage() {
    final newPage = PageModel.sample(title: 'Page ${book.pages.length + 1}');
    final newBook = book.copyWith(pages: [...book.pages, newPage]);
    emit(state.copyWith(book: newBook, currentIndex: newBook.pages.length - 1));
  }

  void deletePage(int idx) {
    final newPages = List<PageModel>.from(book.pages)..removeAt(idx);
    final newIdx = (state.currentIndex >= newPages.length) ? newPages.length - 1 : state.currentIndex;
    emit(state.copyWith(book: book.copyWith(pages: newPages), currentIndex: newIdx < 0 ? 0 : newIdx));
  }

  void setPage(int idx) => emit(state.copyWith(currentIndex: idx));

  void clearWidgets() => _replacePage(currentPage.copyWith(widgets: []));

  void _replacePage(PageModel updated) {
    final pages = List<PageModel>.from(book.pages);
    pages[state.currentIndex] = updated;
    emit(state.copyWith(book: book.copyWith(pages: pages)));
  }
}
