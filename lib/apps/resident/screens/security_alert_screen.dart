import 'package:flutter/material.dart';
import 'package:capstone_frontend/core/models/security_alert.dart';
import 'package:capstone_frontend/core/theme/app_colors.dart';
import 'package:capstone_frontend/core/theme/app_radius.dart';
import 'package:capstone_frontend/core/theme/app_spacing.dart';
import 'package:capstone_frontend/core/theme/app_text_styles.dart';
import 'package:capstone_frontend/core/widgets/info_card.dart';
import 'package:capstone_frontend/core/widgets/primary_cta_button.dart';

class SecurityAlertScreen extends StatelessWidget {
  const SecurityAlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const alert = SecurityAlertItem(
      level: SecurityAlertLevel.warning,
      type: SecurityEventType.forcedOpenAttempt,
      time: '14:37',
      robotId: 'R-02',
      location: '101동 12층 이동 중',
      description: '누군가 적재함을 비정상적으로 열려고 시도했습니다.',
    );

    return Scaffold(
      appBar: AppBar(title: const Text('보안 경고')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(
                  color: Color(0xFFFDECEC),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  size: 48,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              const Text(
                '강제 개방 시도가 감지되었습니다',
                style: AppTextStyles.sectionTitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                alert.description,
                style: AppTextStyles.body,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),
              const InfoCard(
                child: Column(
                  children: [
                    _SecurityInfoRow(label: '발생 시각', value: '14:37'),
                    SizedBox(height: AppSpacing.md),
                    _SecurityInfoRow(label: '대상 로봇', value: 'R-02'),
                    SizedBox(height: AppSpacing.md),
                    _SecurityInfoRow(label: '위치', value: '101동 12층 이동 중'),
                    SizedBox(height: AppSpacing.md),
                    _SecurityInfoRow(label: '이벤트', value: '강제 개방 시도'),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4D6),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: const Color(0xFFF1D18A)),
                ),
                child: const Text(
                  '현재 배송 상태와 로봇 상태를 확인해주세요. 하드웨어 경고 감지는 추후 실제 센서와 연동될 예정입니다.',
                  style: AppTextStyles.body,
                ),
              ),
              const Spacer(),
              PrimaryCtaButton(
                label: '확인',
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/security-history');
                  },
                  child: const Text('보안 기록 보기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SecurityInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _SecurityInfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: AppTextStyles.sub),
        const Spacer(),
        Text(value, style: AppTextStyles.body),
      ],
    );
  }
}