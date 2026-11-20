import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/money.dart';
import '../../data/providers/database_providers.dart';
import '../../data/providers/tax_provider.dart';
import '../../domain/engine/lhdn_tax_engine.dart';
import 'widgets/log_tax_receipt_sheet.dart';
import 'widgets/tax_advisor_tab.dart';
import 'widgets/tax_classifier_tab.dart';
import 'widgets/tax_overview_tab.dart';
import 'widgets/tax_profile_edit_sheet.dart';

class TaxOptimizerScreen extends ConsumerStatefulWidget {
  const TaxOptimizerScreen({super.key});

  @override
  ConsumerState<TaxOptimizerScreen> createState() => _TaxOptimizerScreenState();
}

class _TaxOptimizerScreenState extends ConsumerState<TaxOptimizerScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
        '=== LHDN FORM BE SUMMARY (YA ${data.assessmentYear}) | DANBUDGET v1.6.6 ===',
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
            TaxOverviewTab(
              data: data,
              onEditProfile: () => _openEditProfileSheet(data),
              onLogReceipt: ({initialBucket}) =>
                  _openLogReceiptSheet(data, initialBucket: initialBucket),
              onCopySummary: () => _copyEFilingSummary(data),
            ),
            TaxClassifierTab(
              data: data,
              onOpenLogReceipt: () => _openLogReceiptSheet(data),
            ),
            TaxAdvisorTab(data: data),
          ],
        ),
      ),
    );
  }
}
