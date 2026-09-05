import 'package:flutter/material.dart';
import 'package:capstone_frontend/core/theme/app_colors.dart';

class AppTextStyles {
  static const headline = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textMain,
    height: 1.2,
  );

  static const sectionTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textMain,
    height: 1.25,
  );

  static const cardMetric = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textMain,
    height: 1.2,
  );

  static const body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textMain,
    height: 1.4,
  );

  static const sub = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textSub,
    height: 1.35,
  );
}