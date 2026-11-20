import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../data/local/app_database.dart';

class SpayLaterImpactBanner extends StatelessWidget {
  const SpayLaterImpactBanner({
    super.key,
    required this.spayLaterItems,
    required this.netSalary,
    required this.isIntern,
  });

  final List<CommitmentsTableData> spayLaterItems;
  final Money netSalary;
  final bool isIntern;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final totalMonthlySen = spayLaterItems.fold<int>(0, (sum, c) => sum + c.monthlyPaymentSen);
    final totalRemainingSen = spayLaterItems.fold<int>(0, (sum, c) => sum + c.remainingAmountSen);
    final ratio = netSalary.sen > 0 ? (totalMonthlySen / netSalary.sen) * 100 : 0.0;

    final Color impactColor;
    final String impactBadge;
    if (ratio <= 10) {
      impactColor = colors.success;
      impactBadge = 'Manageable';
    } else if (ratio <= 20) {
      impactColor = colors.warning;
      impactBadge = 'Moderate';
    } else {
      impactColor = colors.danger;
      impactBadge = 'High burden';
    }

    return SurfaceCard(
      padding: const EdgeInsets.all(16),
      borderColor: impactColor.withValues(alpha: 0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.pie_chart_outline_rounded, size: 16, color: colors.accent),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'SPayLater Financial Impact',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: impactColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: impactColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  impactBadge,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: impactColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${Money(totalMonthlySen).formatted} / mo',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: impactColor),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${ratio.toStringAsFixed(1)}% of your ${netSalary.formatted} ${isIntern ? 'allowance' : 'salary'}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 11, color: colors.textSecondary, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Total Outstanding', style: TextStyle(fontSize: 10, color: colors.textSecondary)),
                  Text(
                    Money(totalRemainingSen).formatted,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: colors.textPrimary),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (ratio / 100).clamp(0.0, 1.0),
              backgroundColor: colors.surfaceHigh,
              valueColor: AlwaysStoppedAnimation<Color>(impactColor),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
