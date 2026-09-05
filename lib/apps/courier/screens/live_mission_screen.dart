import 'package:flutter/material.dart';
import 'package:capstone_frontend/core/models/delivery_mission_item.dart';
import 'package:capstone_frontend/core/services/delivery_mission_store.dart';
import 'package:capstone_frontend/core/services/robot_load_store.dart';
import 'package:capstone_frontend/core/theme/app_colors.dart';
import 'package:capstone_frontend/core/theme/app_radius.dart';
import 'package:capstone_frontend/core/theme/app_spacing.dart';
import 'package:capstone_frontend/core/theme/app_text_styles.dart';

class LiveMissionScreen extends StatefulWidget {
  const LiveMissionScreen({super.key});

  @override
  State<LiveMissionScreen> createState() => _LiveMissionScreenState();
}

class _LiveMissionScreenState extends State<LiveMissionScreen> {
  int _demoStep = 0;

  static const List<String> _steps = [
    '접수됨',
    '로봇 적재 완료',
    '이동',
    '배송 층 도착',
    '배송 완료',
    '프레시백 회수',
    '복귀',
  ];

  String _formatAddress(String building, String unit) {
    if (building.trim().isEmpty) return '${unit}호';
    return '${building}동 ${unit}호';
  }

  void _advanceStep() {
    setState(() {
      if (_demoStep >= _steps.length - 1) {
        _demoStep = 0;
      } else {
        _demoStep++;
      }
    });
  }

  _TimelineState _stepState(int index) {
    if (index < _demoStep) return _TimelineState.done;
    if (index == _demoStep) return _TimelineState.current;
    return _TimelineState.future;
  }

  String _statusChipLabel() {
    if (_demoStep >= 6) return '복귀 중';
    if (_demoStep >= 5) return '회수 중';
    if (_demoStep >= 4) return '배송 완료';
    if (_demoStep >= 3) return '배송 층 도착';
    return '이동 중';
  }

  String _statusDescription(DeliveryMissionItem mission) {
    if (_demoStep >= 6) return '${mission.robotId} · 복귀 진행 중';
    if (_demoStep >= 5) return '${mission.robotId} · 프레시백 회수 진행 중';
    if (_demoStep >= 4) return '${mission.robotId} · 배송이 완료되었습니다';
    if (_demoStep >= 3) return '${mission.robotId} · 배송 층 도착';
    return '${mission.robotId} · 예상 도착 ${mission.etaLabel}';
  }

  String _logMessage(DeliveryMissionItem mission) {
    if (_demoStep >= 6) return '복귀 중';
    if (_demoStep >= 5) return '프레시백 회수 진행 중';
    if (_demoStep >= 4) return '배송 완료';
    if (_demoStep >= 3) return '배송 층 도착';
    return '문 앞 도착 예상 ${mission.etaLabel}';
  }

  String _stepSubtitle(int index, DeliveryMissionItem mission) {
    if (index == 2 && _demoStep == 2) {
      return '목적지 방향으로 이동 중';
    }
    if (index == 3 && _demoStep >= 3) {
      return '${_floorText(mission.unit)}층 도착';
    }
    if (index == 5 && _demoStep >= 5) {
      return '프레시백 회수 진행 중';
    }
    if (index == 6 && _demoStep >= 6) {
      return '기본 위치로 복귀 중';
    }
    return '';
  }

  String _floorText(String unit) {
    if (unit.length >= 2) {
      return unit.substring(0, 1);
    }
    return unit;
  }

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

        final addressLabel = _formatAddress(mission.building, mission.unit);
        final isFinalStep = _demoStep >= 6;

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
                          addressLabel,
                          style: AppTextStyles.headline.copyWith(
                            color: AppColors.textOnDark,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          _statusDescription(mission),
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
                            _statusChipLabel(),
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
                    InkWell(
                      onTap: _advanceStep,
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                      child: Container(
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
                            const SizedBox(height: AppSpacing.sm),
                            const Text(
                              '카드를 탭하면 다음 단계로 진행됩니다.',
                              style: AppTextStyles.sub,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            for (int i = 0; i < _steps.length; i++)
                              _TimelineStep(
                                title: _steps[i],
                                subtitle: _stepSubtitle(i, mission),
                                state: _stepState(i),
                                isLast: i == _steps.length - 1,
                              ),
                          ],
                        ),
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
                          Text('목적지: $addressLabel', style: AppTextStyles.body),
                          const SizedBox(height: 8),
                          Text('작업 수량: ${mission.quantity}개', style: AppTextStyles.body),
                          const SizedBox(height: 8),
                          Text(_logMessage(mission), style: AppTextStyles.body),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    SizedBox(
                      height: 56,
                      child: FilledButton(
                        onPressed: isFinalStep
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
                                  '$addressLabel 배송이 완료되었습니다.',
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
              ),
            ],
          ),
        );
      },
    );
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