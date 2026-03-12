import 'dart:async';
import 'package:flutter/material.dart';
import 'app_models.dart';
import 'app_values.dart';

void main() {
  runApp(const JetPaceApp());
}

class JetPaceApp extends StatelessWidget {
  const JetPaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppValues.appName,
      debugShowCheckedModeBanner: false,
      theme: AppValues.theme,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RootScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppValues.screenPadding),
        child: Column(
          children: [
            const Spacer(),
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                color: AppValues.surface,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: AppValues.border),
                boxShadow: [
                  BoxShadow(
                    color: AppValues.primary.withValues(alpha: 0.15),
                    blurRadius: 24,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.directions_run_rounded,
                size: 44,
                color: AppValues.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(AppValues.appName, style: AppText.h1),
            const SizedBox(height: 8),
            const Text(
              '${AppValues.splashTitle}\n${AppValues.splashSubtitle}',
              textAlign: TextAlign.center,
              style: AppText.sub,
            ),
            const Spacer(),
            const CircularProgressIndicator(
              color: AppValues.primary,
              strokeWidth: 2.4,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int currentIndex = 0;

  late final List<Widget> screens = const [
    HomeScreen(),
    SessionScreen(),
    ReportScreen(),
    MyScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) => setState(() => currentIndex = value),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_fill_rounded),
            label: 'Session',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'My',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'JetPace',
      child: ListView(
        padding: const EdgeInsets.all(AppValues.screenPadding),
        children: const [
          Text('러닝 코칭 준비 완료', style: AppText.h1),
          SizedBox(height: 8),
          Text(
            '로봇 촬영 영상 + 자세 분석 기반 러닝 코칭 앱',
            style: AppText.sub,
          ),
          SizedBox(height: 24),
          _HeroRunCard(),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _QuickStatCard(
                  title: '로봇 연결',
                  value: '연결됨',
                  valueColor: AppValues.good,
                  icon: Icons.smart_toy_rounded,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _QuickStatCard(
                  title: '모델 상태',
                  value: 'Ready',
                  valueColor: AppValues.primary,
                  icon: Icons.memory_rounded,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _QuickStatCard(
                  title: '최근 점수',
                  value: '84.5',
                  icon: Icons.auto_graph_rounded,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _QuickStatCard(
                  title: '평균 심박',
                  value: '148',
                  icon: Icons.favorite_rounded,
                  valueColor: AppValues.accent,
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          _SectionTitle(title: '오늘의 추천'),
          SizedBox(height: 12),
          _TipCard(
            title: '상체 각도 안정화',
            body: '러닝 중 상체가 과하게 앞으로 숙여지지 않도록 어깨와 골반 정렬을 유지하세요.',
          ),
          SizedBox(height: 12),
          _TipCard(
            title: '팔 스윙 보완',
            body: '팔 스윙이 너무 작으면 추진력이 줄어들 수 있습니다. 뒤로 보내는 동작도 신경 쓰세요.',
          ),
        ],
      ),
    );
  }
}

class SessionScreen extends StatelessWidget {
  const SessionScreen({super.key});

  PoseFrameResult get dummyPose => PoseFrameResult(
    frameIndex: 128,
    timestamp: DateTime.now(),
    personBox: const DetectionResult(
      label: 'person',
      confidence: 0.93,
      x: 0.18,
      y: 0.12,
      width: 0.52,
      height: 0.74,
    ),
    keypoints: const [
      PoseKeypoint(
        name: 'leftShoulder',
        x: 0.30,
        y: 0.25,
        confidence: 0.92,
      ),
      PoseKeypoint(
        name: 'rightShoulder',
        x: 0.42,
        y: 0.25,
        confidence: 0.91,
      ),
      PoseKeypoint(
        name: 'leftHip',
        x: 0.32,
        y: 0.48,
        confidence: 0.88,
      ),
      PoseKeypoint(
        name: 'rightHip',
        x: 0.40,
        y: 0.48,
        confidence: 0.87,
      ),
    ],
    trunkLeanAngle: 18.0,
    armSwingAngle: 28.0,
    kneeLiftAngle: 42.0,
    strideSymmetry: 81.0,
    postureScore: 76.0,
    postureStatus: 'warning',
    issueCode: 'trunk_forward',
    feedbackText: AppValues.feedbackMap['trunk_forward']!,
  );

  @override
  Widget build(BuildContext context) {
    final pose = dummyPose;

    return AppPage(
      title: 'Running Session',
      child: ListView(
        padding: const EdgeInsets.all(AppValues.screenPadding),
        children: [
          _StatusBanner(
            label: 'LIVE ANALYSIS',
            message: pose.feedbackText,
            color: pose.postureStatus == 'good'
                ? AppValues.good
                : pose.postureStatus == 'warning'
                ? AppValues.warning
                : AppValues.danger,
          ),
          const SizedBox(height: 16),
          const _LivePreviewCard(),
          const SizedBox(height: 16),
          const Row(
            children: [
              Expanded(
                child: _QuickStatCard(
                  title: '심박',
                  value: '152',
                  icon: Icons.favorite_rounded,
                  valueColor: AppValues.accent,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _QuickStatCard(
                  title: '거리(km)',
                  value: '2.84',
                  icon: Icons.route_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Expanded(
                child: _QuickStatCard(
                  title: '페이스',
                  value: '5:42',
                  icon: Icons.timer_rounded,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _QuickStatCard(
                  title: '자세 점수',
                  value: '76.0',
                  icon: Icons.accessibility_new_rounded,
                  valueColor: AppValues.warning,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const _SectionTitle(title: '실시간 분석'),
          const SizedBox(height: 12),
          _AnalysisTile(
            label: '상체 기울기',
            value: '${pose.trunkLeanAngle.toStringAsFixed(1)}°',
            color: AppValues.warning,
          ),
          const SizedBox(height: 10),
          _AnalysisTile(
            label: '팔 스윙 각도',
            value: '${pose.armSwingAngle.toStringAsFixed(1)}°',
          ),
          const SizedBox(height: 10),
          _AnalysisTile(
            label: '무릎 리프트',
            value: '${pose.kneeLiftAngle.toStringAsFixed(1)}°',
          ),
          const SizedBox(height: 10),
          _AnalysisTile(
            label: '좌우 대칭',
            value: '${pose.strideSymmetry.toStringAsFixed(1)}',
          ),
          const SizedBox(height: 24),
          const _SectionTitle(title: '현재 이슈'),
          const SizedBox(height: 12),
          _IssueCard(
            issueCode: pose.issueCode,
            message: pose.feedbackText,
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: AppValues.buttonHeight,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppValues.primary,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppValues.cardRadius),
                ),
              ),
              onPressed: () {},
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text(
                '세션 시작',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  RunningSessionSummary get dummySummary => RunningSessionSummary(
    sessionId: 'run_001',
    startedAt: DateTime.now().subtract(const Duration(minutes: 32)),
    endedAt: DateTime.now(),
    durationMinutes: 31.8,
    distanceKm: 5.24,
    avgHeartRate: 149,
    avgPace: 5.42,
    finalPostureScore: 84.5,
    issueCounts: const {
      'trunk_forward': 12,
      'arm_swing_small': 7,
      'stride_unbalanced': 4,
    },
    topIssueCode: 'trunk_forward',
    topFeedback: AppValues.feedbackMap['trunk_forward']!,
  );

  @override
  Widget build(BuildContext context) {
    final summary = dummySummary;

    return AppPage(
      title: 'Report',
      child: ListView(
        padding: const EdgeInsets.all(AppValues.screenPadding),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('세션 요약', style: AppText.h2),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _MetricBlock(
                        label: '자세 점수',
                        value: summary.finalPostureScore.toStringAsFixed(1),
                        valueColor: AppValues.primary,
                      ),
                    ),
                    Expanded(
                      child: _MetricBlock(
                        label: '거리',
                        value: '${summary.distanceKm.toStringAsFixed(2)} km',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _MetricBlock(
                        label: '평균 심박',
                        value: '${summary.avgHeartRate}',
                        valueColor: AppValues.accent,
                      ),
                    ),
                    Expanded(
                      child: _MetricBlock(
                        label: '평균 페이스',
                        value: summary.avgPace.toStringAsFixed(2),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const _SectionTitle(title: '주요 개선 포인트'),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(summary.topFeedback, style: AppText.h3),
                const SizedBox(height: 8),
                const Text(
                  '세션 중 가장 자주 감지된 문제를 기준으로 우선 개선 포인트를 제시합니다.',
                  style: AppText.sub,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const _SectionTitle(title: '이슈 발생 횟수'),
          const SizedBox(height: 12),
          ...summary.issueCounts.entries.map(
                (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AppCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.key, style: AppText.body),
                    Text(
                      '${entry.value}회',
                      style: const TextStyle(
                        color: AppValues.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyScreen extends StatelessWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'My',
      child: ListView(
        padding: const EdgeInsets.all(AppValues.screenPadding),
        children: const [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Profile', style: AppText.h2),
                SizedBox(height: 12),
                Text('사용자: Demo Runner', style: AppText.body),
                SizedBox(height: 6),
                Text('연동 기기: Apple Watch / Robot Cam', style: AppText.sub),
              ],
            ),
          ),
          SizedBox(height: 16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Settings', style: AppText.h2),
                SizedBox(height: 12),
                Text('• 카메라 권한', style: AppText.body),
                SizedBox(height: 6),
                Text('• 건강 데이터 권한', style: AppText.body),
                SizedBox(height: 6),
                Text('• 피드백 음성 on/off', style: AppText.body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AppPage extends StatelessWidget {
  final String title;
  final Widget child;

  const AppPage({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: child,
    );
  }
}

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}

class _HeroRunCard extends StatelessWidget {
  const _HeroRunCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppValues.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.directions_run_rounded,
                  color: AppValues.primary,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'AI 러닝 코칭 세션',
                  style: AppText.h2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            '로봇이 촬영한 영상을 기반으로 자세를 분석하고, 실시간 피드백과 세션 리포트를 제공합니다.',
            style: AppText.sub,
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: AppValues.buttonHeight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppValues.primary,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppValues.cardRadius),
                ),
              ),
              onPressed: () {},
              child: const Text(
                '러닝 시작',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? valueColor;

  const _QuickStatCard({
    required this.title,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppValues.textSub),
          const SizedBox(height: 12),
          Text(title, style: AppText.sub),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppText.h2.copyWith(
              color: valueColor ?? AppValues.textMain,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppText.h2);
  }
}

class _TipCard extends StatelessWidget {
  final String title;
  final String body;

  const _TipCard({
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppText.h3),
          const SizedBox(height: 8),
          Text(body, style: AppText.sub),
        ],
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  final String label;
  final String message;
  final Color color;

  const _StatusBanner({
    required this.label,
    required this.message,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.graphic_eq_rounded, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppText.sub.copyWith(color: color)),
                const SizedBox(height: 6),
                Text(message, style: AppText.h3),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LivePreviewCard extends StatelessWidget {
  const _LivePreviewCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Container(
        height: 260,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppValues.cardRadius),
          gradient: LinearGradient(
            colors: [
              AppValues.surface,
              AppValues.border.withValues(alpha: 0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            const Center(
              child: Icon(
                Icons.videocam_rounded,
                size: 56,
                color: AppValues.textSub,
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppValues.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'REC',
                  style: TextStyle(
                    color: AppValues.accent,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 18,
              top: 32,
              child: Container(
                width: 120,
                height: 170,
                decoration: BoxDecoration(
                  border: Border.all(color: AppValues.primary, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnalysisTile extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _AnalysisTile({
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppText.body),
          Text(
            value,
            style: TextStyle(
              color: color ?? AppValues.textMain,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _IssueCard extends StatelessWidget {
  final String issueCode;
  final String message;

  const _IssueCard({
    required this.issueCode,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppValues.warning.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: AppValues.warning,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(issueCode, style: AppText.h3),
                const SizedBox(height: 6),
                Text(message, style: AppText.sub),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricBlock extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _MetricBlock({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppText.sub),
        const SizedBox(height: 6),
        Text(
          value,
          style: AppText.metric.copyWith(
            color: valueColor ?? AppValues.textMain,
          ),
        ),
      ],
    );
  }
}