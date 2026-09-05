import 'package:flutter/material.dart';
import 'package:capstone_frontend/core/models/delivery_mission_item.dart';
import 'package:capstone_frontend/core/models/delivery_status.dart';
import 'package:capstone_frontend/core/models/freshbag_request_item.dart';
import 'package:capstone_frontend/core/services/delivery_mission_store.dart';
import 'package:capstone_frontend/core/services/freshbag_request_store.dart';
import 'package:capstone_frontend/core/theme/app_colors.dart';
import 'package:capstone_frontend/core/theme/app_radius.dart';
import 'package:capstone_frontend/core/theme/app_spacing.dart';
import 'package:capstone_frontend/core/theme/app_text_styles.dart';
import 'package:capstone_frontend/core/widgets/hero_status_card.dart';
import 'package:capstone_frontend/core/widgets/info_card.dart';
import 'package:capstone_frontend/core/widgets/status_chip.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const building = '';
  static const unit = '523';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: '홈'),
          NavigationDestination(
            icon: Icon(Icons.local_shipping_outlined),
            label: '배송현황',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            label: '내역',
          ),
          NavigationDestination(icon: Icon(Icons.person_outline), label: '내 정보'),
        ],
        onDestinationSelected: (index) => _onNavTap(context, index),
      ),
      body: SafeArea(
        child: ValueListenableBuilder<DeliveryMissionItem?>(
          valueListenable: DeliveryMissionStore.instance.activeMission,
          builder: (context, _, __) {
            return ValueListenableBuilder<List<DeliveryMissionItem>>(
              valueListenable: DeliveryMissionStore.instance.history,
              builder: (context, __, ___) {
                return ValueListenableBuilder<List<FreshbagRequestItem>>(
                  valueListenable: FreshbagRequestStore.instance.items,
                  builder: (context, ____, _____) {
                    final mission =
                    DeliveryMissionStore.instance.latestMissionForAddress(
                      building: building,
                      unit: unit,
                    );

                    final latestCompleted = DeliveryMissionStore.instance
                        .latestCompletedForAddress(
                      building: building,
                      unit: unit,
                    );

                    final latestFreshbag =
                    FreshbagRequestStore.instance.latestForAddress(
                      building: building,
                      unit: unit,
                    );

                    final heroTitle = mission == null
                        ? '오늘 도착 예정 배송 1건'
                        : mission.status == DeliveryMissionStatus.completed
                        ? '최근 배송이 완료되었습니다'
                        : '오늘 도착 예정 배송 1건';

                    final heroStatus = mission == null
                        ? '로봇이 자동 배송 중입니다'
                        : mission.status == DeliveryMissionStatus.completed
                        ? '문 앞 배송이 완료되었습니다'
                        : mission.status == DeliveryMissionStatus.arrived
                        ? '문 앞에 도착했습니다'
                        : '로봇이 자동 배송 중입니다';

                    final heroEta = mission == null
                        ? '예상 도착 01:18'
                        : mission.status == DeliveryMissionStatus.completed
                        ? '방금 배송 완료'
                        : mission.status == DeliveryMissionStatus.arrived
                        ? '문 앞 도착 완료'
                        : '예상 도착 ${mission.etaLabel}';

                    final hasRecentDelivery = true;

                    final recentDeliveryTime = latestCompleted != null
                        ? '${latestCompleted.startedAt.hour.toString().padLeft(2, '0')}:${latestCompleted.startedAt.minute.toString().padLeft(2, '0')}'
                        : '06:42';

                    final recentDeliveryLabel = latestCompleted != null
                        ? '$recentDeliveryTime 배송 완료'
                        : '오늘 06:42 배송 완료';

                    return ListView(
                      padding: const EdgeInsets.all(AppSpacing.xxl),
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.xl),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(AppRadius.xl),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text('523호', style: AppTextStyles.sectionTitle),
                                    SizedBox(height: 6),
                                    Text(
                                      '오늘 새벽배송 상태를 확인하세요',
                                      style: AppTextStyles.sub,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(AppRadius.md),
                                ),
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.notifications_none),
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        HeroStatusCard(
                          title: heroTitle,
                          status: heroStatus,
                          eta: heroEta,
                          onTap: () => Navigator.of(context).pushNamed('/tracking'),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        InfoCard(
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight,
                                  borderRadius: BorderRadius.circular(AppRadius.md),
                                ),
                                child: const Icon(
                                  Icons.notifications_active_outlined,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.lg),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '문 앞 도착 알림',
                                      style: AppTextStyles.body,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '문 앞 도착 시 알림을 받을 수 있습니다.',
                                      style: AppTextStyles.sub,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              const StatusChip(
                                status: DeliveryStatus.arrived,
                                customLabel: 'ON',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        InfoCard(
                          backgroundColor:
                          hasRecentDelivery ? AppColors.primaryLight : Colors.white,
                          child: Row(
                            children: [
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(
                                    hasRecentDelivery ? 0.9 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(AppRadius.md),
                                ),
                                child: Icon(
                                  hasRecentDelivery
                                      ? Icons.check_circle_outline
                                      : Icons.receipt_long_outlined,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.lg),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '최근 배송',
                                      style: AppTextStyles.body,
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      '523호',
                                      style: AppTextStyles.sub,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      recentDeliveryLabel,
                                      style: AppTextStyles.sub,
                                    ),
                                  ],
                                ),
                              ),
                              if (hasRecentDelivery)
                                const StatusChip(
                                  status: DeliveryStatus.completed,
                                  customLabel: '완료',
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        _FreshbagStatusCard(
                          latest: latestFreshbag,
                          onTap: () {
                            Navigator.of(context).pushNamed('/freshbag-request');
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _onNavTap(BuildContext context, int index) {
    if (index == 0) return;

    final route = switch (index) {
      1 => '/tracking',
      2 => '/history',
      3 => '/profile',
      _ => '/',
    };

    Navigator.of(context).pushReplacementNamed(route);
  }
}

class _FreshbagStatusCard extends StatelessWidget {
  final FreshbagRequestItem? latest;
  final VoidCallback onTap;

  const _FreshbagStatusCard({
    required this.latest,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final title = switch (latest?.status) {
      FreshbagRequestStatus.requested => '프레시백 수거 요청 완료',
      FreshbagRequestStatus.failed => '프레시백 회수 실패',
      FreshbagRequestStatus.completed => '프레시백 수거 완료',
      null => '프레시백 수거 요청',
    };

    final subtitle = switch (latest?.status) {
      FreshbagRequestStatus.requested => '기사 앱에서 수거 요청을 확인 중입니다.',
      FreshbagRequestStatus.failed => '문 앞 배치 상태를 다시 확인한 뒤 재요청해주세요.',
      FreshbagRequestStatus.completed => '프레시백 회수가 완료되었습니다.',
      null => '문 앞에 배치한 프레시백 회수를 요청합니다.',
    };

    final bgColor = switch (latest?.status) {
      FreshbagRequestStatus.requested => AppColors.primaryLight,
      FreshbagRequestStatus.failed => const Color(0xFFFFF2F2),
      FreshbagRequestStatus.completed => const Color(0xFFE8F7EE),
      null => Colors.white,
    };

    final iconColor = switch (latest?.status) {
      FreshbagRequestStatus.requested => AppColors.primary,
      FreshbagRequestStatus.failed => AppColors.error,
      FreshbagRequestStatus.completed => AppColors.success,
      null => AppColors.primary,
    };

    final icon = switch (latest?.status) {
      FreshbagRequestStatus.requested => Icons.shopping_bag_outlined,
      FreshbagRequestStatus.failed => Icons.warning_amber_rounded,
      FreshbagRequestStatus.completed => Icons.check_circle_outline,
      null => Icons.shopping_bag_outlined,
    };

    return InfoCard(
      backgroundColor: bgColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.78),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(icon, color: iconColor),
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