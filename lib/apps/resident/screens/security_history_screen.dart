import 'package:flutter/material.dart';
import 'package:capstone_frontend/core/models/security_alert.dart';
import 'package:capstone_frontend/core/theme/app_colors.dart';
import 'package:capstone_frontend/core/theme/app_radius.dart';
import 'package:capstone_frontend/core/theme/app_spacing.dart';
import 'package:capstone_frontend/core/theme/app_text_styles.dart';
import 'package:capstone_frontend/core/widgets/info_card.dart';

class SecurityHistoryScreen extends StatefulWidget {
  const SecurityHistoryScreen({super.key});

  @override
  State<SecurityHistoryScreen> createState() => _SecurityHistoryScreenState();
}

class _SecurityHistoryScreenState extends State<SecurityHistoryScreen> {
  SecurityAlertLevel? filter;

  final List<SecurityAlertItem> items = const [
    SecurityAlertItem(
      level: SecurityAlertLevel.warning,
      type: SecurityEventType.forcedOpenAttempt,
      time: '오늘 14:37',
      robotId: 'R-02',
      location: '101동 12층 이동 중',
      description: '강제 개방 시도 감지',
    ),
    SecurityAlertItem(
      level: SecurityAlertLevel.resolved,
      type: SecurityEventType.forcedOpenAttempt,
      time: '오늘 14:42',
      robotId: 'R-02',
      location: '보안 상태 복구',
      description: '경고 해제 및 상태 정상화',
    ),
    SecurityAlertItem(
      level: SecurityAlertLevel.normal,
      type: SecurityEventType.shockDetected,
      time: '어제 18:10',
      robotId: 'R-01',
      location: '정상 처리됨',
      description: '충격 감지 후 이상 없음',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = items.where((e) => filter == null || e.level == filter).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('보안 기록')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ChoiceChip(
                label: const Text('전체'),
                selected: filter == null,
                onSelected: (_) => setState(() => filter = null),
              ),
              ChoiceChip(
                label: const Text('경고'),
                selected: filter == SecurityAlertLevel.warning,
                onSelected: (_) => setState(() => filter = SecurityAlertLevel.warning),
              ),
              ChoiceChip(
                label: const Text('정상 복귀'),
                selected: filter == SecurityAlertLevel.resolved,
                onSelected: (_) => setState(() => filter = SecurityAlertLevel.resolved),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          ...filtered.map((item) {
            final style = _style(item.level);

            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: InfoCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
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
                          Text(item.description, style: AppTextStyles.body),
                          const SizedBox(height: 4),
                          Text(
                            '${item.time} · ${item.robotId} · ${item.location}',
                            style: AppTextStyles.sub,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: style.chipBg,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Text(
                        item.level.label,
                        style: AppTextStyles.sub.copyWith(
                          color: style.chipFg,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  _SecurityHistoryStyle _style(SecurityAlertLevel level) {
    switch (level) {
      case SecurityAlertLevel.warning:
        return const _SecurityHistoryStyle(
          icon: Icons.warning_amber_rounded,
          iconBg: Color(0xFFFDECEC),
          iconFg: AppColors.error,
          chipBg: AppColors.error,
          chipFg: AppColors.textOnDark,
        );
      case SecurityAlertLevel.resolved:
        return const _SecurityHistoryStyle(
          icon: Icons.verified_outlined,
          iconBg: Color(0xFFE8F3EF),
          iconFg: AppColors.success,
          chipBg: Color(0xFFE8F3EF),
          chipFg: AppColors.success,
        );
      case SecurityAlertLevel.normal:
        return const _SecurityHistoryStyle(
          icon: Icons.shield_outlined,
          iconBg: AppColors.mintSoft,
          iconFg: AppColors.deepGreen,
          chipBg: Color(0xFFE8F3EF),
          chipFg: AppColors.deepGreen,
        );
    }
  }
}

class _SecurityHistoryStyle {
  final IconData icon;
  final Color iconBg;
  final Color iconFg;
  final Color chipBg;
  final Color chipFg;

  const _SecurityHistoryStyle({
    required this.icon,
    required this.iconBg,
    required this.iconFg,
    required this.chipBg,
    required this.chipFg,
  });
}