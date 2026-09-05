import 'package:flutter/material.dart';
import 'package:capstone_frontend/core/theme/app_spacing.dart';
import 'package:capstone_frontend/core/theme/app_text_styles.dart';
import 'package:capstone_frontend/core/widgets/info_card.dart';

class StatMiniCard extends StatelessWidget {
  final String label;
  final String value;

  const StatMiniCard({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.sub),
          const SizedBox(height: AppSpacing.sm),
          Text(value, style: AppTextStyles.cardMetric),
        ],
      ),
    );
  }
}