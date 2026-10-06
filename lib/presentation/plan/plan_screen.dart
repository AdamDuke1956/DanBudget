import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/money.dart';
import '../../core/widgets/glass_card.dart';
import '../../data/providers/dashboard_provider.dart';
import '../../domain/engine/allocation_engine.dart';
import 'widgets/adjust_plan_sheet.dart';
import 'widgets/ai_coach_card.dart';
import 'widgets/salary_edit_sheet.dart';

class PlanScreen extends ConsumerWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(dashboardStateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          stateAsync.maybeWhen(
            data: (s) {
              final preset = AllocationPreset.getPreset(
                presetKey: s.profile.budgetPreset,
                type: s.employmentType,
                customNeeds: s.profile.customNeedsRatio,
                customWants: s.profile.customWantsRatio,
                customSavings: s.profile.customSavingsRatio,
                customGiving: s.profile.customGivingRatio,
              );
              return '${preset.label} Plan';
            },
            orElse: () => 'Budget Plan',
          ),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          stateAsync.when(
            data: (state) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.tune_rounded, color: AppColors.accent),
                  tooltip: 'Adjust Budget Plan',
                  onPressed: () => AdjustPlanSheet.show(
                    context,
                    profile: state.profile,
                    netSalary: state.netSalary.netSalary,
                    totalCommitments: state.allocation.totalCommitments,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.badge_outlined, color: AppColors.primary),
                  tooltip: 'Edit Salary Settings',
                  onPressed: () => SalaryEditSheet.show(context, state.profile),
                ),
              ],
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: stateAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, _) => Center(
          child: Text('Error: $err', style: const TextStyle(color: AppColors.danger)),
        ),
        data: (state) {
          final net = state.netSalary;
          final alloc = state.allocation;
          final isIntern = state.employmentType.isIntern;
          final epfPercent = (state.profile.epfRate * 100).round();
          String pct(double v) => (v * 100).toStringAsFixed(0);

          return CustomScrollView(
            slivers: [
              // Malaysian Net Salary Payslip Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: GlassCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text('🇲🇾', style: TextStyle(fontSize: 20)),
                                const SizedBox(width: 8),
                                Text(
                                  isIntern
                                      ? 'Monthly Allowance Breakdown'
                                      : 'Monthly Payslip Breakdown',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            TextButton.icon(
                              onPressed: () =>
                                  SalaryEditSheet.show(context, state.profile),
                              icon: const Icon(Icons.edit_rounded,
                                  size: 14, color: AppColors.primary),
                              label: const Text('Edit',
                                  style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        _buildPayslipRow(
                            isIntern
                                ? 'Monthly Allowance'
                                : 'Gross Monthly Salary',
                            net.grossSalary.formatted,
                            isBold: true),
                        if (net.allowances.sen > 0)
                          _buildPayslipRow(
                              'Fixed Allowances', '+${net.allowances.formatted}',
                              color: AppColors.primary),
                        const Divider(color: AppColors.outline, height: 18),

                        if (isIntern)
                          _buildPayslipRow(
                              'Statutory deductions (EPF / SOCSO / EIS)',
                              'None',
                              color: AppColors.primary)
                        else ...[
                          _buildPayslipRow('EPF Employee (KWSP $epfPercent%)',
                              '-${net.epfEmployee.formatted}',
                              color: AppColors.textSecondary),
                          _buildPayslipRow('SOCSO Employee (PERKESO)',
                              '-${net.socsoEmployee.formatted}',
                              color: AppColors.textSecondary),
                          _buildPayslipRow('EIS Employee (SIP)',
                              '-${net.eisEmployee.formatted}',
                              color: AppColors.textSecondary),
                          if (net.pcbTax.sen > 0)
                            _buildPayslipRow(
                                'PCB Tax (MTD)', '-${net.pcbTax.formatted}',
                                color: AppColors.textSecondary),
                        ],

                        const Divider(color: AppColors.outline, height: 18),
                        _buildPayslipRow(
                          'Net Take-home Pay',
                          net.netSalary.formatted,
                          isHighlight: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Visual 40/30/20/10 Ratio Distribution Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Smart Salary Allocation',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () => AdjustPlanSheet.show(
                              context,
                              profile: state.profile,
                              netSalary: state.netSalary.netSalary,
                              totalCommitments: state.allocation.totalCommitments,
                            ),
                            icon: const Icon(Icons.tune_rounded, size: 14, color: AppColors.primary),
                            label: const Text(
                              'Adjust Plan',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Row(
                          children: [
                            Expanded(
                              flex: (alloc.needs.percentage * 100).round(),
                              child: Container(height: 10, color: AppColors.needs),
                            ),
                            Expanded(
                              flex: (alloc.wants.percentage * 100).round(),
                              child: Container(height: 10, color: AppColors.wants),
                            ),
                            Expanded(
                              flex: (alloc.savings.percentage * 100).round(),
                              child: Container(height: 10, color: AppColors.savings),
                            ),
                            Expanded(
                              flex: (alloc.giving.percentage * 100).round(),
                              child: Container(height: 10, color: AppColors.giving),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Legend
                      Wrap(
                        spacing: 12,
                        runSpacing: 6,
                        children: [
                          _buildLegend(
                              '${(alloc.needs.percentage * 100).toStringAsFixed(0)}% Needs',
                              AppColors.needs),
                          _buildLegend(
                              '${(alloc.wants.percentage * 100).toStringAsFixed(0)}% Wants',
                              AppColors.wants),
                          _buildLegend('${pct(alloc.savings.percentage)}% Savings',
                              AppColors.savings),
                          _buildLegend('${pct(alloc.giving.percentage)}% Giving',
                              AppColors.giving),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // 4 Detailed Bucket Cards
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    children: [
                      // Needs
                      _buildDetailedBucketCard(
                        title:
                            '${pct(alloc.needs.percentage)}% Needs (Living Expenses & Debts)',
                        targetAmount: alloc.needs.targetAmount.formatted,
                        color: AppColors.needs,
                        icon: Icons.home_rounded,
                        details: [
                          'Fixed Commitments: ${alloc.needs.fixedCommitmentPortion.formatted}',
                          'Remaining Flexible Needs: ${alloc.needs.flexibleAmount.formatted}',
                        ],
                        description:
                            'Covers groceries, toll, petrol, utility bills, and fixed loan minimums.',
                      ),
                      const SizedBox(height: 10),

                      // Wants 30%
                      _buildDetailedBucketCard(
                        title:
                            '${(alloc.wants.percentage * 100).toStringAsFixed(0)}% Wants (Lifestyle & Social)',
                        targetAmount: alloc.wants.targetAmount.formatted,
                        color: AppColors.wants,
                        icon: Icons.coffee_rounded,
                        details: [
                          'Remaining Flexible: ${state.remainingFlexibleBudget.formatted}',
                        ],
                        description:
                            'Dining out, coffee runs, subscriptions, hobbies, and weekend outings.',
                      ),
                      const SizedBox(height: 10),

                      // Savings
                      _buildDetailedBucketCard(
                        title:
                            '${pct(alloc.savings.percentage)}% Savings & Emergency Fund',
                        targetAmount: alloc.savings.targetAmount.formatted,
                        color: AppColors.savings,
                        icon: Icons.savings_rounded,
                        details: [
                          'Target: 3 Months of living costs',
                          'Current Balance: ${Money(state.profile.currentSavingsSen).formatted}',
                        ],
                        description:
                            'Liquid emergency buffer, ASB, Tabung Haji, or high-yield savings.',
                      ),
                      const SizedBox(height: 10),

                      // Giving
                      _buildDetailedBucketCard(
                        title: '${pct(alloc.giving.percentage)}% Family & Giving',
                        targetAmount: alloc.giving.targetAmount.formatted,
                        color: AppColors.giving,
                        icon: Icons.favorite_rounded,
                        details: [
                          'Recommended: Set automatic transfer on payday',
                        ],
                        description:
                            'Duit Mak Ayah (pocket money for parents), sedekah jumaat, and zakat pendapatan.',
                      ),
                    ],
                  ),
                ),
              ),

              // AI Financial Coach Insights Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: AiCoachCard(state: state),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 90)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPayslipRow(
    String label,
    String value, {
    bool isBold = false,
    bool isHighlight = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isHighlight ? 14 : 13,
              fontWeight:
                  (isBold || isHighlight) ? FontWeight.bold : FontWeight.normal,
              color: isHighlight ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isHighlight ? 17 : 13,
              fontWeight:
                  (isBold || isHighlight) ? FontWeight.bold : FontWeight.w600,
              color: isHighlight
                  ? AppColors.primary
                  : (color ?? AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedBucketCard({
    required String title,
    required String targetAmount,
    required Color color,
    required IconData icon,
    required List<String> details,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: color, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                targetAmount,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            children: details.map((d) {
              return Text(
                '• $d',
                style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
