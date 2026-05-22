import 'package:flutter/material.dart';
import 'package:capstone_frontend/core/models/delivery_mission_item.dart';
import 'package:capstone_frontend/core/services/delivery_mission_store.dart';
import 'package:capstone_frontend/core/services/robot_load_store.dart';
import 'package:capstone_frontend/core/theme/app_colors.dart';
import 'package:capstone_frontend/core/theme/app_radius.dart';
import 'package:capstone_frontend/core/theme/app_spacing.dart';
import 'package:capstone_frontend/core/theme/app_text_styles.dart';

class LiveMissionScreen extends StatelessWidget {
  const LiveMissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DeliveryMissionItem?>(
      valueListenable: DeliveryMissionStore.instance.activeMission,
      builder: (context, mission, _) {
        if (mission == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('실시간 배송')),
            body: const Center(
              child: Text('현재 진행 중인 배송이 없습니다.'),
            ),
          );
        }

        return Scaffold(
          body: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.primary,
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
                        const Text('현재 자동 배송', style: AppTextStyles.sub),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          mission.addressLabel,
                          style: AppTextStyles.headline.copyWith(
                            color: AppColors.textOnDark,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          '${mission.robotId} · ${mission.status == DeliveryMissionStatus.arrived ? '문 앞 도착' : '예상 도착 ${mission.etaLabel}'}',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textOnDark.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                          ),
                          child: Text(
                            mission.status == DeliveryMissionStatus.arrived
                                ? '도착'
                                : '이동 중',
                            style: AppTextStyles.body,
                          ),
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
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                        border: Border.all(color: AppColors.stroke),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('배송 진행 단계', style: AppTextStyles.sectionTitle),
                          const SizedBox(height: AppSpacing.lg),
                          _TimelineStep(
                            title: '접수됨',
                            subtitle: '',
                            state: _stepState(0, mission),
                            isLast: false,
                          ),
                          _TimelineStep(
                            title: '로봇 적재 완료',
                            subtitle: '',
                            state: _stepState(1, mission),
                            isLast: false,
                          ),
                          _TimelineStep(
                            title: '건물 진입',
                            subtitle: '',
                            state: _stepState(2, mission),
                            isLast: false,
                          ),
                          _TimelineStep(
                            title: '층 이동 중',
                            subtitle: '${_floorText(mission.unit)}층으로 이동 중',
                            state: _stepState(3, mission),
                            isLast: false,
                          ),
                          _TimelineStep(
                            title: '문 앞 도착',
                            subtitle: '',
                            state: _stepState(4, mission),
                            isLast: false,
                          ),
                          _TimelineStep(
                            title: '배송 완료',
                            subtitle: '',
                            state: _stepState(5, mission),
                            isLast: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                        border: Border.all(color: AppColors.stroke),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('실시간 운영 로그', style: AppTextStyles.sectionTitle),
                          const SizedBox(height: AppSpacing.lg),
                          Text('로봇: ${mission.robotId}', style: AppTextStyles.body),
                          const SizedBox(height: 8),
                          Text('목적지: ${mission.addressLabel}', style: AppTextStyles.body),
                          const SizedBox(height: 8),
                          Text('작업 수량: ${mission.quantity}개', style: AppTextStyles.body),
                          const SizedBox(height: 8),
                          Text(
                            mission.status == DeliveryMissionStatus.arrived
                                ? '문 앞 도착 완료'
                                : '문 앞 도착 예상 ${mission.etaLabel}',
                            style: AppTextStyles.body,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: mission.status == DeliveryMissionStatus.arrived
                                ? null
                                : () {
                              DeliveryMissionStore.instance.advanceStep();
                            },
                            child: const Text('단계 진행'),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: FilledButton(
                            onPressed: mission.status == DeliveryMissionStatus.arrived
                                ? () {
                              RobotLoadStore.instance.removeFirstMatching(
                                robotId: mission.robotId,
                                building: mission.building,
                                unit: mission.unit,
                              );
                              DeliveryMissionStore.instance.completeActiveMission();

                              showDialog<void>(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('배송 완료'),
                                    content: Text(
                                      '${mission.addressLabel} 배송이 완료되었습니다.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('확인'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                                : null,
                            child: const Text('배송 완료'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      height: 56,
                      child: OutlinedButton(
                        onPressed: mission.status == DeliveryMissionStatus.arrived
                            ? null
                            : () {
                          DeliveryMissionStore.instance.markArrived();
                        },
                        child: const Text('문 앞 도착 처리'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _TimelineState _stepState(int index, DeliveryMissionItem mission) {
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
}

enum _TimelineState { done, current, future }

class _TimelineStep extends StatelessWidget {
  final String title;
  final String subtitle;
  final _TimelineState state;
  final bool isLast;

  const _TimelineStep({
    required this.title,
    required this.subtitle,
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
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(subtitle, style: AppTextStyles.sub),
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