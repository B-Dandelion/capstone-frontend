import 'package:flutter/material.dart';
import 'package:capstone_frontend/apps/courier/screens/live_mission_screen.dart';
import 'package:capstone_frontend/core/theme/app_colors.dart';
import 'package:capstone_frontend/core/theme/app_radius.dart';
import 'package:capstone_frontend/core/theme/app_spacing.dart';
import 'package:capstone_frontend/core/theme/app_text_styles.dart';
import 'package:capstone_frontend/core/widgets/info_card.dart';
import 'package:capstone_frontend/core/widgets/primary_cta_button.dart';

class PreLaunchCheckScreen extends StatefulWidget {
  final String building;
  final String unit;
  final int quantity;

  const PreLaunchCheckScreen({
    super.key,
    required this.building,
    required this.unit,
    required this.quantity,
  });

  @override
  State<PreLaunchCheckScreen> createState() => _PreLaunchCheckScreenState();
}

class _PreLaunchCheckScreenState extends State<PreLaunchCheckScreen> {
  bool hatchClosed = false;
  bool addressChecked = false;

  @override
  Widget build(BuildContext context) {
    final canStart = hatchClosed && addressChecked;

    return Scaffold(
      appBar: AppBar(title: const Text('출발 전 확인')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('목적지와 적재 상태를 점검하세요', style: AppTextStyles.sectionTitle),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                '배송 시작 전 마지막 확인 단계입니다. 잘못된 출발은 기사 업무를 크게 늘립니다.',
                style: AppTextStyles.sub,
              ),
              const SizedBox(height: AppSpacing.xl),
              InfoCard(
                child: Row(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceMuted,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: const Icon(
                        Icons.precision_manufacturing_outlined,
                        size: 34,
                        color: AppColors.deepGreen,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('R-02', style: AppTextStyles.sectionTitle),
                          const SizedBox(height: AppSpacing.md),
                          _MetricRow(label: '목적지', value: '${widget.building} ${widget.unit}호'),
                          const SizedBox(height: AppSpacing.sm),
                          _MetricRow(label: '택배 수량', value: '${widget.quantity}개'),
                          const SizedBox(height: AppSpacing.sm),
                          const _MetricRow(label: '상태', value: '출발 대기'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              _CheckCard(
                title: '적재함이 완전히 닫혔나요?',
                subtitle: '운행 중 적재함이 열리면 배송이 중단됩니다.',
                checked: hatchClosed,
                onTap: () => setState(() => hatchClosed = !hatchClosed),
              ),
              const SizedBox(height: AppSpacing.md),
              _CheckCard(
                title: '목적지 정보가 정확한가요?',
                subtitle: '${widget.building} ${widget.unit}호로 배송됩니다.',
                checked: addressChecked,
                onTap: () => setState(() => addressChecked = !addressChecked),
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
                child: Row(
                  children: const [
                    Icon(Icons.warning_amber_rounded, color: AppColors.warning),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        '배송 시작 후에는 목적지 변경이 제한됩니다.',
                        style: AppTextStyles.body,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              PrimaryCtaButton(
                label: '배송 시작',
                icon: Icons.play_arrow_rounded,
                onPressed: canStart
                    ? () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const LiveMissionScreen(),
                    ),
                  );
                }
                    : null,
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('취소'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final String value;

  const _MetricRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: AppTextStyles.sub),
        const Spacer(),
        Text(
          value,
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _CheckCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool checked;
  final VoidCallback onTap;

  const _CheckCard({
    required this.title,
    required this.subtitle,
    required this.checked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: InfoCard(
          backgroundColor: checked ? const Color(0xFFEFF8F4) : AppColors.surface,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  color: checked ? AppColors.deepGreen : AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: checked ? AppColors.deepGreen : AppColors.stroke,
                    width: 2,
                  ),
                ),
                child: checked
                    ? const Icon(Icons.check, size: 16, color: AppColors.textOnDark)
                    : null,
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.body),
                    const SizedBox(height: 6),
                    Text(subtitle, style: AppTextStyles.sub),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}