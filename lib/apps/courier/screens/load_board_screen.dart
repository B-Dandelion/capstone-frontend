import 'package:flutter/material.dart';
import 'package:capstone_frontend/core/models/load_board_item.dart';
import 'package:capstone_frontend/core/services/robot_load_store.dart';
import 'package:capstone_frontend/core/theme/app_colors.dart';
import 'package:capstone_frontend/core/theme/app_radius.dart';
import 'package:capstone_frontend/core/theme/app_spacing.dart';
import 'package:capstone_frontend/core/theme/app_text_styles.dart';

class LoadBoardScreen extends StatelessWidget {
  final String robotId;

  const LoadBoardScreen({
    super.key,
    required this.robotId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$robotId 실시간 적재 현황'),
      ),
      body: ValueListenableBuilder<Map<String, List<LoadBoardItem>>>(
        valueListenable: RobotLoadStore.instance.itemsByRobot,
        builder: (context, boardMap, _) {
          final grouped = RobotLoadStore.instance.groupedItems(robotId);
          final totalCount = RobotLoadStore.instance.countForRobot(robotId);

          return Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$robotId 적재 보드', style: AppTextStyles.sectionTitle),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '현재 적재 $totalCount건 · 배송 완료 시 카드가 제거됩니다.',
                  style: AppTextStyles.sub,
                ),
                const SizedBox(height: AppSpacing.xl),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: grouped.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.md),
                          child: _LoadColumn(
                            title: entry.key,
                            items: entry.value,
                            onRemove: (item) {
                              RobotLoadStore.instance.removeItem(
                                robotId: robotId,
                                itemId: item.id,
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LoadColumn extends StatelessWidget {
  final String title;
  final List<LoadBoardItem> items;
  final void Function(LoadBoardItem item) onRemove;

  const _LoadColumn({
    required this.title,
    required this.items,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Column(
        children: [
          Text(title, style: AppTextStyles.body),
          const SizedBox(height: AppSpacing.md),
          if (items.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: const Center(
                child: Text('비어 있음', style: AppTextStyles.sub),
              ),
            )
          else
            ...items.map(
                  (item) => Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.addressLabel,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.zone,
                            style: AppTextStyles.sub,
                          ),
                        ),
                        IconButton(
                          onPressed: () => onRemove(item),
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            color: AppColors.error,
                          ),
                          iconSize: 20,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}