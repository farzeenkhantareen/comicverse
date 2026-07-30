import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../shared/models/comic.dart';
import '../../../shared/widgets/comic_card.dart';

class FeaturedCarousel extends StatefulWidget {
  const FeaturedCarousel({super.key, required this.comics});
  final List<Comic> comics;

  @override
  State<FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends State<FeaturedCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.comics.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.comics.length,
          options: CarouselOptions(
            height: AppSizes.heroCarouselHeight,
            viewportFraction: 0.9,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            enlargeCenterPage: true,
            onPageChanged: (index, _) {
              setState(() => _currentIndex = index);
            },
          ),
          itemBuilder: (context, index, _) {
            return FeaturedComicCard(comic: widget.comics[index]);
          },
        ),
        const SizedBox(height: 12),
        AnimatedSmoothIndicator(
          activeIndex: _currentIndex,
          count: widget.comics.length,
          effect: const ScrollingDotsEffect(
            activeDotColor: AppColors.primaryPurple,
            dotColor: AppColors.outline,
            dotWidth: 6,
            dotHeight: 6,
            activeDotScale: 1.3,
          ),
        ),
      ],
    );
  }
}
