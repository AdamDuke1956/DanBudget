import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../domain/engine/allocation_engine.dart';

class BudgetSplitStripCard extends StatelessWidget {
  const BudgetSplitStripCard({
    super.key,
    required this.allocation,
    this.onViewPlan,
  });

  final AllocationResult allocation;
  final VoidCallback? onViewPlan;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final alloc = allocation;

    return SurfaceCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${(alloc.needs.percentage * 100).round()}/${(alloc.wants.percentage * 100).round()}/${(alloc.savings.percentage * 100).round()}/${(alloc.giving.percentage * 100).round()} Budget Split',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onViewPlan,
                child: Text(
                  'View plan',
                  style: TextStyle(
                    color: colors.accent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 8,
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
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _BucketTile(
                  title: 'Needs',
                  pct: (alloc.needs.percentage * 100).round(),
                  amount: alloc.needs.targetAmount.formatted,
                  color: colors.needs,
                  icon: Icons.home_rounded,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _BucketTile(
                  title: 'Wants',
                  pct: (alloc.wants.percentage * 100).round(),
                  amount: alloc.wants.targetAmount.formatted,
                  color: colors.wants,
                  icon: Icons.coffee_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _BucketTile(
                  title: 'Savings',
                  pct: (alloc.savings.percentage * 100).round(),
                  amount: alloc.savings.targetAmount.formatted,
                  color: colors.savings,
                  icon: Icons.savings_rounded,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _BucketTile(
                  title: 'Giving',
                  pct: (alloc.giving.percentage * 100).round(),
                  amount: alloc.giving.targetAmount.formatted,
                  color: colors.giving,
                  icon: Icons.volunteer_activism_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BucketTile extends StatelessWidget {
  const _BucketTile({
    required this.title,
    required this.pct,
    required this.amount,
    required this.color,
    required this.icon,
  });

  final String title;
  final int pct;
  final String amount;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$pct% $title',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  amount,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
