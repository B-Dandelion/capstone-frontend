import 'package:flutter/material.dart';
import 'package:capstone_frontend/core/models/freshbag_request_item.dart';
import 'package:capstone_frontend/core/services/freshbag_request_store.dart';
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
    return ValueListenableBuilder<List<FreshbagRequestItem>>(
      valueListenable: FreshbagRequestStore.instance.items,
      builder: (context, _, __) {
        final items = FreshbagRequestStore.instance.getRequested();
        return _PickupList(
          emptyText: '현재 수거 요청이 없습니다.',
          items: items,
          mode: _PickupListMode.requested,
        );
      },
    );
  }
}

class _PickupFailedTab extends StatelessWidget {
  const _PickupFailedTab();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<FreshbagRequestItem>>(
      valueListenable: FreshbagRequestStore.instance.items,
      builder: (context, _, __) {
        final items = FreshbagRequestStore.instance.getFailed();
        return _PickupList(
          emptyText: '현재 회수 실패 항목이 없습니다.',
          items: items,
          mode: _PickupListMode.failed,
        );
      },
    );
  }
}

class _PickupMissedTab extends StatelessWidget {
  const _PickupMissedTab();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<FreshbagRequestItem>>(
      valueListenable: FreshbagRequestStore.instance.items,
      builder: (context, _, __) {
        final items = FreshbagRequestStore.instance.getMissed();
        return _PickupList(
          emptyText: '현재 누적 미회수 항목이 없습니다.',
          items: items,
          mode: _PickupListMode.missed,
        );
      },
    );
  }
}

enum _PickupListMode { requested, failed, missed }

class _PickupList extends StatelessWidget {
  final List<FreshbagRequestItem> items;
  final String emptyText;
  final _PickupListMode mode;

  const _PickupList({
    required this.items,
    required this.emptyText,
    required this.mode,
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
        final badge = _badgeOf(item);

        return InfoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
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
                        Text(_detailText(item), style: AppTextStyles.sub),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: badge.bg,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Text(
                      badge.label,
                      style: AppTextStyles.sub.copyWith(
                        color: badge.fg,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              if (mode == _PickupListMode.requested) ...[
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          FreshbagRequestStore.instance.markFailed(item.id);
                        },
                        child: const Text('회수 실패'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          FreshbagRequestStore.instance.markCompleted(item.id);
                        },
                        child: const Text('수거 완료'),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  String _detailText(FreshbagRequestItem item) {
    switch (mode) {
      case _PickupListMode.requested:
        return '수거 요청 대기';
      case _PickupListMode.failed:
        return '문 앞 미배출 · 실패 ${item.failedCount}회';
      case _PickupListMode.missed:
        return '${item.missedDays}일째 미회수';
    }
  }

  _BadgeData _badgeOf(FreshbagRequestItem item) {
    switch (mode) {
      case _PickupListMode.requested:
        return const _BadgeData(
          label: '요청',
          bg: AppColors.primaryLight,
          fg: AppColors.primary,
        );
      case _PickupListMode.failed:
        return const _BadgeData(
          label: '실패',
          bg: Color(0xFFFFE8E8),
          fg: AppColors.error,
        );
      case _PickupListMode.missed:
        return _BadgeData(
          label: '${item.missedDays}일',
          bg: const Color(0xFFFFF2D9),
          fg: AppColors.warning,
        );
    }
  }
}

class _BadgeData {
  final String label;
  final Color bg;
  final Color fg;

  const _BadgeData({
    required this.label,
    required this.bg,
    required this.fg,
  });
}