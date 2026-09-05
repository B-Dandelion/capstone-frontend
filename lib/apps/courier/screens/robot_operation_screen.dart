import 'package:flutter/material.dart';
import 'package:capstone_frontend/apps/courier/screens/camera_scan_screen.dart';
import 'package:capstone_frontend/apps/courier/screens/create_delivery_screen.dart';
import 'package:capstone_frontend/apps/courier/screens/live_mission_screen.dart';
import 'package:capstone_frontend/apps/courier/screens/load_board_screen.dart';
import 'package:capstone_frontend/core/models/delivery_mission_item.dart';
import 'package:capstone_frontend/core/models/load_board_item.dart';
import 'package:capstone_frontend/core/services/delivery_mission_store.dart';
import 'package:capstone_frontend/core/services/robot_load_store.dart';
import 'package:capstone_frontend/core/theme/app_colors.dart';
import 'package:capstone_frontend/core/theme/app_radius.dart';
import 'package:capstone_frontend/core/theme/app_spacing.dart';
import 'package:capstone_frontend/core/theme/app_text_styles.dart';

class RobotOperationScreen extends StatelessWidget {
  final String robotId;

  const RobotOperationScreen({
    super.key,
    required this.robotId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$robotId 운영 화면'),
      ),
      body: ValueListenableBuilder<Map<String, List<LoadBoardItem>>>(
        valueListenable: RobotLoadStore.instance.itemsByRobot,
        builder: (context, board, _) {
          return ValueListenableBuilder<DeliveryMissionItem?>(
            valueListenable: DeliveryMissionStore.instance.activeMission,
            builder: (context, __, ___) {
              final items = RobotLoadStore.instance.getItems(robotId);
              final recentItems = items.take(4).toList();
              final activeMission =
              DeliveryMissionStore.instance.activeMissionForRobot(robotId);
              final isBusy = activeMission != null;

              return ListView(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                children: [
                  _HeroPanel(
                    robotId: robotId,
                    isBusy: isBusy,
                    activeMission: activeMission,
                    loadCount: items.length,
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  if (isBusy) ...[
                    _CurrentMissionPanel(
                      mission: activeMission,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const LiveMissionScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],

                  Row(
                    children: [
                      Expanded(
                        child: _ActionCard(
                          icon: Icons.camera_alt_outlined,
                          title: '카메라 스캔',
                          subtitle: isBusy ? '운행 중 사용 불가' : '목적지 스캔',
                          enabled: !isBusy,
                          onTap: () {
                            if (isBusy) return;
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => CameraScanScreen(robotId: robotId),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _ActionCard(
                          icon: Icons.view_column_outlined,
                          title: '적재 현황',
                          subtitle: '현재 카드 확인',
                          enabled: true,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => LoadBoardScreen(robotId: robotId),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  SizedBox(
                    height: 56,
                    child: FilledButton.icon(
                      onPressed: isBusy
                          ? null
                          : () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                CreateDeliveryScreen(robotId: robotId),
                          ),
                        );
                      },
                      icon: const Icon(Icons.arrow_forward),
                      label: Text(isBusy ? '현재 배송 진행 중' : '새 배송 작업 등록'),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),
                  const Text('최근 적재 카드', style: AppTextStyles.sectionTitle),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    isBusy
                        ? '현재 로봇에 적재된 목적지 카드입니다.'
                        : '스캔된 목적지가 최근 순서대로 표시됩니다.',
                    style: AppTextStyles.sub,
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  if (recentItems.isEmpty)
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
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceMuted,
                              borderRadius: BorderRadius.circular(AppRadius.md),
                            ),
                            child: const Icon(
                              Icons.inventory_2_outlined,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          const Expanded(
                            child: Text(
                              '아직 적재된 목적지가 없습니다. 카메라 스캔으로 추가하세요.',
                              style: AppTextStyles.body,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...recentItems.map(
                          (item) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      LoadBoardScreen(robotId: robotId),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(AppSpacing.lg),
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(AppRadius.lg),
                                border: Border.all(color: AppColors.stroke),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryLight,
                                      borderRadius:
                                      BorderRadius.circular(AppRadius.md),
                                    ),
                                    child: const Icon(
                                      Icons.inventory_2_outlined,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.lg),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.addressLabel,
                                          style: AppTextStyles.body,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${item.zone} · ${_timeLabel(item.createdAt)} 적재',
                                          style: AppTextStyles.sub,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceMuted,
                                      borderRadius:
                                      BorderRadius.circular(AppRadius.md),
                                    ),
                                    child: const Text(
                                      '보기',
                                      style: AppTextStyles.sub,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: AppSpacing.xl),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: AppColors.primary),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            isBusy
                                ? '현재 배송이 끝나면 다음 작업 등록이 가능합니다.'
                                : '스캔으로 목적지를 추가한 뒤 배송 작업을 등록하세요.',
                            style: AppTextStyles.body,
                          ),
                        ),
                      ],
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

  static String _timeLabel(DateTime dt) {
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }
}

class _HeroPanel extends StatelessWidget {
  final String robotId;
  final bool isBusy;
  final DeliveryMissionItem? activeMission;
  final int loadCount;

  const _HeroPanel({
    required this.robotId,
    required this.isBusy,
    required this.activeMission,
    required this.loadCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('운영 장비', style: AppTextStyles.sub),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isBusy ? AppColors.primaryDark : AppColors.primary,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Text(
                  isBusy ? '운행 중' : 'READY',
                  style: AppTextStyles.sub.copyWith(
                    color: AppColors.textOnDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(robotId, style: AppTextStyles.headline),
          const SizedBox(height: AppSpacing.sm),
          Text(
            isBusy
                ? '${activeMission!.addressLabel} 배송 진행 중'
                : '배터리 84% · 즉시 사용',
            style: AppTextStyles.body,
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  label: '현재 적재',
                  value: '$loadCount건',
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _MiniStat(
                  label: '배송 상태',
                  value: isBusy ? '진행 중' : '대기',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CurrentMissionPanel extends StatelessWidget {
  final DeliveryMissionItem mission;
  final VoidCallback onTap;

  const _CurrentMissionPanel({
    required this.mission,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('현재 진행 중 배송', style: AppTextStyles.sectionTitle),
          const SizedBox(height: AppSpacing.md),
          Text(
            '${mission.addressLabel} · ${mission.quantity}개',
            style: AppTextStyles.body,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            mission.status == DeliveryMissionStatus.arrived
                ? '문 앞 도착 완료'
                : '예상 도착 ${mission.etaLabel}',
            style: AppTextStyles.sub,
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton.icon(
              onPressed: onTap,
              icon: const Icon(Icons.local_shipping_outlined),
              label: const Text('실시간 배송 보기'),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;

  const _MiniStat({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.sub),
          const SizedBox(height: 6),
          Text(value, style: AppTextStyles.body),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool enabled;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        onTap: enabled ? onTap : null,
        child: Opacity(
          opacity: enabled ? 1 : 0.55,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(color: AppColors.stroke),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 28, color: AppColors.primary),
                const SizedBox(height: AppSpacing.md),
                Text(title, style: AppTextStyles.body),
                const SizedBox(height: 4),
                Text(subtitle, style: AppTextStyles.sub),
              ],
            ),
          ),
        ),
      ),
    );
  }
}