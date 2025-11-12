import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/page_cubit.dart';
import '../models/page_model.dart';

class Toolbar extends StatefulWidget {
  final VoidCallback onImportImage;

  const Toolbar({required this.onImportImage, super.key});

  @override
  State<Toolbar> createState() => _ToolbarState();
}

class _ToolbarState extends State<Toolbar> {
  final TextEditingController _textCtrl = TextEditingController(
    text: 'Heading',
  );
  int _fontSize = 18;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PageCubit>();
    final page = cubit.currentPage;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Editor Tools',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            const Text('Page Layout'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (page.layout != PageLayout.oneColumn)
                        cubit.toggleLayout();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: page.layout == PageLayout.oneColumn
                          ? Colors.blue
                          : Colors.grey[200],
                    ),
                    child: const Text(
                      'One column',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (page.layout != PageLayout.twoColumns)
                        cubit.toggleLayout();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: page.layout == PageLayout.twoColumns
                          ? Colors.blue
                          : Colors.grey[200],
                    ),
                    child: const Text(
                      'Two Columns',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Text('Text tool'),
            const SizedBox(height: 8),
            TextField(
              controller: _textCtrl,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Text',
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Size'),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () =>
                      setState(() => _fontSize = (_fontSize - 1).clamp(8, 72)),
                ),
                Text('$_fontSize'),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () =>
                      setState(() => _fontSize = (_fontSize + 1).clamp(8, 72)),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => cubit.addWidget(
                    WidgetData.text(_textCtrl.text, fontSize: _fontSize),
                  ),
                  child: const Text('Add'),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Text('Image'),
            ElevatedButton.icon(
              onPressed: widget.onImportImage,
              icon: const Icon(Icons.image),
              label: const Text('Import'),
            ),

            const SizedBox(height: 12),
            const Text('Video'),
            ElevatedButton.icon(
              onPressed: () async {
                final url = await _askForString(
                  context,
                  'Video URL',
                  'https://',
                );
                if (url != null && url.isNotEmpty)
                  cubit.addWidget(WidgetData.video(url));
              },
              icon: const Icon(Icons.video_collection),
              label: const Text('+ Video'),
            ),

            const SizedBox(height: 10),
            const Text('Live data'),
            ElevatedButton.icon(
              onPressed: () => cubit.addWidget(
                WidgetData.liveData('Weather: Thanjavur • 30°C'),
              ),
              icon: const Icon(Icons.cloud),
              label: const Text('Weather'),
            ),


            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () =>
                  cubit.addWidget(WidgetData.liveData('Location: Thanjavur')),
              icon: const Icon(Icons.location_on),
              label: const Text('Live location'),
            ),

            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => cubit.clearWidgets(),
              icon: const Icon(Icons.clear_all),
              label: const Text('Clear'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _askForString(
    BuildContext context,
    String title,
    String hint,
  ) async {
    String? value;
    await showDialog(
      context: context,
      builder: (ctx) {
        final c = TextEditingController(text: hint);
        return AlertDialog(
          title: Text(title),
          content: TextField(controller: c),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                value = c.text;
                Navigator.of(ctx).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
    return value;
  }
}
