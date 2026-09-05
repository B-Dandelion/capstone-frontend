import 'package:flutter/material.dart';
import 'package:capstone_frontend/apps/courier/screens/live_mission_screen.dart';
import 'package:capstone_frontend/core/services/delivery_mission_store.dart';
import 'package:capstone_frontend/core/theme/app_colors.dart';
import 'package:capstone_frontend/core/theme/app_radius.dart';
import 'package:capstone_frontend/core/theme/app_spacing.dart';
import 'package:capstone_frontend/core/theme/app_text_styles.dart';

class PreLaunchCheckScreen extends StatefulWidget {
  final String robotId;
  final String building;
  final String unit;
  final int quantity;

  const PreLaunchCheckScreen({
    super.key,
    required this.robotId,
    required this.building,
    required this.unit,
    required this.quantity,
  });

  @override
  State<PreLaunchCheckScreen> createState() => _PreLaunchCheckScreenState();
}

class _PreLaunchCheckScreenState extends State<PreLaunchCheckScreen> {
  bool isLoadChecked = false;
  bool isDestinationChecked = false;

  @override
  Widget build(BuildContext context) {
    final canStart = isLoadChecked && isDestinationChecked;

    return Scaffold(
      appBar: AppBar(
        title: const Text('작업 시작 전 점검'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        children: [
          const Text(
            '목적지와 적재 상태를 점검하세요',
            style: AppTextStyles.sectionTitle,
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            '자동 배송 시작 전 마지막 점검 단계입니다. 장비와 작업 정보가 정확한지 확인합니다.',
            style: AppTextStyles.sub,
          ),
          const SizedBox(height: AppSpacing.xl),
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(color: AppColors.stroke),
            ),
            child: Row(
              children: [
                Container(
                  width: 92,
                  height: 92,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  child: const Icon(
                    Icons.precision_manufacturing_outlined,
                    size: 42,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.xl),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.robotId, style: AppTextStyles.headline),
                      const SizedBox(height: AppSpacing.md),
                      _InfoRow(
                        label: '목적지',
                        value: '${widget.building}동 ${widget.unit}호',
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _InfoRow(
                        label: '택배 수량',
                        value: '${widget.quantity}개',
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      const _InfoRow(
                        label: '상태',
                        value: '출발 대기',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _CheckCard(
            title: '적재 상태가 정상인가요?',
            subtitle: '운행 중 적재함이 열리면 배송이 중단됩니다.',
            value: isLoadChecked,
            onChanged: (value) {
              setState(() {
                isLoadChecked = value;
              });
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          _CheckCard(
            title: '등록된 배송 대상이 맞나요?',
            subtitle: '${widget.building}동 ${widget.unit}호로 배송됩니다.',
            value: isDestinationChecked,
            onChanged: (value) {
              setState(() {
                isDestinationChecked = value;
              });
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF2D9),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: const Color(0xFFE6C56A)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.warning_amber_rounded, color: AppColors.warning),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    '작업 시작 후 배송 대상 변경이 제한됩니다.',
                    style: AppTextStyles.body,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),
          SizedBox(
            height: 60,
            child: FilledButton.icon(
              onPressed: canStart
                  ? () {
                DeliveryMissionStore.instance.startMission(
                  robotId: widget.robotId,
                  building: widget.building,
                  unit: widget.unit,
                  quantity: widget.quantity,
                );

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => const LiveMissionScreen(),
                  ),
                );
              }
                  : null,
              icon: const Icon(Icons.play_arrow),
              label: const Text('배송 시작'),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 56,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('취소'),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _CheckCard({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        onTap: () => onChanged(!value),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: AppColors.stroke),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: value,
                onChanged: (checked) => onChanged(checked ?? false),
              ),
              const SizedBox(width: AppSpacing.sm),
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

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
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