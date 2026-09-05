import 'package:flutter/material.dart';
import 'package:capstone_frontend/apps/courier/screens/live_mission_screen.dart';
import 'package:capstone_frontend/core/services/delivery_mission_store.dart';
import 'package:capstone_frontend/core/models/load_board_item.dart';
import 'package:capstone_frontend/core/services/robot_load_store.dart';
import 'package:capstone_frontend/core/theme/app_colors.dart';
import 'package:capstone_frontend/core/theme/app_radius.dart';
import 'package:capstone_frontend/core/theme/app_spacing.dart';
import 'package:capstone_frontend/core/theme/app_text_styles.dart';

class CreateDeliveryScreen extends StatefulWidget {
  final String robotId;

  const CreateDeliveryScreen({
    super.key,
    required this.robotId,
  });

  @override
  State<CreateDeliveryScreen> createState() => _CreateDeliveryScreenState();
}

class _CreateDeliveryScreenState extends State<CreateDeliveryScreen> {
  String? selectedBuilding;
  String unit = '';
  int quantity = 1;
  bool fragile = false;
  bool quietDrop = true;

  final TextEditingController _unitController = TextEditingController();

  @override
  void dispose() {
    _unitController.dispose();
    super.dispose();
  }

  String _formatAddress(String? building, String unit) {
    if (building == null || building.trim().isEmpty) return '${unit}호';
    return '${building}동 ${unit}호';
  }

  List<LoadBoardItem> _recentTop3(List<LoadBoardItem> items) {
    final filtered = items
        .where((item) => item.status != LoadItemStatus.completed)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    if (filtered.length <= 3) return filtered;
    return filtered.take(3).toList();
  }

  void _applyAddress(LoadBoardItem item) {
    setState(() {
      selectedBuilding =
      item.building.trim().isEmpty ? null : item.building.trim();
      unit = item.unit.trim();
      _unitController.text = unit;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentLoadCount = RobotLoadStore.instance.countForRobot(widget.robotId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('새 배송 작업 등록'),
      ),
      body: ValueListenableBuilder<Map<String, List<LoadBoardItem>>>(
        valueListenable: RobotLoadStore.instance.itemsByRobot,
        builder: (context, itemsByRobot, _) {
          final robotItems = itemsByRobot[widget.robotId] ?? const <LoadBoardItem>[];
          final recentTop3 = _recentTop3(robotItems);

          final hasBuilding =
              selectedBuilding != null && selectedBuilding!.trim().isNotEmpty;

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            children: [
              Row(
                children: [
                  const Spacer(),
                  Text(
                    'Step 1 / 3',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textMain,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  border: Border.all(color: AppColors.stroke),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: const Icon(
                        Icons.precision_manufacturing_outlined,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${widget.robotId} 선택됨', style: AppTextStyles.body),
                          const SizedBox(height: 4),
                          Text('현재 적재 ${currentLoadCount}건', style: AppTextStyles.sub),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              _SectionCard(
                title: '배송 대상',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasBuilding) ...[
                      DropdownButtonFormField<String>(
                        value: selectedBuilding,
                        decoration: const InputDecoration(
                          labelText: '동 선택',
                        ),
                        items: const [
                          DropdownMenuItem(value: '101', child: Text('101동')),
                          DropdownMenuItem(value: '102', child: Text('102동')),
                          DropdownMenuItem(value: '105', child: Text('105동')),
                          DropdownMenuItem(value: '108', child: Text('108동')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedBuilding = value;
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                    TextFormField(
                      controller: _unitController,
                      decoration: InputDecoration(
                        labelText: hasBuilding ? '호수 입력' : '배송 호수 입력',
                      ),
                      onChanged: (value) {
                        setState(() {
                          unit = value.trim();
                        });
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    if (recentTop3.isNotEmpty) ...[
                      Text(
                        '현재 적재 카드 기반 추천',
                        style: AppTextStyles.sub.copyWith(
                          color: AppColors.textMain,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: recentTop3.map((item) {
                          return _QuickAddressChip(
                            label: _formatAddress(
                              item.building.trim().isEmpty ? null : item.building,
                              item.unit,
                            ),
                            onTap: () => _applyAddress(item),
                          );
                        }).toList(),
                      ),
                    ] else ...[
                      const Text(
                        '현재 적재된 카드가 없습니다. 스캔 후 다시 확인해주세요.',
                        style: AppTextStyles.sub,
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              _SectionCard(
                title: '작업 정보',
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceMuted,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      child: Row(
                        children: [
                          _QtyButton(
                            icon: Icons.remove,
                            onTap: quantity > 1
                                ? () {
                              setState(() {
                                quantity--;
                              });
                            }
                                : null,
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                '$quantity',
                                style: AppTextStyles.headline,
                              ),
                            ),
                          ),
                          _QtyButton(
                            icon: Icons.add,
                            onTap: () {
                              setState(() {
                                quantity++;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _OptionTile(
                      label: '파손 주의',
                      value: fragile,
                      onChanged: (value) {
                        setState(() {
                          fragile = value;
                        });
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _OptionTile(
                      label: '문 앞 조용히 배치',
                      value: quietDrop,
                      onChanged: (value) {
                        setState(() {
                          quietDrop = value;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  border: Border.all(color: AppColors.stroke),
                ),
                child: Column(
                  children: [
                    Text(
                      '${widget.robotId} · 배송 대상 1곳 · 작업 수량 ${quantity}개',
                      style: AppTextStyles.sub,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton.icon(
                        onPressed: unit.trim().isEmpty
                            ? null
                            : () {
                          final building = (selectedBuilding ?? '').trim();

                          DeliveryMissionStore.instance.startMission(
                            robotId: widget.robotId,
                            building: building,
                            unit: unit.trim(),
                            quantity: quantity,
                          );

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const LiveMissionScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('다음'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.sectionTitle),
          const SizedBox(height: AppSpacing.lg),
          child,
        ],
      ),
    );
  }
}

class _QuickAddressChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickAddressChip({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _QtyButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: onTap == null ? AppColors.stroke : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _OptionTile({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label, style: AppTextStyles.body)),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}