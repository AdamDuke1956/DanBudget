import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../data/providers/dashboard_provider.dart';
import '../../../domain/engine/allocation_engine.dart';
import '../../commitments/widgets/affordability_simulator_sheet.dart';

/// Plan-tab summary of cash flow: two status chips and one line of advice.
/// Rule-based (DSR vs the preset's Needs share), so it is labelled as such
/// instead of dressed up as an assistant.
class CashflowAdvisorCard extends StatelessWidget {
  const CashflowAdvisorCard({super.key, required this.state});

  final DashboardState state;

  @override
  Widget build(BuildContext context) {
    final alloc = state.allocation;
    final dsrPercent = alloc.dsrRatio * 100;
    final monthlySavings = alloc.savings.targetAmount;
    final preset = AllocationPreset.forType(state.employmentType);

    // Emergency fund target: 3 months of Needs.
    final threeMonthsNeedsSen = alloc.needs.targetAmount.sen * 3;
    final savingsDeficitSen =
        (threeMonthsNeedsSen - state.profile.currentSavingsSen).clamp(0, 1 << 40);
    final monthsToEmergencyTarget = monthlySavings.sen > 0
        ? (savingsDeficitSen / monthlySavings.sen).ceil()
        : 0;

    final String advice;
    final Color statusColor;
    final String secondChip;

    if (alloc.dsrRatio > preset.needs) {
      statusColor = AppColors.warning;
      advice = 'Wants capped at ${alloc.wants.targetAmount.formatted} to protect savings.';
      secondChip = 'Wants capped';
    } else if (alloc.dsrRatio <= 0.25) {
      statusColor = AppColors.primary;
      advice = 'Save ${monthlySavings.formatted} a month to stay on track.';
      secondChip = savingsDeficitSen == 0
          ? 'Emergency fund ready'
          : (monthsToEmergencyTarget > 0
              ? 'Emergency fund in $monthsToEmergencyTarget mo'
              : 'Emergency fund not started');
    } else {
      statusColor = AppColors.accent;
      advice = 'Hold off on new SPayLater tenures for now.';
      secondChip = 'Watch new debt';
    }

    return SurfaceCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.insights_rounded, color: AppColors.textSecondary, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Cashflow Advisor',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _StatusChip(label: 'DSR ${dsrPercent.toStringAsFixed(1)}%', color: statusColor),
              _StatusChip(label: secondChip, color: statusColor),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            advice,
            style: TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.4),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => AffordabilitySimulatorSheet.show(context),
              icon: Icon(Icons.calculate_outlined, size: 18, color: AppColors.textPrimary),
              label: const Text('Can I afford a purchase?'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: BorderSide(color: AppColors.outline),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color),
      ),
    );
  }
}
