import 'package:flutter/material.dart';
import 'package:capstone_frontend/apps/courier/courier_app.dart';
import 'package:capstone_frontend/apps/resident/resident_app.dart';
import 'package:capstone_frontend/core/theme/app_colors.dart';
import 'package:capstone_frontend/core/theme/app_radius.dart';
import 'package:capstone_frontend/core/theme/app_spacing.dart';
import 'package:capstone_frontend/core/theme/app_text_styles.dart';

void main() {
  runApp(const PorterLauncherApp());
}

class PorterLauncherApp extends StatelessWidget {
  const PorterLauncherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.bgResident,
      ),
      home: const _LauncherScreen(),
    );
  }
}

class _LauncherScreen extends StatelessWidget {
  const _LauncherScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xxxl),
              const Text('Porter', style: AppTextStyles.headline),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                '새벽배송 자동화 서비스 테스트\n운영 앱과 고객 확인 앱을 실행할 수 있습니다.',
                style: AppTextStyles.body,
              ),
              const SizedBox(height: AppSpacing.xxxl),
              _LauncherCard(
                title: '새벽배송 운영 앱',
                subtitle: '로비 적재 후 자동 배송 작업을 시작하고 상태를 확인합니다.',
                color: AppColors.deepGreen,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CourierApp()),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              _LauncherCard(
                title: '고객 확인 앱',
                subtitle: '배송 진행과 문 앞 도착 알림을 확인합니다.',
                color: AppColors.deepGreenDark,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ResidentApp()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LauncherCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _LauncherCard({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.textOnDark,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                subtitle,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textOnDark.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}