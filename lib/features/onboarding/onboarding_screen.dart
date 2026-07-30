import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/router/app_router.dart';
import '../../core/di/providers.dart';
import '../../shared/widgets/glass_container.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    const OnboardingData(
      title: AppStrings.onboarding1Title,
      subtitle: AppStrings.onboarding1Subtitle,
      icon: Icons.explore_rounded,
      gradient: AppColors.purpleGradient,
    ),
    const OnboardingData(
      title: AppStrings.onboarding2Title,
      subtitle: AppStrings.onboarding2Subtitle,
      icon: Icons.wifi_off_rounded,
      gradient: AppColors.blueGradient,
    ),
    const OnboardingData(
      title: AppStrings.onboarding3Title,
      subtitle: AppStrings.onboarding3Subtitle,
      icon: Icons.bookmark_added_rounded,
      gradient: AppColors.cyanGradient,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() async {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: AppSizes.durationNormal,
        curve: Curves.easeInOutCubic,
      );
    } else {
      await markOnboardingDone();
      if (mounted) {
        context.go(AppRoutes.home);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // Background soft gradient
          Positioned.fill(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.5,
                  colors: [
                    _pages[_currentPage].gradient.colors.first.withOpacity(0.15),
                    AppColors.backgroundDark,
                  ],
                ),
              ),
            ),
          ),

          // Sliding Page View
          PageView.builder(
            controller: _pageController,
            onPageChanged: (page) => setState(() => _currentPage = page),
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              final page = _pages[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.pagePaddingH),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Graphic panel with glassmorphism
                    GlassContainer(
                      width: 240,
                      height: 240,
                      opacity: 0.05,
                      borderOpacity: 0.1,
                      child: Center(
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: page.gradient,
                            boxShadow: [
                              BoxShadow(
                                color: page.gradient.colors.first.withOpacity(0.5),
                                blurRadius: 30,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: Icon(
                            page.icon,
                            color: Colors.white,
                            size: 64,
                          ),
                        ),
                      ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
                    ),
                    const SizedBox(height: AppSizes.sp48),

                    // Copywriting titles
                    Text(
                      page.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ).animate(key: ValueKey('title_$index')).fadeIn().slideY(begin: 0.2, end: 0),
                    const SizedBox(height: AppSizes.sp16),
                    Text(
                      page.subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ).animate(key: ValueKey('subtitle_$index')).fadeIn(delay: 150.ms).slideY(begin: 0.2, end: 0),
                  ],
                ),
              );
            },
          ),

          // Bottom Bar with skip, indicators, and next
          Positioned(
            bottom: 50,
            left: AppSizes.pagePaddingH,
            right: AppSizes.pagePaddingH,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Skip Button
                TextButton(
                  onPressed: () async {
                    await markOnboardingDone();
                    if (mounted) {
                      context.go(AppRoutes.home);
                    }
                  },
                  child: const Text(
                    AppStrings.skip,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),

                // Indicator dots
                SmoothPageIndicator(
                  controller: _pageController,
                  count: _pages.length,
                  effect: const ExpandingDotsEffect(
                    activeDotColor: AppColors.primaryPurple,
                    dotColor: AppColors.outline,
                    dotHeight: 8,
                    dotWidth: 8,
                    expansionFactor: 3,
                    spacing: 8,
                  ),
                ),

                // Next Button
                ElevatedButton(
                  onPressed: _onNext,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    ),
                  ),
                  child: Text(
                    _currentPage == _pages.length - 1
                        ? AppStrings.getStarted
                        : AppStrings.next,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String subtitle;
  final IconData icon;
  final LinearGradient gradient;

  const OnboardingData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
  });
}
