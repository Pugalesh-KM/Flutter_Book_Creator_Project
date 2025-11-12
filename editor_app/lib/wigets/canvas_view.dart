import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/page_cubit.dart';
import '../models/page_model.dart';

class CanvasView extends StatelessWidget {
  final bool readOnly;
  const CanvasView({this.readOnly = false, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PageCubit, dynamic>(builder: (context, state) {
      final page = state.currentPage as PageModel;
      if (page.layout == PageLayout.oneColumn) {
        return _oneColumn(context, page.widgets);
      } else {
        return _twoColumns(context, page.widgets);
      }
    });
  }

  Widget _oneColumn(BuildContext ctx, List<WidgetData> ws) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: ws.asMap().entries.map((e) {
      return Padding(padding: const EdgeInsets.symmetric(vertical: 8.0), child: _render(ctx, e.value, e.key));
    }).toList());
  }

  Widget _twoColumns(BuildContext ctx, List<WidgetData> ws) {
    final left = <Widget>[];
    final right = <Widget>[];
    for (var i = 0; i < ws.length; i++) {
      if (i % 2 == 0) left.add(_render(ctx, ws[i], i));
      else right.add(_render(ctx, ws[i], i));
    }
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(child: Column(children: left)),
      const SizedBox(width: 12),
      Expanded(child: Column(children: right)),
    ]);
  }

  Widget _render(BuildContext ctx, WidgetData w, int idx) {
    final cubit = ctx.read<PageCubit>();
    switch (w.type) {
      case 'Text':
        final txt = w.props['text'] ?? '';
        final size = (w.props['fontSize'] ?? 16).toDouble();
        return Row(children: [
          Expanded(child: Text(txt, style: TextStyle(fontSize: size))),
          if (!readOnly) IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => cubit.removeWidgetAt(idx))
        ]);
      case 'Image':
        final url = w.props['url'] ?? '';
        Widget img;
        if (url.startsWith('file://')) {
          img = Image.file(File(url.replaceFirst('file://', '')), fit: BoxFit.cover);
        } else {
          img = Image.network(url, fit: BoxFit.cover);
        }
        return Stack(children: [
          ClipRRect(borderRadius: BorderRadius.circular(6), child: SizedBox(height: 220, width: double.infinity, child: img)),
          if (!readOnly)
            Positioned(right: 4, top: 4, child: IconButton(icon: const Icon(Icons.delete, color: Colors.white), onPressed: () => cubit.removeWidgetAt(idx)))
        ]);
      case 'Video':
        return Container(height: 180, color: Colors.black12, child: const Center(child: Icon(Icons.play_circle_outline, size: 48)));
      case 'LiveData':
        return Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.pink.shade50, borderRadius: BorderRadius.circular(6)), child: Row(children: [Expanded(child: Text(w.props['data'] ?? '')), if (!readOnly) IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => cubit.removeWidgetAt(idx))]));
      default:
        return const SizedBox.shrink();
    }
  }
}
