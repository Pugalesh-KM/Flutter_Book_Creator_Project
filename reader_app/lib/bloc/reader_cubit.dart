import 'dart:convert';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import '../models/book_model.dart';
import 'reader_state.dart';

class ReaderCubit extends Cubit<ReaderState> {
  ReaderCubit() : super(ReaderState());

  Future<void> loadJson() async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['json']);
      if (result == null) {
        emit(state.copyWith(isLoading: false));
        return;
      }

      final filePath = result.files.single.path!;
      final content = await File(filePath).readAsString();
      final data = jsonDecode(content);
      final book = BookModel.fromJson(data);

      emit(state.copyWith(book: book, isLoading: false, currentPageIndex: 0));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void nextPage() {
    if (state.book == null) return;
    final next = state.currentPageIndex + 1;
    if (next < state.book!.pages.length) {
      emit(state.copyWith(currentPageIndex: next));
    }
  }

  void previousPage() {
    if (state.currentPageIndex > 0) {
      emit(state.copyWith(currentPageIndex: state.currentPageIndex - 1));
    }
  }
}
