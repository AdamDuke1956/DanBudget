import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../data/providers/tax_provider.dart';
import '../../../domain/engine/lhdn_tax_engine.dart';

class TaxOverviewTab extends StatelessWidget {
  const TaxOverviewTab({
    super.key,
    required this.data,
    required this.onEditProfile,
    required this.onLogReceipt,
    required this.onCopySummary,
  });

  final TaxDashboardData data;
  final VoidCallback onEditProfile;
  final void Function({LhdnReliefBucket? initialBucket}) onLogReceipt;
  final VoidCallback onCopySummary;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final r = data.taxResult;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
      children: [
        // Hero Refund / Tax Payable Card
        SurfaceCard(
          raised: true,
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: (r.isRefund ? colors.accentSecondary : colors.accentWarning)
                          .withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      r.isRefund ? 'Estimated refund' : 'Estimated tax owed',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: r.isRefund ? colors.accentSecondary : colors.accentWarning,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: colors.bgSecondary,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: colors.borderSubtle),
                    ),
                    child: Text(
                      'Bracket ${r.marginalRatePercentLabel}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: colors.accentPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                r.isRefund
                    ? '+${r.estimatedRefund.formatted}'
                    : '-${r.additionalTaxPayable.formatted}',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: r.isRefund ? colors.accentSecondary : colors.accentWarning,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                r.isRefund
                    ? 'Refund expected around March or April.'
                    : 'PCB paid is short of final tax. Claim more reliefs to reduce it.',
                style: TextStyle(
                  fontSize: 12,
                  color: colors.textSecondary,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton.icon(
                    onPressed: onEditProfile,
                    icon: const Icon(Icons.tune_rounded, size: 16),
                    label: const Text('Configure Income & Reliefs'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.accentPrimary,
                      foregroundColor: colors.onPrimary,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => onLogReceipt(),
                    icon: const Icon(Icons.receipt_long_rounded, size: 16),
                    label: const Text('Log Tax Receipt'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.textPrimary,
                      side: BorderSide(color: colors.borderSubtle),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Copy Form BE Summary',
                    onPressed: onCopySummary,
                    icon: Icon(
                      Icons.copy_all_rounded,
                      size: 20,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 6-Step Calculation Methodology Card
        SurfaceCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calculate_outlined,
                    size: 18,
                    color: colors.accentPrimary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'LHDN Form BE Calculation Methodology',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  Text(
                    'Eff. ${(r.effectiveTaxRate * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: colors.textMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _StepRow(
                step: '1',
                label: 'Total Annual Gross Income',
                sublabel:
                    'Base (${data.taxInput.annualBaseSalary.formattedCompact}) + Bonus (${data.taxInput.annualBonuses.formattedCompact}) + Allowances (${data.taxInput.annualTaxableAllowances.formattedCompact}) + Other (${data.taxInput.annualOtherIncome.formattedCompact})',
                value: r.totalGrossIncome.formatted,
                colors: colors,
              ),
              _StepRow(
                step: '2',
                label: 'Total Statutory Reliefs (Pelepasan Cukai)',
                sublabel: 'Sum of all valid claimable categories (strictly capped)',
                value: '-${r.totalStatutoryReliefs.formatted}',
                valueColor: colors.accentSecondary,
                colors: colors,
              ),
              const Divider(height: 16),
              _StepRow(
                step: '3',
                label: 'Chargeable Income (Pendapatan Bercukai)',
                sublabel: 'Total Gross Income minus Total Statutory Reliefs',
                value: r.chargeableIncome.formatted,
                isBold: true,
                colors: colors,
              ),
              _StepRow(
                step: '4',
                label: 'Calculated Tax (Progressive 0% – 30%)',
                sublabel: 'Marginal Tax Rate: ${r.marginalRatePercentLabel}',
                value: r.calculatedTaxBeforeRebates.formatted,
                colors: colors,
              ),
              _StepRow(
                step: '5',
                label: 'Tax Rebates (Individual RM400 + Zakat 1:1)',
                sublabel:
                    'Ind. Rebate: ${r.individualRebate.formattedCompact} ${r.qualifiesForIndividualRebate ? "(<= RM35k)" : "(> RM35k)"} • Zakat: ${r.zakatRebateApplied.formattedCompact}',
                value: '-${r.totalTaxRebates.formatted}',
                valueColor: colors.accentSecondary,
                colors: colors,
              ),
              const Divider(height: 16),
              _StepRow(
                step: '6',
                label: r.isRefund
                    ? 'Final Tax Refund (PCB Paid - Final Tax)'
                    : 'Final Tax Payable (PCB Paid - Final Tax)',
                sublabel:
                    'PCB Paid (${r.annualPcbPaid.formatted}) - Final Tax (${r.finalCalculatedTax.formatted})',
                value: r.isRefund
                    ? '+${r.estimatedRefund.formatted}'
                    : '-${r.additionalTaxPayable.formatted}',
                valueColor: r.isRefund ? colors.accentSecondary : colors.accentWarning,
                isBold: true,
                colors: colors,
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Core Tax Relief Categories & Strict Caps
        Row(
          children: [
            Expanded(
              child: Text(
                'Core Tax Relief Categories & Strict Caps',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: onEditProfile,
              icon: const Icon(Icons.edit_outlined, size: 15),
              label: const Text('Edit Caps'),
              style: TextButton.styleFrom(
                foregroundColor: colors.accentPrimary,
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        ...r.buckets.map(
          (b) => _ReliefBucketCard(
            utilization: b,
            colors: colors,
            onTapAddReceipt: b.bucket == LhdnReliefBucket.individualAndDependent
                ? null
                : () => onLogReceipt(initialBucket: b.bucket),
          ),
        ),
      ],
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.step,
    required this.label,
    required this.sublabel,
    required this.value,
    this.valueColor,
    this.isBold = false,
    required this.colors,
  });

  final String step;
  final String label;
  final String sublabel;
  final String value;
  final Color? valueColor;
  final bool isBold;
  final AppPalette colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 1, right: 8),
            decoration: BoxDecoration(
              color: colors.accentPrimary.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Text(
              step,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: colors.accentPrimary,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
                Text(
                  sublabel,
                  style: TextStyle(fontSize: 11, color: colors.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w700,
              color: valueColor ?? colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReliefBucketCard extends StatelessWidget {
  const _ReliefBucketCard({
    required this.utilization,
    required this.colors,
    this.onTapAddReceipt,
  });

  final BucketUtilization utilization;
  final AppPalette colors;
  final VoidCallback? onTapAddReceipt;

  @override
  Widget build(BuildContext context) {
    final u = utilization;
    final barColor = u.isSaturated
        ? colors.accentWarning
        : u.progress >= 0.75
            ? colors.accentPrimary
            : colors.accentSecondary;

    return SurfaceCard(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      borderColor: u.isSaturated
          ? colors.accentWarning.withValues(alpha: 0.45)
          : colors.cardBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  u.bucket.title,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              if (onTapAddReceipt != null)
                InkWell(
                  onTap: onTapAddReceipt,
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add_circle_outline,
                          size: 14,
                          color: colors.accentPrimary,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          'Receipt',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: colors.accentPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            u.formatCapStatus(short: true),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: barColor,
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: u.progress,
              minHeight: 7,
              backgroundColor: colors.bgPrimary,
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
            ),
          ),
          if (u.excessUnclaimable.sen > 0) ...[
            const SizedBox(height: 6),
            Text(
              'Cap reached: ${u.excessUnclaimable.formatted} over ${u.annualCap.formattedCompact} earns no extra relief.',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: colors.accentWarning,
              ),
            ),
          ],
          if (u.subBuckets.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: u.subBuckets.map((sub) {
                final hasCap = sub.subCap != null;
                final label = hasCap
                    ? '${sub.title}: ${sub.claimedAmount.formattedCompact}/${sub.subCap!.formattedCompact}'
                    : '${sub.title}: ${sub.rawSpent.formattedCompact}';
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: colors.bgPrimary,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: colors.borderSubtle),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 10.5,
                      color: colors.textSecondary,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 6),
          Text(
            u.bucket.ruleSummary,
            style: TextStyle(
              fontSize: 11,
              color: colors.textMuted,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
