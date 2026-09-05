import 'package:flutter/material.dart';
import 'package:capstone_frontend/core/theme/app_colors.dart';
import 'package:capstone_frontend/core/theme/app_radius.dart';
import 'package:capstone_frontend/core/theme/app_spacing.dart';
import 'package:capstone_frontend/core/theme/app_text_styles.dart';
import 'package:capstone_frontend/core/widgets/info_card.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  int currentStep = 2;
  bool _hasShownCompletionPopup = false;

  static const address = '523호';
  static const eta = '01:18';

  static const List<String> steps = [
    '접수됨',
    '로봇 적재 완료',
    '이동',
    '배송 층 도착',
    '배송 완료',
  ];

  bool get isCompleted => currentStep >= steps.length - 1;
  bool get isArrived => currentStep >= 3;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tryShowCompletionPopup();
  }

  void _advanceStep() {
    setState(() {
      if (currentStep >= steps.length - 1) {
        currentStep = 0;
        _hasShownCompletionPopup = false;
      } else {
        currentStep++;
      }
    });

    _tryShowCompletionPopup();
  }

  void _tryShowCompletionPopup() {
    if (!mounted) return;
    if (currentStep == steps.length - 1 && !_hasShownCompletionPopup) {
      _hasShownCompletionPopup = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _showDeliveryCheckPhoto();
      });
    }
  }

  void _showDeliveryCheckPhoto() {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 32,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '배송이 완료되었습니다',
                  style: AppTextStyles.sectionTitle,
                ),
                const SizedBox(height: AppSpacing.sm),
                const Text(
                  '문 앞에 안전하게 배송되었어요.',
                  style: AppTextStyles.sub,
                ),
                const SizedBox(height: AppSpacing.xl),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  child: Image.asset(
                    'assets/check.png',
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                const Text(
                  '도착 사진을 확인해 주세요.',
                  style: AppTextStyles.sub,
                ),
                const SizedBox(height: AppSpacing.xl),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('확인'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFreshbagStatus() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('프래시백 회수 신청 현황'),
          content: const Text(
            '현재 프래시백 회수 신청이 접수되었습니다. 회수 진행 상태는 추후 안내됩니다.',
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

  String _statusLabel() {
    if (isCompleted) return '완료';
    if (isArrived) return '배송 층 도착';
    return '이동';
  }

  String _statusBody() {
    if (isCompleted) return '배송 완료';
    if (isArrived) return '배송 층 도착';
    return '배송 진행 중';
  }

  String _bottomMessage() {
    if (isCompleted) return '배송이 안전하게 완료되었습니다.';
    if (isArrived) return '배송 층에 도착했습니다. 곧 배송이 완료됩니다.';
    return '배송이 완료되면 바로 알려드릴게요.';
  }

  String _stepSubtitle(int index) {
    if (index == 2 && currentStep == 2) {
      return '목적지 방향으로 이동 중';
    }
    if (index == 3 && currentStep >= 3) {
      return '5층 도착';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('배송 현황')),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: '홈'),
          NavigationDestination(
            icon: Icon(Icons.local_shipping_outlined),
            label: '배송현황',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            label: '내역',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: '내 정보',
          ),
        ],
        onDestinationSelected: (index) => _onNavTap(context, index),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        children: [
          Text(
            isCompleted ? '배송이 완료되었습니다' : '현재 새벽배송이 진행 중입니다',
            style: AppTextStyles.body,
          ),
          const SizedBox(height: AppSpacing.xl),
          InfoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Text(
                        _statusLabel(),
                        style: AppTextStyles.sub.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      isCompleted ? '배송 완료' : 'ETA $eta',
                      style: AppTextStyles.sub,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                const Text(
                  address,
                  style: AppTextStyles.sectionTitle,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  _statusBody(),
                  style: AppTextStyles.body,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          InkWell(
            onTap: _advanceStep,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            child: InfoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '배송 진행 단계',
                    style: AppTextStyles.sectionTitle,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const SizedBox(height: AppSpacing.lg),
                  for (int i = 0; i < steps.length; i++)
                    _TrackingStep(
                      title: steps[i],
                      subtitle: _stepSubtitle(i),
                      state: _stepState(i, currentStep),
                      isLast: i == steps.length - 1,
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          InfoCard(
            backgroundColor: AppColors.primaryLight,
            child: Text(
              _bottomMessage(),
              style: AppTextStyles.body,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton(
              onPressed: _showFreshbagStatus,
              child: const Text('프래시백 회수 신청 현황 확인'),
            ),
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

_TimelineState _stepState(int index, int currentStep) {
  if (index < currentStep) return _TimelineState.done;
  if (index == currentStep) return _TimelineState.current;
  return _TimelineState.future;
}

enum _TimelineState { done, current, future }

class _TrackingStep extends StatefulWidget {
  final String title;
  final String? subtitle;
  final _TimelineState state;
  final bool isLast;

  const _TrackingStep({
    required this.title,
    this.subtitle,
    required this.state,
    required this.isLast,
  });

  @override
  State<_TrackingStep> createState() => _TrackingStepState();
}

class _TrackingStepState extends State<_TrackingStep>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.22,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.state == _TimelineState.current) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant _TrackingStep oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.state == _TimelineState.current) {
      if (!_controller.isAnimating) {
        _controller.repeat(reverse: true);
      }
    } else {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDone = widget.state == _TimelineState.done;
    final isCurrent = widget.state == _TimelineState.current;

    final lineColor =
    (isDone || isCurrent) ? AppColors.primary : AppColors.stroke;

    final dotFillColor = isDone
        ? AppColors.primary
        : isCurrent
        ? AppColors.primary
        : Colors.white;

    final dotBorderColor =
    (isDone || isCurrent) ? AppColors.primary : AppColors.stroke;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 28,
            child: Column(
              children: [
                ScaleTransition(
                  scale: isCurrent
                      ? _scaleAnimation
                      : const AlwaysStoppedAnimation(1.0),
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: dotFillColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: dotBorderColor,
                        width: 3,
                      ),
                      boxShadow: isCurrent
                          ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.28),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ]
                          : null,
                    ),
                  ),
                ),
                if (!widget.isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: lineColor,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title, style: AppTextStyles.body),
                  if (widget.subtitle != null && widget.subtitle!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(widget.subtitle!, style: AppTextStyles.sub),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}