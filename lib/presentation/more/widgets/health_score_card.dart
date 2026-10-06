import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';
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

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.shield_rounded, color: AppColors.primary, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Financial Health Score',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: gradeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: gradeColor.withValues(alpha: 0.4)),
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

          // Big Score Display
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${health.totalScore}',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  color: gradeColor,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                '/ 100',
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            health.summary,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),

          // 4 Sub-score bars
          _buildScoreBar('Debt Service Ratio (DSR)', health.dsrScore, 35, AppColors.needs),
          const SizedBox(height: 8),
          _buildScoreBar('Savings Rate (20% Target)', health.savingsScore, 25, AppColors.savings),
          const SizedBox(height: 8),
          _buildScoreBar('Emergency Fund Buffer', health.emergencyFundScore, 25, AppColors.accent),
          const SizedBox(height: 8),
          _buildScoreBar('BNPL & Loan Safety', health.bnplSafetyScore, 15, AppColors.giving),
          const SizedBox(height: 14),

          // Recommendations
          if (health.recommendations.isNotEmpty) ...[
            const Divider(color: AppColors.outline, height: 20),
            const Text(
              'Actionable Tips for Your Score:',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            ...health.recommendations.map(
              (rec) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('👉 ', style: TextStyle(fontSize: 12)),
                    Expanded(
                      child: Text(
                        rec,
                        style: const TextStyle(
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
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            Text('$current / $max',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ratio,
            backgroundColor: AppColors.surfaceHigh,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
