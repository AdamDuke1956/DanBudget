import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/money.dart';
import '../../../data/local/app_database.dart';
import '../../../data/providers/database_providers.dart';
import 'add_edit_account_sheet.dart';
import 'quick_adjust_balance_sheet.dart';
import 'transfer_funds_sheet.dart';

class AccountDetailsHistorySheet extends ConsumerWidget {
  final AccountsTableData? account; // If null, shows all transfers/accounts

  const AccountDetailsHistorySheet({super.key, this.account});

  static Future<void> show(BuildContext context, {AccountsTableData? account}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AccountDetailsHistorySheet(account: account),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transfersAsync = ref.watch(recentTransfersStreamProvider);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
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
      child: Column(
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

          if (account != null) ...[
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(account!.colorHex).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(account!.icon, style: const TextStyle(fontSize: 26)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account!.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${account!.type.toUpperCase()} • ${account!.isLiquidOnHand ? "Liquid Cash" : "Locked Savings"}',
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit_rounded, color: AppColors.textSecondary),
                  tooltip: 'Edit Account',
                  onPressed: () {
                    Navigator.of(context).pop();
                    AddEditAccountSheet.show(context, account: account);
                  },
                ),
              ],
            ),
            const SizedBox(height: 14),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceHigh,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Color(account!.colorHex).withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Current Balance',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  Text(
                    Money(account!.balanceSen).formatted,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Color(account!.colorHex),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      QuickAdjustBalanceSheet.show(context, initialAccount: account);
                    },
                    icon: const Icon(Icons.tune_rounded, size: 14),
                    label: const Text('Reconcile', style: TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: BorderSide(color: AppColors.outline),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      TransferFundsSheet.show(context, fromAccountId: account!.id);
                    },
                    icon: const Icon(Icons.sync_alt_rounded, size: 14),
                    label: const Text('Transfer', style: TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.accent,
                      side: BorderSide(color: AppColors.accent.withValues(alpha: 0.5)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
            Divider(height: 24, color: AppColors.outline),
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transfers & Movement History',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    TransferFundsSheet.show(context);
                  },
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: const Text('New Transfer'),
                  style: TextButton.styleFrom(foregroundColor: AppColors.accent),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'View all movements between your banks, e-wallets, and cash with notes.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 14),
          ],

          Text(
            account != null ? 'Transfer & Movement Notes' : 'All Transfer Notes',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),

          Expanded(
            child: transfersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
              data: (transfers) {
                final filtered = account == null
                    ? transfers
                    : transfers.where((t) =>
                        t.transfer.fromAccountId == account!.id ||
                        t.transfer.toAccountId == account!.id).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.sync_alt_rounded, size: 40, color: AppColors.textSecondary),
                          const SizedBox(height: 10),
                          Text(
                            'No transfers recorded yet',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Use "Transfer" to move funds between bank accounts & e-wallets (e.g. reload TnG or ATM cash).',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final item = filtered[i];
                    final isOutgoing = account != null && item.transfer.fromAccountId == account!.id;
                    final isIncoming = account != null && item.transfer.toAccountId == account!.id;

                    final fromName = item.fromAccount?.name ?? 'Account';
                    final toName = item.toAccount?.name ?? 'Account';
                    final note = item.transfer.note;

                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceHigh,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.accent.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.sync_alt_rounded,
                              color: AppColors.accent,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$fromName ➔ $toName',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                if (note != null && note.isNotEmpty) ...[
                                  Text(
                                    '📝 "$note"',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.accent,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                ],
                                Text(
                                  DateFormat('dd MMM yyyy, h:mm a').format(item.transfer.date),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${isOutgoing ? "-" : (isIncoming ? "+" : "")}${Money(item.transfer.amountSen).formatted}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isOutgoing
                                      ? AppColors.danger
                                      : (isIncoming ? AppColors.success : AppColors.accent),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.textSecondary),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                tooltip: 'Revert transfer',
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      backgroundColor: AppColors.surface,
                                      title: Text('Revert Transfer?', style: TextStyle(color: AppColors.textPrimary)),
                                      content: Text(
                                        'This will undo the transfer and restore the previous balances in both accounts.',
                                        style: TextStyle(color: AppColors.textSecondary),
                                      ),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
                                          onPressed: () => Navigator.of(ctx).pop(true),
                                          child: const Text('Revert'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    await ref.read(accountRepositoryProvider).deleteTransfer(item.transfer.id);
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
