import 'package:flutter/material.dart';
import 'package:capstone_frontend/core/models/delivery_status.dart';
import 'package:capstone_frontend/core/theme/app_colors.dart';
import 'package:capstone_frontend/core/theme/app_spacing.dart';
import 'package:capstone_frontend/core/theme/app_text_styles.dart';
import 'package:capstone_frontend/core/widgets/info_card.dart';
import 'package:capstone_frontend/core/widgets/progress_timeline.dart';
import 'package:capstone_frontend/core/widgets/status_chip.dart';
import 'package:capstone_frontend/core/models/security_alert.dart';
import 'package:capstone_frontend/core/widgets/security_status_card.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final steps = [
      const TimelineStepData(
        title: '접수됨',
        state: TimelineStepState.done,
      ),
      const TimelineStepData(
        title: '로봇 적재 완료',
        state: TimelineStepState.done,
      ),
      const TimelineStepData(
        title: '건물 진입',
        state: TimelineStepState.done,
      ),
      const TimelineStepData(
        title: '층 이동 중',
        subtitle: '14층으로 이동 중',
        state: TimelineStepState.current,
      ),
      const TimelineStepData(
        title: '문 앞 도착',
        state: TimelineStepState.future,
      ),
      const TimelineStepData(
        title: '배송 완료',
        state: TimelineStepState.future,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('배송 현황')),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
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
          const Text('현재 문 앞 배송이 진행 중입니다', style: AppTextStyles.body),
          const SizedBox(height: AppSpacing.xl),
          const InfoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Row(
                  children: [
                    StatusChip(
                      status: DeliveryStatus.movingToFloor,
                      customLabel: '이동 중',
                    ),
                    Spacer(),
                    Text('ETA 01:18', style: AppTextStyles.sub),
                  ],
                ),
                SizedBox(height: AppSpacing.lg),
                Text('101동 1203호', style: AppTextStyles.sectionTitle),
                SizedBox(height: AppSpacing.sm),
                Text('예상 도착 01:18', style: AppTextStyles.body),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          InfoCard(
            child: ProgressTimeline(
              steps: steps,
              compact: true,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          const InfoCard(
            backgroundColor: AppColors.mintSoft,
            child: Text(
              '로봇이 문 앞에 도착하면 바로 알려드릴게요.',
              style: AppTextStyles.body,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          SecurityStatusCard(
            level: SecurityAlertLevel.warning,
            title: '배송 중 보안 경고',
            subtitle: '적재함 강제 개방 시도가 감지되었습니다.',
            buttonLabel: '보안 경고 확인',
            onTap: () {
              Navigator.of(context).pushNamed('/security-alert');
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed: () => Navigator.of(context).pushNamed('/arrived'),
            child: const Text('완료 화면 미리보기'),
          ),
        ],
      ),
    );
  }

  void _onNavTap(BuildContext context, int index) {
    if (index == 1) return;

    final route = switch (index) {
      0 => '/',
      2 => '/history',
      3 => '/profile',
      _ => '/',
    };

    Navigator.of(context).pushReplacementNamed(route);
  }
}