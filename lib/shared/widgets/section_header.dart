import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

/// Consistent section header with title, optional subtitle, and "See All" action
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onSeeAll,
    this.showSeeAll = true,
    this.padding,
    this.gradient,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onSeeAll;
  final bool showSeeAll;
  final EdgeInsetsGeometry? padding;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ??
          const EdgeInsets.fromLTRB(
            AppSizes.pagePaddingH,
            0,
            AppSizes.sp8,
            AppSizes.sp12,
          ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _GradientTitle(title: title, gradient: gradient),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      height: 1.3,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (showSeeAll && onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                children: [
                  Text(
                    'See All',
                    style: TextStyle(
                      color: AppColors.primaryPurpleLight,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 16,
                    color: AppColors.primaryPurpleLight,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _GradientTitle extends StatelessWidget {
  const _GradientTitle({required this.title, this.gradient});
  final String title;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final effectiveGradient = gradient ??
        const LinearGradient(colors: [Colors.white, Color(0xFFB8C0D8)]);

    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) =>
          effectiveGradient.createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.3,
          height: 1.2,
        ),
      ),
    );
  }
}
