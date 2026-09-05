import 'package:flutter/material.dart';
import 'package:capstone_frontend/core/theme/app_colors.dart';
import 'package:capstone_frontend/core/theme/app_radius.dart';
import 'package:capstone_frontend/core/theme/app_spacing.dart';
import 'package:capstone_frontend/core/theme/app_text_styles.dart';

enum _CourierNotificationFilter { all, important, system }

class CourierNotificationScreen extends StatefulWidget {
  const CourierNotificationScreen({super.key});

  @override
  State<CourierNotificationScreen> createState() =>
      _CourierNotificationScreenState();
}

class _CourierNotificationScreenState
    extends State<CourierNotificationScreen> {
  _CourierNotificationFilter _filter = _CourierNotificationFilter.all;

  final List<_CourierNotificationItem> _items = [
    _CourierNotificationItem(
      title: '새 배송 작업 등록',
      message: '101동 1203호 배송이 등록되었습니다.',
      time: '방금 전',
      type: _CourierNotificationType.important,
      icon: Icons.add_task_outlined,
      iconBg: const Color(0xFFEAF2FF),
      iconColor: AppColors.primary,
    ),
    _CourierNotificationItem(
      title: '적재 완료',
      message: 'R-02에 현재 적재 1건이 반영되었습니다.',
      time: '3분 전',
      type: _CourierNotificationType.all,
      icon: Icons.inventory_2_outlined,
      iconBg: const Color(0xFFEFF8F3),
      iconColor: const Color(0xFF1E8E5A),
    ),
    _CourierNotificationItem(
      title: '수거 요청 도착',
      message: '프레시백 수거 요청 1건이 접수되었습니다.',
      time: '12분 전',
      type: _CourierNotificationType.important,
      icon: Icons.shopping_bag_outlined,
      iconBg: const Color(0xFFFFF6E6),
      iconColor: const Color(0xFFE59E0B),
    ),
    _CourierNotificationItem(
      title: '통신 상태 정상',
      message: '운영 장비와 앱 간 통신이 정상입니다.',
      time: '18분 전',
      type: _CourierNotificationType.system,
      icon: Icons.wifi_outlined,
      iconBg: const Color(0xFFEAF2FF),
      iconColor: AppColors.primary,
    ),
    _CourierNotificationItem(
      title: '운영 시작 준비',
      message: 'R-02 장비 상태가 READY로 확인되었습니다.',
      time: '25분 전',
      type: _CourierNotificationType.system,
      icon: Icons.precision_manufacturing_outlined,
      iconBg: const Color(0xFFEFF8F3),
      iconColor: const Color(0xFF1E8E5A),
    ),
  ];

  List<_CourierNotificationItem> get _filteredItems {
    switch (_filter) {
      case _CourierNotificationFilter.all:
        return _items;
      case _CourierNotificationFilter.important:
        return _items
            .where((e) => e.type == _CourierNotificationType.important)
            .toList();
      case _CourierNotificationFilter.system:
        return _items
            .where((e) => e.type == _CourierNotificationType.system)
            .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알림'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _buildFilterChip(
                label: '전체',
                selected: _filter == _CourierNotificationFilter.all,
                onTap: () {
                  setState(() => _filter = _CourierNotificationFilter.all);
                },
              ),
              _buildFilterChip(
                label: '중요',
                selected: _filter == _CourierNotificationFilter.important,
                onTap: () {
                  setState(
                        () => _filter = _CourierNotificationFilter.important,
                  );
                },
              ),
              _buildFilterChip(
                label: '시스템',
                selected: _filter == _CourierNotificationFilter.system,
                onTap: () {
                  setState(() => _filter = _CourierNotificationFilter.system);
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          ..._filteredItems.map(_buildNotificationCard),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.primaryLight,
      backgroundColor: Colors.white,
      side: BorderSide(
        color: selected ? AppColors.primary : AppColors.stroke,
      ),
      labelStyle: TextStyle(
        color: selected ? AppColors.primary : AppColors.textSub,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 10,
      ),
    );
  }

  Widget _buildNotificationCard(_CourierNotificationItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: item.iconBg,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(item.icon, color: item.iconColor),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: AppTextStyles.body),
                const SizedBox(height: 4),
                Text(item.message, style: AppTextStyles.sub),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  item.time,
                  style: AppTextStyles.sub.copyWith(
                    fontSize: 12,
                    color: AppColors.textSub,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum _CourierNotificationType { all, important, system }

class _CourierNotificationItem {
  final String title;
  final String message;
  final String time;
  final _CourierNotificationType type;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;

  _CourierNotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
  });
}