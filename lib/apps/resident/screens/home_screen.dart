import 'package:flutter/material.dart';
import 'package:capstone_frontend/core/models/delivery_status.dart';
import 'package:capstone_frontend/core/theme/app_spacing.dart';
import 'package:capstone_frontend/core/theme/app_text_styles.dart';
import 'package:capstone_frontend/core/widgets/hero_status_card.dart';
import 'package:capstone_frontend/core/widgets/info_card.dart';
import 'package:capstone_frontend/core/widgets/status_chip.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: '홈'),
          NavigationDestination(icon: Icon(Icons.local_shipping_outlined), label: '배송현황'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: '내역'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: '내 정보'),
        ],
        onDestinationSelected: (index) => _onNavTap(context, index),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          children: [
            Row(
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('101동 1203호', style: AppTextStyles.sectionTitle),
                    SizedBox(height: 4),
                    Text('오늘 배송 상태를 확인하세요', style: AppTextStyles.sub),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_none),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            HeroStatusCard(
              title: '오늘 도착 예정 택배 1건',
              status: '로봇이 이동 중입니다',
              eta: '예상 도착 1분 18초',
              onTap: () => Navigator.of(context).pushNamed('/tracking'),
            ),
            const SizedBox(height: AppSpacing.xl),
            InfoCard(
              child: Row(
                children: const [
                  Expanded(
                    child: Text('문 앞 도착 시 알림 예정', style: AppTextStyles.body),
                  ),
                  StatusChip(
                    status: DeliveryStatus.arrived,
                    customLabel: 'ON',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const InfoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('최근 배송', style: AppTextStyles.sectionTitle),
                  SizedBox(height: AppSpacing.md),
                  Text('어제 19:10 배송 완료', style: AppTextStyles.body),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onNavTap(BuildContext context, int index) {
    if (index == 0) return;

    final route = switch (index) {
      1 => '/tracking',
      2 => '/history',
      3 => '/profile',
      _ => '/',
    };

    Navigator.of(context).pushReplacementNamed(route);
  }
}