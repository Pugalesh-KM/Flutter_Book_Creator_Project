import 'dart:io';

import 'package:editor_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/page_cubit.dart';
import '../models/page_model.dart';

class PreviewPanel extends StatelessWidget {
  const PreviewPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PageCubit, dynamic>(
      builder: (context, state) {
        final book = state.book as BookModel;
        final current = state.currentIndex as int;
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    book.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: book.pages.length,
                  itemBuilder: (ctx, idx) {
                    final page = book.pages[idx];
                    return GestureDetector(
                      onTap: () => context.read<PageCubit>().setPage(idx),
                      child: Card(
                        color: idx == current
                            ? Colors.blue.shade50
                            : Colors.white,
                        child: ListTile(
                          leading: _thumb(page),
                          title: Text(page.pageTitle),
                          subtitle: Text('${page.widgets.length} items'),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                            onPressed: () =>
                                context.read<PageCubit>().deletePage(idx),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _thumb(PageModel page) {
    final img = page.widgets.firstWhere(
      (w) => w.type == 'Image',
      orElse: () => WidgetData.text(''),
    );
    if (img.type == 'Image') {
      final url = img.props['url'] ?? '';
      if (url.startsWith('file://')) {
        return SizedBox(
          width: 56,
          child: Image.file(
            File(url.replaceFirst('file://', '')),
            fit: BoxFit.cover,
          ),
        );
      } else if (url.isNotEmpty) {
        return SizedBox(
          width: 56,
          child: Image.network(url, fit: BoxFit.cover),
        );
      }
    }
    return const SizedBox(width: 56, child: Icon(Icons.description));
  }
}
