import 'package:flutter/material.dart';
import 'package:capstone_frontend/core/theme/app_colors.dart';
import 'package:capstone_frontend/core/theme/app_radius.dart';
import 'package:capstone_frontend/core/theme/app_spacing.dart';
import 'package:capstone_frontend/core/theme/app_text_styles.dart';

class HeroStatusCard extends StatelessWidget {
  final String title;
  final String status;
  final String eta;
  final VoidCallback onTap;

  const HeroStatusCard({
    super.key,
    required this.title,
    required this.status,
    required this.eta,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        gradient: const LinearGradient(
          colors: [AppColors.deepGreen, AppColors.deepGreenDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.sub.copyWith(
              color: AppColors.textOnDark.withOpacity(0.85),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            status,
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.textOnDark,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            eta,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textOnDark.withOpacity(0.92),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton.tonalIcon(
            onPressed: onTap,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('자세히 보기'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.surface,
              foregroundColor: AppColors.deepGreen,
            ),
          ),
        ],
      ),
    );
  }
}