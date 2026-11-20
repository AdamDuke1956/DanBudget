import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/animated_counter.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../data/providers/dashboard_provider.dart';

class ExpenseSummaryCard extends StatelessWidget {
  const ExpenseSummaryCard({
    super.key,
    required this.totalSen,
    required this.entryCount,
    required this.hasCategoryFilter,
    required this.dashboard,
  });

  final int totalSen;
  final int entryCount;
  final bool hasCategoryFilter;
  final DashboardState? dashboard;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return SurfaceCard(
      margin: const EdgeInsets.fromLTRB(20, 4, 20, 10),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  hasCategoryFilter ? 'Filtered Spend' : 'Total Spend',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$entryCount entries',
                style: TextStyle(
                  color: colors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AnimatedMoneyCounter(
            sen: totalSen,
            style: AppTypography.moneyAmount(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: colors.textPrimary,
            ),
          ),
          if (dashboard case final dash?) ...[
            const SizedBox(height: 12),
            _SpendingPace(dashboard: dash),
          ],
        ],
      ),
    );
  }
}

class _SpendingPace extends StatelessWidget {
  const _SpendingPace({required this.dashboard});

  final DashboardState dashboard;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final spent = dashboard.totalSpentThisCycle.sen;
    final totalBudget = spent + dashboard.remainingFlexibleBudget.sen;
    final velocity = totalBudget > 0 ? spent / totalBudget : 0.0;
    final isOnTrack = velocity <= 0.8;

    return Row(
      children: [
        Expanded(
          child: Text(
            'Safe pace: ${dashboard.safeToSpend.safeDailyAmount.formatted}/day',
            style: TextStyle(
              fontSize: 12,
              color: colors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isOnTrack ? colors.success : colors.warning,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            child: Text(
              isOnTrack ? 'On Track' : 'High Pace',
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
