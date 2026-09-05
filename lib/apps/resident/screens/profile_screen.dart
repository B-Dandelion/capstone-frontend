import 'package:flutter/material.dart';
import 'package:capstone_frontend/core/theme/app_colors.dart';
import 'package:capstone_frontend/core/theme/app_spacing.dart';
import 'package:capstone_frontend/core/theme/app_text_styles.dart';
import 'package:capstone_frontend/core/widgets/info_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool arrivedAlert = true;
  bool startAlert = true;
  bool delayedAlert = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('내 정보')),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 3,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: '홈'),
          NavigationDestination(icon: Icon(Icons.local_shipping_outlined), label: '배송현황'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: '내역'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: '내 정보'),
        ],
        onDestinationSelected: (index) => _onNavTap(context, index),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        children: [
          const InfoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('101동 1203호', style: AppTextStyles.sectionTitle),
                SizedBox(height: AppSpacing.sm),
                Text('이 기기에서 알림을 수신 중입니다.', style: AppTextStyles.body),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          const Text('세대 정보', style: AppTextStyles.sectionTitle),
          const SizedBox(height: AppSpacing.md),
          const InfoCard(
            child: Column(
              children: [
                _ProfileRow(label: '동', value: '101동'),
                SizedBox(height: AppSpacing.md),
                _ProfileRow(label: '호수', value: '1203호'),
                SizedBox(height: AppSpacing.md),
                _ProfileRow(label: '등록 기기', value: '현재 기기 1대'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          const Text('알림 설정', style: AppTextStyles.sectionTitle),
          const SizedBox(height: AppSpacing.md),
          InfoCard(
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: arrivedAlert,
                  onChanged: (value) => setState(() => arrivedAlert = value),
                  title: const Text('문 앞 도착 알림'),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: startAlert,
                  onChanged: (value) => setState(() => startAlert = value),
                  title: const Text('배송 시작 알림'),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: delayedAlert,
                  onChanged: (value) => setState(() => delayedAlert = value),
                  title: const Text('지연 알림'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          const Text('도움말', style: AppTextStyles.sectionTitle),
          const SizedBox(height: AppSpacing.md),
          InfoCard(
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('서비스 안내'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('문의하기'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    '로그아웃',
                    style: TextStyle(color: AppColors.error),
                  ),
                  trailing: const Icon(Icons.logout, color: AppColors.error),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onNavTap(BuildContext context, int index) {
    if (index == 3) return;

    final route = switch (index) {
      0 => '/',
      1 => '/tracking',
      2 => '/history',
      _ => '/',
    };

    Navigator.of(context).pushReplacementNamed(route);
  }
}

class _ProfileRow extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: AppTextStyles.sub),
        const Spacer(),
        Text(
          value,
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}