import 'package:flutter/material.dart';
import 'package:capstone_frontend/core/theme/app_colors.dart';
import 'package:capstone_frontend/core/theme/app_spacing.dart';
import 'package:capstone_frontend/core/theme/app_text_styles.dart';
import 'package:capstone_frontend/core/widgets/info_card.dart';
import 'package:capstone_frontend/core/widgets/primary_cta_button.dart';

class ArrivedScreen extends StatelessWidget {
  const ArrivedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(
                  color: AppColors.mintSoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.inventory_2_outlined,
                  size: 44,
                  color: AppColors.deepGreen,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              const Text(
                '택배가 문 앞에 도착했습니다',
                style: AppTextStyles.sectionTitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                '14:32에 안전하게 배달되었어요',
                style: AppTextStyles.body,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),
              const InfoCard(
                child: Column(
                  children: [
                    _InfoRow(label: '수량', value: '1개'),
                    SizedBox(height: AppSpacing.md),
                    _InfoRow(label: '위치', value: '101동 1203호'),
                    SizedBox(height: AppSpacing.md),
                    _InfoRow(label: '상태', value: '배송 완료'),
                  ],
                ),
              ),
              const Spacer(),
              PrimaryCtaButton(
                label: '확인',
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/history');
                  },
                  child: const Text('배송 내역 보기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: AppTextStyles.sub),
        const Spacer(),
        Text(value, style: AppTextStyles.body),
      ],
    );
  }
}