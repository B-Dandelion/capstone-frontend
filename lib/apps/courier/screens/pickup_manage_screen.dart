import 'package:flutter/material.dart';
import 'package:capstone_frontend/core/theme/app_colors.dart';
import 'package:capstone_frontend/core/theme/app_radius.dart';
import 'package:capstone_frontend/core/theme/app_spacing.dart';
import 'package:capstone_frontend/core/theme/app_text_styles.dart';
import 'package:capstone_frontend/core/widgets/info_card.dart';

class PickupManageScreen extends StatelessWidget {
  const PickupManageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('프레시백 수거 관리'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '수거 요청'),
              Tab(text: '회수 실패'),
              Tab(text: '누적 미회수'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _PickupRequestTab(),
            _PickupFailedTab(),
            _PickupMissedTab(),
          ],
        ),
      ),
    );
  }
}

class _PickupRequestTab extends StatelessWidget {
  const _PickupRequestTab();

  @override
  Widget build(BuildContext context) {
    final items = const [
      _PickupRowData(
        address: '101동 1203호',
        detail: '수거 요청 · 14:10',
        badgeLabel: '요청',
        badgeColor: AppColors.primaryLight,
        badgeTextColor: AppColors.primary,
      ),
      _PickupRowData(
        address: '102동 804호',
        detail: '수거 요청 · 14:22',
        badgeLabel: '요청',
        badgeColor: AppColors.primaryLight,
        badgeTextColor: AppColors.primary,
      ),
      _PickupRowData(
        address: '105동 1104호',
        detail: '수거 요청 · 14:35',
        badgeLabel: '대기',
        badgeColor: AppColors.surfaceMuted,
        badgeTextColor: AppColors.textMain,
      ),
    ];

    return _PickupList(
      emptyText: '현재 수거 요청이 없습니다.',
      items: items,
      icon: Icons.shopping_bag_outlined,
    );
  }
}

class _PickupFailedTab extends StatelessWidget {
  const _PickupFailedTab();

  @override
  Widget build(BuildContext context) {
    final items = const [
      _PickupRowData(
        address: '101동 1502호',
        detail: '문 앞 미배출 · 실패 1회',
        badgeLabel: '실패',
        badgeColor: Color(0xFFFFE8E8),
        badgeTextColor: AppColors.error,
      ),
      _PickupRowData(
        address: '103동 903호',
        detail: '문 앞 미배출 · 실패 2회',
        badgeLabel: '경고',
        badgeColor: Color(0xFFFFE8E8),
        badgeTextColor: AppColors.error,
      ),
    ];

    return _PickupList(
      emptyText: '현재 회수 실패 항목이 없습니다.',
      items: items,
      icon: Icons.error_outline,
    );
  }
}

class _PickupMissedTab extends StatelessWidget {
  const _PickupMissedTab();

  @override
  Widget build(BuildContext context) {
    final items = const [
      _PickupRowData(
        address: '101동 1502호',
        detail: '3일째 미회수',
        badgeLabel: '3일',
        badgeColor: Color(0xFFFFF2D9),
        badgeTextColor: AppColors.warning,
      ),
      _PickupRowData(
        address: '105동 1104호',
        detail: '2일째 미회수',
        badgeLabel: '2일',
        badgeColor: Color(0xFFFFF2D9),
        badgeTextColor: AppColors.warning,
      ),
    ];

    return _PickupList(
      emptyText: '현재 누적 미회수 항목이 없습니다.',
      items: items,
      icon: Icons.schedule_outlined,
    );
  }
}

class _PickupList extends StatelessWidget {
  final List<_PickupRowData> items;
  final String emptyText;
  final IconData icon;

  const _PickupList({
    required this.items,
    required this.emptyText,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        children: [
          InfoCard(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text(emptyText, style: AppTextStyles.body),
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final item = items[index];

        return InfoCard(
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.address, style: AppTextStyles.body),
                    const SizedBox(height: 4),
                    Text(item.detail, style: AppTextStyles.sub),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: item.badgeColor,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Text(
                  item.badgeLabel,
                  style: AppTextStyles.sub.copyWith(
                    color: item.badgeTextColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PickupRowData {
  final String address;
  final String detail;
  final String badgeLabel;
  final Color badgeColor;
  final Color badgeTextColor;

  const _PickupRowData({
    required this.address,
    required this.detail,
    required this.badgeLabel,
    required this.badgeColor,
    required this.badgeTextColor,
  });
}