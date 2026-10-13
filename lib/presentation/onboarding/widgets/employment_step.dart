import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../domain/engine/employment_type.dart';
import 'onboarding_widgets.dart';

/// Step 2 - choose between Internship and Full-Time employment.
class EmploymentStep extends StatelessWidget {
  const EmploymentStep({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final EmploymentType? selected;
  final ValueChanged<EmploymentType> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const OnboardingStepHeader(
          icon: Icons.explore_rounded,
          title: "What's your current status?",
          subtitle:
              'This decides how DanBudget calculates your take-home pay and splits your budget.',
        ),
        const SizedBox(height: 24),
        _EmploymentCard(
          key: const Key('employment_intern'),
          type: EmploymentType.intern,
          title: 'Internship / Student',
          description:
              'Monthly allowance or stipend. No EPF, SOCSO or EIS deductions.',
          badge: 'Budget split 60 / 20 / 15 / 5',
          selected: selected == EmploymentType.intern,
          onTap: () => _select(EmploymentType.intern),
        ),
        const SizedBox(height: 14),
        _EmploymentCard(
          key: const Key('employment_full_time'),
          type: EmploymentType.fullTime,
          title: 'Full-Time Employment',
          description:
              'Standard salary with EPF, SOCSO, EIS and estimated PCB tax.',
          badge: 'Budget split 40 / 30 / 20 / 10',
          selected: selected == EmploymentType.fullTime,
          onTap: () => _select(EmploymentType.fullTime),
        ),
        const SizedBox(height: 16),
        Text(
          'You can switch to Full-Time later when you graduate.',
          style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  void _select(EmploymentType type) {
    HapticFeedback.selectionClick();
    onSelected(type);
  }
}

class _EmploymentCard extends StatelessWidget {
  const _EmploymentCard({
    super.key,
    required this.type,
    required this.title,
    required this.description,
    required this.badge,
    required this.selected,
    required this.onTap,
  });

  final EmploymentType type;
  final String title;
  final String description;
  final String badge;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: selected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.22),
                    AppColors.primary.withValues(alpha: 0.06),
                  ],
                )
              : null,
          color: selected ? null : AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.outline,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.surfaceHigh,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                type == EmploymentType.intern
                    ? Icons.school_rounded
                    : Icons.work_rounded,
                size: 24,
                color: selected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.4,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.background.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      badge,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: selected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                selected
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                key: ValueKey(selected),
                color: selected ? AppColors.primary : AppColors.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
