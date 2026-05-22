import 'package:flutter/material.dart';
import 'package:capstone_frontend/core/models/delivery_mission_item.dart';
import 'package:capstone_frontend/core/services/delivery_mission_store.dart';
import 'package:capstone_frontend/core/theme/app_colors.dart';
import 'package:capstone_frontend/core/theme/app_radius.dart';
import 'package:capstone_frontend/core/theme/app_spacing.dart';
import 'package:capstone_frontend/core/theme/app_text_styles.dart';
import 'package:capstone_frontend/core/widgets/info_card.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  static const building = '101';
  static const unit = '1203';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('배송 현황')),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: '홈'),
          NavigationDestination(icon: Icon(Icons.local_shipping_outlined), label: '배송현황'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: '내역'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: '내 정보'),
        ],
        onDestinationSelected: (index) => _onNavTap(context, index),
      ),
      body: ValueListenableBuilder<DeliveryMissionItem?>(
        valueListenable: DeliveryMissionStore.instance.activeMission,
        builder: (context, _, __) {
          return ValueListenableBuilder<List<DeliveryMissionItem>>(
            valueListenable: DeliveryMissionStore.instance.history,
            builder: (context, __, ___) {
              final mission = DeliveryMissionStore.instance.latestMissionForAddress(
                building: building,
                unit: unit,
              );

              final exists = mission != null;
              final isCompleted = mission?.status == DeliveryMissionStatus.completed;
              final isArrived = mission?.status == DeliveryMissionStatus.arrived;

              return ListView(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                children: [
                  Text(
                    exists
                        ? (isCompleted
                        ? '최근 배송이 완료되었습니다'
                        : '현재 새벽배송이 진행 중입니다')
                        : '현재 배송 정보가 없습니다',
                    style: AppTextStyles.body,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  InfoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(AppRadius.md),
                              ),
                              child: Text(
                                isCompleted
                                    ? '완료'
                                    : isArrived
                                    ? '도착'
                                    : '이동 중',
                                style: AppTextStyles.sub.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              exists && !isCompleted
                                  ? 'ETA ${mission!.etaLabel}'
                                  : '배송 완료',
                              style: AppTextStyles.sub,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          exists ? mission!.addressLabel : '101동 1203호',
                          style: AppTextStyles.sectionTitle,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          exists
                              ? (isCompleted
                              ? '최근 배송 완료'
                              : isArrived
                              ? '문 앞 도착 완료'
                              : '예상 도착 ${mission!.etaLabel}')
                              : '배송 준비 중',
                          style: AppTextStyles.body,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  InfoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _TrackingStep(
                          title: '접수됨',
                          state: _stepState(0, mission),
                          isLast: false,
                        ),
                        _TrackingStep(
                          title: '로봇 적재 완료',
                          state: _stepState(1, mission),
                          isLast: false,
                        ),
                        _TrackingStep(
                          title: '건물 진입',
                          state: _stepState(2, mission),
                          isLast: false,
                        ),
                        _TrackingStep(
                          title: '층 이동 중',
                          subtitle: exists && !isCompleted
                              ? '${_floorText(mission!.unit)}층으로 이동 중'
                              : '',
                          state: _stepState(3, mission),
                          isLast: false,
                        ),
                        _TrackingStep(
                          title: '문 앞 도착',
                          state: _stepState(4, mission),
                          isLast: false,
                        ),
                        _TrackingStep(
                          title: '배송 완료',
                          state: _stepState(5, mission),
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  InfoCard(
                    backgroundColor: AppColors.primaryLight,
                    child: Text(
                      isCompleted
                          ? '배송이 안전하게 완료되었습니다.'
                          : isArrived
                          ? '문 앞에 도착했습니다. 확인해주세요.'
                          : '배송이 완료되면 바로 알려드릴게요.',
                      style: AppTextStyles.body,
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  _TimelineState _stepState(int index, DeliveryMissionItem? mission) {
    if (mission == null) return _TimelineState.future;
    if (mission.status == DeliveryMissionStatus.completed) {
      return _TimelineState.done;
    }
    if (index < mission.currentStep) return _TimelineState.done;
    if (index == mission.currentStep) return _TimelineState.current;
    return _TimelineState.future;
  }

  String _floorText(String unit) {
    if (unit.length >= 2) {
      return unit.substring(0, 2);
    }
    return unit.substring(0, 1);
  }

  void _onNavTap(BuildContext context, int index) {
    if (index == 1) return;

    final route = switch (index) {
      0 => '/',
      2 => '/history',
      3 => '/profile',
      _ => '/',
    };

    Navigator.of(context).pushReplacementNamed(route);
  }
}

enum _TimelineState { done, current, future }

class _TrackingStep extends StatelessWidget {
  final String title;
  final String? subtitle;
  final _TimelineState state;
  final bool isLast;

  const _TrackingStep({
    required this.title,
    this.subtitle,
    required this.state,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = state == _TimelineState.done;
    final isCurrent = state == _TimelineState.current;

    final lineColor =
    (isDone || isCurrent) ? AppColors.primary : AppColors.stroke;
    final dotColor =
    isDone ? AppColors.primary : (isCurrent ? Colors.white : AppColors.surface);
    final dotBorderColor =
    (isDone || isCurrent) ? AppColors.primary : AppColors.stroke;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 28,
            child: Column(
              children: [
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: dotBorderColor,
                      width: 3,
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: lineColor,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.body),
                  if (subtitle != null && subtitle!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(subtitle!, style: AppTextStyles.sub),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}