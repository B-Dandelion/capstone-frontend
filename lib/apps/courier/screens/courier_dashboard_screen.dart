import 'package:flutter/material.dart';
import 'package:capstone_frontend/apps/courier/screens/create_delivery_screen.dart';
import 'package:capstone_frontend/apps/courier/screens/robot_connect_screen.dart';
import 'package:capstone_frontend/apps/courier/screens/scout_wifi_test_screen.dart';
import 'package:capstone_frontend/core/models/delivery_status.dart';
import 'package:capstone_frontend/core/theme/app_colors.dart';
import 'package:capstone_frontend/core/theme/app_radius.dart';
import 'package:capstone_frontend/core/theme/app_spacing.dart';
import 'package:capstone_frontend/core/theme/app_text_styles.dart';
import 'package:capstone_frontend/core/widgets/info_card.dart';
import 'package:capstone_frontend/core/widgets/primary_cta_button.dart';
import 'package:capstone_frontend/core/widgets/stat_mini_card.dart';
import 'package:capstone_frontend/core/widgets/status_chip.dart';

class CourierDashboardScreen extends StatelessWidget {
  const CourierDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppColors.deepGreen,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(AppRadius.xl),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xxl,
                  AppSpacing.lg,
                  AppSpacing.xxl,
                  AppSpacing.xxxl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.white24,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.notifications_none, color: Colors.white),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.settings_outlined, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      '새벽배송 운영 현황',
                      style: AppTextStyles.headline.copyWith(
                        color: AppColors.textOnDark,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      '오늘 작업 12건 · 운영 장비 2대',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textOnDark.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              children: [
                InfoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Text('운영 중 장비', style: AppTextStyles.sub),
                          Spacer(),
                          StatusChip(
                            status: DeliveryStatus.arrived,
                            customLabel: 'READY',
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      const Text('R-02', style: AppTextStyles.headline),
                      const SizedBox(height: AppSpacing.sm),
                      const Text(
                        '배터리 82% · 즉시 사용 가능',
                        style: AppTextStyles.body,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const RobotConnectScreen(),
                                ),
                              );
                            },
                            child: const Text('장비 변경'),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: PrimaryCtaButton(
                              label: '새 배송 작업 등록',
                              icon: Icons.arrow_forward,
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const CreateDeliveryScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                InfoCard(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceMuted,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        child: const Icon(
                          Icons.wifi,
                          color: AppColors.deepGreen,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Scout Mini 통신 테스트', style: AppTextStyles.body),
                            SizedBox(height: 4),
                            Text(
                              '운영 앱과 장비 간 명령 송수신을 확인합니다.',
                              style: AppTextStyles.sub,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ScoutWifiTestScreen(),
                            ),
                          );
                        },
                        child: const Text('열기'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                const Text('운영 요약', style: AppTextStyles.sectionTitle),
                const SizedBox(height: AppSpacing.lg),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: AppSpacing.lg,
                  crossAxisSpacing: AppSpacing.lg,
                  childAspectRatio: 1.35,
                  children: const [
                    StatMiniCard(label: '등록 작업', value: '12'),
                    StatMiniCard(label: '진행 중 배송', value: '2'),
                    StatMiniCard(label: '완료 배송', value: '10'),
                    StatMiniCard(label: '평균 처리 시간', value: '2m 18s'),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxl),
                const Text('최근 작업', style: AppTextStyles.sectionTitle),
                const SizedBox(height: AppSpacing.lg),
                ...List.generate(
                  3,
                      (index) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: InfoCard(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceMuted,
                              borderRadius: BorderRadius.circular(AppRadius.md),
                            ),
                            child: const Icon(Icons.inventory_2_outlined),
                          ),
                          const SizedBox(width: AppSpacing.lg),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('101동 1203호', style: AppTextStyles.body),
                                SizedBox(height: 4),
                                Text('완료 · 14:12', style: AppTextStyles.sub),
                              ],
                            ),
                          ),
                          const StatusChip(status: DeliveryStatus.completed),
                        ],
                      ),
                    ),
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