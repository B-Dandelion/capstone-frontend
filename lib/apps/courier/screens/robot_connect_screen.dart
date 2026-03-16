import 'package:flutter/material.dart';
import 'package:capstone_frontend/core/theme/app_colors.dart';
import 'package:capstone_frontend/core/theme/app_radius.dart';
import 'package:capstone_frontend/core/theme/app_spacing.dart';
import 'package:capstone_frontend/core/theme/app_text_styles.dart';
import 'package:capstone_frontend/core/widgets/info_card.dart';
import 'package:capstone_frontend/core/widgets/primary_cta_button.dart';

class RobotConnectScreen extends StatefulWidget {
  const RobotConnectScreen({super.key});

  @override
  State<RobotConnectScreen> createState() => _RobotConnectScreenState();
}

class _RobotConnectScreenState extends State<RobotConnectScreen> {
  final List<_RobotItem> robots = const [
    _RobotItem(
      id: 'R-01',
      stateLabel: '사용 가능',
      detail: '배터리 84% · 대기 중',
      status: _RobotConnectStatus.ready,
    ),
    _RobotItem(
      id: 'R-02',
      stateLabel: '현재 연결됨',
      detail: '배터리 82% · 즉시 사용 가능',
      status: _RobotConnectStatus.connected,
    ),
    _RobotItem(
      id: 'R-03',
      stateLabel: '충전 중',
      detail: '배터리 27% · 18분 후 사용 가능',
      status: _RobotConnectStatus.charging,
    ),
    _RobotItem(
      id: 'R-04',
      stateLabel: '사용 중',
      detail: '현재 다른 배송 진행 중',
      status: _RobotConnectStatus.busy,
    ),
  ];

  String selectedRobotId = 'R-02';

  @override
  Widget build(BuildContext context) {
    final selected = robots.firstWhere((e) => e.id == selectedRobotId);

    return Scaffold(
      appBar: AppBar(title: const Text('로봇 연결')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('사용 가능한 로봇을 선택하세요', style: AppTextStyles.sectionTitle),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                '배송 등록 전에 연결 로봇을 확인하면 이후 단계가 훨씬 빨라집니다.',
                style: AppTextStyles.sub,
              ),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: ListView.separated(
                  itemCount: robots.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final robot = robots[index];
                    final isSelected = selectedRobotId == robot.id;
                    final canSelect = robot.status == _RobotConnectStatus.ready ||
                        robot.status == _RobotConnectStatus.connected;

                    return Opacity(
                      opacity: robot.status == _RobotConnectStatus.busy ||
                          robot.status == _RobotConnectStatus.charging
                          ? 0.72
                          : 1,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          onTap: canSelect
                              ? () => setState(() => selectedRobotId = robot.id)
                              : null,
                          child: InfoCard(
                            child: Row(
                              children: [
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.deepGreen
                                        : AppColors.surfaceMuted,
                                    borderRadius: BorderRadius.circular(AppRadius.md),
                                  ),
                                  child: Icon(
                                    Icons.precision_manufacturing_outlined,
                                    color: isSelected
                                        ? AppColors.textOnDark
                                        : AppColors.deepGreen,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.lg),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(robot.id, style: AppTextStyles.sectionTitle),
                                      const SizedBox(height: 6),
                                      Text(robot.detail, style: AppTextStyles.body),
                                      const SizedBox(height: 8),
                                      _RobotStatePill(
                                        label: robot.stateLabel,
                                        status: robot.status,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                if (canSelect)
                                  Radio<String>(
                                    value: robot.id,
                                    groupValue: selectedRobotId,
                                    onChanged: (value) {
                                      if (value == null) return;
                                      setState(() => selectedRobotId = value);
                                    },
                                  )
                                else
                                  const Icon(
                                    Icons.lock_outline,
                                    color: AppColors.textSub,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              InfoCard(
                backgroundColor: AppColors.mintSoft,
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppColors.deepGreen),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        '${selected.id} 선택됨 · 연결 완료 후 배송 등록 화면으로 돌아갑니다.',
                        style: AppTextStyles.body,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryCtaButton(
                label: '선택 완료',
                icon: Icons.check,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${selected.id} 연결 완료')),
                  );
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _RobotConnectStatus { ready, connected, charging, busy }

class _RobotItem {
  final String id;
  final String stateLabel;
  final String detail;
  final _RobotConnectStatus status;

  const _RobotItem({
    required this.id,
    required this.stateLabel,
    required this.detail,
    required this.status,
  });
}

class _RobotStatePill extends StatelessWidget {
  final String label;
  final _RobotConnectStatus status;

  const _RobotStatePill({
    required this.label,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    late final Color bg;
    late final Color fg;

    switch (status) {
      case _RobotConnectStatus.ready:
        bg = const Color(0xFFE8F3EF);
        fg = AppColors.deepGreen;
        break;
      case _RobotConnectStatus.connected:
        bg = AppColors.deepGreen;
        fg = AppColors.textOnDark;
        break;
      case _RobotConnectStatus.charging:
        bg = const Color(0xFFFFF4D6);
        fg = AppColors.warning;
        break;
      case _RobotConnectStatus.busy:
        bg = const Color(0xFFFDECEC);
        fg = AppColors.error;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.sm),
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