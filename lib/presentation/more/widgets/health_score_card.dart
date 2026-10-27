import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/animated_counter.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../domain/engine/financial_health_score.dart';

class HealthScoreCard extends StatelessWidget {
  const HealthScoreCard({super.key, required this.health});

  final HealthScoreResult health;

  @override
  Widget build(BuildContext context) {
    Color gradeColor;
    switch (health.grade) {
      case 'A':
        gradeColor = AppColors.primary;
        break;
      case 'B':
        gradeColor = AppColors.accent;
        break;
      case 'C':
        gradeColor = AppColors.warning;
        break;
      default:
        gradeColor = AppColors.danger;
    }

    return SurfaceCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.shield_rounded, color: AppColors.primary, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Health Score',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: gradeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Grade ${health.grade}',
                  style: TextStyle(
                    color: gradeColor,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              TweenAnimationBuilder<int>(
                tween: IntTween(begin: 0, end: health.totalScore),
                duration: const Duration(milliseconds: 650),
                curve: Curves.easeOutCubic,
                builder: (context, val, child) {
                  return Text(
                    '$val',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      color: gradeColor,
                      letterSpacing: -1,
                    ),
                  );
                },
              ),
              const SizedBox(width: 6),
              Text(
                '/ 100',
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            health.summary,
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),

          _buildScoreBar('Debt Service Ratio (DSR)', health.dsrScore, 35, AppColors.needs),
          const SizedBox(height: 8),
          _buildScoreBar('Savings rate', health.savingsScore, 25, AppColors.savings),
          const SizedBox(height: 8),
          _buildScoreBar('Emergency fund', health.emergencyFundScore, 25, AppColors.accent),
          const SizedBox(height: 8),
          _buildScoreBar('Loan & BNPL safety', health.bnplSafetyScore, 15, AppColors.giving),
          const SizedBox(height: 14),

          if (health.recommendations.isNotEmpty) ...[
            Divider(color: AppColors.outline, height: 20),
            Text(
              'Tips',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            ...health.recommendations.take(3).map(
              (rec) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2, right: 6),
                      child: Icon(
                        Icons.check_circle_outline_rounded,
                        size: 14,
                        color: AppColors.primary,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        rec,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textPrimary,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildScoreBar(String label, int current, int max, Color color) {
    final ratio = (current / max).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            Text('$current / $max',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 4),
        AnimatedProgressBar(
          value: ratio,
          color: color,
          backgroundColor: AppColors.surfaceHigh,
          height: 6,
          borderRadius: 4,
        ),
      ],
    );
  }
}
