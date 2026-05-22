import 'package:flutter/material.dart';
import 'package:capstone_frontend/apps/courier/screens/prelaunch_check_screen.dart';
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
  String selectedBuilding = '101';
  String unit = '1203';
  int quantity = 1;
  bool fragile = false;
  bool quietDrop = true;

  @override
  Widget build(BuildContext context) {
    final currentLoadCount = RobotLoadStore.instance.countForRobot(widget.robotId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('새 배송 작업 등록'),
      ),
      body: ListView(
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
              children: [
                DropdownButtonFormField<String>(
                  value: selectedBuilding,
                  decoration: const InputDecoration(
                    labelText: '동 선택',
                  ),
                  items: const [
                    DropdownMenuItem(value: '101', child: Text('101동')),
                    DropdownMenuItem(value: '102', child: Text('102동')),
                    DropdownMenuItem(value: '105', child: Text('105동')),
                  ],
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      selectedBuilding = value;
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  initialValue: unit,
                  decoration: const InputDecoration(
                    labelText: '호수 입력',
                  ),
                  onChanged: (value) {
                    setState(() {
                      unit = value;
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _QuickAddressChip(
                      label: '101동 1203호',
                      onTap: () {
                        setState(() {
                          selectedBuilding = '101';
                          unit = '1203';
                        });
                      },
                    ),
                    _QuickAddressChip(
                      label: '102동 804호',
                      onTap: () {
                        setState(() {
                          selectedBuilding = '102';
                          unit = '804';
                        });
                      },
                    ),
                    _QuickAddressChip(
                      label: '105동 1501호',
                      onTap: () {
                        setState(() {
                          selectedBuilding = '105';
                          unit = '1501';
                        });
                      },
                    ),
                  ],
                ),
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
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PreLaunchCheckScreen(
                            robotId: widget.robotId,
                            building: selectedBuilding,
                            unit: unit,
                            quantity: quantity,
                          ),
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