import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/money.dart';
import '../../data/providers/database_providers.dart';
import '../../data/providers/tax_provider.dart';
import '../../domain/engine/lhdn_tax_engine.dart';
import 'widgets/log_tax_receipt_sheet.dart';
import 'widgets/tax_profile_edit_sheet.dart';

class TaxOptimizerScreen extends ConsumerStatefulWidget {
  const TaxOptimizerScreen({super.key});

  @override
  ConsumerState<TaxOptimizerScreen> createState() => _TaxOptimizerScreenState();
}

class _TaxOptimizerScreenState extends ConsumerState<TaxOptimizerScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _simDescCtrl = TextEditingController(
    text: 'ChatGPT Plus AI Subscription',
  );
  final TextEditingController _simAmountCtrl = TextEditingController(
    text: '100',
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _simDescCtrl.dispose();
    _simAmountCtrl.dispose();
    super.dispose();
  }

  void _openEditProfileSheet(TaxDashboardData data) {
    final defaultAnnualPcb = Money(data.monthlyPayslip.pcbTax.sen * 12);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TaxProfileEditSheet(
        initialProfile: data.taxProfile,
        defaultAnnualPcb: defaultAnnualPcb,
      ),
    );
  }

  void _openLogReceiptSheet(
    TaxDashboardData data, {
    LhdnReliefBucket? initialBucket,
    String? initialTitle,
    Money? initialAmount,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LogTaxReceiptSheet(
        assessmentYear: data.assessmentYear,
        currentInput: data.taxInput,
        initialBucket: initialBucket,
        initialTitle: initialTitle,
        initialAmount: initialAmount,
      ),
    );
  }

  Future<void> _copyEFilingSummary(TaxDashboardData data) async {
    final r = data.taxResult;
    final buffer = StringBuffer()
      ..writeln(
        '=== LHDN FORM BE SUMMARY (YA ${data.assessmentYear}) — DANBUDGET v1.6.5 ===',
      )
      ..writeln('1. Total Annual Gross Income: ${r.totalGrossIncome.formatted}')
      ..writeln(
        '2. Total Statutory Reliefs (Pelepasan Cukai): -${r.totalStatutoryReliefs.formatted}',
      )
      ..writeln(
        '3. Chargeable Income (Pendapatan Bercukai): ${r.chargeableIncome.formatted}',
      )
      ..writeln(
        '4. Calculated Tax (Marginal Bracket ${r.marginalRatePercentLabel}): ${r.calculatedTaxBeforeRebates.formatted}',
      )
      ..writeln(
        '5. Total Rebates (Individual RM400 + Zakat 1:1): -${r.totalTaxRebates.formatted}',
      )
      ..writeln('   Final Tax Charged: ${r.finalCalculatedTax.formatted}')
      ..writeln('   PCB Paid: ${r.annualPcbPaid.formatted}')
      ..writeln(
        r.isRefund
            ? '6. Estimated Tax Refund: +${r.estimatedRefund.formatted}'
            : '6. Additional Tax Payable: -${r.additionalTaxPayable.formatted}',
      )
      ..writeln('\n--- STATUTORY RELIEF BUCKETS ---');

    for (final b in r.buckets) {
      buffer.writeln('- ${b.formatCapStatus(short: false)}');
    }
    buffer.writeln('\n${r.complianceReminder}');

    await Clipboard.setData(ClipboardData(text: buffer.toString()));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('LHDN Form BE e-Filing summary copied to clipboard!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final taxAsync = ref.watch(taxDashboardProvider);
    final selectedYear = ref.watch(selectedTaxYearProvider);
    final currentYear = DateTime.now().year;
    final years = [currentYear - 1, currentYear, currentYear + 1];

    return Scaffold(
      backgroundColor: colors.bgPrimary,
      appBar: AppBar(
        backgroundColor: colors.bgPrimary,
        elevation: 0,
        titleSpacing: 0,
        title: Text(
          'LHDN Tax Engine (Form BE)',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
          ),
        ),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: years.contains(selectedYear) ? selectedYear : currentYear,
              dropdownColor: colors.bgElevated,
              style: TextStyle(
                color: colors.accentPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
              items: years
                  .map(
                    (y) => DropdownMenuItem<int>(
                      value: y,
                      child: Text('YA $y'),
                    ),
                  )
                  .toList(),
              onChanged: (y) {
                if (y != null) {
                  ref.read(selectedTaxYearProvider.notifier).setYear(y);
                }
              },
            ),
          ),
          const SizedBox(width: 12),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelColor: colors.accentPrimary,
          unselectedLabelColor: colors.textMuted,
          indicatorColor: colors.accentPrimary,
          labelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
          tabs: const [
            Tab(text: 'Reliefs & Form BE'),
            Tab(text: 'Receipt Classifier'),
            Tab(text: 'Advisor & Brackets'),
          ],
        ),
      ),
      body: taxAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Error loading LHDN Tax Engine: $err',
              style: TextStyle(color: colors.accentDanger),
            ),
          ),
        ),
        data: (data) => TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewAndReliefsTab(context, colors, data),
            _buildClassifierAndSimulatorTab(context, colors, data),
            _buildAdvisorAndBracketsTab(context, colors, data),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewAndReliefsTab(
    BuildContext context,
    AppPalette colors,
    TaxDashboardData data,
  ) {
    final r = data.taxResult;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
      children: [
        // Hero Refund / Tax Payable Card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: colors.bgElevated,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.borderSubtle),
          ),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: (r.isRefund
                              ? colors.accentSecondary
                              : colors.accentWarning)
                          .withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      r.isRefund
                          ? 'Estimated refund'
                          : 'Estimated tax owed',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: r.isRefund
                            ? colors.accentSecondary
                            : colors.accentWarning,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colors.bgSecondary,
                      borderRadius: BorderRadius.circular(20),
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
                  color: r.isRefund
                      ? colors.accentSecondary
                      : colors.accentWarning,
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
                    onPressed: () => _openEditProfileSheet(data),
                    icon: const Icon(Icons.tune_rounded, size: 16),
                    label: const Text('Configure Income & Reliefs'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.accentPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
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
                    onPressed: () => _openLogReceiptSheet(data),
                    icon: const Icon(Icons.receipt_long_rounded, size: 16),
                    label: const Text('Log Tax Receipt'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.textPrimary,
                      side: BorderSide(color: colors.borderSubtle),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
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
                    onPressed: () => _copyEFilingSummary(data),
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
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.bgSecondary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.borderSubtle),
          ),
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
                sublabel:
                    'Sum of all valid claimable categories (strictly capped)',
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
                valueColor: r.isRefund
                    ? colors.accentSecondary
                    : colors.accentWarning,
                isBold: true,
                colors: colors,
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Section Header: Core Tax Relief Categories & Strict Caps
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
              onPressed: () => _openEditProfileSheet(data),
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
            marginalRate: r.marginalTaxRate,
            colors: colors,
            onTapAddReceipt: b.bucket == LhdnReliefBucket.individualAndDependent
                ? null
                : () => _openLogReceiptSheet(
                      data,
                      initialBucket: b.bucket,
                    ),
          ),
        ),
      ],
    );
  }

  Widget _buildClassifierAndSimulatorTab(
    BuildContext context,
    AppPalette colors,
    TaxDashboardData data,
  ) {
    final simAmount =
        Money.tryParse(_simAmountCtrl.text) ?? Money.fromRinggit(100);
    final simDesc = _simDescCtrl.text.trim().isEmpty
        ? 'ChatGPT Plus AI Subscription'
        : _simDescCtrl.text.trim();

    final impact = LhdnTaxEngine.simulateExpenseImpact(
      currentInput: data.taxInput,
      description: simDesc,
      amount: simAmount,
    );

    const presets = <(String, String)>[
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

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
      children: [
        // Simulator Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.bgSecondary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.borderSubtle),
          ),
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
                  children: presets.map((preset) {
                    final isSelected = _simDescCtrl.text == preset.$1;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        backgroundColor: isSelected
                            ? colors.accentPrimary.withValues(alpha: 0.2)
                            : colors.bgPrimary,
                        side: BorderSide(
                          color: isSelected
                              ? colors.accentPrimary
                              : colors.borderSubtle,
                        ),
                        label: Text(
                          '${preset.$1} (RM${preset.$2})',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? colors.accentPrimary
                                : colors.textSecondary,
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
                        labelStyle: TextStyle(
                          color: colors.textSecondary,
                          fontSize: 12,
                        ),
                        filled: true,
                        fillColor: colors.bgPrimary,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
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
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      style: TextStyle(color: colors.textPrimary, fontSize: 13),
                      decoration: InputDecoration(
                        labelText: 'Amount (RM)',
                        prefixText: 'RM ',
                        labelStyle: TextStyle(
                          color: colors.textSecondary,
                          fontSize: 12,
                        ),
                        filled: true,
                        fillColor: colors.bgPrimary,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colors.borderSubtle),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // Protocol Output Container
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colors.bgPrimary,
                  borderRadius: BorderRadius.circular(12),
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
                          ? 'NOT ELIGIBLE — Excluded under LHDN Sports & Fitness rules (sports shoes/apparel).'
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
                            await ref
                                .read(taxRepositoryProvider)
                                .addReceiptClaim(
                                  assessmentYear: data.assessmentYear,
                                  title: simDesc,
                                  amountSen: simAmount.sen,
                                  bucket: impact.classification.bucket!,
                                  subBucketId:
                                      impact.classification.subBucketId,
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
                          icon: const Icon(
                            Icons.add_task_rounded,
                            size: 16,
                          ),
                          label: Text(
                            'Log "$simDesc" (${simAmount.formatted}) to ${impact.classification.bucket!.shortTitle}',
                            overflow: TextOverflow.ellipsis,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.accentPrimary,
                            foregroundColor: Colors.white,
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

        // Auto-Detected Eligible Expenses from Expense Log
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
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.bgSecondary,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.borderSubtle),
              ),
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

        // Logged Tax Receipts & 7-Year Vault
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
              onPressed: () => _openLogReceiptSheet(data),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add Receipt'),
            ),
          ],
        ),
        if (data.receiptClaims.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colors.bgSecondary,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colors.borderSubtle),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 32,
                  color: colors.textMuted,
                ),
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
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: colors.bgSecondary,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.borderSubtle),
              ),
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
                          style: TextStyle(
                            fontSize: 11.5,
                            color: colors.textMuted,
                          ),
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
                      ref
                          .read(taxRepositoryProvider)
                          .deleteReceiptClaim(claim.id);
                    },
                    icon: Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: colors.textMuted,
                    ),
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }

  Widget _buildAdvisorAndBracketsTab(
    BuildContext context,
    AppPalette colors,
    TaxDashboardData data,
  ) {
    final r = data.taxResult;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
      children: [
        // 5. Compliance Alert Banner (7-Year Rule)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.accentWarning.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: colors.accentWarning.withValues(alpha: 0.4),
            ),
          ),
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

        // Actionable Suggestions
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
          (adv) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.bgSecondary,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: adv.isWarning
                    ? colors.accentWarning.withValues(alpha: 0.45)
                    : colors.borderSubtle,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      adv.isWarning
                          ? Icons.warning_amber_rounded
                          : Icons.lightbulb_outline_rounded,
                      size: 18,
                      color: adv.isWarning
                          ? colors.accentWarning
                          : colors.accentPrimary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        adv.title,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                    if (adv.estimatedMaxTaxSaved.sen > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: colors.accentSecondary.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(8),
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

        // Progressive Tax Brackets Table (0% to 30%)
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
        Container(
          decoration: BoxDecoration(
            color: colors.bgSecondary,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.borderSubtle),
          ),
          child: Column(
            children: LhdnTaxEngine.residentBrackets.map((band) {
              final activeSlice = r.bracketSlices
                  .where((s) => s.bracket.label == band.label)
                  .firstOrNull;
              final isMarginalBand =
                  (band.rate - r.marginalTaxRate).abs() < 0.0001 &&
                      r.chargeableIncome.sen > band.lowerSen;
              final ratePct = (band.rate * 100).toStringAsFixed(
                band.rate * 100 == (band.rate * 100).roundToDouble() ? 0 : 1,
              );

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
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
                              fontWeight: isMarginalBand
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isMarginalBand
                                  ? colors.accentPrimary
                                  : colors.textPrimary,
                            ),
                          ),
                          if (activeSlice != null)
                            Text(
                              'Taxed: ${activeSlice.taxableAmount.formattedCompact}',
                              style: TextStyle(
                                fontSize: 11,
                                color: colors.textMuted,
                              ),
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
                          color: isMarginalBand
                              ? colors.accentPrimary
                              : colors.textSecondary,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        activeSlice != null
                            ? activeSlice.taxAmount.formatted
                            : 'RM 0.00',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: activeSlice != null
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: activeSlice != null
                              ? colors.textPrimary
                              : colors.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _StepRow extends StatelessWidget {
  final String step;
  final String label;
  final String sublabel;
  final String value;
  final Color? valueColor;
  final bool isBold;
  final AppPalette colors;

  const _StepRow({
    required this.step,
    required this.label,
    required this.sublabel,
    required this.value,
    this.valueColor,
    this.isBold = false,
    required this.colors,
  });

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
  final BucketUtilization utilization;
  final double marginalRate;
  final AppPalette colors;
  final VoidCallback? onTapAddReceipt;

  const _ReliefBucketCard({
    required this.utilization,
    required this.marginalRate,
    required this.colors,
    this.onTapAddReceipt,
  });

  @override
  Widget build(BuildContext context) {
    final u = utilization;
    final barColor = u.isSaturated
        ? colors.accentWarning
        : u.progress >= 0.75
            ? colors.accentPrimary
            : colors.accentSecondary;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.bgSecondary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: u.isSaturated
              ? colors.accentWarning.withValues(alpha: 0.45)
              : colors.borderSubtle,
        ),
      ),
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
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
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
          // Exact LHDN Cap Status String required by protocol
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: colors.bgPrimary,
                    borderRadius: BorderRadius.circular(8),
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

class _ProtocolItem extends StatelessWidget {
  final String badge;
  final String content;
  final Color color;
  final AppPalette colors;

  const _ProtocolItem({
    required this.badge,
    required this.content,
    required this.color,
    required this.colors,
  });

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
