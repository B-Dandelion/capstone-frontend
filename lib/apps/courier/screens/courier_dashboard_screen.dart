import 'package:flutter/material.dart';
import 'package:capstone_frontend/apps/courier/screens/pickup_manage_screen.dart';
import 'package:capstone_frontend/apps/courier/screens/robot_connect_screen.dart';
import 'package:capstone_frontend/apps/courier/screens/scout_wifi_test_screen.dart';
import 'package:capstone_frontend/core/models/delivery_mission_item.dart';
import 'package:capstone_frontend/core/models/delivery_status.dart';
import 'package:capstone_frontend/core/models/load_board_item.dart';
import 'package:capstone_frontend/core/models/freshbag_request_item.dart';
import 'package:capstone_frontend/core/services/delivery_mission_store.dart';
import 'package:capstone_frontend/core/services/freshbag_request_store.dart';
import 'package:capstone_frontend/core/services/robot_load_store.dart';
import 'package:capstone_frontend/core/theme/app_colors.dart';
import 'package:capstone_frontend/core/theme/app_radius.dart';
import 'package:capstone_frontend/core/theme/app_spacing.dart';
import 'package:capstone_frontend/core/theme/app_text_styles.dart';
import 'package:capstone_frontend/core/widgets/info_card.dart';
import 'package:capstone_frontend/core/widgets/status_chip.dart';

class CourierDashboardScreen extends StatelessWidget {
  const CourierDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<Map<String, List<LoadBoardItem>>>(
        valueListenable: RobotLoadStore.instance.itemsByRobot,
        builder: (context, _, __) {
          return ValueListenableBuilder<DeliveryMissionItem?>(
            valueListenable: DeliveryMissionStore.instance.activeMission,
            builder: (context, ___, ____) {
              return ValueListenableBuilder<List<FreshbagRequestItem>>(
                valueListenable: FreshbagRequestStore.instance.items,
                builder: (context, ____, _____) {
                  final totalLoadCount = RobotLoadStore.instance.itemsByRobot.value
                      .values
                      .fold<int>(0, (sum, items) => sum + items.length);

                  final activeMission = DeliveryMissionStore.instance.activeMission.value;
                  final requestedCount =
                      FreshbagRequestStore.instance.getRequested().length;
                  final failedCount =
                      FreshbagRequestStore.instance.getFailed().length;

                  final currentRobotId = activeMission?.robotId ?? 'R-02';
                  final currentRobotLoad =
                  RobotLoadStore.instance.countForRobot(currentRobotId);

                  return Column(
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
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      backgroundColor: Colors.white24,
                                      child: Icon(Icons.person, color: Colors.white),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.notifications_none,
                                          color: Colors.white),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.settings_outlined,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.xl),
                                Text(
                                  '새벽배송 운영 현황',
                                  style: AppTextStyles.headline.copyWith(
                                    color: AppColors.textOnDark,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  '현재 적재 $totalLoadCount건 · 진행 중 배송 ${DeliveryMissionStore.instance.activeMissionCount}건',
                                  style: AppTextStyles.body.copyWith(
                                    color:
                                    AppColors.textOnDark.withOpacity(0.9),
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
                            InfoCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text('운영 중 장비',
                                          style: AppTextStyles.sub),
                                      const Spacer(),
                                      StatusChip(
                                        status: DeliveryStatus.arrived,
                                        customLabel: activeMission == null ? 'READY' : '운행 중',
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppSpacing.lg),
                                  Text(currentRobotId,
                                      style: AppTextStyles.headline),
                                  const SizedBox(height: AppSpacing.sm),
                                  Text(
                                    activeMission == null
                                        ? '배터리 82% · 즉시 사용 가능'
                                        : '${activeMission.addressLabel} 배송 진행 중',
                                    style: AppTextStyles.body,
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  Text(
                                    '현재 적재 ${currentRobotLoad}건',
                                    style: AppTextStyles.body,
                                  ),
                                  const SizedBox(height: AppSpacing.xl),
                                  Row(
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) =>
                                              const RobotConnectScreen(),
                                            ),
                                          );
                                        },
                                        child: const Text('장비 변경'),
                                      ),
                                      const SizedBox(width: AppSpacing.md),
                                      Expanded(
                                        child: SizedBox(
                                          height: 56,
                                          child: FilledButton.icon(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                  const RobotConnectScreen(),
                                                ),
                                              );
                                            },
                                            icon: const Icon(Icons.arrow_forward),
                                            label: Text(
                                              activeMission == null
                                                  ? '로봇 선택 및 운영 시작'
                                                  : '운행 로봇 확인',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            _QuickEntryCard(
                              icon: Icons.precision_manufacturing_outlined,
                              title: '로봇 연결 및 적재 관리',
                              subtitle:
                              '로봇을 선택한 뒤 해당 로봇의 스캔/적재 현황을 관리합니다.',
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const RobotConnectScreen(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: AppSpacing.md),
                            _QuickEntryCard(
                              icon: Icons.shopping_bag_outlined,
                              title: '프레시백 수거 관리',
                              subtitle:
                              '수거 요청, 회수 실패, 누적 미회수 현황을 확인합니다.',
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const PickupManageScreen(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: AppSpacing.md),
                            _QuickEntryCard(
                              icon: Icons.wifi,
                              title: 'Scout Mini 통신 테스트',
                              subtitle: '운영 앱과 장비 간 명령 송수신을 확인합니다.',
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const ScoutWifiTestScreen(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            const Text('운영 요약',
                                style: AppTextStyles.sectionTitle),
                            const SizedBox(height: AppSpacing.lg),
                            GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              mainAxisSpacing: AppSpacing.lg,
                              crossAxisSpacing: AppSpacing.lg,
                              childAspectRatio: 1.35,
                              children: [
                                _StatMiniCard(
                                  label: '현재 적재',
                                  value: '$totalLoadCount',
                                ),
                                _StatMiniCard(
                                  label: '진행 중 배송',
                                  value:
                                  '${DeliveryMissionStore.instance.activeMissionCount}',
                                ),
                                _StatMiniCard(
                                  label: '수거 요청',
                                  value: '$requestedCount',
                                ),
                                _StatMiniCard(
                                  label: '회수 실패',
                                  value: '$failedCount',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _QuickEntryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickEntryCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.body),
                const SizedBox(height: 4),
                Text(subtitle, style: AppTextStyles.sub),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          OutlinedButton(
            onPressed: onTap,
            child: const Text('열기'),
          ),
        ],
      ),
    );
  }
}

class _StatMiniCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatMiniCard({
    required this.label,
    required this.value,
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
          Text(label, style: AppTextStyles.sub),
          const Spacer(),
          Text(value, style: AppTextStyles.headline),
        ],
      ),
    );
  }
}