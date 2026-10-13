import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/money.dart';
import '../../../data/providers/database_providers.dart';
import 'account_details_history_sheet.dart';

class TransferFundsSheet extends ConsumerStatefulWidget {
  final int? initialFromAccountId;
  final int? initialToAccountId;

  const TransferFundsSheet({
    super.key,
    this.initialFromAccountId,
    this.initialToAccountId,
  });

  static Future<void> show(
    BuildContext context, {
    int? fromAccountId,
    int? toAccountId,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TransferFundsSheet(
        initialFromAccountId: fromAccountId,
        initialToAccountId: toAccountId,
      ),
    );
  }

  @override
  ConsumerState<TransferFundsSheet> createState() => _TransferFundsSheetState();
}

class _TransferFundsSheetState extends ConsumerState<TransferFundsSheet> {
  int? _fromAccountId;
  int? _toAccountId;
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  static const _quickAmounts = [10, 20, 50, 100];

  @override
  void initState() {
    super.initState();
    _fromAccountId = widget.initialFromAccountId;
    _toAccountId = widget.initialToAccountId;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _onQuickAmountTap(int ringgit) {
    _amountController.text = ringgit.toStringAsFixed(0);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final accountsAsync = ref.watch(accountsStreamProvider);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return accountsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (accounts) {
        if (accounts.length < 2) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: const Text('You need at least 2 accounts to make a transfer.'),
          );
        }

        // Initialize defaults if null or equal
        _fromAccountId ??= accounts.first.id;
        _toAccountId ??= accounts.firstWhere((a) => a.id != _fromAccountId).id;

        final fromAccount = accounts.firstWhere((a) => a.id == _fromAccountId);
        final toAccount = accounts.firstWhere((a) => a.id == _toAccountId);

        final parsedAmount = double.tryParse(_amountController.text.trim()) ?? 0;
        final transferSen = Money.fromRinggit(parsedAmount).sen;

        return Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: 24 + bottomInset,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
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
                    Expanded(
                      child: Text(
                        'Transfer Between Accounts',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        AccountDetailsHistorySheet.show(context);
                      },
                      icon: const Icon(Icons.history_rounded, size: 16),
                      label: const Text('History'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.accent,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Move money between bank accounts, e-wallets, or cash without recording an expense.',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHigh,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.outline),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Color(fromAccount.colorHex).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(fromAccount.icon, style: const TextStyle(fontSize: 20)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'From Account',
                                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                ),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<int>(
                                    value: _fromAccountId,
                                    dropdownColor: AppColors.surfaceHigh,
                                    isDense: true,
                                    items: accounts.map((a) {
                                      return DropdownMenuItem(
                                        value: a.id,
                                        child: Text(
                                          '${a.name} (${Money(a.balanceSen).formatted})',
                                          style: TextStyle(
                                            color: AppColors.textPrimary,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      if (val != null) {
                                        setState(() {
                                          _fromAccountId = val;
                                          if (_toAccountId == val) {
                                            _toAccountId = accounts.firstWhere((a) => a.id != val).id;
                                          }
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Divider(color: AppColors.outline, height: 1),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Color(toAccount.colorHex).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(toAccount.icon, style: const TextStyle(fontSize: 20)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'To Account',
                                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                ),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<int>(
                                    value: _toAccountId,
                                    dropdownColor: AppColors.surfaceHigh,
                                    isDense: true,
                                    items: accounts.map((a) {
                                      return DropdownMenuItem(
                                        value: a.id,
                                        child: Text(
                                          '${a.name} (${Money(a.balanceSen).formatted})',
                                          style: TextStyle(
                                            color: AppColors.textPrimary,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      if (val != null) {
                                        setState(() {
                                          _toAccountId = val;
                                          if (_fromAccountId == val) {
                                            _fromAccountId = accounts.firstWhere((a) => a.id != val).id;
                                          }
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(20),
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
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: _quickAmounts.map((amt) {
                    return ActionChip(
                      label: Text('RM $amt'),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: AppColors.textPrimary,
                      ),
                      backgroundColor: AppColors.surfaceHigh,
                      side: BorderSide(color: AppColors.outline),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      onPressed: () => _onQuickAmountTap(amt),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _noteController,
                  style: TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Note (e.g. DuitNow QR topup, ATM withdrawal)',
                    hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    prefixIcon: Icon(Icons.sync_alt_rounded, color: AppColors.textSecondary),
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
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (transferSen <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter an amount to transfer')),
                      );
                      return;
                    }
                    if (_fromAccountId == _toAccountId) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Source and destination must be different')),
                      );
                      return;
                    }

                    await ref.read(accountRepositoryProvider).transferFunds(
                          fromAccountId: _fromAccountId!,
                          toAccountId: _toAccountId!,
                          amountSen: transferSen,
                          note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
                        );

                    if (context.mounted) {
                      Navigator.of(context).pop();
                      final noteText = _noteController.text.trim();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.surfaceHigh,
                          content: Row(
                            children: [
                              Icon(Icons.check_circle_rounded, color: AppColors.primary),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Transferred ${Money(transferSen).formatted} to ${toAccount.name}${noteText.isNotEmpty ? " • \"$noteText\"" : ""}',
                                  style: TextStyle(color: AppColors.textPrimary),
                                ),
                              ),
                            ],
                          ),
                          action: SnackBarAction(
                            label: 'History',
                            textColor: AppColors.accent,
                            onPressed: () => AccountDetailsHistorySheet.show(context),
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    elevation: 0,
                  ),
                  child: Text(
                    'Transfer ${Money(transferSen).formatted}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
