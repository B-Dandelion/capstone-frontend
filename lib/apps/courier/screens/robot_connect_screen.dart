import 'package:flutter/material.dart';
import 'package:capstone_frontend/apps/courier/screens/robot_operation_screen.dart';
import 'package:capstone_frontend/core/models/delivery_mission_item.dart';
import 'package:capstone_frontend/core/models/load_board_item.dart';
import 'package:capstone_frontend/core/services/delivery_mission_store.dart';
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

  final List<_RobotMeta> robots = const [
    _RobotMeta(
      id: 'R-01',
      idleBatteryText: '배터리 84% · 대기',
      connectedLabel: '사용 가능',
      selectable: true,
      charging: false,
    ),
    _RobotMeta(
      id: 'R-02',
      idleBatteryText: '배터리 82% · 즉시 사용',
      connectedLabel: '연결됨',
      selectable: true,
      charging: false,
    ),
    _RobotMeta(
      id: 'R-03',
      idleBatteryText: '배터리 27% · 18분 후 사용',
      connectedLabel: '충전 중',
      selectable: false,
      charging: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('로봇 연결')),
      body: ValueListenableBuilder<Map<String, List<LoadBoardItem>>>(
        valueListenable: RobotLoadStore.instance.itemsByRobot,
        builder: (context, _, __) {
          return ValueListenableBuilder<DeliveryMissionItem?>(
            valueListenable: DeliveryMissionStore.instance.activeMission,
            builder: (context, ___, ____) {
              final availableRobots = robots
                  .where((robot) =>
              robot.selectable &&
                  !robot.charging &&
                  !DeliveryMissionStore.instance.isRobotBusy(robot.id))
                  .toList();

              if (!availableRobots.any((e) => e.id == selectedRobotId) &&
                  availableRobots.isNotEmpty) {
                selectedRobotId = availableRobots.first.id;
              }

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
                        loadCount:
                        RobotLoadStore.instance.countForRobot(robot.id),
                        activeMission:
                        DeliveryMissionStore.instance.activeMissionForRobot(
                          robot.id,
                        ),
                        onSelect: (robot.selectable &&
                            !robot.charging &&
                            !DeliveryMissionStore.instance
                                .isRobotBusy(robot.id))
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
                        const Icon(Icons.info_outline, color: AppColors.primary),
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
                      onPressed: availableRobots.isEmpty
                          ? null
                          : () {
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
          );
        },
      ),
    );
  }
}

class _RobotMeta {
  final String id;
  final String idleBatteryText;
  final String connectedLabel;
  final bool selectable;
  final bool charging;

  const _RobotMeta({
    required this.id,
    required this.idleBatteryText,
    required this.connectedLabel,
    required this.selectable,
    required this.charging,
  });
}

class _RobotCard extends StatelessWidget {
  final _RobotMeta robot;
  final bool selected;
  final int loadCount;
  final DeliveryMissionItem? activeMission;
  final VoidCallback? onSelect;

  const _RobotCard({
    required this.robot,
    required this.selected,
    required this.loadCount,
    required this.activeMission,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isBusy = activeMission != null;
    final isDisabled = onSelect == null;

    final badgeLabel = isBusy
        ? '운행 중'
        : robot.charging
        ? '충전 중'
        : robot.connectedLabel;

    final badgeBg = isBusy
        ? AppColors.primary
        : robot.charging
        ? const Color(0xFFFFF2D9)
        : (robot.id == 'R-02'
        ? AppColors.primary
        : AppColors.primaryLight);

    final badgeFg = isBusy
        ? AppColors.textOnDark
        : robot.charging
        ? AppColors.warning
        : (robot.id == 'R-02'
        ? AppColors.textOnDark
        : AppColors.primary);

    final statusText = isBusy
        ? '${activeMission!.addressLabel} 배송 중'
        : robot.idleBatteryText;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        onTap: onSelect,
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
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  color: isDisabled ? AppColors.surfaceMuted : AppColors.primary,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Icon(
                  Icons.precision_manufacturing_outlined,
                  size: 42,
                  color: isDisabled
                      ? AppColors.primary.withOpacity(0.5)
                      : Colors.white,
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
                        color: isDisabled && !isBusy
                            ? AppColors.textSub
                            : AppColors.textMain,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      statusText,
                      style: AppTextStyles.body.copyWith(
                        color: isDisabled && !isBusy
                            ? AppColors.textSub
                            : AppColors.textMain,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: badgeBg,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          child: Text(
                            badgeLabel,
                            style: AppTextStyles.sub.copyWith(
                              color: badgeFg,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
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
                robot.charging
                    ? Icons.lock_outline
                    : isBusy
                    ? Icons.lock_clock_outlined
                    : selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: isBusy || !robot.charging
                    ? AppColors.primary
                    : AppColors.textSub,
                size: 34,
              ),
            ],
          ),
        ),
      ),
    );
  }
}