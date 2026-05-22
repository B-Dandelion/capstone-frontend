import 'package:flutter/material.dart';
import 'package:capstone_frontend/apps/courier/screens/camera_scan_screen.dart';
import 'package:capstone_frontend/apps/courier/screens/create_delivery_screen.dart';
import 'package:capstone_frontend/apps/courier/screens/load_board_screen.dart';
import 'package:capstone_frontend/core/models/load_board_item.dart';
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
          final items = RobotLoadStore.instance.getItems(robotId);
          final recentItems = items.take(4).toList();

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            children: [
              Container(
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
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          child: Text(
                            'READY',
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
                    const Text(
                      '배터리 84% · 즉시 사용',
                      style: AppTextStyles.body,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      '현재 적재 ${items.length}건',
                      style: AppTextStyles.body,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              Row(
                children: [
                  Expanded(
                    child: _ActionCard(
                      icon: Icons.camera_alt_outlined,
                      title: '카메라 스캔',
                      subtitle: '목적지 스캔',
                      onTap: () {
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
                      subtitle: '카드 확인',
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
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const CreateDeliveryScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('새 배송 작업 등록'),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),
              const Text('최근 적재 카드', style: AppTextStyles.sectionTitle),
              const SizedBox(height: AppSpacing.lg),

              if (recentItems.isEmpty)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    border: Border.all(color: AppColors.stroke),
                  ),
                  child: const Text(
                    '아직 적재된 목적지가 없습니다. 카메라 스캔으로 추가하세요.',
                    style: AppTextStyles.body,
                  ),
                )
              else
                ...recentItems.map(
                      (item) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(color: AppColors.stroke),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(AppRadius.md),
                            ),
                            child: const Icon(
                              Icons.inventory_2_outlined,
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
                                Text('${item.zone} · $robotId', style: AppTextStyles.sub),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        onTap: onTap,
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
    );
  }
}