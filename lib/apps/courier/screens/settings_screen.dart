import 'package:flutter/material.dart';
import 'package:capstone_frontend/core/theme/app_colors.dart';
import 'package:capstone_frontend/core/theme/app_radius.dart';
import 'package:capstone_frontend/core/theme/app_spacing.dart';
import 'package:capstone_frontend/core/theme/app_text_styles.dart';

class CourierSettingsScreen extends StatefulWidget {
  const CourierSettingsScreen({super.key});

  @override
  State<CourierSettingsScreen> createState() => _CourierSettingsScreenState();
}

class _CourierSettingsScreenState extends State<CourierSettingsScreen> {
  bool notifyDeliveryStart = true;
  bool notifyPickupRequest = true;
  bool notifySystemError = true;
  bool useSound = false;
  bool useVibration = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          _SectionTitle(title: '알림 설정'),
          _SettingCard(
            children: [
              _buildSwitchTile(
                title: '배송 시작 알림',
                subtitle: '새 배송 작업 시작 시 알림을 표시합니다.',
                value: notifyDeliveryStart,
                onChanged: (value) {
                  setState(() => notifyDeliveryStart = value);
                },
              ),
              _divider(),
              _buildSwitchTile(
                title: '수거 요청 알림',
                subtitle: '프레시백 수거 요청이 들어오면 알림을 표시합니다.',
                value: notifyPickupRequest,
                onChanged: (value) {
                  setState(() => notifyPickupRequest = value);
                },
              ),
              _divider(),
              _buildSwitchTile(
                title: '통신 오류 알림',
                subtitle: '장비 또는 앱 통신 이상 발생 시 알림을 표시합니다.',
                value: notifySystemError,
                onChanged: (value) {
                  setState(() => notifySystemError = value);
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          _SectionTitle(title: '사용 옵션'),
          _SettingCard(
            children: [
              _buildSwitchTile(
                title: '사운드 사용',
                subtitle: '중요 알림에 효과음을 사용합니다.',
                value: useSound,
                onChanged: (value) {
                  setState(() => useSound = value);
                },
              ),
              _divider(),
              _buildSwitchTile(
                title: '진동 사용',
                subtitle: '중요 이벤트 발생 시 진동을 사용합니다.',
                value: useVibration,
                onChanged: (value) {
                  setState(() => useVibration = value);
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          _SectionTitle(title: '앱 정보'),
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(color: AppColors.stroke),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Porter Courier App', style: AppTextStyles.body),
                SizedBox(height: 6),
                Text('버전 0.1.0 (시연용 빌드)', style: AppTextStyles.sub),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile.adaptive(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: AppTextStyles.body),
      subtitle: Text(subtitle, style: AppTextStyles.sub),
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primary,
    );
  }

  Widget _divider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColors.stroke,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Text(
        title,
        style: AppTextStyles.sectionTitle,
      ),
    );
  }
}

class _SettingCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.stroke),
      ),
      child: Column(children: children),
    );
  }
}