import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/router/app_router.dart';
import '../../core/di/providers.dart';
import '../../shared/widgets/comic_card.dart';
import '../../shared/widgets/empty_state.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoriteComicsProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        appBar: AppBar(
          title: const Text(
            AppStrings.navLibrary,
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: AppStrings.libraryFavorites),
              Tab(text: AppStrings.libraryHistory),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Favorites Tab
            favorites.when(
              data: (comics) {
                if (comics.isEmpty) {
                  return const EmptyState(
                    icon: Icons.favorite_border_rounded,
                    title: AppStrings.emptyFavorites,
                    subtitle: AppStrings.emptyFavoritesSubtitle,
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(AppSizes.pagePaddingH),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: AppSizes.coverAspectRatio,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: comics.length,
                  itemBuilder: (context, index) {
                    return ComicCard(
                      comic: comics[index],
                      heroTagPrefix: 'library_fav',
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const SizedBox.shrink(),
            ),

            // History Tab
            _HistoryTab(),
          ],
        ),
      ),
    );
  }
}

class _HistoryTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(readingHistoryProvider.notifier).recentHistory;

    if (history.isEmpty) {
      return const EmptyState(
        icon: Icons.history_rounded,
        title: AppStrings.emptyHistory,
        subtitle: AppStrings.emptyHistorySubtitle,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSizes.pagePaddingH),
      itemCount: history.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final progress = history[index];
        return _HistoryItem(progress: progress);
      },
    );
  }
}

class _HistoryItem extends ConsumerWidget {
  const _HistoryItem({required this.progress});
  final ReadingProgress progress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final comicVal = ref.watch(comicByIdProvider(progress.comicId));

    return comicVal.when(
      data: (comic) {
        if (comic == null) return const SizedBox.shrink();
        final ch = comic.chapters[progress.chapterIndex];
        return InkWell(
          onTap: () => context.push('${AppRoutes.reader}/${comic.id}?chapter=${progress.chapterIndex}'),
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              border: Border.all(color: AppColors.outlineVariant),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  child: Image.asset(
                    'assets/${comic.coverAsset}',
                    width: 60,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comic.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Chapter ${progress.chapterIndex + 1}: ${ch.title}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Progress Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: ch.pageCount > 0 ? (progress.pageIndex + 1) / ch.pageCount : 0.0,
                          backgroundColor: AppColors.outlineVariant,
                          color: AppColors.primaryPurple,
                          minHeight: 4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox(height: 114),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
