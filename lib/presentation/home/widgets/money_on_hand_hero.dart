import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../data/local/app_database.dart';
import 'quick_adjust_balance_sheet.dart';
import 'transfer_funds_sheet.dart';

class MoneyOnHandHero extends StatefulWidget {
  final Money totalLiquidOnHand;
  final List<AccountsTableData> accounts;
  final bool isLiquidityConstrained;

  const MoneyOnHandHero({
    super.key,
    required this.totalLiquidOnHand,
    required this.accounts,
    this.isLiquidityConstrained = false,
  });

  @override
  State<MoneyOnHandHero> createState() => _MoneyOnHandHeroState();
}

class _MoneyOnHandHeroState extends State<MoneyOnHandHero> {
  bool _isObscured = false;

  @override
  Widget build(BuildContext context) {
    final liquidAccounts = widget.accounts.where((a) => a.isLiquidOnHand).toList();

    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Title & Eye Privacy Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_rounded,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Money on Hand',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  _isObscured ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => setState(() => _isObscured = !_isObscured),
                tooltip: _isObscured ? 'Show balances' : 'Hide balances',
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Big Total Amount
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                _isObscured ? 'RM •••••' : widget.totalLiquidOnHand.formatted,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'across ${liquidAccounts.length} pockets',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          // Liquidity Warning if real cash is less than remaining flexible budget
          if (widget.isLiquidityConstrained) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline_rounded, size: 14, color: AppColors.warning),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Safe-to-spend is capped by actual cash in your bank & eWallets.',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.warning,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Pocket Chips List
          if (liquidAccounts.isNotEmpty)
            SizedBox(
              height: 54,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: liquidAccounts.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final acc = liquidAccounts[i];
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => QuickAdjustBalanceSheet.show(context, initialAccount: acc),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceHigh,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Color(acc.colorHex).withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(acc.icon, style: const TextStyle(fontSize: 16)),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  acc.name,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  _isObscured ? '•••••' : Money(acc.balanceSen).formatted,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(acc.colorHex),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          const SizedBox(height: 14),

          // Action Buttons: Quick Reconcile & Transfer
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => QuickAdjustBalanceSheet.show(context),
                  icon: const Icon(Icons.tune_rounded, size: 14),
                  label: const Text('Reconcile', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.outline),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => TransferFundsSheet.show(context),
                  icon: const Icon(Icons.sync_alt_rounded, size: 14),
                  label: const Text('Transfer', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.accent,
                    side: BorderSide(color: AppColors.accent.withValues(alpha: 0.5)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
