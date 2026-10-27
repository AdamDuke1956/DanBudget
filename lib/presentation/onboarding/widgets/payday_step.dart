import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../../domain/engine/allocation_engine.dart';
import '../../../domain/engine/employment_type.dart';
import 'onboarding_widgets.dart';

/// An optional recurring cost the user can add during onboarding.
class StarterOption {
  const StarterOption({
    required this.id,
    this.emoji = '',
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.monthlySen,
    required this.dueDay,
  });

  final String id;
  final String emoji;
  final IconData icon;
  final String title;
  final String subtitle;
  final int monthlySen;
  final int dueDay;

  StarterCommitment toCommitment() => StarterCommitment(
        title: title,
        monthlyPaymentSen: monthlySen,
        dueDayOfMonth: dueDay,
      );
}

/// Offered starter commitments (My50 is pre-selected for interns).
const List<StarterOption> kStarterOptions = [
  StarterOption(
    id: 'my50',
    icon: Icons.directions_subway_rounded,
    title: 'My50 Transit Pass',
    subtitle: 'Unlimited RapidKL travel',
    monthlySen: 5000,
    dueDay: 1,
  ),
  StarterOption(
    id: 'telco',
    icon: Icons.phone_android_rounded,
    title: 'Mobile Plan',
    subtitle: 'Prepaid / postpaid data',
    monthlySen: 3500,
    dueDay: 1,
  ),
];

/// Step 4 - payday, optional starter commitments and a live plan preview.
class PaydayStep extends StatelessWidget {
  const PaydayStep({
    super.key,
    required this.employmentType,
    required this.netIncome,
    required this.payday,
    required this.onPaydayChanged,
    required this.selectedStarterIds,
    required this.onStarterToggled,
  });

  final EmploymentType employmentType;
  final Money netIncome;
  final int payday;
  final ValueChanged<int> onPaydayChanged;
  final Set<String> selectedStarterIds;
  final ValueChanged<String> onStarterToggled;

  static const List<int> quickPaydays = [1, 15, 25, 28];

  @override
  Widget build(BuildContext context) {
    final selected =
        kStarterOptions.where((o) => selectedStarterIds.contains(o.id));
    final commitments =
        Money(selected.fold<int>(0, (sum, o) => sum + o.monthlySen));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const OnboardingStepHeader(
          icon: Icons.calendar_month_rounded,
          title: 'Payday & starter costs',
          subtitle:
              'Tell us when money lands so we can pace your daily budget. Starter costs are optional.',
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Payday of the month',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              _ordinal(payday),
              key: const Key('onboarding_payday_label'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.outline,
            thumbColor: AppColors.primary,
            overlayColor: AppColors.primary.withValues(alpha: 0.15),
          ),
          child: Slider(
            key: const Key('onboarding_payday_slider'),
            min: 1,
            max: 28,
            divisions: 27,
            value: payday.toDouble(),
            onChanged: (v) => onPaydayChanged(v.round()),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final d in quickPaydays)
              OnboardingChip(
                label: _ordinal(d),
                selected: payday == d,
                onTap: () {
                  HapticFeedback.selectionClick();
                  onPaydayChanged(d);
                },
              ),
          ],
        ),
        const SizedBox(height: 26),
        Text(
          'Starter commitments (optional)',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 10),
        for (final option in kStarterOptions) ...[
          _StarterTile(
            option: option,
            selected: selectedStarterIds.contains(option.id),
            onTap: () {
              HapticFeedback.selectionClick();
              onStarterToggled(option.id);
            },
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 10),
        _PlanPreview(
          employmentType: employmentType,
          netIncome: netIncome,
          commitments: commitments,
        ),
      ],
    );
  }

  static String _ordinal(int n) {
    if (n % 100 >= 11 && n % 100 <= 13) return '${n}th';
    switch (n % 10) {
      case 1:
        return '${n}st';
      case 2:
        return '${n}nd';
      case 3:
        return '${n}rd';
      default:
        return '${n}th';
    }
  }
}

class _StarterTile extends StatelessWidget {
  const _StarterTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final StarterOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: Key('starter_${option.id}'),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.12)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.outline,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primary.withValues(alpha: 0.18)
                    : AppColors.surfaceHigh,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                option.icon,
                size: 20,
                color: selected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${option.subtitle} • ${Money(option.monthlySen).formatted}/mo',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.check_circle_rounded
                  : Icons.add_circle_outline_rounded,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanPreview extends StatelessWidget {
  const _PlanPreview({
    required this.employmentType,
    required this.netIncome,
    required this.commitments,
  });

  final EmploymentType employmentType;
  final Money netIncome;
  final Money commitments;

  @override
  Widget build(BuildContext context) {
    final alloc = AllocationEngine.calculate(
      netSalary: netIncome,
      totalCommitments: commitments,
      employmentType: employmentType,
    );
    final preset = AllocationPreset.forType(employmentType);

    return SurfaceCard(
      raised: true,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your monthly plan',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                preset.label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Take-home ${netIncome.formatted}',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          _row('Needs', alloc.needs.targetAmount, AppColors.needs),
          _row('Wants', alloc.wants.targetAmount, AppColors.wants),
          _row('Savings', alloc.savings.targetAmount, AppColors.savings),
          _row('Charity', alloc.giving.targetAmount, AppColors.giving),
        ],
      ),
    );
  }

  Widget _row(String label, Money amount, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            amount.formatted,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
