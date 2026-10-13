import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
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
            orElse: () => 'Budget Strategy',
          ),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: -0.3),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          stateAsync.when(
            data: (state) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.tune_rounded, color: AppColors.primary),
                  tooltip: 'Adjust Budget Plan',
                  onPressed: () => AdjustPlanSheet.show(
                    context,
                    profile: state.profile,
                    netSalary: state.netSalary.netSalary,
                    totalCommitments: state.allocation.totalCommitments,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.badge_outlined, color: AppColors.accent),
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
        loading: () => Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, _) => Center(
          child: Text('Error: $err', style: TextStyle(color: AppColors.danger)),
        ),
        data: (state) {
          final net = state.netSalary;
          final alloc = state.allocation;
          final isIntern = state.employmentType.isIntern;
          final epfPercent = (state.profile.epfRate * 100).round();
          String pct(double v) => (v * 100).toStringAsFixed(0);

          return Stack(
            children: [
              CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                slivers: [
                  // 1. Payslip & Statutory Deductions Voucher
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 6, 20, 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColors.cardBorder),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: AppColors.isDark ? 0.25 : 0.04),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(20),
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
                                          color: AppColors.primary.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Icon(Icons.receipt_rounded, size: 18, color: AppColors.primary),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          isIntern ? 'Monthly Allowance Voucher' : 'Monthly Payslip Breakdown',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                TextButton.icon(
                                  onPressed: () => SalaryEditSheet.show(context, state.profile),
                                  icon: Icon(Icons.edit_rounded, size: 14, color: AppColors.primary),
                                  label: Text(
                                    'Edit',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            _buildPayslipRow(
                              isIntern ? 'Monthly Allowance' : 'Gross Basic Salary',
                              net.grossSalary.formatted,
                              isBold: true,
                            ),
                            if (net.allowances.sen > 0)
                              _buildPayslipRow(
                                'Fixed Allowances',
                                '+${net.allowances.formatted}',
                                color: AppColors.primary,
                              ),
                            Divider(color: AppColors.outline.withValues(alpha: 0.5), height: 18),

                            if (isIntern)
                              _buildPayslipRow(
                                'Statutory deductions (EPF / SOCSO / EIS)',
                                'None (Exempted)',
                                color: AppColors.primary,
                              )
                            else ...[
                              _buildPayslipRow(
                                'KWSP Employee ($epfPercent%)',
                                '-${net.epfEmployee.formatted}',
                                color: AppColors.textSecondary,
                              ),
                              _buildPayslipRow(
                                'SOCSO / PERKESO',
                                '-${net.socsoEmployee.formatted}',
                                color: AppColors.textSecondary,
                              ),
                              _buildPayslipRow(
                                'EIS / SIP',
                                '-${net.eisEmployee.formatted}',
                                color: AppColors.textSecondary,
                              ),
                              if (net.pcbTax.sen > 0)
                                _buildPayslipRow(
                                  'PCB Tax (MTD)',
                                  '-${net.pcbTax.formatted}',
                                  color: AppColors.textSecondary,
                                ),
                            ],

                            Divider(color: AppColors.outline.withValues(alpha: 0.5), height: 18),
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

                  // 2. Budget Allocation Framework Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 6, 20, 10),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: AppColors.heroGradient,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Net Monthly Allocation',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.surface,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.35)),
                                        ),
                                        child: Text(
                                          '${pct(alloc.needs.percentage)} / ${pct(alloc.wants.percentage)} / ${pct(alloc.savings.percentage)} / ${pct(alloc.giving.percentage)} Split',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                TextButton.icon(
                                  onPressed: () => AdjustPlanSheet.show(
                                    context,
                                    profile: state.profile,
                                    netSalary: state.netSalary.netSalary,
                                    totalCommitments: state.allocation.totalCommitments,
                                  ),
                                  icon: Icon(Icons.tune_rounded, size: 14, color: AppColors.primary),
                                  label: Text(
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
                            Text(
                              net.netSalary.formatted,
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 14),
                            // Multi-segment progress bar
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: SizedBox(
                                height: 10,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: (alloc.needs.percentage * 100).round().clamp(1, 100),
                                      child: Container(color: AppColors.needs),
                                    ),
                                    const SizedBox(width: 2),
                                    Expanded(
                                      flex: (alloc.wants.percentage * 100).round().clamp(1, 100),
                                      child: Container(color: AppColors.wants),
                                    ),
                                    const SizedBox(width: 2),
                                    Expanded(
                                      flex: (alloc.savings.percentage * 100).round().clamp(1, 100),
                                      child: Container(color: AppColors.savings),
                                    ),
                                    const SizedBox(width: 2),
                                    Expanded(
                                      flex: (alloc.giving.percentage * 100).round().clamp(1, 100),
                                      child: Container(color: AppColors.giving),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 12,
                              runSpacing: 6,
                              children: [
                                _buildLegend('${pct(alloc.needs.percentage)}% Needs', AppColors.needs),
                                _buildLegend('${pct(alloc.wants.percentage)}% Wants', AppColors.wants),
                                _buildLegend('${pct(alloc.savings.percentage)}% Savings', AppColors.savings),
                                _buildLegend('${pct(alloc.giving.percentage)}% Giving', AppColors.giving),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 3. Detailed Buckets Breakdown
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      child: Column(
                        children: [
                          // Needs Card
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.needs.withValues(alpha: 0.4)),
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
                                              color: AppColors.needs.withValues(alpha: 0.15),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Icon(Icons.home_rounded, color: AppColors.needs, size: 20),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              '${pct(alloc.needs.percentage)}% Needs & Fixed Living',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.needs,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      alloc.needs.targetAmount.formatted,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Essential living expenses: groceries, utility bills, rent, fuel, and loan installments.',
                                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: AppColors.surfaceHigh,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Fixed Loans / SPayLater',
                                              style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              alloc.needs.fixedCommitmentPortion.formatted,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: AppColors.surfaceHigh,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Flexible Needs Buffer',
                                              style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              alloc.needs.flexibleAmount.formatted,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Wants & Savings Row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(color: AppColors.wants.withValues(alpha: 0.35)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: AppColors.wants.withValues(alpha: 0.15),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Icon(Icons.coffee_rounded, color: AppColors.wants, size: 16),
                                          ),
                                          const SizedBox(width: 4),
                                          Flexible(
                                            child: Text(
                                              alloc.wants.targetAmount.formatted,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        '${pct(alloc.wants.percentage)}% Wants',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.wants,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Dining out, hobbies, movies, coffee runs.',
                                        style: TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.3),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(color: AppColors.savings.withValues(alpha: 0.35)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: AppColors.savings.withValues(alpha: 0.15),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Icon(Icons.savings_rounded, color: AppColors.savings, size: 16),
                                          ),
                                          const SizedBox(width: 4),
                                          Flexible(
                                            child: Text(
                                              alloc.savings.targetAmount.formatted,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        '${pct(alloc.savings.percentage)}% Savings',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.savings,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Emergency runway, ASB, Versa & deposits.',
                                        style: TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.3),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Giving Strip
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.giving.withValues(alpha: 0.35)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppColors.giving.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(Icons.volunteer_activism_rounded, color: AppColors.giving, size: 16),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${pct(alloc.giving.percentage)}% Charity & Giving',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.giving,
                                        ),
                                      ),
                                      Text(
                                        'Sedekah jumaat, zakat pendapatan, and contributions.',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  alloc.giving.targetAmount.formatted,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 4. AI Coach Insights Card
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: AiCoachCard(state: state),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),

              // Sticky Lower-Zone Strategy Dock (Reachable within bottom 60%)
              Positioned(
                left: 20,
                right: 20,
                bottom: 16,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.outline.withValues(alpha: 0.8)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: AppColors.isDark ? 0.35 : 0.08),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => AdjustPlanSheet.show(
                            context,
                            profile: state.profile,
                            netSalary: state.netSalary.netSalary,
                            totalCommitments: state.allocation.totalCommitments,
                          ),
                          icon: const Icon(Icons.tune_rounded, size: 18),
                          label: const Text(
                            'Customize Ratios',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.onPrimary,
                            elevation: 0,
                            minimumSize: const Size(0, 48),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => SalaryEditSheet.show(context, state.profile),
                          icon: Icon(Icons.badge_outlined, size: 16, color: AppColors.textPrimary),
                          label: Text(
                            'Edit Salary',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.cardBorder),
                            minimumSize: const Size(0, 48),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: isHighlight ? 14 : 13,
                fontWeight: (isBold || isHighlight) ? FontWeight.bold : FontWeight.normal,
                color: isHighlight ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: isHighlight ? 18 : 13,
              fontWeight: (isBold || isHighlight) ? FontWeight.bold : FontWeight.w600,
              color: isHighlight ? AppColors.primary : (color ?? AppColors.textPrimary),
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
}
