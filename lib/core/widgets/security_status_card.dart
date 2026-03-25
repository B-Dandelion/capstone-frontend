import 'package:flutter/material.dart';
import 'package:capstone_frontend/core/models/security_alert.dart';
import 'package:capstone_frontend/core/theme/app_colors.dart';
import 'package:capstone_frontend/core/theme/app_radius.dart';
import 'package:capstone_frontend/core/theme/app_spacing.dart';
import 'package:capstone_frontend/core/theme/app_text_styles.dart';
import 'package:capstone_frontend/core/widgets/info_card.dart';

class SecurityStatusCard extends StatelessWidget {
  final SecurityAlertLevel level;
  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback onTap;

  const SecurityStatusCard({
    super.key,
    required this.level,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final style = _style(level);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: InfoCard(
          backgroundColor: style.bg,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: style.iconBg,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(style.icon, color: style.iconFg),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Text(subtitle, style: AppTextStyles.sub.copyWith(color: style.textSub)),
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: style.chipBg,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Text(
                        buttonLabel,
                        style: AppTextStyles.sub.copyWith(
                          color: style.chipFg,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _SecurityCardStyle _style(SecurityAlertLevel level) {
    switch (level) {
      case SecurityAlertLevel.normal:
        return const _SecurityCardStyle(
          bg: Color(0xFFF3FBF7),
          iconBg: AppColors.mintSoft,
          iconFg: AppColors.deepGreen,
          chipBg: Color(0xFFE8F3EF),
          chipFg: AppColors.deepGreen,
          textSub: AppColors.textSub,
          icon: Icons.shield_outlined,
        );
      case SecurityAlertLevel.warning:
        return const _SecurityCardStyle(
          bg: Color(0xFFFFF1F1),
          iconBg: Color(0xFFFDECEC),
          iconFg: AppColors.error,
          chipBg: AppColors.error,
          chipFg: AppColors.textOnDark,
          textSub: AppColors.error,
          icon: Icons.warning_amber_rounded,
        );
      case SecurityAlertLevel.resolved:
        return const _SecurityCardStyle(
          bg: Color(0xFFF5FAF7),
          iconBg: Color(0xFFE8F3EF),
          iconFg: AppColors.success,
          chipBg: Color(0xFFE8F3EF),
          chipFg: AppColors.success,
          textSub: AppColors.textSub,
          icon: Icons.verified_outlined,
        );
    }
  }
}

class _SecurityCardStyle {
  final Color bg;
  final Color iconBg;
  final Color iconFg;
  final Color chipBg;
  final Color chipFg;
  final Color textSub;
  final IconData icon;

  const _SecurityCardStyle({
    required this.bg,
    required this.iconBg,
    required this.iconFg,
    required this.chipBg,
    required this.chipFg,
    required this.textSub,
    required this.icon,
  });
}