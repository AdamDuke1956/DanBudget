import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../data/providers/database_providers.dart';
import '../../../data/providers/tax_provider.dart';
import '../../../domain/engine/lhdn_tax_engine.dart';

class TaxClassifierTab extends ConsumerStatefulWidget {
  const TaxClassifierTab({
    super.key,
    required this.data,
    required this.onOpenLogReceipt,
  });

  final TaxDashboardData data;
  final VoidCallback onOpenLogReceipt;

  @override
  ConsumerState<TaxClassifierTab> createState() => _TaxClassifierTabState();
}

class _TaxClassifierTabState extends ConsumerState<TaxClassifierTab> {
  final TextEditingController _simDescCtrl = TextEditingController(
    text: 'ChatGPT Plus AI Subscription',
  );
  final TextEditingController _simAmountCtrl = TextEditingController(text: '100');

  static const _presets = <(String, String)>[
    ('ChatGPT Plus AI Subscription', '95'),
    ('Claude Pro AI Subscription', '95'),
    ('GitHub Copilot Personal', '45'),
    ('Unifi Home Broadband Bill', '139'),
    ('Yonex Badminton Racket', '220'),
    ('Nike Running Shoes', '350'),
    ('Full Health Screening Checkup', '300'),
    ('Dental Scaling & Treatment', '180'),
    ('PRS Voluntary Contribution', '500'),
    ('Simpan SSPN Prime Deposit', '1000'),
    ('Zakat Pendapatan Fitrah', '250'),
  ];

