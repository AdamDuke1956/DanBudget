import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/money.dart';
import '../../../data/models/expense_with_category.dart';
import '../../../data/providers/database_providers.dart';
import '../../../data/providers/tax_provider.dart';
import '../../../domain/engine/lhdn_tax_engine.dart';

class AddExpenseSheet extends ConsumerStatefulWidget {
  final ExpenseWithCategory? existingExpense;

  const AddExpenseSheet({super.key, this.existingExpense});

  bool get isEditing => existingExpense != null;

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddExpenseSheet(),
    );
  }

  static Future<void> edit(BuildContext context, ExpenseWithCategory item) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddExpenseSheet(existingExpense: item),
    );
  }

  @override
  ConsumerState<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends ConsumerState<AddExpenseSheet> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String _selectedCategoryId = 'food';
  int? _selectedAccountId;
  DateTime _selectedDate = DateTime.now();
  bool _autoClaimTaxRelief = true;

  static const _quickAmounts = [5, 10, 15, 25, 50, 100];

  @override
  void initState() {
    super.initState();
    if (widget.existingExpense != null) {
      final exp = widget.existingExpense!.expense;
      _amountController.text = (exp.amountSen / 100).toStringAsFixed(2);
      _noteController.text = exp.note ?? '';
      _selectedCategoryId = exp.categoryId;
      _selectedAccountId = exp.accountId;
      _selectedDate = exp.date;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _onQuickAmountTap(int ringgit) {
    final currentSen = Money.fromRinggit(
      double.tryParse(_amountController.text.trim()) ?? 0,
    ).sen;
    final newRinggit = (currentSen / 100) + ringgit;
    setState(() {
      _amountController.text = newRinggit.toStringAsFixed(
        newRinggit.truncateToDouble() == newRinggit ? 0 : 2,
      );
    });
  }

  Future<void> _saveExpense() async {
    final amountText = _amountController.text.trim();
    if (amountText.isEmpty) return;

    final ringgit = double.tryParse(amountText);
    if (ringgit == null || ringgit <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    final amountSen = Money.fromRinggit(ringgit).sen;
    final repo = ref.read(expenseRepositoryProvider);
    final noteTrimmed = _noteController.text.trim();

    if (widget.isEditing) {
      await repo.updateExpense(
        id: widget.existingExpense!.expense.id,
        amountSen: amountSen,
        categoryId: _selectedCategoryId,
        date: _selectedDate,
        note: noteTrimmed.isEmpty ? null : noteTrimmed,
        accountId: _selectedAccountId,
      );
    } else {
      final newExpenseId = await repo.addExpense(
        amountSen: amountSen,
        categoryId: _selectedCategoryId,
        date: _selectedDate,
        note: noteTrimmed.isEmpty ? null : noteTrimmed,
        accountId: _selectedAccountId,
      );

      if (_autoClaimTaxRelief && noteTrimmed.isNotEmpty) {
        final cls = LhdnTaxEngine.classifyTransaction(description: noteTrimmed);
        if (cls.bucket != null && !cls.isExcludedWarn) {
          await ref.read(taxRepositoryProvider).addReceiptClaim(
                assessmentYear: _selectedDate.year,
                expenseId: newExpenseId,
                title: noteTrimmed,
                amountSen: amountSen,
                bucket: cls.bucket!,
                subBucketId: cls.subBucketId,
                claimedDate: _selectedDate,
                isAutoClassified: true,
              );
        }
      }
    }

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.surfaceHigh,
          content: Row(
            children: [
              Icon(Icons.check_circle_rounded, color: AppColors.primary),
              const SizedBox(width: 12),
              Text(
                widget.isEditing
                    ? 'Updated RM ${ringgit.toStringAsFixed(2)}'
                    : 'Logged RM ${ringgit.toStringAsFixed(2)}',
                style: TextStyle(color: AppColors.textPrimary),
              ),
            ],
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesStreamProvider);
    final accountsAsync = ref.watch(accountsStreamProvider);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    final accounts = accountsAsync.value ?? [];
    if (_selectedAccountId == null && accounts.isNotEmpty) {
      _selectedAccountId = accounts.firstWhere((a) => a.isDefault, orElse: () => accounts.first).id;
    }

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: 24 + bottomInset,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.outline,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.isEditing ? 'Edit Expense' : 'Quick Log Expense',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton.icon(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime.now().subtract(const Duration(days: 365)),
                      lastDate: DateTime.now().add(const Duration(days: 7)),
                    );
                    if (picked != null) {
                      setState(() => _selectedDate = picked);
                    }
                  },
                  icon: Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.accent),
                  label: Text(
                    DateFormat('dd MMM').format(_selectedDate),
                    style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.outline),
              ),
              child: Row(
                children: [
                  Text(
                    'RM ',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      onChanged: (_) => setState(() {}),
                      autofocus: true,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: '0.00',
                        hintStyle: TextStyle(color: AppColors.textSecondary),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              children: _quickAmounts.map((amt) {
                return ActionChip(
                  label: Text('+$amt'),
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                  backgroundColor: AppColors.surfaceHigh,
                  side: BorderSide(color: AppColors.outline),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  onPressed: () => _onQuickAmountTap(amt),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            Text(
              'Category',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 10),

            categoriesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Text('Error loading categories'),
              data: (categories) {
                return SizedBox(
                  height: 90,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, i) {
                      final cat = categories[i];
                      final isSelected = cat.id == _selectedCategoryId;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedCategoryId = cat.id),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 82,
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Color(cat.colorHex).withValues(alpha: 0.25)
                                : AppColors.surfaceHigh,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? Color(cat.colorHex)
                                  : AppColors.outline.withValues(alpha: 0.5),
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(cat.icon, style: const TextStyle(fontSize: 24)),
                              const SizedBox(height: 4),
                              Text(
                                cat.name,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            if (accounts.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Paid From Pocket',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 42,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: accounts.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final acc = accounts[i];
                    final isSelected = acc.id == _selectedAccountId;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedAccountId = acc.id),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Color(acc.colorHex).withValues(alpha: 0.2)
                              : AppColors.surfaceHigh,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? Color(acc.colorHex)
                                : AppColors.outline.withValues(alpha: 0.5),
                            width: isSelected ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(acc.icon, style: const TextStyle(fontSize: 14)),
                            const SizedBox(width: 6),
                            Text(
                              acc.name,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 16),

            TextField(
              controller: _noteController,
              onChanged: (_) => setState(() {}),
              style: TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Note (e.g. Mixed rice, Touch n Go reload)',
                hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                prefixIcon: Icon(Icons.edit_note_rounded, color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.surfaceHigh,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: AppColors.outline),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: AppColors.outline),
                ),
              ),
            ),
            _buildLhdnTaxPreviewBanner(),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _saveExpense,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                elevation: 0,
              ),
              child: Text(
                widget.isEditing ? 'Save Changes' : 'Save Expense',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLhdnTaxPreviewBanner() {
    final taxDashAsync = ref.watch(taxDashboardProvider);
    final profileEmpType = taxDashAsync.value?.userProfile.employmentType;
    if (profileEmpType == 'intern') {
      return const SizedBox.shrink();
    }

    final note = _noteController.text.trim();
    if (note.isEmpty) return const SizedBox.shrink();

    final cls = LhdnTaxEngine.classifyTransaction(description: note);
    if (cls.bucket == null && !cls.isZakatRebate && !cls.isExcludedWarn) {
      return const SizedBox.shrink();
    }

    final amount =
        Money.tryParse(_amountController.text) ?? Money.fromRinggit(100);
    final currentInput = taxDashAsync.value?.taxInput ??
        const LhdnTaxInput(assessmentYear: 2026);

    final impact = LhdnTaxEngine.simulateExpenseImpact(
      currentInput: currentInput,
      description: note,
      amount: amount.sen > 0 ? amount : Money.fromRinggit(100),
    );

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cls.isExcludedWarn
            ? AppColors.danger.withValues(alpha: 0.12)
            : AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: cls.isExcludedWarn
              ? AppColors.danger.withValues(alpha: 0.45)
              : AppColors.primary.withValues(alpha: 0.45),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                cls.isExcludedWarn
                    ? Icons.warning_amber_rounded
                    : Icons.account_balance_rounded,
                size: 16,
                color: cls.isExcludedWarn ? AppColors.danger : AppColors.primary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  cls.isExcludedWarn
                      ? 'LHDN Tax Alert: Excluded Item'
                      : 'LHDN Tax Relief Match: ${cls.subBucketTitle ?? cls.bucket?.shortTitle ?? "Zakat Rebate"}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            impact.capStatusSummary,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            impact.marginalImpactStatement,
            style: TextStyle(
              fontSize: 11.5,
              color: AppColors.textSecondary,
              height: 1.35,
            ),
          ),
          if (!widget.isEditing && cls.bucket != null && !cls.isExcludedWarn)
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: AppColors.primary,
              value: _autoClaimTaxRelief,
              onChanged: (v) =>
                  setState(() => _autoClaimTaxRelief = v ?? true),
              title: Text(
                'Save to Tax Relief Vault',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
