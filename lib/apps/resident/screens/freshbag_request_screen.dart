import 'package:flutter/material.dart';
import 'package:capstone_frontend/core/theme/app_colors.dart';
import 'package:capstone_frontend/core/theme/app_radius.dart';
import 'package:capstone_frontend/core/theme/app_spacing.dart';
import 'package:capstone_frontend/core/theme/app_text_styles.dart';
import 'package:capstone_frontend/core/widgets/info_card.dart';
import 'package:capstone_frontend/core/widgets/primary_cta_button.dart';

class FreshbagRequestScreen extends StatefulWidget {
  const FreshbagRequestScreen({super.key});

  @override
  State<FreshbagRequestScreen> createState() => _FreshbagRequestScreenState();
}

class _FreshbagRequestScreenState extends State<FreshbagRequestScreen> {
  bool requested = false;
  bool failed = false;

  void _requestPickup() {
    setState(() {
      requested = true;
      failed = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('프레시백 수거 요청이 등록되었습니다.')),
    );
  }

  void _showFailedDialog() {
    setState(() {
      failed = true;
    });

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('회수 실패'),
          content: const Text(
            '문 앞에 프레시백이 없어 회수하지 못했습니다. 다시 문 앞에 배치한 뒤 재요청해주세요.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('프레시백 수거 요청'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        children: [
          const Text(
            '프레시백 회수를 요청하세요',
            style: AppTextStyles.sectionTitle,
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            '문 앞에 프레시백을 배치한 뒤 수거 요청을 등록하면 기사 앱에서 확인할 수 있습니다.',
            style: AppTextStyles.sub,
          ),
          const SizedBox(height: AppSpacing.xl),

          const InfoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('수거 위치', style: AppTextStyles.sub),
                SizedBox(height: AppSpacing.sm),
                Text('101동 1203호', style: AppTextStyles.body),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          InfoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('현재 상태', style: AppTextStyles.sub),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: requested ? AppColors.primaryLight : AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Text(
                    requested ? '수거 요청 완료' : '요청 전',
                    style: AppTextStyles.sub.copyWith(
                      color: requested ? AppColors.primary : AppColors.textMain,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (failed) ...[
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF2F2),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Text(
                      '회수 실패: 문 앞 배치 상태를 다시 확인해주세요.',
                      style: AppTextStyles.sub.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          PrimaryCtaButton(
            label: '수거 요청하기',
            icon: Icons.shopping_bag_outlined,
            onPressed: _requestPickup,
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 56,
            child: OutlinedButton(
              onPressed: _showFailedDialog,
              child: const Text('회수 실패 팝업 미리보기'),
            ),
          ),
        ],
      ),
    );
  }
}