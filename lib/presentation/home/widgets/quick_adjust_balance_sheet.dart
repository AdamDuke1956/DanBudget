import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/money.dart';
import '../../../data/local/app_database.dart';
import '../../../data/providers/database_providers.dart';

class QuickAdjustBalanceSheet extends ConsumerStatefulWidget {
  final AccountsTableData? initialAccount;

  const QuickAdjustBalanceSheet({super.key, this.initialAccount});

  static Future<void> show(BuildContext context, {AccountsTableData? initialAccount}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => QuickAdjustBalanceSheet(initialAccount: initialAccount),
    );
  }

  @override
  ConsumerState<QuickAdjustBalanceSheet> createState() => _QuickAdjustBalanceSheetState();
}

class _QuickAdjustBalanceSheetState extends ConsumerState<QuickAdjustBalanceSheet> {
  late int? _selectedAccountId;
  final _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedAccountId = widget.initialAccount?.id;
    if (widget.initialAccount != null) {
      _amountController.text = (widget.initialAccount!.balanceSen / 100).toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final accountsAsync = ref.watch(accountsStreamProvider);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return accountsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (accounts) {
        if (accounts.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: const Text('No accounts available.'),
          );
        }

        final selectedAccount = accounts.firstWhere(
          (a) => a.id == _selectedAccountId,
          orElse: () => accounts.first,
        );

        if (_selectedAccountId == null) {
          _selectedAccountId = selectedAccount.id;
          if (_amountController.text.isEmpty) {
            _amountController.text = (selectedAccount.balanceSen / 100).toStringAsFixed(2);
          }
        }

        final currentSen = selectedAccount.balanceSen;
        final inputRinggit = double.tryParse(_amountController.text.trim()) ?? (currentSen / 100);
        final inputSen = Money.fromRinggit(inputRinggit).sen;
        final deltaSen = inputSen - currentSen;

        return Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: 24 + bottomInset,
          ),
          decoration: BoxDecoration(
            color: colors.surface,
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
                      color: colors.outline,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Reconcile Balance',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(selectedAccount.colorHex).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Current: ${Money(currentSen).formatted}',
                        style: TextStyle(
                          color: Color(selectedAccount.colorHex),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Match your account balance with your banking app or physical cash.',
                  style: TextStyle(fontSize: 13, color: colors.textSecondary),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 42,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: accounts.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      final acc = accounts[i];
                      final isSelected = acc.id == selectedAccount.id;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedAccountId = acc.id;
                            _amountController.text = (acc.balanceSen / 100).toStringAsFixed(2);
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Color(acc.colorHex).withValues(alpha: 0.2)
                                : colors.surfaceHigh,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isSelected
                                  ? Color(acc.colorHex)
                                  : colors.outline.withValues(alpha: 0.5),
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
                                  color: isSelected ? colors.textPrimary : colors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: colors.background,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: colors.outline),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'RM ',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: colors.primary,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: colors.textPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: '0.00',
                            hintStyle: TextStyle(color: colors.textSecondary),
                            border: InputBorder.none,
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                if (deltaSen != 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: deltaSen > 0
                          ? colors.savings.withValues(alpha: 0.12)
                          : colors.danger.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          deltaSen > 0 ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                          size: 16,
                          color: deltaSen > 0 ? colors.savings : colors.danger,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${deltaSen > 0 ? 'Adjustment: +' : 'Adjustment: -'}${Money(deltaSen.abs()).formatted}',
                          style: TextStyle(
                            color: deltaSen > 0 ? colors.savings : colors.danger,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final text = _amountController.text.trim();
                    final parsedRinggit = double.tryParse(text);
                    if (parsedRinggit == null || parsedRinggit < 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a valid balance')),
                      );
                      return;
                    }

                    final newSen = Money.fromRinggit(parsedRinggit).sen;
                    await ref.read(accountRepositoryProvider).setAccountBalance(
                          selectedAccount.id,
                          newSen,
                        );

                    if (context.mounted) {
                      final toastColors = AppColors.of(context);
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: toastColors.surfaceHigh,
                          content: Row(
                            children: [
                              Icon(Icons.check_circle_rounded, color: toastColors.primary),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  '${selectedAccount.name} updated to ${Money(newSen).formatted}',
                                  style: TextStyle(color: toastColors.textPrimary),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Save New Balance',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
