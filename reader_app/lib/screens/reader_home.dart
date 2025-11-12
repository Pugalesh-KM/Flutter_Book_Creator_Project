import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import '../bloc/reader_cubit.dart';
import '../bloc/reader_state.dart';
import '../models/widget_model.dart';

class ReaderHome extends StatelessWidget {
  const ReaderHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReaderCubit, ReaderState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Reader App'),
            actions: [
              IconButton(
                icon: const Icon(Icons.folder_open),
                onPressed: () => context.read<ReaderCubit>().loadJson(),
              ),
            ],
          ),
          body: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : state.book == null
              ? const Center(child: Text('Click “Load JSON” to open a book'))
              : _buildBookView(context, state),
        );
      },
    );
  }

  Widget _buildBookView(BuildContext context, ReaderState state) {
    final page = state.book!.pages[state.currentPageIndex];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(page.pageTitle, style: Theme.of(context).textTheme.titleLarge),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: page.widgets.map((w) => _buildWidget(w)).toList(),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(onPressed: context.read<ReaderCubit>().previousPage, icon: const Icon(Icons.chevron_left)),
            Text('Page ${state.currentPageIndex + 1}/${state.book!.pages.length}'),
            IconButton(onPressed: context.read<ReaderCubit>().nextPage, icon: const Icon(Icons.chevron_right)),
          ],
        ),
      ],
    );
  }

  Widget _buildWidget(WidgetData data) {
    switch (data.type) {
      case 'Text':
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            data.props['text'] ?? '',
            style: TextStyle(
              fontSize: (data.props['fontSize'] ?? 16).toDouble(),
              color: Color(int.parse(data.props['color'].toString().replaceFirst('#', '0xff'))),
            ),
          ),
        );
      case 'Image':
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Image.network(data.props['url'], fit: BoxFit.cover),
        );
      case 'Video':
        final controller = VideoPlayerController.network(data.props['url']);
        final chewieController = ChewieController(videoPlayerController: controller, autoPlay: false, looping: false);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: SizedBox(height: 200, child: Chewie(controller: chewieController)),
        );
      case 'LiveData':
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text('🌦️ Live Weather: 30°C (Mock Data)'),
        );
      default:
        return const SizedBox();
    }
  }
}
