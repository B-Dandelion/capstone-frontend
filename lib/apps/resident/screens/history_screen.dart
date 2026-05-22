import 'package:flutter/material.dart';
import 'package:capstone_frontend/core/models/delivery_mission_item.dart';
import 'package:capstone_frontend/core/models/freshbag_request_item.dart';
import 'package:capstone_frontend/core/services/delivery_mission_store.dart';
import 'package:capstone_frontend/core/services/freshbag_request_store.dart';
import 'package:capstone_frontend/core/theme/app_colors.dart';
import 'package:capstone_frontend/core/theme/app_radius.dart';
import 'package:capstone_frontend/core/theme/app_spacing.dart';
import 'package:capstone_frontend/core/theme/app_text_styles.dart';
import 'package:capstone_frontend/core/widgets/info_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  static const building = '101';
  static const unit = '1203';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('내역')),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 2,
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
              return ValueListenableBuilder<List<FreshbagRequestItem>>(
                valueListenable: FreshbagRequestStore.instance.items,
                builder: (context, ____, _____) {
                  final deliveryHistory =
                  DeliveryMissionStore.instance.historyForAddress(
                    building: building,
                    unit: unit,
                  );

                  final freshbagHistory = FreshbagRequestStore.instance
                      .getAll()
                      .where((e) => e.building == building && e.unit == unit)
                      .toList();

                  return ListView(
                    padding: const EdgeInsets.all(AppSpacing.xxl),
                    children: [
                      const Text('배송 내역', style: AppTextStyles.sectionTitle),
                      const SizedBox(height: AppSpacing.lg),
                      if (deliveryHistory.isEmpty)
                        const InfoCard(
                          child: Text('배송 내역이 없습니다.', style: AppTextStyles.body),
                        )
                      else
                        ...deliveryHistory.map(
                              (item) => Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.md),
                            child: InfoCard(
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
                                      Icons.local_shipping_outlined,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.lg),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(item.addressLabel, style: AppTextStyles.body),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${item.startedAt.month}/${item.startedAt.day} · ${item.quantity}개',
                                          style: AppTextStyles.sub,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8F7EE),
                                      borderRadius: BorderRadius.circular(AppRadius.md),
                                    ),
                                    child: Text(
                                      '완료',
                                      style: AppTextStyles.sub.copyWith(
                                        color: AppColors.success,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: AppSpacing.xl),
                      const Text('프레시백 수거 내역', style: AppTextStyles.sectionTitle),
                      const SizedBox(height: AppSpacing.lg),
                      if (freshbagHistory.isEmpty)
                        const InfoCard(
                          child: Text('프레시백 수거 내역이 없습니다.', style: AppTextStyles.body),
                        )
                      else
                        ...freshbagHistory.map(
                              (item) => Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.md),
                            child: InfoCard(
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
                                      Icons.shopping_bag_outlined,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.lg),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(item.addressLabel, style: AppTextStyles.body),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${item.requestedAt.month}/${item.requestedAt.day} 요청',
                                          style: AppTextStyles.sub,
                                        ),
                                      ],
                                    ),
                                  ),
                                  _FreshbagStatusBadge(status: item.status),
                                ],
                              ),
                            ),
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

  void _onNavTap(BuildContext context, int index) {
    if (index == 2) return;

    final route = switch (index) {
      0 => '/',
      1 => '/tracking',
      3 => '/profile',
      _ => '/',
    };

    Navigator.of(context).pushReplacementNamed(route);
  }
}

class _FreshbagStatusBadge extends StatelessWidget {
  final FreshbagRequestStatus status;

  const _FreshbagStatusBadge({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final label = switch (status) {
      FreshbagRequestStatus.requested => '요청',
      FreshbagRequestStatus.failed => '실패',
      FreshbagRequestStatus.completed => '완료',
    };

    final bg = switch (status) {
      FreshbagRequestStatus.requested => AppColors.primaryLight,
      FreshbagRequestStatus.failed => const Color(0xFFFFF2F2),
      FreshbagRequestStatus.completed => const Color(0xFFE8F7EE),
    };

    final fg = switch (status) {
      FreshbagRequestStatus.requested => AppColors.primary,
      FreshbagRequestStatus.failed => AppColors.error,
      FreshbagRequestStatus.completed => AppColors.success,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Text(
        label,
        style: AppTextStyles.sub.copyWith(
          color: fg,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}