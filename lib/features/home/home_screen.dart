import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/router/app_router.dart';
import '../../core/di/providers.dart';
import '../../shared/models/comic.dart';
import '../../shared/widgets/section_header.dart';
import '../../shared/widgets/comic_card.dart';
import '../../shared/widgets/shimmer_loading.dart';
import 'widgets/featured_carousel.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featured = ref.watch(featuredComicsProvider);
    final trending = ref.watch(trendingComicsProvider);
    final editors = ref.watch(editorsChoiceProvider);
    final aiOriginals = ref.watch(aiOriginalsProvider);
    final publicDomain = ref.watch(publicDomainProvider);
    final historyMap = ref.watch(readingHistoryProvider);
    final history = ref.read(readingHistoryProvider.notifier).recentHistory;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(allComicsProvider);
        },
        color: AppColors.primaryPurple,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Immersive Header Bar
            SliverAppBar(
              floating: true,
              pinned: false,
              title: const Text(
                AppStrings.appName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search_rounded),
                  onPressed: () => context.go(AppRoutes.search),
                ),
                IconButton(
                  icon: const Icon(Icons.category_outlined),
                  onPressed: () => context.push(AppRoutes.categories),
                ),
                const SizedBox(width: AppSizes.sp8),
              ],
            ),

            // Top Carousel Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.sectionGap),
                child: featured.when(
                  data: (comics) => FeaturedCarousel(comics: comics),
                  loading: () => const FeaturedCarouselShimmer(),
                  error: (_, __) => const SizedBox(height: 100),
                ),
              ),
            ),

            // Continue Reading (if history exists)
            if (history.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.sectionGap),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(
                        title: AppStrings.sectionContinueReading,
                        showSeeAll: false,
                      ),
                      SizedBox(
                        height: 100,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: AppSizes.pagePaddingH),
                          itemCount: history.length,
                          separatorBuilder: (_, __) => const SizedBox(width: AppSizes.itemGap),
                          itemBuilder: (context, index) {
                            final progress = history[index];
                            return _ContinueReadingCard(progress: progress);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Trending Section
            SliverToBoxAdapter(
              child: _HorizontalSection(
                title: AppStrings.sectionTrending,
                comicsState: trending,
                heroPrefix: 'trending',
              ),
            ),

            // Editor's Choice
            SliverToBoxAdapter(
              child: _HorizontalSection(
                title: AppStrings.sectionEditorsChoice,
                comicsState: editors,
                heroPrefix: 'editors',
              ),
            ),

            // AI Originals
            SliverToBoxAdapter(
              child: _HorizontalSection(
                title: AppStrings.sectionAiOriginals,
                comicsState: aiOriginals,
                heroPrefix: 'ai',
              ),
            ),

            // Public Domain Classics
            SliverToBoxAdapter(
              child: _HorizontalSection(
                title: AppStrings.sectionPublicDomain,
                comicsState: publicDomain,
                heroPrefix: 'pd',
              ),
            ),

            // Bottom Spacing
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSizes.sp48),
            ),
          ],
        ),
      ),
    );
  }
}

class _HorizontalSection extends StatelessWidget {
  const _HorizontalSection({
    required this.title,
    required this.comicsState,
    required this.heroPrefix,
  });

  final String title;
  final AsyncValue<List<Comic>> comicsState;
  final String heroPrefix;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.sectionGap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: title,
            showSeeAll: false,
          ),
          comicsState.when(
            data: (comics) {
              if (comics.isEmpty) return const SizedBox.shrink();
              return SizedBox(
                height: AppSizes.cardHeight,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.pagePaddingH),
                  itemCount: comics.length,
                  separatorBuilder: (_, __) => const SizedBox(width: AppSizes.itemGap),
                  itemBuilder: (context, index) {
                    return ComicCard(
                      comic: comics[index],
                      heroTagPrefix: heroPrefix,
                    );
                  },
                ),
              );
            },
            loading: () => const ComicRowShimmer(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _ContinueReadingCard extends ConsumerWidget {
  const _ContinueReadingCard({required this.progress});
  final ReadingProgress progress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final comicVal = ref.watch(comicByIdProvider(progress.comicId));

    return comicVal.when(
      data: (comic) {
        if (comic == null) return const SizedBox.shrink();
        final ch = comic.chapters[progress.chapterIndex];
        return GestureDetector(
          onTap: () => context.push('${AppRoutes.reader}/${comic.id}?chapter=${progress.chapterIndex}'),
          child: Container(
            width: 220,
            padding: const EdgeInsets.all(10),
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
                    width: 50,
                    height: 75,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 50,
                      height: 75,
                      color: AppColors.primaryPurple,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        comic.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ch. ${progress.chapterIndex + 1}: ${ch.title}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Progress Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: ch.pageCount > 0 ? (progress.pageIndex + 1) / ch.pageCount : 0.0,
                          backgroundColor: AppColors.outlineVariant,
                          color: AppColors.primaryPurple,
                          minHeight: 3,
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
      loading: () => const SizedBox(width: 220, height: 75),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
