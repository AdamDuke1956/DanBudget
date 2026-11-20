import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../data/providers/tax_provider.dart';
import '../../../domain/engine/lhdn_tax_engine.dart';

class TaxAdvisorTab extends StatelessWidget {
  const TaxAdvisorTab({super.key, required this.data});

  final TaxDashboardData data;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final r = data.taxResult;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
      children: [
        // 7-Year Receipt Rule Compliance Banner
        SurfaceCard(
          padding: const EdgeInsets.all(16),
          color: colors.accentWarning.withValues(alpha: 0.12),
          borderColor: colors.accentWarning.withValues(alpha: 0.4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.verified_user_outlined,
                color: colors.accentWarning,
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '7-year receipt rule',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      r.complianceReminder,
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        Text(
          'Tax Advisories',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        ...r.advisories.map(
          (adv) => SurfaceCard(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            borderColor: adv.isWarning
                ? colors.accentWarning.withValues(alpha: 0.45)
                : colors.cardBorder,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      adv.isWarning
                          ? Icons.warning_amber_rounded
                          : Icons.lightbulb_outline_rounded,
                      size: 18,
                      color: adv.isWarning ? colors.accentWarning : colors.accentPrimary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          Text(
                            adv.title,
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: colors.textPrimary,
                            ),
                          ),
                          if (adv.estimatedMaxTaxSaved.sen > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: colors.accentSecondary.withValues(
                                  alpha: 0.16,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Save up to ${adv.estimatedMaxTaxSaved.formattedCompact}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: colors.accentSecondary,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  adv.message,
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),

        Text(
          'Resident Tax Brackets (0% – 30%)',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Your chargeable income (${r.chargeableIncome.formatted}) is taxed in bands:',
          style: TextStyle(fontSize: 12, color: colors.textMuted),
        ),
        const SizedBox(height: 10),
        SurfaceCard(
          padding: EdgeInsets.zero,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Column(
              children: LhdnTaxEngine.residentBrackets.map((band) {
                final activeSlice = r.bracketSlices
                    .where((s) => s.bracket.label == band.label)
                    .firstOrNull;
                final isMarginalBand = (band.rate - r.marginalTaxRate).abs() < 0.0001 &&
                    r.chargeableIncome.sen > band.lowerSen;
                final ratePct = (band.rate * 100).toStringAsFixed(
                  band.rate * 100 == (band.rate * 100).roundToDouble() ? 0 : 1,
                );

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isMarginalBand
                        ? colors.accentPrimary.withValues(alpha: 0.14)
                        : Colors.transparent,
                    border: Border(
                      bottom: BorderSide(
                        color: colors.borderSubtle.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              band.label,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isMarginalBand ? FontWeight.w700 : FontWeight.w500,
                                color: isMarginalBand ? colors.accentPrimary : colors.textPrimary,
                              ),
                            ),
                            if (activeSlice != null)
                              Text(
                                'Taxed: ${activeSlice.taxableAmount.formattedCompact}',
                                style: TextStyle(fontSize: 11, color: colors.textMuted),
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          '$ratePct%',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isMarginalBand ? colors.accentPrimary : colors.textSecondary,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          activeSlice != null ? activeSlice.taxAmount.formatted : 'RM 0.00',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: activeSlice != null ? FontWeight.w700 : FontWeight.w400,
                            color: activeSlice != null ? colors.textPrimary : colors.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
