import 'package:flutter/material.dart';
import 'package:capstone_frontend/core/models/delivery_mission_item.dart';
import 'package:capstone_frontend/core/services/delivery_mission_store.dart';
import 'package:capstone_frontend/core/theme/app_colors.dart';
import 'package:capstone_frontend/core/theme/app_radius.dart';
import 'package:capstone_frontend/core/theme/app_spacing.dart';
import 'package:capstone_frontend/core/theme/app_text_styles.dart';

class ArrivedScreen extends StatelessWidget {
  const ArrivedScreen({super.key});

  static const building = '101';
  static const unit = '1203';

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DeliveryMissionItem?>(
      valueListenable: DeliveryMissionStore.instance.activeMission,
      builder: (context, _, __) {
        return ValueListenableBuilder<List<DeliveryMissionItem>>(
          valueListenable: DeliveryMissionStore.instance.history,
          builder: (context, __, ___) {
            final mission =
            DeliveryMissionStore.instance.latestCompletedForAddress(
              building: building,
              unit: unit,
            );

            return Scaffold(
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xxl),
                  child: Column(
                    children: [
                      const Spacer(),
                      Container(
                        width: 120,
                        height: 120,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryLight,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.inventory_2_outlined,
                          size: 56,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      const Text(
                        '택배가 문 앞에 도착했습니다',
                        style: AppTextStyles.sectionTitle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        mission == null
                            ? '방금 안전하게 배송되었어요'
                            : '${mission.startedAt.hour.toString().padLeft(2, '0')}:${mission.startedAt.minute.toString().padLeft(2, '0')}에 안전하게 배송되었어요',
                        style: AppTextStyles.body,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppRadius.xl),
                          border: Border.all(color: AppColors.stroke),
                        ),
                        child: Column(
                          children: [
                            _InfoRow(label: '수량', value: '${mission?.quantity ?? 1}개'),
                            const SizedBox(height: AppSpacing.lg),
                            _InfoRow(label: '위치', value: '${building}동 ${unit}호'),
                            const SizedBox(height: AppSpacing.lg),
                            const _InfoRow(label: '상태', value: '배송 완료'),
                          ],
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: FilledButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed('/');
                          },
                          child: const Text('확인'),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed('/history');
                          },
                          child: const Text('배송 내역 보기'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
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