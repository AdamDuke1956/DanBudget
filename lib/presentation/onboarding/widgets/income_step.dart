import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/money.dart';
import '../../../domain/engine/employment_type.dart';
import '../../../domain/engine/net_salary_calculator.dart';
import 'onboarding_widgets.dart';

/// Step 3 - monthly allowance (intern) or gross salary (full-time).
class IncomeStep extends StatelessWidget {
  const IncomeStep({
    super.key,
    required this.employmentType,
    required this.controller,
    required this.onChanged,
    required this.onPresetSelected,
    required this.epfRate,
    required this.onEpfRateChanged,
  });

  final EmploymentType employmentType;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<int> onPresetSelected;
  final double epfRate;
  final ValueChanged<double> onEpfRateChanged;

  static const List<int> internPresets = [500, 800, 900, 1200];
  static const List<int> fullTimePresets = [2800, 3000, 3500, 4500];

  /// Parses the typed amount in ringgit; null when empty / invalid.
  static double? parseRinggit(String text) {
    final cleaned = text.trim().replaceAll(',', '');
    return double.tryParse(cleaned);
  }

  @override
  Widget build(BuildContext context) {
    final isIntern = employmentType.isIntern;
    final presets = isIntern ? internPresets : fullTimePresets;
    final amount = parseRinggit(controller.text) ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OnboardingStepHeader(
          emoji: isIntern ? '🎓' : '💼',
          title: isIntern
              ? "What's your monthly allowance?"
              : "What's your monthly salary?",
          subtitle: isIntern
              ? 'The amount you receive from your internship each month.'
              : 'Your gross basic salary before EPF, SOCSO, EIS and tax.',
        ),
        const SizedBox(height: 24),
        TextField(
          key: const Key('onboarding_income_field'),
          controller: controller,
          onChanged: onChanged,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
            LengthLimitingTextInputFormatter(9),
          ],
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
          decoration: onboardingInputDecoration(
            label: isIntern ? 'Monthly Allowance' : 'Gross Monthly Salary',
            prefixText: 'RM ',
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final p in presets)
              OnboardingChip(
                label: 'RM ${_withCommas(p)}',
                selected: amount == p.toDouble(),
                onTap: () {
                  HapticFeedback.selectionClick();
                  onPresetSelected(p);
                },
              ),
          ],
        ),
        const SizedBox(height: 22),
        if (isIntern)
          OnboardingInfoPill(
            icon: Icons.verified_rounded,
            text: amount > 0
                ? 'No statutory deductions. You take home the full ${Money.fromRinggit(amount).formatted}.'
                : 'No statutory deductions. You take home your full allowance.',
          )
        else ...[
          const Text(
            'EPF (KWSP) employee contribution',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              OnboardingChip(
                label: '11% Standard',
                selected: epfRate == 0.11,
                onTap: () => onEpfRateChanged(0.11),
              ),
              const SizedBox(width: 8),
              OnboardingChip(
                label: '9% Reduced',
                selected: epfRate == 0.09,
                onTap: () => onEpfRateChanged(0.09),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _TakeHomePreview(amount: amount, epfRate: epfRate),
        ],
      ],
    );
  }

  static String _withCommas(int v) {
    final s = v.toString();
    if (s.length <= 3) return s;
    return '${s.substring(0, s.length - 3)},${s.substring(s.length - 3)}';
  }
}

class _TakeHomePreview extends StatelessWidget {
  const _TakeHomePreview({required this.amount, required this.epfRate});

  final double amount;
  final double epfRate;

  @override
  Widget build(BuildContext context) {
    final result = NetSalaryCalculator.calculate(
      grossSalary: Money.fromRinggit(amount),
      employmentType: EmploymentType.fullTime,
      epfRate: epfRate,
    );

    return OnboardingInfoPill(
      icon: Icons.account_balance_wallet_rounded,
      text:
          'Estimated take-home: ${result.netSalary.formatted} after ${result.totalDeductions.formatted} in EPF, SOCSO, EIS and tax.',
    );
  }
}
