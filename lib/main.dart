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
                '개발용 실행 화면\n기사 앱 / 주민 앱을 바로 띄울 수 있습니다.',
                style: AppTextStyles.body,
              ),
              const SizedBox(height: AppSpacing.xxxl),
              _LauncherCard(
                title: 'Courier App',
                subtitle: '기사용 앱',
                color: AppColors.deepGreen,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CourierApp()),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              _LauncherCard(
                title: 'Home App',
                subtitle: '주민용 앱',
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