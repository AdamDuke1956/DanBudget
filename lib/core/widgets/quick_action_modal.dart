import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../../presentation/expenses/widgets/add_expense_sheet.dart';
import '../../presentation/home/widgets/quick_adjust_balance_sheet.dart';
import '../../presentation/home/widgets/transfer_funds_sheet.dart';

class QuickActionModal extends StatelessWidget {
  const QuickActionModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => const QuickActionModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(
          color: AppColors.isDark
              ? AppColors.outline.withValues(alpha: 0.45)
              : AppColors.outline,
        ),
      ),
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
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Manage transactions and balances instantly',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          _ActionTile(
            title: 'Log New Expense',
            subtitle: 'Record dining, groceries, transport, or bills',
            icon: Icons.receipt_long_rounded,
            color: AppColors.primary,
            onTap: () {
              Navigator.of(context).pop();
              AddExpenseSheet.show(context);
            },
          ),
          const SizedBox(height: 12),
          _ActionTile(
            title: 'Transfer Between Accounts',
            subtitle: 'e.g. Reload Touch \'n Go from Maybank / CIMB',
            icon: Icons.swap_horiz_rounded,
            color: AppColors.accent,
            onTap: () {
              Navigator.of(context).pop();
              TransferFundsSheet.show(context);
            },
          ),
          const SizedBox(height: 12),
          _ActionTile(
            title: 'Reconcile Account Balance',
            subtitle: 'Sync recorded balance with real online banking balance',
            icon: Icons.tune_rounded,
            color: AppColors.needs,
            onTap: () {
              Navigator.of(context).pop();
              QuickAdjustBalanceSheet.show(context);
            },
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: color.withValues(alpha: 0.25),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
