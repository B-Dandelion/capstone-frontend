import 'package:flutter/material.dart';
import 'package:capstone_frontend/core/models/delivery_status.dart';
import 'package:capstone_frontend/core/theme/app_colors.dart';
import 'package:capstone_frontend/core/theme/app_radius.dart';
import 'package:capstone_frontend/core/theme/app_spacing.dart';
import 'package:capstone_frontend/core/theme/app_text_styles.dart';
import 'package:capstone_frontend/core/widgets/info_card.dart';
import 'package:capstone_frontend/core/widgets/status_chip.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

enum _HistoryFilter { all, completed, delayed }

class _HistoryScreenState extends State<HistoryScreen> {
  _HistoryFilter filter = _HistoryFilter.all;

  final List<_HistoryItem> items = const [
    _HistoryItem(
      group: '오늘',
      time: '14:32',
      destination: '101동 1203호',
      quantity: '1개',
      status: DeliveryStatus.completed,
    ),
    _HistoryItem(
      group: '오늘',
      time: '11:08',
      destination: '101동 1203호',
      quantity: '2개',
      status: DeliveryStatus.completed,
    ),
    _HistoryItem(
      group: '어제',
      time: '19:10',
      destination: '101동 1203호',
      quantity: '1개',
      status: DeliveryStatus.completed,
    ),
    _HistoryItem(
      group: '3월 12일',
      time: '16:42',
      destination: '101동 1203호',
      quantity: '1개',
      status: DeliveryStatus.delayed,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = items.where((item) {
      switch (filter) {
        case _HistoryFilter.all:
          return true;
        case _HistoryFilter.completed:
          return item.status == DeliveryStatus.completed;
        case _HistoryFilter.delayed:
          return item.status == DeliveryStatus.delayed;
      }
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('배송 내역')),
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
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ChoiceChip(
                label: const Text('전체'),
                selected: filter == _HistoryFilter.all,
                onSelected: (_) => setState(() => filter = _HistoryFilter.all),
              ),
              ChoiceChip(
                label: const Text('완료'),
                selected: filter == _HistoryFilter.completed,
                onSelected: (_) => setState(() => filter = _HistoryFilter.completed),
              ),
              ChoiceChip(
                label: const Text('지연'),
                selected: filter == _HistoryFilter.delayed,
                onSelected: (_) => setState(() => filter = _HistoryFilter.delayed),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          ..._buildGroupedWidgets(filtered),
        ],
      ),
    );
  }

  List<Widget> _buildGroupedWidgets(List<_HistoryItem> filtered) {
    final List<Widget> widgets = [];
    String? currentGroup;

    for (final item in filtered) {
      if (currentGroup != item.group) {
        currentGroup = item.group;
        widgets.add(
          Padding(
            padding: EdgeInsets.only(
              top: widgets.isEmpty ? 0 : AppSpacing.xl,
              bottom: AppSpacing.md,
            ),
            child: Text(currentGroup, style: AppTextStyles.sectionTitle),
          ),
        );
      }

      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: InfoCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Icon(
                    item.status == DeliveryStatus.completed
                        ? Icons.check_circle_outline
                        : Icons.schedule_outlined,
                    color: item.status == DeliveryStatus.completed
                        ? AppColors.deepGreen
                        : AppColors.warning,
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.destination, style: AppTextStyles.body),
                      const SizedBox(height: 4),
                      Text(
                        '${item.time} · 택배 ${item.quantity}',
                        style: AppTextStyles.sub,
                      ),
                    ],
                  ),
                ),
                StatusChip(status: item.status),
              ],
            ),
          ),
        ),
      );
    }

    if (widgets.isEmpty) {
      widgets.add(
        const InfoCard(
          child: Text('선택한 조건에 해당하는 배송 내역이 없습니다.', style: AppTextStyles.body),
        ),
      );
    }

    return widgets;
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

class _HistoryItem {
  final String group;
  final String time;
  final String destination;
  final String quantity;
  final DeliveryStatus status;

  const _HistoryItem({
    required this.group,
    required this.time,
    required this.destination,
    required this.quantity,
    required this.status,
  });
}