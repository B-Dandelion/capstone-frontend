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
import 'package:capstone_frontend/core/widgets/press_feedback.dart';
import 'package:capstone_frontend/apps/courier/screens/notification_screen.dart';
import 'package:capstone_frontend/apps/courier/screens/settings_screen.dart';

class _HeaderActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderActionButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PressFeedback(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      splashColor: Colors.white.withOpacity(0.16),
      highlightColor: Colors.white.withOpacity(0.10),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withOpacity(0.14),
          ),
        ),
        child: Icon(
          icon,
          color: AppColors.textOnDark,
          size: 24,
        ),
      ),
    );
  }
}

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
                  final activeMission =
                      DeliveryMissionStore.instance.activeMission.value;

                  final currentRobotId = activeMission?.robotId ?? 'R-02';
                  final currentRobotLoad =
                  RobotLoadStore.instance.countForRobot(currentRobotId);

                  // 발표/시연용으로 너무 비어 보이지 않게 현실적인 값 고정
                  final totalLoadCount = 4;
                  final activeDeliveryCount = activeMission == null ? 1 : 1;
                  final requestedCount = 2;
                  final failedCount = 1;

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
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.md),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '김도윤 기사',
                                          style: AppTextStyles.body.copyWith(
                                            color: AppColors.textOnDark,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          '새벽배송 운영 담당',
                                          style: AppTextStyles.sub.copyWith(
                                            color: AppColors.textOnDark
                                                .withOpacity(0.86),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    _HeaderActionButton(
                                      icon: Icons.notifications_none,
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) =>
                                            const CourierNotificationScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(width: AppSpacing.sm),
                                    _HeaderActionButton(
                                      icon: Icons.settings_outlined,
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) =>
                                            const CourierSettingsScreen(),
                                          ),
                                        );
                                      },
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
                                  '현재 적재 ${totalLoadCount}건 · 진행 중 배송 ${activeDeliveryCount}건',
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
                                      const Text(
                                        '운영 중 장비',
                                        style: AppTextStyles.sub,
                                      ),
                                      const Spacer(),
                                      StatusChip(
                                        status: DeliveryStatus.arrived,
                                        customLabel: activeMission == null
                                            ? 'READY'
                                            : '운행 중',
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppSpacing.lg),
                                  Text(
                                    currentRobotId,
                                    style: AppTextStyles.headline,
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  Text(
                                    activeMission == null
                                        ? '배터리 82% · 523호 배송 진행 중'
                                        : '${activeMission.addressLabel} 배송 진행 중',
                                    style: AppTextStyles.body,
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  Text(
                                    '현재 적재 ${currentRobotLoad == 0 ? 4 : currentRobotLoad}건',
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
                                            icon:
                                            const Icon(Icons.arrow_forward),
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
                                    builder: (_) =>
                                    const ScoutWifiTestScreen(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            const Text(
                              '운영 요약',
                              style: AppTextStyles.sectionTitle,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              mainAxisSpacing: AppSpacing.lg,
                              crossAxisSpacing: AppSpacing.lg,
                              childAspectRatio: 1.35,
                              children: [
                                const _StatMiniCard(
                                  label: '현재 적재',
                                  value: '4',
                                ),
                                const _StatMiniCard(
                                  label: '진행 중 배송',
                                  value: '1',
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
    return PressFeedback(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      splashColor: AppColors.primary.withOpacity(0.08),
      highlightColor: AppColors.primary.withOpacity(0.04),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: AppColors.stroke),
        ),
        child: Row(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 32,
              ),
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
            const SizedBox(width: AppSpacing.md),
            OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.stroke),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: 14,
                ),
              ).copyWith(
                overlayColor: WidgetStatePropertyAll(
                  AppColors.primary.withOpacity(0.08),
                ),
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.pressed)) {
                    return AppColors.primaryLight;
                  }
                  return Colors.white;
                }),
              ),
              child: const Text('열기'),
            ),
          ],
        ),
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