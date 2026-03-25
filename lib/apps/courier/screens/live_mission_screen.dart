import 'package:flutter/material.dart';
import 'package:capstone_frontend/core/models/delivery_status.dart';
import 'package:capstone_frontend/core/theme/app_colors.dart';
import 'package:capstone_frontend/core/theme/app_radius.dart';
import 'package:capstone_frontend/core/theme/app_spacing.dart';
import 'package:capstone_frontend/core/theme/app_text_styles.dart';
import 'package:capstone_frontend/core/widgets/info_card.dart';
import 'package:capstone_frontend/core/widgets/progress_timeline.dart';
import 'package:capstone_frontend/core/widgets/status_chip.dart';

class LiveMissionScreen extends StatelessWidget {
  const LiveMissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final steps = [
      const TimelineStepData(
        title: '접수 완료',
        subtitle: '14:22',
        state: TimelineStepState.done,
      ),
      const TimelineStepData(
        title: '적재 완료',
        subtitle: '14:23',
        state: TimelineStepState.done,
      ),
      const TimelineStepData(
        title: '엘리베이터 호출',
        subtitle: '대기 없음',
        state: TimelineStepState.done,
      ),
      const TimelineStepData(
        title: '층 이동 중',
        subtitle: '14층으로 이동 중',
        state: TimelineStepState.current,
      ),
      const TimelineStepData(
        title: '문 앞 도착',
        state: TimelineStepState.future,
      ),
      const TimelineStepData(
        title: '배송 완료',
        state: TimelineStepState.future,
      ),
    ];

    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.deepGreen,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(AppRadius.xl),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xxl,
                  AppSpacing.lg,
                  AppSpacing.xxl,
                  AppSpacing.xxxl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '현재 배송',
                      style: AppTextStyles.sub.copyWith(
                        color: AppColors.textOnDark.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      '101동 1203호',
                      style: AppTextStyles.headline.copyWith(
                        color: AppColors.textOnDark,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Text(
                          '예상 도착 1분 18초',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textOnDark.withOpacity(0.92),
                          ),
                        ),
                        const Spacer(),
                        const StatusChip(
                          status: DeliveryStatus.movingToFloor,
                          customLabel: '이동 중',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              children: [
                InfoCard(
                  child: Column(
                    children: [
                      const LinearProgressIndicator(
                        value: 0.74,
                        minHeight: 10,
                        borderRadius: BorderRadius.all(Radius.circular(999)),
                        backgroundColor: Color(0xFFE8ECEA),
                        color: AppColors.deepGreen,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text('74%', style: AppTextStyles.cardMetric),
                      const SizedBox(height: AppSpacing.sm),
                      const Text(
                        '14층으로 이동 중입니다',
                        style: AppTextStyles.body,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                InfoCard(
                  child: ProgressTimeline(steps: steps),
                ),
                const SizedBox(height: AppSpacing.xl),
                InfoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('실시간 메시지', style: AppTextStyles.sectionTitle),
                      SizedBox(height: AppSpacing.lg),
                      Text('복도 진입', style: AppTextStyles.body),
                      SizedBox(height: 6),
                      Text('통신 양호', style: AppTextStyles.body),
                      SizedBox(height: 6),
                      Text('문 앞 도착 예상 00:42', style: AppTextStyles.body),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                const InfoCard(
                  backgroundColor: Color(0xFFFFF1F1),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: AppColors.error),
                      SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          '보안 상태: 강제 개방 시도 감지',
                          style: AppTextStyles.body,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xxl,
                0,
                AppSpacing.xxl,
                AppSpacing.xl,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text('문제 신고'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      '중단',
                      style: TextStyle(color: AppColors.error),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: () {},
                      child: const Text('긴급 호출'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}