import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/surface_card.dart';
import '../../data/providers/dashboard_provider.dart';
import '../../domain/engine/allocation_engine.dart';
import 'widgets/adjust_plan_sheet.dart';
import 'widgets/allocation_buckets_section.dart';
import 'widgets/allocation_overview_card.dart';
import 'widgets/cashflow_advisor_card.dart';
import 'widgets/lhdn_tax_summary_card.dart';
import 'widgets/payslip_breakdown_card.dart';
import 'widgets/salary_edit_sheet.dart';

class PlanScreen extends ConsumerWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final stateAsync = ref.watch(dashboardStateProvider);

    return Scaffold(
      backgroundColor: colors.background,
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
        backgroundColor: colors.background,
        elevation: 0,
        actions: [
          stateAsync.when(
            data: (state) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.tune_rounded, color: colors.primary),
                  tooltip: 'Adjust Budget Plan',
                  onPressed: () => AdjustPlanSheet.show(
                    context,
                    profile: state.profile,
                    netSalary: state.netSalary.netSalary,
                    totalCommitments: state.allocation.totalCommitments,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.badge_outlined, color: colors.accent),
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
          child: CircularProgressIndicator(color: colors.primary),
        ),
        error: (err, _) => Center(
          child: Text('Error: $err', style: TextStyle(color: colors.danger)),
        ),
        data: (state) {
          final isIntern = state.employmentType.isIntern;

          return Stack(
            children: [
              CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 6, 20, 10),
                      child: PayslipBreakdownCard(state: state),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 6, 20, 10),
                      child: AllocationOverviewCard(state: state),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      child: AllocationBucketsSection(allocation: state.allocation),
                    ),
                  ),
                  if (state.profile.aiAdviceEnabled)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: CashflowAdvisorCard(state: state),
                      ),
                    ),
                  if (!isIntern)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 4, 20, 10),
                        child: LhdnTaxSummaryCard(),
                      ),
                    ),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 16,
                child: SurfaceCard(
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
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.primary,
                            foregroundColor: colors.onPrimary,
                            elevation: 0,
                            minimumSize: const Size(0, 48),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => SalaryEditSheet.show(context, state.profile),
                          icon: Icon(Icons.badge_outlined, size: 16, color: colors.textPrimary),
                          label: Text(
                            'Edit Salary',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: colors.textPrimary,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: colors.cardBorder),
                            minimumSize: const Size(0, 48),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
}
