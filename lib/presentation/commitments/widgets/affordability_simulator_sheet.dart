import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/money.dart';
import '../../../domain/engine/allocation_engine.dart';
import '../../../domain/engine/safe_to_spend_calculator.dart';
import '../../../data/providers/dashboard_provider.dart';
import '../../../data/providers/database_providers.dart';

class AffordabilitySimulatorSheet extends ConsumerStatefulWidget {
  const AffordabilitySimulatorSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AffordabilitySimulatorSheet(),
    );
  }

  @override
  ConsumerState<AffordabilitySimulatorSheet> createState() =>
      _AffordabilitySimulatorSheetState();
}

class _AffordabilitySimulatorSheetState
    extends ConsumerState<AffordabilitySimulatorSheet> {
  final _titleController = TextEditingController(text: 'New Gadget / BNPL');
  final _monthlyCostController = TextEditingController(text: '150');
  final _tenureController = TextEditingController(text: '12');

  @override
  void dispose() {
    _titleController.dispose();
    _monthlyCostController.dispose();
    _tenureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stateAsync = ref.watch(dashboardStateProvider);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: 24 + bottomInset,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: stateAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Text('Error: $err'),
        data: (state) {
          final netSalary = state.netSalary.netSalary;
          final currentCommitments = state.allocation.totalCommitments;

          final proposedMonthly =
              double.tryParse(_monthlyCostController.text.trim()) ?? 0;
          final proposedSen = Money.fromRinggit(proposedMonthly).sen;
          final proposedMoney = Money(proposedSen);

          final simulatedTotalCommitments = currentCommitments + proposedMoney;
          final simulatedAllocation = AllocationEngine.calculate(
            netSalary: netSalary,
            totalCommitments: simulatedTotalCommitments,
            employmentType: state.employmentType,
          );

          final currentDsr = state.allocation.dsrRatio * 100;
          final simulatedDsr = simulatedAllocation.dsrRatio * 100;

          final currentDaily = state.safeToSpend.safeDailyAmount;
          final remainingSimulatedFlexible = Money(
            (simulatedAllocation.needs.flexibleAmount.sen +
                    simulatedAllocation.wants.targetAmount.sen -
                    state.totalSpentThisCycle.sen)
                .clamp(0, double.infinity)
                .toInt(),
          );

          final simulatedSafe = SafeToSpendCalculator.calculate(
            remainingFlexibleBudget: remainingSimulatedFlexible,
            unpaidCommitmentsBeforePayday: const Money(0),
            currentDate: DateTime.now(),
            paydayDayOfMonth: state.profile.paydayDayOfMonth,
          );

          final dailyDiff = currentDaily.sen - simulatedSafe.safeDailyAmount.sen;

          Color verdictColor;
          IconData verdictIcon;
          String verdictTitle;
          String verdictDesc;

          if (simulatedDsr <= 35) {
            verdictColor = AppColors.success;
            verdictIcon = Icons.check_circle_rounded;
            verdictTitle = 'Affordable & Healthy';
            verdictDesc =
                'Your debt-service ratio stays at ${simulatedDsr.toStringAsFixed(1)}% (under the 35% safe ceiling). Your savings buffer is secure.';
          } else if (simulatedDsr <= 50) {
            verdictColor = AppColors.warning;
            verdictIcon = Icons.warning_rounded;
            verdictTitle = 'Moderate Stretch (Caution)';
            verdictDesc =
                'Your DSR climbs to ${simulatedDsr.toStringAsFixed(1)}%. Your Wants budget will be compressed to prevent dipping into savings.';
          } else {
            verdictColor = AppColors.danger;
            verdictIcon = Icons.error_rounded;
            verdictTitle = 'High Risk / Debt Stress';
            verdictDesc =
                'Critical DSR: ${simulatedDsr.toStringAsFixed(1)}%! More than half your take-home pay is locked in fixed debts. We advise postponing this purchase.';
          }

          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.outline,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Icon(Icons.psychology_alt_rounded,
                        color: AppColors.accent, size: 26),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '"Can I Afford It?" Simulator',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Test a new SPayLater or loan before committing to protect your fresh grad cashflow.',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _titleController,
                        style: TextStyle(color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          labelText: 'Purchase Name',
                          labelStyle: TextStyle(
                              color: AppColors.textSecondary, fontSize: 12),
                          filled: true,
                          fillColor: AppColors.surfaceHigh,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: AppColors.outline),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _monthlyCostController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          labelText: 'Monthly (RM)',
                          labelStyle: TextStyle(
                              color: AppColors.textSecondary, fontSize: 12),
                          prefixText: 'RM ',
                          filled: true,
                          fillColor: AppColors.surfaceHigh,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: AppColors.outline),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: verdictColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: verdictColor.withValues(alpha: 0.4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(verdictIcon, color: verdictColor, size: 24),
                          const SizedBox(width: 8),
                          Text(
                            verdictTitle,
                            style: TextStyle(
                              color: verdictColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        verdictDesc,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textPrimary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _buildMetricComparison(
                        title: 'Debt Service Ratio',
                        current: '${currentDsr.toStringAsFixed(1)}%',
                        simulated: '${simulatedDsr.toStringAsFixed(1)}%',
                        isIncreaseBad: true,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildMetricComparison(
                        title: 'Safe Daily Spend',
                        current: currentDaily.formatted,
                        simulated: simulatedSafe.safeDailyAmount.formatted,
                        diffLabel: dailyDiff > 0
                            ? '-${Money(dailyDiff).formatted}/day'
                            : 'No drop',
                        isIncreaseBad: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: AppColors.outline),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text('Cancel',
                            style: TextStyle(color: AppColors.textSecondary)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (proposedSen <= 0) return;
                          final tenure =
                              int.tryParse(_tenureController.text.trim()) ?? 12;
                          await ref
                              .read(commitmentRepositoryProvider)
                              .addCommitment(
                                title: _titleController.text.trim(),
                                type: 'spaylater',
                                totalAmountSen: proposedSen * tenure,
                                monthlyPaymentSen: proposedSen,
                                remainingAmountSen: proposedSen * tenure,
                                totalTenureMonths: tenure,
                                remainingTenureMonths: tenure,
                                dueDayOfMonth: 10,
                              );
                          if (context.mounted) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Added ${_titleController.text.trim()} to commitments'),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text('Add to Commitments',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetricComparison({
    required String title,
    required String current,
    required String simulated,
    String? diffLabel,
    required bool isIncreaseBad,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(current,
                  style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      decoration: TextDecoration.lineThrough)),
              Icon(Icons.arrow_forward_rounded,
                  size: 14, color: AppColors.textSecondary),
              Text(simulated,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary)),
            ],
          ),
          if (diffLabel != null) ...[
            const SizedBox(height: 4),
            Text(diffLabel,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.danger)),
          ],
        ],
      ),
    );
  }
}
