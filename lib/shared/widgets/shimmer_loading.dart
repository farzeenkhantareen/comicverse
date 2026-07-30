import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

/// Shimmer placeholder for a single comic card
class ComicCardShimmer extends StatelessWidget {
  const ComicCardShimmer({
    super.key,
    this.width = AppSizes.cardWidth,
    this.height = AppSizes.cardHeight,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return _ShimmerBox(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
      ),
    );
  }
}

/// Shimmer row of comic cards for horizontal lists
class ComicRowShimmer extends StatelessWidget {
  const ComicRowShimmer({super.key, this.count = 4});

  final int count;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.cardHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.pagePaddingH),
        itemCount: count,
        separatorBuilder: (_, __) => const SizedBox(width: AppSizes.itemGap),
        itemBuilder: (_, __) => const ComicCardShimmer(),
      ),
    );
  }
}

/// Shimmer for the hero featured carousel
class FeaturedCarouselShimmer extends StatelessWidget {
  const FeaturedCarouselShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return _ShimmerBox(
      child: Container(
        height: AppSizes.heroCarouselHeight,
        margin: const EdgeInsets.symmetric(horizontal: AppSizes.pagePaddingH),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppSizes.radiusXl),
        ),
      ),
    );
  }
}

/// Generic shimmer rectangle
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  final double width;
  final double height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return _ShimmerBox(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius:
              borderRadius ?? BorderRadius.circular(AppSizes.radiusMd),
        ),
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceVariant,
      highlightColor: AppColors.surfaceElevated,
      period: const Duration(milliseconds: 1400),
      child: child,
    );
  }
}
