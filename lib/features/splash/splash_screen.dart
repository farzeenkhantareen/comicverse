import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/router/app_router.dart';
import '../../core/di/providers.dart';

/// Animated splash screen with logo reveal, particle-style dots, and smooth navigation
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _glowController;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _glowRadius;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _logoScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    _glowRadius = Tween<double>(begin: 30, end: 80).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _startSequence();
  }

  Future<void> _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 300));
    await _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    // Check onboarding status
    final hasSeenOnboarding = await ref.read(hasSeenOnboardingProvider.future);

    if (!mounted) return;

    final destination = hasSeenOnboarding
        ? AppRoutes.home
        : AppRoutes.onboarding;

    context.go(destination);
  }

  @override
  void dispose() {
    _logoController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // Background gradient
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.2,
                  colors: [
                    AppColors.primaryPurpleDark.withOpacity(0.4),
                    AppColors.backgroundDark,
                  ],
                ),
              ),
            ),
          ),

          // Animated ambient orbs
          const _AmbientOrbs(),

          // Center logo + text
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo orb
                AnimatedBuilder(
                  animation: Listenable.merge([_logoController, _glowController]),
                  builder: (context, _) {
                    return Opacity(
                      opacity: _logoOpacity.value,
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Glow ring
                            Container(
                              width: _glowRadius.value * 2 + 80,
                              height: _glowRadius.value * 2 + 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryPurple.withOpacity(0.25),
                                    blurRadius: _glowRadius.value,
                                    spreadRadius: _glowRadius.value * 0.3,
                                  ),
                                ],
                              ),
                            ),
                            // Logo container
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryPurple.withOpacity(0.6),
                                    blurRadius: 30,
                                    spreadRadius: 4,
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/app_logo.png',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 28),

                // App name + tagline
                AnimatedBuilder(
                  animation: _logoController,
                  builder: (context, _) {
                    return Opacity(
                      opacity: _textOpacity.value,
                      child: SlideTransition(
                        position: _textSlide,
                        child: Column(
                          children: [
                            ShaderMask(
                              blendMode: BlendMode.srcIn,
                              shaderCallback: (bounds) =>
                                  const LinearGradient(
                                colors: [
                                  Colors.white,
                                  AppColors.primaryPurpleLight,
                                ],
                              ).createShader(bounds),
                              child: const Text(
                                AppStrings.appName,
                                style: TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -1,
                                  height: 1.1,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              AppStrings.appTagline.toUpperCase(),
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 3.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Version text at bottom
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Text(
              'v${AppStrings.appVersion}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
              ),
            )
                .animate(delay: 1200.ms)
                .fadeIn(duration: 600.ms),
          ),
        ],
      ),
    );
  }
}

/// Floating ambient orbs in the background
class _AmbientOrbs extends StatefulWidget {
  const _AmbientOrbs();

  @override
  State<_AmbientOrbs> createState() => _AmbientOrbsState();
}

class _AmbientOrbsState extends State<_AmbientOrbs>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, _) {
        return Stack(
          children: [
            Positioned(
              top: -50,
              right: -60,
              child: _Orb(
                size: 280,
                color: AppColors.primaryPurple.withOpacity(0.12 + _pulse.value * 0.06),
              ),
            ),
            Positioned(
              bottom: 80,
              left: -80,
              child: _Orb(
                size: 240,
                color: AppColors.electricBlue.withOpacity(0.08 + _pulse.value * 0.04),
              ),
            ),
            Positioned(
              top: 200,
              left: 40,
              child: _Orb(
                size: 100,
                color: AppColors.cyan.withOpacity(0.06 + _pulse.value * 0.04),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Orb extends StatelessWidget {
  const _Orb({required this.size, required this.color});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: size * 0.5,
            spreadRadius: size * 0.1,
          ),
        ],
      ),
    );
  }
}
