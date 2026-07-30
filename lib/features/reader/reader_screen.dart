import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/di/providers.dart';
import '../../shared/models/comic.dart';
import 'widgets/reader_controls.dart';

class ReaderScreen extends ConsumerStatefulWidget {
  const ReaderScreen({
    super.key,
    required this.comicId,
    this.initialChapter = 0,
  });

  final String comicId;
  final int initialChapter;

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  late int _currentChapterIndex;
  late int _currentPageIndex;
  late PageController _pageController;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _currentChapterIndex = widget.initialChapter;

    // Load saved progress if exists
    final progress = ref.read(readingHistoryProvider.notifier).getProgress(widget.comicId);
    if (progress != null && progress.chapterIndex == _currentChapterIndex) {
      _currentPageIndex = progress.pageIndex;
    } else {
      _currentPageIndex = 0;
    }

    _pageController = PageController(initialPage: _currentPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index, Comic comic) {
    setState(() => _currentPageIndex = index);
    ref.read(readingHistoryProvider.notifier).updateProgress(
      widget.comicId,
      _currentChapterIndex,
      index,
    );
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
  }

  void _onChapterSelected(int index) {
    setState(() {
      _currentChapterIndex = index;
      _currentPageIndex = 0;
    });
    _pageController.jumpToPage(0);
    ref.read(readingHistoryProvider.notifier).updateProgress(
      widget.comicId,
      index,
      0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final comicVal = ref.watch(comicByIdProvider(widget.comicId));
    final readingDir = ref.watch(readingDirectionProvider);
    final readerMode = ref.watch(readerModeProvider);

    Color bg;
    switch (readerMode) {
      case ReaderMode.night:
        bg = Colors.black;
      case ReaderMode.sepia:
        bg = const Color(0xFFF4ECD8);
      default:
        bg = AppColors.backgroundDark;
    }

    return Scaffold(
      backgroundColor: bg,
      body: comicVal.when(
        data: (comic) {
          if (comic == null) {
            return const Center(child: Text('Comic not found'));
          }

          final chapter = comic.chapters[_currentChapterIndex];
          final pages = chapter.pages;

          if (pages.isEmpty) {
            return const Center(child: Text('This chapter has no pages.'));
          }

          final isVertical = readingDir == ReadingDirection.vertical;
          final isRtl = readingDir == ReadingDirection.rtl;

          return Stack(
            children: [
              // Interactive Page Gallery
              GestureDetector(
                onTap: _toggleControls,
                child: isVertical
                    ? ListView.builder(
                        itemCount: pages.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final page = pages[index];
                          return page.startsWith('http')
                              ? Image.network(
                                  page,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => _ImageErrorPlaceholder(),
                                )
                              : Image.asset(
                                  'assets/$page',
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => _ImageErrorPlaceholder(),
                                );
                        },
                      )
                    : PhotoViewGallery.builder(
                        scrollPhysics: const BouncingScrollPhysics(),
                        builder: (context, index) {
                          final page = pages[index];
                          final provider = page.startsWith('http')
                              ? NetworkImage(page) as ImageProvider
                              : AssetImage('assets/$page') as ImageProvider;
                          return PhotoViewGalleryPageOptions(
                            imageProvider: provider,
                            initialScale: PhotoViewComputedScale.contained,
                            minScale: PhotoViewComputedScale.contained * 0.8,
                            maxScale: PhotoViewComputedScale.covered * 2.5,
                            errorBuilder: (_, __, ___) => _ImageErrorPlaceholder(),
                          );
                        },
                        itemCount: pages.length,
                        loadingBuilder: (context, event) => const Center(
                          child: CircularProgressIndicator(color: AppColors.primaryPurple),
                        ),
                        backgroundDecoration: BoxDecoration(color: bg),
                        pageController: _pageController,
                        onPageChanged: (idx) => _onPageChanged(idx, comic),
                        reverse: isRtl,
                      ),
              ),

              // Floating Overlays & Bars
              ReaderControls(
                visible: _showControls,
                comicTitle: comic.title,
                chapterTitle: chapter.title,
                currentPage: _currentPageIndex,
                totalPages: pages.length,
                chapters: comic.chapters,
                currentChapterIndex: _currentChapterIndex,
                onChapterSelected: _onChapterSelected,
                pageController: _pageController,
                onBack: () => Navigator.pop(context),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primaryPurple),
        ),
        error: (_, __) => const Center(child: Text('An error occurred')),
      ),
    );
  }
}

class _ImageErrorPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cardDark,
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.broken_image_rounded, size: 48, color: AppColors.textSecondary),
            SizedBox(height: 8),
            Text('Failed to load page', style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
