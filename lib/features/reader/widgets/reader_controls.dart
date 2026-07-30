import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/di/providers.dart';
import '../../../shared/models/comic.dart';
import '../../../shared/widgets/glass_container.dart';

class ReaderControls extends ConsumerWidget {
  const ReaderControls({
    super.key,
    required this.visible,
    required this.comicTitle,
    required this.chapterTitle,
    required this.currentPage,
    required this.totalPages,
    required this.chapters,
    required this.currentChapterIndex,
    required this.onChapterSelected,
    required this.pageController,
    required this.onBack,
  });

  final bool visible;
  final String comicTitle;
  final String chapterTitle;
  final int currentPage;
  final int totalPages;
  final List<Chapter> chapters;
  final int currentChapterIndex;
  final ValueChanged<int> onChapterSelected;
  final PageController pageController;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readingDir = ref.watch(readingDirectionProvider);
    final readerMode = ref.watch(readerModeProvider);

    return AnimatedPositioned(
      duration: AppSizes.durationNormal,
      curve: Curves.easeInOut,
      top: visible ? 0 : -140,
      left: 0,
      right: 0,
      bottom: visible ? 0 : -140,
      child: IgnorePointer(
        ignoring: !visible,
        child: Stack(
          children: [
            // Top App Bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: GlassContainer(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(AppSizes.radiusLg)),
                padding: const EdgeInsets.only(top: 40, bottom: 12, left: 16, right: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                      onPressed: onBack,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comicTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            chapterTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.menu_rounded, color: Colors.white),
                      onPressed: () => _showChapterDrawer(context),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Navigation Panel
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GlassContainer(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSizes.radiusLg)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Page Progress Indicator & Sliders
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${currentPage + 1} / $totalPages',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            // Layout orientation config
                            IconButton(
                              icon: Icon(
                                readingDir == ReadingDirection.vertical
                                    ? Icons.swap_vert_rounded
                                    : Icons.swap_horiz_rounded,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                final next = ReadingDirection.values[
                                    (readingDir.index + 1) % ReadingDirection.values.length];
                                ref.read(readingDirectionProvider.notifier).set(next);
                              },
                            ),
                            // Sepia / dark / night filters
                            IconButton(
                              icon: const Icon(Icons.style_rounded, color: Colors.white),
                              onPressed: () {
                                final next = ReaderMode.values[
                                    (readerMode.index + 1) % ReaderMode.values.length];
                                ref.read(readerModeProvider.notifier).state = next;
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showChapterDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusXl)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(AppSizes.pagePaddingH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chapters',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  itemCount: chapters.length,
                  separatorBuilder: (_, __) => Divider(color: AppColors.outlineVariant),
                  itemBuilder: (context, index) {
                    final isCurrent = index == currentChapterIndex;
                    return ListTile(
                      title: Text(
                        chapters[index].title,
                        style: TextStyle(
                          color: isCurrent ? AppColors.primaryPurpleLight : Colors.white,
                          fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      trailing: isCurrent ? const Icon(Icons.play_circle_fill, color: AppColors.primaryPurpleLight) : null,
                      onTap: () {
                        onChapterSelected(index);
                        Navigator.pop(context);
                      },
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
}
