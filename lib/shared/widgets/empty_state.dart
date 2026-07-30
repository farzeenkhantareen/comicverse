import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

/// Flexible empty-state illustration with icon, title, subtitle, and optional action
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
    this.actionLabel,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? action;
  final String? actionLabel;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.sp32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with glow
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (iconColor ?? AppColors.primaryPurple).withOpacity(0.1),
                boxShadow: [
                  BoxShadow(
                    color: (iconColor ?? AppColors.primaryPurple).withOpacity(0.2),
                    blurRadius: 24,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 36,
                color: (iconColor ?? AppColors.primaryPurple).withOpacity(0.8),
              ),
            )
                .animate()
                .scale(duration: 400.ms, curve: Curves.elasticOut)
                .fadeIn(duration: 300.ms),

            const SizedBox(height: AppSizes.sp20),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.2, end: 0),

            if (subtitle != null) ...[
              const SizedBox(height: AppSizes.sp8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.5,
                ),
              ).animate(delay: 150.ms).fadeIn().slideY(begin: 0.2, end: 0),
            ],

            if (action != null && actionLabel != null) ...[
              const SizedBox(height: AppSizes.sp24),
              ElevatedButton(
                onPressed: action,
                child: Text(actionLabel!),
              ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.2, end: 0),
            ],
          ],
        ),
      ),
    );
  }
}
