import 'package:flutter/material.dart';
import 'package:capstone_frontend/core/theme/app_colors.dart';
import 'package:capstone_frontend/core/theme/app_spacing.dart';
import 'package:capstone_frontend/core/theme/app_text_styles.dart';

enum TimelineStepState { done, current, future }

class TimelineStepData {
  final String title;
  final String? subtitle;
  final TimelineStepState state;

  const TimelineStepData({
    required this.title,
    this.subtitle,
    required this.state,
  });
}

class ProgressTimeline extends StatelessWidget {
  final List<TimelineStepData> steps;
  final bool compact;

  const ProgressTimeline({
    super.key,
    required this.steps,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isLast = index == steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                _Node(state: step.state, compact: compact),
                if (!isLast)
                  Container(
                    width: 2,
                    height: compact ? 36 : 44,
                    color: step.state == TimelineStepState.done
                        ? AppColors.deepGreen
                        : AppColors.timelineInactive,
                  ),
              ],
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(step.title, style: AppTextStyles.body),
                    if (step.subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(step.subtitle!, style: AppTextStyles.sub),
                    ],
                    if (!isLast) const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _Node extends StatelessWidget {
  final TimelineStepState state;
  final bool compact;

  const _Node({
    required this.state,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    final size = compact ? 14.0 : 18.0;

    Color fill;
    Color border;

    switch (state) {
      case TimelineStepState.done:
        fill = AppColors.deepGreen;
        border = AppColors.deepGreen;
        break;
      case TimelineStepState.current:
        fill = AppColors.surface;
        border = AppColors.deepGreen;
        break;
      case TimelineStepState.future:
        fill = AppColors.surface;
        border = AppColors.timelineInactive;
        break;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: fill,
        shape: BoxShape.circle,
        border: Border.all(color: border, width: 2),
      ),
    );
  }
}