import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../data/providers/dashboard_provider.dart';
import '../../../domain/engine/allocation_engine.dart';
import '../../commitments/widgets/affordability_simulator_sheet.dart';

class AiCoachCard extends StatelessWidget {
  const AiCoachCard({super.key, required this.state});

  final DashboardState state;

  @override
  Widget build(BuildContext context) {
    final alloc = state.allocation;
    final netSalary = state.netSalary.netSalary;
    final totalCommitments = alloc.totalCommitments;
    final dsrPercent = alloc.dsrRatio * 100;
    final monthlySavings = alloc.savings.targetAmount;

    // Emergency fund milestone calculation (3 months of needs)
    final threeMonthsNeedsSen = alloc.needs.targetAmount.sen * 3;
    final currentSavingsSen = state.profile.currentSavingsSen;
    final savingsDeficitSen = (threeMonthsNeedsSen - currentSavingsSen).clamp(0, double.infinity).toInt();
    final monthsToEmergencyTarget = monthlySavings.sen > 0
        ? (savingsDeficitSen / monthlySavings.sen).ceil()
        : 0;

    String coachHeading;
    String coachAdvice;
    Color accentColor;

    final preset = AllocationPreset.forType(state.employmentType);
    final needsPct = (preset.needs * 100).round();
    final savingsPct = (preset.savings * 100).round();

    if (alloc.dsrRatio > preset.needs) {
      coachHeading = 'Debt Squeeze Alert: Wants Budget Clamped';
      coachAdvice =
          'Your monthly commitments (${totalCommitments.formatted}) consume ${dsrPercent.toStringAsFixed(1)}% of your take-home pay, exceeding the $needsPct% standard Needs bucket. DanBudget automatically clamped your Wants allocation down to ${alloc.wants.targetAmount.formatted} to keep your $savingsPct% emergency savings intact!';
      accentColor = AppColors.warning;
    } else if (alloc.dsrRatio <= 0.25) {
      coachHeading = 'Strong Financial Cushion — Build Your ASB Runway';
      coachAdvice =
          'Excellent! Your debt commitments are just ${dsrPercent.toStringAsFixed(1)}% of take-home pay. You have ${alloc.needs.flexibleAmount.formatted} in flexible Needs and ${alloc.wants.targetAmount.formatted} in Wants. Saving ${monthlySavings.formatted}/month will build a 3-month emergency safety net of ${Money(threeMonthsNeedsSen).formatted} in approximately $monthsToEmergencyTarget months.';
      accentColor = AppColors.primary;
    } else {
      coachHeading = 'Balanced Cashflow — On Track';
      coachAdvice =
          'Your DSR is moderate at ${dsrPercent.toStringAsFixed(1)}%. Keep loan additions strictly under control and resist piling up extra SPayLater tenures until your initial RM 1,000 liquid buffer is established.';
      accentColor = AppColors.accent;
    }

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.auto_awesome_rounded, color: accentColor, size: 20),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'AI Financial Coach',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceHigh,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.outline),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lock_rounded, size: 11, color: AppColors.primary),
                    SizedBox(width: 4),
                    Text(
                      'ZDR Privacy',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          Text(
            coachHeading,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            coachAdvice,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textPrimary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),

          // Pro-tip pill
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceHigh,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Text('💡', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    netSalary.sen >= 300000
                        ? 'Malaysian Pro-Tip: Setup standing instructions to transfer 20% (${monthlySavings.formatted}) into ASB or high-yield digital banking right on payday (25th).'
                        : 'Malaysian Pro-Tip: Utilize the My50 RapidKL unlimited travel pass to cap your monthly transit costs at RM 50.',
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.3),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => AffordabilitySimulatorSheet.show(context),
              icon: const Icon(Icons.psychology_alt_rounded, size: 18, color: AppColors.accent),
              label: const Text('Ask Coach: Can I Afford A Purchase?'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.accent,
                side: BorderSide(color: AppColors.accent.withValues(alpha: 0.5)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
