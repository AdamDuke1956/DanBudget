import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../data/providers/dashboard_provider.dart';
import 'adjust_plan_sheet.dart';

class AllocationOverviewCard extends StatelessWidget {
  const AllocationOverviewCard({super.key, required this.state});

  final DashboardState state;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final net = state.netSalary;
    final alloc = state.allocation;
    String pct(double v) => (v * 100).toStringAsFixed(0);

    return SurfaceCard(
      raised: true,
      padding: const EdgeInsets.all(20),
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
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: colors.primary.withValues(alpha: 0.35)),
                      ),
                      child: Text(
                        '${pct(alloc.needs.percentage)} / ${pct(alloc.wants.percentage)} / ${pct(alloc.savings.percentage)} / ${pct(alloc.giving.percentage)} Split',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: colors.primary,
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
                icon: Icon(Icons.tune_rounded, size: 14, color: colors.primary),
                label: Text(
                  'Adjust Plan',
                  style: TextStyle(
                    color: colors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  backgroundColor: colors.primary.withValues(alpha: 0.12),
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
              color: colors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 10,
              child: Row(
                children: [
                  Expanded(
                    flex: (alloc.needs.percentage * 100).round().clamp(1, 100),
                    child: Container(color: colors.needs),
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    flex: (alloc.wants.percentage * 100).round().clamp(1, 100),
                    child: Container(color: colors.wants),
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    flex: (alloc.savings.percentage * 100).round().clamp(1, 100),
                    child: Container(color: colors.savings),
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    flex: (alloc.giving.percentage * 100).round().clamp(1, 100),
                    child: Container(color: colors.giving),
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
              _LegendDot(label: '${pct(alloc.needs.percentage)}% Needs', color: colors.needs),
              _LegendDot(label: '${pct(alloc.wants.percentage)}% Wants', color: colors.wants),
              _LegendDot(label: '${pct(alloc.savings.percentage)}% Savings', color: colors.savings),
              _LegendDot(label: '${pct(alloc.giving.percentage)}% Giving', color: colors.giving),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
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
