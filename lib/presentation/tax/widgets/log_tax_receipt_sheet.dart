import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/money.dart';
import '../../../data/providers/database_providers.dart';
import '../../../domain/engine/lhdn_tax_engine.dart';

class LogTaxReceiptSheet extends ConsumerStatefulWidget {
  final int assessmentYear;
  final LhdnTaxInput currentInput;
  final LhdnReliefBucket? initialBucket;
  final String? initialTitle;
  final Money? initialAmount;

  const LogTaxReceiptSheet({
    super.key,
    required this.assessmentYear,
    required this.currentInput,
    this.initialBucket,
    this.initialTitle,
    this.initialAmount,
  });

  @override
  ConsumerState<LogTaxReceiptSheet> createState() => _LogTaxReceiptSheetState();
}

class _LogTaxReceiptSheetState extends ConsumerState<LogTaxReceiptSheet> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _amountCtrl;
  late final TextEditingController _refCtrl;
  LhdnReliefBucket? _manualBucket;

  @override
  void initState() {
    super.initState();
    _manualBucket = widget.initialBucket;
    _titleCtrl = TextEditingController(text: widget.initialTitle ?? '');
    _amountCtrl = TextEditingController(
      text: widget.initialAmount != null && widget.initialAmount!.sen > 0
          ? (widget.initialAmount!.sen / 100.0).toStringAsFixed(2)
          : '',
    );
    _refCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _amountCtrl.dispose();
    _refCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveReceipt(
    MarginalTaxImpactResult impact,
    Money amount,
  ) async {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty || amount.sen <= 0) return;

    final bucket = _manualBucket ??
        impact.classification.bucket ??
        LhdnReliefBucket.lifestyle;
    final subBucketId = impact.classification.subBucketId;

    await ref.read(taxRepositoryProvider).addReceiptClaim(
          assessmentYear: widget.assessmentYear,
          title: title,
          amountSen: amount.sen,
          bucket: bucket,
          subBucketId: subBucketId,
          receiptRef: _refCtrl.text.trim(),
          isAutoClassified: _manualBucket == null,
        );

    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    final titleText = _titleCtrl.text.trim();
    final amount = Money.tryParse(_amountCtrl.text) ?? Money.zero;
    final previewAmount =
        amount.sen > 0 ? amount : Money.fromRinggit(100); // default RM100 preview

    final impact = LhdnTaxEngine.simulateExpenseImpact(
      currentInput: widget.currentInput,
      description: titleText.isEmpty ? 'ChatGPT Plus AI Subscription' : titleText,
      amount: previewAmount,
      overrideBucket: _manualBucket,
    );

    final claimableBuckets = LhdnReliefBucket.values
        .where((b) => b != LhdnReliefBucket.individualAndDependent)
        .toList();

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: colors.bgSecondary,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.borderSubtle,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Log LHDN Tax Relief Receipt (YA ${widget.assessmentYear})',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, color: colors.textMuted),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _titleCtrl,
                onChanged: (_) => setState(() {}),
                style: TextStyle(color: colors.textPrimary, fontSize: 14),
                decoration: InputDecoration(
                  labelText: 'Receipt / Expense Description',
                  hintText:
                      'e.g. ChatGPT Plus, Claude Pro, Unifi Fibre, Dental Scaling',
                  labelStyle: TextStyle(color: colors.textSecondary),
                  hintStyle: TextStyle(color: colors.textMuted, fontSize: 12),
                  filled: true,
                  fillColor: colors.bgPrimary,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colors.borderSubtle),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _amountCtrl,
                      onChanged: (_) => setState(() {}),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      style: TextStyle(color: colors.textPrimary, fontSize: 14),
                      decoration: InputDecoration(
                        labelText: 'Amount (RM)',
                        hintText: '100.00',
                        prefixText: 'RM ',
                        labelStyle: TextStyle(color: colors.textSecondary),
                        filled: true,
                        fillColor: colors.bgPrimary,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colors.borderSubtle),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _refCtrl,
                      style: TextStyle(color: colors.textPrimary, fontSize: 14),
                      decoration: InputDecoration(
                        labelText: 'Invoice / Receipt No.',
                        hintText: 'INV-2026-001',
                        labelStyle: TextStyle(color: colors.textSecondary),
                        filled: true,
                        fillColor: colors.bgPrimary,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colors.borderSubtle),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<LhdnReliefBucket?>(
                value: _manualBucket,
                isExpanded: true,
                dropdownColor: colors.bgElevated,
                style: TextStyle(color: colors.textPrimary, fontSize: 13),
                decoration: InputDecoration(
                  labelText: 'LHDN Relief Bucket (Auto-Detect or Override)',
                  labelStyle: TextStyle(color: colors.textSecondary),
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
                items: [
                  DropdownMenuItem<LhdnReliefBucket?>(
                    value: null,
                    child: Text(
                      'Auto-Classify (${impact.classification.bucket?.shortTitle ?? "Smart Match"})',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  ...claimableBuckets.map(
                    (b) => DropdownMenuItem<LhdnReliefBucket?>(
                      value: b,
                      child: Text(
                        '${b.shortTitle} (Cap ${b.defaultAnnualCap.formatted})',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
                onChanged: (val) => setState(() => _manualBucket = val),
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: impact.classification.isExcludedWarn
                      ? colors.accentDanger.withValues(alpha: 0.1)
                      : colors.accentPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: impact.classification.isExcludedWarn
                        ? colors.accentDanger.withValues(alpha: 0.4)
                        : colors.accentPrimary.withValues(alpha: 0.35),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          impact.classification.isExcludedWarn
                              ? Icons.warning_amber_rounded
                              : Icons.auto_awesome,
                          size: 16,
                          color: impact.classification.isExcludedWarn
                              ? colors.accentDanger
                              : colors.accentPrimary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            impact.classification.subBucketTitle ??
                                impact.classification.bucket?.title ??
                                'LHDN Tax Impact Preview',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: colors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      impact.capStatusSummary,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colors.accentSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      impact.marginalImpactStatement,
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                    if (impact.actionableSuggestion != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        impact.actionableSuggestion!,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: colors.accentWarning,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: titleText.isNotEmpty &&
                          amount.sen > 0 &&
                          !impact.classification.isExcludedWarn
                      ? () => _saveReceipt(impact, amount)
                      : null,
                  icon: const Icon(Icons.receipt_long_rounded, size: 18),
                  label: const Text('Save Receipt to 7-Year LHDN Vault'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.accentPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
