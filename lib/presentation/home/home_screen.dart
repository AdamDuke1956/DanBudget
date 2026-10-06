import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/money.dart';
import '../../core/widgets/glass_card.dart';
import '../../data/models/transfer_with_accounts.dart';
import '../../data/models/expense_with_category.dart';
import '../../data/providers/dashboard_provider.dart';
import '../expenses/widgets/add_expense_sheet.dart';
import 'widgets/money_on_hand_hero.dart';

sealed class _ActivityFeedItem {
  DateTime get date;
}

class _ExpenseFeedItem extends _ActivityFeedItem {
  final ExpenseWithCategory item;
  _ExpenseFeedItem(this.item);
  @override
  DateTime get date => item.expense.date;
}

class _TransferFeedItem extends _ActivityFeedItem {
  final TransferWithAccounts item;
  _TransferFeedItem(this.item);
  @override
  DateTime get date => item.transfer.date;
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({
    super.key,
    this.onNavigateToTab,
  });

  final void Function(int tabIndex)? onNavigateToTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(dashboardStateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: stateAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (err, stack) => Center(
            child: Text('Error: $err', style: const TextStyle(color: AppColors.danger)),
          ),
          data: (state) {
            final profile = state.profile;
            final safe = state.safeToSpend;
            final alloc = state.allocation;

            return CustomScrollView(
              slivers: [
                // Top App Bar / Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hai, ${profile.name} 👋',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Net Take-home: ${state.netSalary.netSalary.formatted}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        // Financial Health Pill
                        GestureDetector(
                          onTap: () => onNavigateToTab?.call(4), // Navigate to More/Checklist
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.shield_rounded, size: 16, color: AppColors.primary),
                                const SizedBox(width: 6),
                                Text(
                                  'Grade ${state.healthScore.grade} (${state.healthScore.totalScore}/100)',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Hero: "Money on Hand"
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 6, 20, 6),
                    child: MoneyOnHandHero(
                      totalLiquidOnHand: state.totalLiquidOnHand,
                      accounts: state.accounts,
                      isLiquidityConstrained: state.safeToSpend.isLiquidityConstrained,
                    ),
                  ),
                ),

                // Hero: "Safe to Spend Today"
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: GlassCard(
                      gradient: AppColors.heroGradient,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.bolt_rounded, size: 14, color: AppColors.primary),
                                    SizedBox(width: 4),
                                    Text(
                                      'Safe-to-Spend Today',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '⏳ ${safe.daysUntilPayday} days left',
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Large Daily Amount
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                safe.safeDailyAmount.formatted,
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textPrimary,
                                  letterSpacing: -1,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                '/ day',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Flexible budget progress
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Spent this cycle: ${state.totalSpentThisCycle.formatted}',
                                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                  ),
                                  Text(
                                    'Remaining: ${state.remainingFlexibleBudget.formatted}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: LinearProgressIndicator(
                                  value: (state.totalSpentThisCycle.sen +
                                              state.remainingFlexibleBudget.sen) >
                                          0
                                      ? (state.remainingFlexibleBudget.sen /
                                              (state.totalSpentThisCycle.sen +
                                                  state.remainingFlexibleBudget.sen))
                                          .clamp(0.0, 1.0)
                                      : 1.0,
                                  backgroundColor: Colors.black.withValues(alpha: 0.3),
                                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                                  minHeight: 8,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 40/30/20/10 Allocation Overview & DSR
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${(alloc.needs.percentage * 100).round()} / ${(alloc.wants.percentage * 100).round()} / ${(alloc.savings.percentage * 100).round()} / ${(alloc.giving.percentage * 100).round()} Budget Split',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => onNavigateToTab?.call(2), // Plan tab
                              child: const Text(
                                'View Plan →',
                                style: TextStyle(
                                  color: AppColors.accent,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Mini 4-bucket grid
                        Row(
                          children: [
                            Expanded(
                              child: _buildMiniBucketCard(
                                label: '${(alloc.needs.percentage * 100).round()}% Needs',
                                amount: alloc.needs.targetAmount.formatted,
                                color: AppColors.needs,
                                subtitle: 'Food, bills, fuel',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildMiniBucketCard(
                                label: '${(alloc.wants.percentage * 100).round()}% Wants',
                                amount: alloc.wants.targetAmount.formatted,
                                color: AppColors.wants,
                                subtitle: 'Dining, hobbies',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _buildMiniBucketCard(
                                label: '${(alloc.savings.percentage * 100).round()}% Savings',
                                amount: alloc.savings.targetAmount.formatted,
                                color: AppColors.savings,
                                subtitle: 'Emergency / ASB',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildMiniBucketCard(
                                label: '${(alloc.giving.percentage * 100).round()}% Giving',
                                amount: alloc.giving.targetAmount.formatted,
                                color: AppColors.giving,
                                subtitle: 'Mak ayah & sedekah',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Commitments Summary Preview
                if (state.activeCommitments.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: GlassCard(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(Icons.account_balance_wallet_rounded,
                                  color: AppColors.accent, size: 24),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${state.activeCommitments.length} Active Commitments',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Total: ${state.allocation.totalCommitments.formatted} / month (DSR: ${(state.allocation.dsrRatio * 100).toStringAsFixed(1)}%)',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () => onNavigateToTab?.call(3), // Commitments tab
                              child: const Text('Manage', style: TextStyle(color: AppColors.accent)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // Recent Transactions Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recent Transactions',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (state.recentExpenses.isNotEmpty)
                          GestureDetector(
                            onTap: () => onNavigateToTab?.call(1), // Expenses tab
                            child: const Text(
                              'All Expenses →',
                              style: TextStyle(
                                color: AppColors.accent,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // Recent Transactions & Transfers List
                Builder(
                  builder: (context) {
                    final activities = <_ActivityFeedItem>[
                      ...state.recentExpenses.map(_ExpenseFeedItem.new),
                      ...state.recentTransfers.map(_TransferFeedItem.new),
                    ]..sort((a, b) => b.date.compareTo(a.date));

                    if (activities.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          child: GlassCard(
                            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                            child: Column(
                              children: [
                                const Text('🍜', style: TextStyle(fontSize: 40)),
                                const SizedBox(height: 10),
                                const Text(
                                  'No transactions logged yet',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Tap the + button below to log your first lunch or coffee!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: () => AddExpenseSheet.show(context),
                                  icon: const Icon(Icons.add, size: 18),
                                  label: const Text('Quick Log'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: const Color(0xFF04291F),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, i) {
                            final act = activities[i];
                            if (act is _ExpenseFeedItem) {
                              final item = act.item;
                              final accountBadge = item.account != null
                                  ? ' • ${item.account!.icon} ${item.account!.name}'
                                  : '';

                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.outline.withValues(alpha: 0.5)),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Color(item.category.colorHex).withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        item.category.icon,
                                        style: const TextStyle(fontSize: 22),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.expense.note ?? item.category.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${item.category.name}$accountBadge • ${DateFormat('dd MMM').format(item.expense.date)}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '-${Money(item.expense.amountSen).formatted}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else if (act is _TransferFeedItem) {
                              final trans = act.item;
                              final fromName = trans.fromAccount?.name ?? 'Account';
                              final toName = trans.toAccount?.name ?? 'Account';
                              final noteText = trans.transfer.note != null ? ' • ${trans.transfer.note}' : '';

                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.accent.withValues(alpha: 0.25)),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: AppColors.accent.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.sync_alt_rounded,
                                        color: AppColors.accent,
                                        size: 22,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '$fromName → $toName',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Transfer$noteText • ${DateFormat('dd MMM').format(trans.transfer.date)}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.accent.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        Money(trans.transfer.amountSen).formatted,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: AppColors.accent,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                          childCount: activities.take(5).length,
                        ),
                      ),
                    );
                  },
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 90)),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => AddExpenseSheet.show(context),
        backgroundColor: AppColors.primary,
        foregroundColor: const Color(0xFF04291F),
        elevation: 4,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Log Expense', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildMiniBucketCard({
    required String label,
    required String amount,
    required Color color,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
