import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/router/app_router.dart';
import '../../shared/models/comic.dart';
import '../../core/di/providers.dart';
import 'glass_container.dart';

/// Standard comic cover card with parallax hover, shimmer, and favorite button.
/// Used across Home, Search, Library, and Category screens.
class ComicCard extends ConsumerStatefulWidget {
  const ComicCard({
    super.key,
    required this.comic,
    this.width,
    this.height,
    this.showRating = true,
    this.showBadge = true,
    this.heroTagPrefix = 'comic',
  });

  final Comic comic;
  final double? width;
  final double? height;
  final bool showRating;
  final bool showBadge;
  final String heroTagPrefix;

  @override
  ConsumerState<ComicCard> createState() => _ComicCardState();
}

class _ComicCardState extends ConsumerState<ComicCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _onTap() {
    context.push('${AppRoutes.reader}/${widget.comic.id}');
  }

  @override
  Widget build(BuildContext context) {
    final width = widget.width ?? AppSizes.cardWidth;
    final height = widget.height ?? AppSizes.cardHeight;
    final heroTag = '${widget.heroTagPrefix}_${widget.comic.id}';

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: child,
      ),
      child: GestureDetector(
        onTapDown: (_) => _pressController.forward(),
        onTapUp: (_) {
          _pressController.reverse();
          _onTap();
        },
        onTapCancel: () => _pressController.reverse(),
        child: SizedBox(
          width: width,
          height: height,
          child: Stack(
            children: [
              // Cover image with hero animation
              Hero(
                tag: heroTag,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  child: _CoverImage(
                    assetPath: widget.comic.coverAsset,
                    width: width,
                    height: height,
                  ),
                ),
              ),

              // Gradient overlay for text readability
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black.withOpacity(0.5),
                          Colors.black.withOpacity(0.92),
                        ],
                        stops: const [0.0, 0.45, 0.7, 1.0],
                      ),
                    ),
                  ),
                ),
              ),

              // License badge (top-left)
              if (widget.showBadge && (widget.comic.isAiOriginal || widget.comic.isPublicDomain))
                Positioned(
                  top: 8,
                  left: 8,
                  child: GlassBadge(
                    label: widget.comic.isAiOriginal ? 'AI' : 'PD',
                    color: widget.comic.isAiOriginal
                        ? AppColors.cyan
                        : AppColors.electricBlue,
                    small: true,
                  ),
                ),

              // Bottom info
              Positioned(
                left: 8,
                right: 8,
                bottom: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.comic.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                        shadows: [
                          Shadow(blurRadius: 4, color: Colors.black),
                        ],
                      ),
                    ),
                    if (widget.showRating) ...[
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              size: 11, color: AppColors.starFilled),
                          const SizedBox(width: 2),
                          Text(
                            widget.comic.ratingFormatted,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Favorite button (top-right)
              Positioned(
                top: 4,
                right: 4,
                child: _FavoriteButton(comicId: widget.comic.id),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CoverImage extends StatelessWidget {
  const _CoverImage({
    required this.assetPath,
    required this.width,
    required this.height,
  });

  final String assetPath;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (assetPath.startsWith('http')) {
      return Image.network(
        assetPath,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _PlaceholderCover(width: width, height: height),
      );
    }
    return Image.asset(
      'assets/$assetPath',
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _PlaceholderCover(width: width, height: height),
    );
  }
}

class _PlaceholderCover extends StatelessWidget {
  const _PlaceholderCover({required this.width, required this.height});
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: const Center(
        child: Icon(Icons.auto_stories_rounded,
            color: Colors.white54, size: 40),
      ),
    );
  }
}

class _FavoriteButton extends ConsumerWidget {
  const _FavoriteButton({required this.comicId});
  final String comicId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final isFav = favorites.contains(comicId);

    return GestureDetector(
      onTap: () => ref.read(favoritesProvider.notifier).toggle(comicId),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 36,
        height: 36,
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, anim) => ScaleTransition(
              scale: anim,
              child: child,
            ),
            child: Icon(
              isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              key: ValueKey(isFav),
              color: isFav ? Colors.red : Colors.white70,
              size: 18,
              shadows: const [Shadow(blurRadius: 4, color: Colors.black)],
            ),
          ),
        ),
      ),
    );
  }
}

/// Larger featured card for carousels with prominent title and description
class FeaturedComicCard extends StatelessWidget {
  const FeaturedComicCard({
    super.key,
    required this.comic,
    this.onTap,
  });

  final Comic comic;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => context.push('${AppRoutes.reader}/${comic.id}'),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        child: Stack(
          children: [
            // Full cover
            Hero(
              tag: 'featured_${comic.id}',
              child: SizedBox(
                width: double.infinity,
                height: AppSizes.heroCarouselHeight,
                child: comic.coverAsset.startsWith('http')
                    ? Image.network(
                        comic.coverAsset,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          decoration: const BoxDecoration(gradient: AppColors.heroGradient),
                          child: const Center(
                            child: Icon(Icons.auto_stories_rounded,
                                color: Colors.white38, size: 80),
                          ),
                        ),
                      )
                    : Image.asset(
                        'assets/${comic.coverAsset}',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          decoration: const BoxDecoration(gradient: AppColors.heroGradient),
                          child: const Center(
                            child: Icon(Icons.auto_stories_rounded,
                                color: Colors.white38, size: 80),
                          ),
                        ),
                      ),
              ),
            ),

            // Bottom gradient
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.85),
                    ],
                    stops: const [0.3, 0.6, 1.0],
                  ),
                ),
              ),
            ),

            // Content
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Genre badge
                  GlassBadge(
                    label: comic.primaryGenre.toUpperCase(),
                    color: AppColors.primaryPurple,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    comic.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    comic.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _ReadNowButton(comic: comic),
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              size: 14, color: AppColors.starFilled),
                          const SizedBox(width: 3),
                          Text(
                            comic.ratingFormatted,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReadNowButton extends StatelessWidget {
  const _ReadNowButton({required this.comic});
  final Comic comic;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('${AppRoutes.reader}/${comic.id}'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          gradient: AppColors.purpleGradient,
          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryPurple.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.play_arrow_rounded, size: 16, color: Colors.white),
            SizedBox(width: 4),
            Text(
              'Read Now',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
