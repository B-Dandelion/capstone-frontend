import 'package:flutter/material.dart';
import 'package:capstone_frontend/core/models/delivery_status.dart';
import 'package:capstone_frontend/core/theme/app_colors.dart';
import 'package:capstone_frontend/core/theme/app_radius.dart';
import 'package:capstone_frontend/core/theme/app_text_styles.dart';

class StatusChip extends StatelessWidget {
  final DeliveryStatus status;
  final String? customLabel;

  const StatusChip({
    super.key,
    required this.status,
    this.customLabel,
  });

  @override
  Widget build(BuildContext context) {
    final config = _styleFor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: config.bg,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        customLabel ?? status.label,
        style: AppTextStyles.sub.copyWith(
          color: config.fg,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  _ChipStyle _styleFor(DeliveryStatus status) {
    switch (status) {
      case DeliveryStatus.completed:
        return const _ChipStyle(AppColors.success, AppColors.textOnDark);
      case DeliveryStatus.failed:
        return const _ChipStyle(Color(0xFFFDECEC), AppColors.error);
      case DeliveryStatus.delayed:
        return const _ChipStyle(Color(0xFFFFF4D6), AppColors.warning);
      case DeliveryStatus.arrived:
        return const _ChipStyle(AppColors.deepGreen, AppColors.textOnDark);
      default:
        return const _ChipStyle(Color(0xFFE8F3EF), AppColors.deepGreen);
    }
  }
}

class _ChipStyle {
  final Color bg;
  final Color fg;

  const _ChipStyle(this.bg, this.fg);
}