  @override
  void dispose() {
    _simDescCtrl.dispose();
    _simAmountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final data = widget.data;
    final simAmount = Money.tryParse(_simAmountCtrl.text) ?? Money.fromRinggit(100);
    final simDesc = _simDescCtrl.text.trim().isEmpty
        ? 'ChatGPT Plus AI Subscription'
        : _simDescCtrl.text.trim();

    final impact = LhdnTaxEngine.simulateExpenseImpact(
      currentInput: data.taxInput,
      description: simDesc,
      amount: simAmount,
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
      children: [
        // Simulator Card
        SurfaceCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.calculate_outlined, size: 18, color: colors.accentPrimary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Receipt Tax Simulator',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Type an expense or tap a preset to see its relief bucket and tax saved.',
                style: TextStyle(fontSize: 12, color: colors.textMuted),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _presets.map((preset) {
                    final isSelected = _simDescCtrl.text == preset.$1;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        backgroundColor: isSelected
                            ? colors.accentPrimary.withValues(alpha: 0.2)
                            : colors.bgPrimary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        side: BorderSide(
                          color: isSelected ? colors.accentPrimary : colors.borderSubtle,
                        ),
                        label: Text(
                          '${preset.$1} (RM${preset.$2})',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? colors.accentPrimary : colors.textSecondary,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _simDescCtrl.text = preset.$1;
                            _simAmountCtrl.text = preset.$2;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      key: const Key('tax_sim_desc_field'),
                      controller: _simDescCtrl,
                      onChanged: (_) => setState(() {}),
                      style: TextStyle(color: colors.textPrimary, fontSize: 13),
                      decoration: InputDecoration(
                        labelText: 'Receipt / Transaction Item',
                        labelStyle: TextStyle(color: colors.textSecondary, fontSize: 12),
                        filled: true,
                        fillColor: colors.bgPrimary,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: colors.borderSubtle),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      key: const Key('tax_sim_amount_field'),
                      controller: _simAmountCtrl,
                      onChanged: (_) => setState(() {}),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: TextStyle(color: colors.textPrimary, fontSize: 13),
                      decoration: InputDecoration(
                        labelText: 'Amount (RM)',
                        prefixText: 'RM ',
                        labelStyle: TextStyle(color: colors.textSecondary, fontSize: 12),
                        filled: true,
                        fillColor: colors.bgPrimary,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: colors.borderSubtle),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colors.bgPrimary,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: impact.classification.isExcludedWarn
                        ? colors.accentDanger.withValues(alpha: 0.5)
                        : colors.accentPrimary.withValues(alpha: 0.4),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ProtocolItem(
                      badge: '1. CATEGORY',
                      content: impact.classification.isExcludedWarn
                          ? 'NOT ELIGIBLE: Excluded under LHDN Sports & Fitness rules (sports shoes/apparel).'
                          : impact.classification.isZakatRebate
                              ? 'Zakat / Fitrah (Section 6A(3) 1:1 Direct Tax Rebate)'
                              : impact.classification.bucket != null
                                  ? '${impact.classification.bucket!.title} • ${impact.classification.subBucketTitle ?? ""}'
                                  : 'Not a statutory LHDN relief category',
                      color: impact.classification.isExcludedWarn
                          ? colors.accentDanger
                          : colors.accentPrimary,
                      colors: colors,
                    ),
                    const SizedBox(height: 8),
                    _ProtocolItem(
                      badge: '2. CAP',
                      content: impact.capStatusSummary,
                      color: colors.accentSecondary,
                      colors: colors,
                    ),
                    const SizedBox(height: 8),
                    _ProtocolItem(
                      badge: '3. TAX SAVED',
                      content: impact.marginalImpactStatement,
                      color: colors.textPrimary,
                      colors: colors,
                    ),
                    if (impact.actionableSuggestion != null) ...[
                      const SizedBox(height: 8),
                      _ProtocolItem(
                        badge: '4. TIP',
                        content: impact.actionableSuggestion!,
                        color: colors.accentWarning,
                        colors: colors,
                      ),
                    ],
                    const SizedBox(height: 12),
                    if (impact.classification.bucket != null &&
                        !impact.classification.isExcludedWarn)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await ref.read(taxRepositoryProvider).addReceiptClaim(
                                  assessmentYear: data.assessmentYear,
                                  title: simDesc,
                                  amountSen: simAmount.sen,
                                  bucket: impact.classification.bucket!,
                                  subBucketId: impact.classification.subBucketId,
                                  isAutoClassified: true,
                                );
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Logged "$simDesc" (${simAmount.formatted}) to ${impact.classification.bucket!.shortTitle}!',
                                  ),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.add_task_rounded, size: 16),
                          label: Text(
                            'Log "$simDesc" (${simAmount.formatted}) to ${impact.classification.bucket!.shortTitle}',
                            overflow: TextOverflow.ellipsis,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.accentPrimary,
                            foregroundColor: colors.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 11),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        if (data.unloggedCandidates.isNotEmpty) ...[
          Text(
            'Auto-Detected from Your Expense Log (${data.unloggedCandidates.length})',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          ...data.unloggedCandidates.map((cand) {
            final exp = cand.expenseWithCategory.expense;
            final cls = cand.classification;
            final expMoney = Money(exp.amountSen);
            return SurfaceCard(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exp.note ?? 'Expense',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${expMoney.formatted} • ${cls.subBucketTitle ?? cls.bucket?.shortTitle ?? "Tax Warning"}',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: cls.isExcludedWarn
                                ? colors.accentDanger
                                : colors.accentSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (cls.bucket != null && !cls.isExcludedWarn)
                    TextButton.icon(
                      onPressed: () async {
                        await ref.read(taxRepositoryProvider).addReceiptClaim(
                              assessmentYear: data.assessmentYear,
                              expenseId: exp.id,
                              title: exp.note ?? 'Expense',
                              amountSen: exp.amountSen,
                              bucket: cls.bucket!,
                              subBucketId: cls.subBucketId,
                              claimedDate: exp.date,
                              isAutoClassified: true,
                            );
                      },
                      icon: const Icon(Icons.download_done_rounded, size: 16),
                      label: const Text('Claim'),
                    ),
                ],
              ),
            );
          }),
          const SizedBox(height: 12),
        ],

        Row(
          children: [
            Expanded(
              child: Text(
                'Logged Tax Receipts (${data.receiptClaims.length})',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: widget.onOpenLogReceipt,
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add Receipt'),
            ),
          ],
        ),
        if (data.receiptClaims.isEmpty)
          SurfaceCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Icon(Icons.receipt_long_outlined, size: 32, color: colors.textMuted),
                const SizedBox(height: 8),
                Text(
                  'No receipts logged for YA ${data.assessmentYear} yet.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tap "Add Receipt" or use the simulator to log one.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: colors.textMuted),
                ),
              ],
            ),
          )
        else
          ...data.receiptClaims.map((claim) {
            final money = Money(claim.amountSen);
            final dateStr = DateFormat('d MMM y').format(claim.claimedDate);
            return SurfaceCard(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          claim.title,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${claim.bucket.shortTitle} • $dateStr${claim.receiptRef.isNotEmpty ? " • Ref: ${claim.receiptRef}" : ""}',
                          style: TextStyle(fontSize: 11.5, color: colors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    money.formatted,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: colors.accentSecondary,
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: 'Remove receipt',
                    onPressed: () {
                      ref.read(taxRepositoryProvider).deleteReceiptClaim(claim.id);
                    },
                    icon: Icon(Icons.delete_outline, size: 18, color: colors.textMuted),
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }
}

class _ProtocolItem extends StatelessWidget {
  const _ProtocolItem({
    required this.badge,
    required this.content,
    required this.color,
    required this.colors,
  });

  final String badge;
  final String content;
  final Color color;
  final AppPalette colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          badge,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
            color: colors.textMuted,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          content,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}
