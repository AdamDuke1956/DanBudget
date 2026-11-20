import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/animated_counter.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../data/providers/dashboard_provider.dart';
import 'daily_spending_calendar_sheet.dart';

class SafeToSpendCard extends StatelessWidget {
  const SafeToSpendCard({super.key, required this.state});

  final DashboardState state;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final safe = state.safeToSpend;
    final totalPoolSen = state.totalSpentThisCycle.sen + state.remainingFlexibleBudget.sen;
    final progress = totalPoolSen > 0
        ? (state.remainingFlexibleBudget.sen / totalPoolSen).clamp(0.0, 1.0)
        : 1.0;

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
                child: Text(
                  'Safe-to-Spend Today',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => DailySpendingCalendarSheet.show(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: colors.surface.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: colors.subtleBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.hourglass_bottom_rounded, size: 12, color: colors.accent),
                      const SizedBox(width: 4),
                      Text(
                        '${safe.daysUntilPayday}d to payday',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              AnimatedMoneyCounter(
                sen: (safe.todayCustomTarget ?? safe.safeDailyAmount).sen,
                style: AppTypography.moneyAmount(
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  color: colors.textPrimary,
                ),
              ),
              Text(
                safe.todayCustomTarget != null ? '/ today' : '/ day',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: safe.todayCustomTarget != null ? colors.primary : colors.textSecondary,
                ),
              ),
            ],
          ),
          if (safe.todayCustomTarget != null) ...[
            const SizedBox(height: 4),
            Text(
              'Usual pace: ${safe.safeDailyAmount.formatted}/day',
              style: TextStyle(fontSize: 11, color: colors.textSecondary),
            ),
          ],
          const SizedBox(height: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Spent: ${state.totalSpentThisCycle.formatted}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: colors.textSecondary),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Left: ${state.remainingFlexibleBudget.formatted}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              AnimatedProgressBar(
                value: progress,
                color: colors.primary,
                backgroundColor: colors.isDark
                    ? colors.surface.withValues(alpha: 0.7)
                    : colors.outline.withValues(alpha: 0.6),
                height: 7,
                borderRadius: 6,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
