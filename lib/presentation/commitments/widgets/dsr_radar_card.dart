import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/dsr_gauge.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../data/local/app_database.dart';
import 'affordability_simulator_sheet.dart';
import 'debt_payoff_sheet.dart';

class DsrRadarCard extends StatelessWidget {
  const DsrRadarCard({
    super.key,
    required this.dsrRatio,
    required this.totalMonthlyCommitment,
    required this.totalDebtOutstandingSen,
  });

  final double dsrRatio;
  final Money totalMonthlyCommitment;
  final int totalDebtOutstandingSen;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final dsr = dsrRatio * 100;

    final Color dsrColor;
    final String dsrLabel;
    if (dsr <= 35) {
      dsrColor = colors.success;
      dsrLabel = 'Healthy';
    } else if (dsr <= 50) {
      dsrColor = colors.warning;
      dsrLabel = 'Moderate';
    } else {
      dsrColor = colors.danger;
      dsrLabel = 'Critical';
    }

    return SurfaceCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Debt Service Ratio (DSR)',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: dsrColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: dsrColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  dsrLabel,
                  style: TextStyle(
                    color: dsrColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Semantics(
                label: 'Debt service ratio ${dsr.toStringAsFixed(1)} percent, $dsrLabel',
                child: ExcludeSemantics(
                  child: DsrGauge(
                    dsrRatio: dsrRatio,
                    size: 126,
                    strokeWidth: 10,
                    showStatusLabel: false,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monthly commitments',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        totalMonthlyCommitment.formatted,
                        style: AppTypography.moneyAmount(
                          fontSize: 22,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: colors.outline.withValues(alpha: 0.5), height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Total Outstanding Debt',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: colors.textSecondary),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                Money(totalDebtOutstandingSen).formatted,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CommitmentsActionHubRibbon extends StatelessWidget {
  const CommitmentsActionHubRibbon({super.key, required this.commitments});

  final List<CommitmentsTableData> commitments;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Row(
      children: [
        _ActionTile(
          icon: Icons.calculate_outlined,
          label: 'Simulator',
          color: colors.accent,
          onTap: () => AffordabilitySimulatorSheet.show(context),
        ),
        const SizedBox(width: 10),
        _ActionTile(
          icon: Icons.trending_down_rounded,
          label: 'Strategy',
          color: colors.primary,
          onTap: () => DebtPayoffSheet.show(context, commitments),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
