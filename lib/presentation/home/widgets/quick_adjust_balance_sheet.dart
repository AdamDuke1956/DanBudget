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
    final accountsAsync = ref.watch(accountsStreamProvider);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return accountsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (accounts) {
        if (accounts.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
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
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Handle bar
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
                    const Text(
                      'Reconcile Balance',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(selectedAccount.colorHex).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
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
                const Text(
                  'Match your pocket balance with your banking app or physical cash.',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),

                // Pocket Selector
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
                const SizedBox(height: 16),

                // Balance input hero
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.outline),
                  ),
                  child: Row(
                    children: [
                      const Text(
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
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          decoration: const InputDecoration(
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
                const SizedBox(height: 12),

                // Adjustment Delta Indicator
                if (deltaSen != 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: deltaSen > 0
                          ? AppColors.savings.withValues(alpha: 0.12)
                          : AppColors.danger.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          deltaSen > 0 ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                          size: 16,
                          color: deltaSen > 0 ? AppColors.savings : AppColors.danger,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${deltaSen > 0 ? 'Adjustment: +' : 'Adjustment: -'}${Money(deltaSen.abs()).formatted}',
                          style: TextStyle(
                            color: deltaSen > 0 ? AppColors.savings : AppColors.danger,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),

                // Update Button
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
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.surfaceHigh,
                          content: Row(
                            children: [
                              const Icon(Icons.check_circle_rounded, color: AppColors.primary),
                              const SizedBox(width: 12),
                              Text(
                                '${selectedAccount.name} updated to ${Money(newSen).formatted}',
                                style: const TextStyle(color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: const Color(0xFF04291F),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
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
