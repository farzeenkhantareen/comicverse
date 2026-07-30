import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

/// Glassmorphism container with blur effect, gradient border, and subtle glow.
/// Usage: wrap any widget to get the glass panel look.
class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.blur = AppSizes.blurMd,
    this.opacity = 0.08,
    this.borderOpacity = 0.15,
    this.gradient,
    this.borderGradient,
    this.boxShadow,
  });

  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double blur;
  final double opacity;
  final double borderOpacity;
  final Gradient? gradient;
  final Gradient? borderGradient;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(AppSizes.radiusXl);

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: boxShadow ?? [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: -4,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            width: width,
            height: height,
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: radius,
              gradient: gradient ?? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(opacity),
                  Colors.white.withOpacity(opacity * 0.5),
                ],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(borderOpacity),
                width: 1.0,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// A lighter glass chip/badge — for tags, status labels etc.
class GlassBadge extends StatelessWidget {
  const GlassBadge({
    super.key,
    required this.label,
    this.color,
    this.icon,
    this.small = false,
  });

  final String label;
  final Color? color;
  final IconData? icon;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.primaryPurple;
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: small ? 8 : 12,
            vertical: small ? 3 : 5,
          ),
          decoration: BoxDecoration(
            color: effectiveColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            border: Border.all(
              color: effectiveColor.withOpacity(0.4),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: small ? 10 : 12, color: effectiveColor),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: TextStyle(
                  color: effectiveColor,
                  fontSize: small ? 10 : 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
