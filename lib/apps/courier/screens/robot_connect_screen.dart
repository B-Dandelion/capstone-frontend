import 'package:flutter/material.dart';
import 'package:capstone_frontend/apps/courier/screens/robot_operation_screen.dart';
import 'package:capstone_frontend/core/services/robot_load_store.dart';
import 'package:capstone_frontend/core/theme/app_colors.dart';
import 'package:capstone_frontend/core/theme/app_radius.dart';
import 'package:capstone_frontend/core/theme/app_spacing.dart';
import 'package:capstone_frontend/core/theme/app_text_styles.dart';

class RobotConnectScreen extends StatefulWidget {
  const RobotConnectScreen({super.key});

  @override
  State<RobotConnectScreen> createState() => _RobotConnectScreenState();
}

class _RobotConnectScreenState extends State<RobotConnectScreen> {
  String selectedRobotId = 'R-01';

  final List<_RobotSummary> robots = const [
    _RobotSummary(
      id: 'R-01',
      batteryText: '배터리 84% · 대기 중',
      badgeLabel: '사용 가능',
      badgeColor: AppColors.mintSoft,
      badgeTextColor: AppColors.primary,
      selectable: true,
    ),
    _RobotSummary(
      id: 'R-02',
      batteryText: '배터리 82% · 즉시 사용 가능',
      badgeLabel: '연결됨',
      badgeColor: AppColors.primary,
      badgeTextColor: AppColors.textOnDark,
      selectable: true,
    ),
    _RobotSummary(
      id: 'R-03',
      batteryText: '배터리 27% · 18분 후 사용 가능',
      badgeLabel: '충전 중',
      badgeColor: Color(0xFFF5E9C8),
      badgeTextColor: AppColors.warning,
      selectable: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('로봇 연결')),
      body: ValueListenableBuilder<Map<String, List<dynamic>>>(
        valueListenable: RobotLoadStore.instance.itemsByRobot,
        builder: (context, _, __) {
          final selectedCount =
          RobotLoadStore.instance.countForRobot(selectedRobotId);

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            children: [
              const Text(
                '사용 가능한 로봇을 선택하세요',
                style: AppTextStyles.sectionTitle,
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                '작업 시작 전에 장비를 확인하면 운영 흐름을 빠르게 진행할 수 있습니다.',
                style: AppTextStyles.sub,
              ),
              const SizedBox(height: AppSpacing.xl),
              ...robots.map(
                    (robot) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  child: _RobotCard(
                    robot: robot,
                    selected: selectedRobotId == robot.id,
                    loadCount: RobotLoadStore.instance.countForRobot(robot.id),
                    onSelect: robot.selectable
                        ? () {
                      setState(() {
                        selectedRobotId = robot.id;
                      });
                    }
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        '$selectedRobotId 선택됨 · 현재 적재 $selectedCount건 · 연결 완료 후 운영 화면으로 이동합니다.',
                        style: AppTextStyles.body,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                height: 60,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RobotOperationScreen(
                          robotId: selectedRobotId,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('선택 완료'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RobotSummary {
  final String id;
  final String batteryText;
  final String badgeLabel;
  final Color badgeColor;
  final Color badgeTextColor;
  final bool selectable;

  const _RobotSummary({
    required this.id,
    required this.batteryText,
    required this.badgeLabel,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.selectable,
  });
}

class _RobotCard extends StatelessWidget {
  final _RobotSummary robot;
  final bool selected;
  final int loadCount;
  final VoidCallback? onSelect;

  const _RobotCard({
    required this.robot,
    required this.selected,
    required this.loadCount,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = !robot.selectable;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        onTap: disabled ? null : onSelect,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: AppColors.stroke),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  color: disabled ? AppColors.surfaceMuted : AppColors.primary,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Icon(
                  Icons.precision_manufacturing_outlined,
                  size: 40,
                  color: disabled ? AppColors.primary.withOpacity(0.6) : Colors.white,
                ),
              ),
              const SizedBox(width: AppSpacing.xl),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      robot.id,
                      style: AppTextStyles.headline.copyWith(
                        color: disabled ? AppColors.textSub : AppColors.textMain,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      robot.batteryText,
                      style: AppTextStyles.body.copyWith(
                        color: disabled ? AppColors.textSub : AppColors.textMain,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: robot.badgeColor,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          child: Text(
                            robot.badgeLabel,
                            style: AppTextStyles.sub.copyWith(
                              color: robot.badgeTextColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceMuted,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          child: Text(
                            '적재 $loadCount건',
                            style: AppTextStyles.sub.copyWith(
                              color: AppColors.textMain,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Icon(
                disabled
                    ? Icons.lock_outline
                    : selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: disabled ? AppColors.textSub : AppColors.primary,
                size: 34,
              ),
            ],
          ),
        ),
      ),
    );
  }
}