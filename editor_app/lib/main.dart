import 'dart:convert';
import 'dart:io';


import 'package:editor_app/wigets/canvas_view.dart';
import 'package:editor_app/wigets/preview_panel.dart';
import 'package:editor_app/wigets/toolbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bloc/page_cubit.dart';
import 'bloc/page_state.dart';
import 'models/page_model.dart';

void main() {
  runApp(const EditorApp());
}

class EditorApp extends StatelessWidget {
  const EditorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PageCubit.initial(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Editor App',
        theme: ThemeData(
          useMaterial3: true,
          textTheme: GoogleFonts.dmSansTextTheme(),
          scaffoldBackgroundColor: Colors.grey[50],
          
        ),
        home: const EditorHome(),
      ),
    );
  }
}

class EditorHome extends StatelessWidget {
  const EditorHome({super.key});

  Future<void> _exportJson(BuildContext context) async {
    final state = context.read<PageCubit>().state;
    final book = state.book;
    final jsonStr = jsonEncode(book.toJson());
    try {
      final safeName = '${book.title.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_')}.json';
      final path = await FilePicker.platform.saveFile(
        dialogTitle: 'Export Book JSON',
        fileName: safeName,
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      if (path == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Export cancelled')));
        return;
      }
      final f = File(path);
      await f.writeAsString(jsonStr);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saved JSON to ${f.path}')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Export failed: $e')));
    }
  }

  Future<void> _importImage(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null) return;
    final path = result.files.single.path;
    if (path == null) return;
    context.read<PageCubit>().addWidget(WidgetData.image('file://$path'));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PageCubit, PageState>(builder: (context, state) {
      final page = state.currentPage;
      return Scaffold(
        appBar: AppBar(
          title: const Text('Editor — Book Creator'),
          actions: [
            TextButton.icon(
              onPressed: () => _exportJson(context),
              icon: const Icon(Icons.save, color: Colors.black),
              label: const Text('Export', style: TextStyle(color: Colors.black)),
            ),
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => Dialog(
                    child: SizedBox(
                      width: 900,
                      height: 700,
                      child: CanvasPreviewDialog(page: page),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.remove_red_eye, color: Colors.black),
              label: const Text('Preview', style: TextStyle(color: Colors.black)),
            ),
            const SizedBox(width: 12),
          ],
        ),
        body: Row(
          children: [
            // Left toolbar
            SizedBox(
              width: 300,
              child: Toolbar(onImportImage: () => _importImage(context)),
            ),

            // Center canvas
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                    ),
                    child: Container(
                      width: page.pageSizeX.toDouble(),
                      height: page.pageSizeY.toDouble(),
                      padding: const EdgeInsets.all(24),
                      color: Colors.white,
                      child: const CanvasView(),
                    ),
                  ),
                ),
              ),
            ),

            // Right preview panel
            SizedBox(width: 320, child: const PreviewPanel()),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.read<PageCubit>().addPage(),
          icon: const Icon(Icons.add),
          label: const Text('Add Page'),
        ),
      );
    });
  }
}

class CanvasPreviewDialog extends StatelessWidget {
  final PageModel page;
  const CanvasPreviewDialog({required this.page, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        Text(page.pageTitle, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              width: page.pageSizeX.toDouble(),
              height: page.pageSizeY.toDouble(),
              color: Colors.white,
              child: const CanvasView(readOnly: true),
            ),
          ),
        ),
      ]),
    );
  }
}
