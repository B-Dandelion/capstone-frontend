import 'package:flutter/material.dart';
import 'package:capstone_frontend/apps/courier/screens/live_mission_screen.dart';
import 'package:capstone_frontend/core/theme/app_spacing.dart';
import 'package:capstone_frontend/core/theme/app_text_styles.dart';
import 'package:capstone_frontend/core/widgets/app_text_field.dart';
import 'package:capstone_frontend/core/widgets/floating_bottom_cta.dart';
import 'package:capstone_frontend/core/widgets/info_card.dart';
import 'package:capstone_frontend/core/widgets/primary_cta_button.dart';
import 'package:capstone_frontend/core/widgets/quantity_stepper.dart';

class CreateDeliveryScreen extends StatefulWidget {
  const CreateDeliveryScreen({super.key});

  @override
  State<CreateDeliveryScreen> createState() => _CreateDeliveryScreenState();
}

class _CreateDeliveryScreenState extends State<CreateDeliveryScreen> {
  final TextEditingController unitController = TextEditingController();
  String selectedBuilding = '101동';
  int quantity = 1;
  bool fragile = false;
  bool silent = true;

  @override
  void dispose() {
    unitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buildings = ['101동', '102동', '103동', '105동'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('새 배송 등록'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Center(
              child: Text('Step 1 / 3'),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xxl,
              AppSpacing.lg,
              AppSpacing.xxl,
              150,
            ),
            child: Column(
              children: [
                InfoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('배송 목적지', style: AppTextStyles.sectionTitle),
                      const SizedBox(height: AppSpacing.lg),
                      DropdownButtonFormField<String>(
                        value: selectedBuilding,
                        items: buildings
                            .map(
                              (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ),
                        )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() => selectedBuilding = value);
                        },
                        decoration: const InputDecoration(labelText: '동 선택'),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AppTextField(
                        label: '호수 입력',
                        hintText: '예: 1203',
                        keyboardType: TextInputType.number,
                        controller: unitController,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: ['101동 1203호', '102동 804호', '105동 1501호']
                            .map(
                              (e) => ActionChip(
                            label: Text(e),
                            onPressed: () {
                              final parts = e.split(' ');
                              setState(() {
                                selectedBuilding = parts.first;
                                unitController.text = parts.last.replaceAll('호', '');
                              });
                            },
                          ),
                        )
                            .toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                InfoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('적재 정보', style: AppTextStyles.sectionTitle),
                      const SizedBox(height: AppSpacing.lg),
                      QuantityStepper(
                        value: quantity,
                        onChanged: (value) => setState(() => quantity = value),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        value: fragile,
                        onChanged: (value) => setState(() => fragile = value),
                        title: const Text('파손 주의'),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        value: silent,
                        onChanged: (value) => setState(() => silent = value),
                        title: const Text('문 앞 조용히 배치'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          FloatingBottomCta(
            summary: '목적지 1곳 · 택배 $quantity개',
            button: PrimaryCtaButton(
              label: '다음',
              icon: Icons.arrow_forward,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const LiveMissionScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}