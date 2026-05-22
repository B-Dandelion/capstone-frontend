import 'package:flutter/material.dart';
import 'package:capstone_frontend/apps/courier/screens/load_board_screen.dart';
import 'package:capstone_frontend/core/services/robot_load_store.dart';
import 'package:capstone_frontend/core/theme/app_colors.dart';
import 'package:capstone_frontend/core/theme/app_radius.dart';
import 'package:capstone_frontend/core/theme/app_spacing.dart';
import 'package:capstone_frontend/core/theme/app_text_styles.dart';

class CameraScanScreen extends StatefulWidget {
  final String robotId;

  const CameraScanScreen({
    super.key,
    required this.robotId,
  });

  @override
  State<CameraScanScreen> createState() => _CameraScanScreenState();
}

class _CameraScanScreenState extends State<CameraScanScreen> {
  String? selectedResult;

  final List<String> mockResults = const [
    '101동 1203호',
    '102동 804호',
    '105동 1104호',
    '103동 1502호',
  ];

  void _selectResult(String value) {
    setState(() {
      selectedResult = value;
    });
  }

  void _addToBoard() {
    final result = selectedResult;
    if (result == null) return;

    final match = RegExp(r'(\d+)동\s*(\d+)호').firstMatch(result);
    if (match == null) return;

    final building = match.group(1)!;
    final unit = match.group(2)!;

    RobotLoadStore.instance.addScannedAddress(
      robotId: widget.robotId,
      building: building,
      unit: unit,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$result 적재 현황에 추가됨')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.robotId} 카메라 스캔'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        children: [
          const Text(
            '송장 또는 목적지 정보를 스캔하세요',
            style: AppTextStyles.sectionTitle,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${widget.robotId}에 적재할 목적지를 선택하고 적재 현황에 추가합니다.',
            style: AppTextStyles.sub,
          ),
          const SizedBox(height: AppSpacing.xl),

          Container(
            height: 240,
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(color: AppColors.stroke),
            ),
            child: const Center(
              child: Icon(
                Icons.camera_alt_outlined,
                size: 60,
                color: AppColors.primary,
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),
          const Text('Mock 스캔 결과', style: AppTextStyles.sectionTitle),
          const SizedBox(height: AppSpacing.lg),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: mockResults.map((item) {
              final selected = selectedResult == item;
              return ChoiceChip(
                label: Text(item),
                selected: selected,
                onSelected: (_) => _selectResult(item),
              );
            }).toList(),
          ),

          const SizedBox(height: AppSpacing.xl),
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.stroke),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('현재 선택된 목적지', style: AppTextStyles.sub),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  selectedResult ?? '아직 선택된 목적지가 없습니다.',
                  style: AppTextStyles.body,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            height: 56,
            child: FilledButton.icon(
              onPressed: selectedResult == null ? null : _addToBoard,
              icon: const Icon(Icons.add),
              label: const Text('적재 현황에 추가'),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 56,
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => LoadBoardScreen(robotId: widget.robotId),
                  ),
                );
              },
              child: const Text('적재 현황 보기'),
            ),
          ),
        ],
      ),
    );
  }
}