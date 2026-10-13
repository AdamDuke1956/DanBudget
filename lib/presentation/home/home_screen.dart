import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/app_icons.dart';
import '../../core/utils/money.dart';
import '../../core/widgets/animated_counter.dart';
import '../../data/models/transfer_with_accounts.dart';
import '../../data/models/expense_with_category.dart';
import '../../data/providers/dashboard_provider.dart';
import '../expenses/widgets/add_expense_sheet.dart';
import 'widgets/daily_spending_calendar_sheet.dart';
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

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({
    super.key,
    this.onNavigateToTab,
  });

  final void Function(int tabIndex)? onNavigateToTab;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _activityFilter = 'all'; // 'all', 'expenses', 'transfers'

  @override
  Widget build(BuildContext context) {
    final stateAsync = ref.watch(dashboardStateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: stateAsync.when(
          loading: () => Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (err, stack) => Center(
            child: Text('Error: $err', style: TextStyle(color: AppColors.danger)),
          ),
          data: (state) {
            final profile = state.profile;
            final safe = state.safeToSpend;
            final alloc = state.allocation;

            return Stack(
              children: [
                CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                  slivers: [
                    // 1. Executive Status Header (Linear minimal clean status)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => widget.onNavigateToTab?.call(4), // More tab
                                    child: Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: AppColors.surface,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.primary.withValues(alpha: 0.35),
                                          width: 1.5,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        state.employmentType.emoji.isNotEmpty
                                            ? state.employmentType.emoji
                                            : (profile.name.isNotEmpty ? profile.name[0].toUpperCase() : 'D'),
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Welcome, ${profile.name.isNotEmpty ? profile.name : 'Friend'}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                            letterSpacing: -0.3,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Net Salary: ${state.netSalary.netSalary.formatted}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Health Grade Pill
                            GestureDetector(
                              onTap: () => widget.onNavigateToTab?.call(4),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: AppColors.primary.withValues(alpha: 0.35),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.shield_rounded, size: 14, color: AppColors.primary),
                                    const SizedBox(width: 5),
                                    Text(
                                      'Grade ${state.healthScore.grade}',
                                      style: TextStyle(
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

                    // 2. Primary Command Module: Safe-to-Spend Today
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: AppColors.heroGradient,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: AppColors.cardBorder),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: AppColors.isDark ? 0.3 : 0.05),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Icon(Icons.bolt_rounded, size: 16, color: AppColors.primary),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Safe-to-Spend Today',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: AppColors.textPrimary,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: -0.2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () => DailySpendingCalendarSheet.show(context),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: AppColors.surface.withValues(alpha: 0.85),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: AppColors.subtleBorder),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.hourglass_bottom_rounded, size: 12, color: AppColors.accent),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${safe.daysUntilPayday}d to payday',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 8,
                                runSpacing: 4,
                                children: [
                                  AnimatedMoneyCounter(
                                    sen: (safe.todayCustomTarget ?? safe.safeDailyAmount).sen,
                                    style: AppTypography.moneyAmount(
                                      fontSize: 38,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    safe.todayCustomTarget != null ? '/ today' : '/ day',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: safe.todayCustomTarget != null ? AppColors.primary : AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              if (safe.todayCustomTarget != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'Standard safe base: ${safe.safeDailyAmount.formatted}/day',
                                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                ),
                              ],
                              const SizedBox(height: 14),
                              // Spending Cycle Progress
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          'Spent: ${state.totalSpentThisCycle.formatted}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          'Buffer Left: ${state.remainingFlexibleBudget.formatted}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  AnimatedProgressBar(
                                    value: (state.totalSpentThisCycle.sen + state.remainingFlexibleBudget.sen) > 0
                                        ? (state.remainingFlexibleBudget.sen /
                                                (state.totalSpentThisCycle.sen + state.remainingFlexibleBudget.sen))
                                            .clamp(0.0, 1.0)
                                        : 1.0,
                                    color: AppColors.primary,
                                    backgroundColor: AppColors.isDark
                                        ? AppColors.surfaceHigh.withValues(alpha: 0.6)
                                        : AppColors.outline.withValues(alpha: 0.6),
                                    height: 7,
                                    borderRadius: 6,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () => AddExpenseSheet.show(context),
                                      icon: const Icon(Icons.add_rounded, size: 18),
                                      label: const FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text('Log Spend', style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        foregroundColor: AppColors.onPrimary,
                                        minimumSize: const Size(0, 44),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () => DailySpendingCalendarSheet.show(context),
                                      icon: const Icon(Icons.calendar_month_rounded, size: 16),
                                      label: const FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text('Calendar', style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: AppColors.textPrimary,
                                        side: BorderSide(color: AppColors.cardBorder),
                                        minimumSize: const Size(0, 44),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // 3. Liquid Assets Hero: Money on Hand
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 2, 20, 8),
                        child: MoneyOnHandHero(
                          totalLiquidOnHand: state.totalLiquidOnHand,
                          accounts: state.accounts,
                          isLiquidityConstrained: state.safeToSpend.isLiquidityConstrained,
                        ),
                      ),
                    ),

                    // 4. Strategic Budget Allocation Strip (40/30/20/10 Split)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: AppColors.outline.withValues(alpha: 0.6)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${(alloc.needs.percentage * 100).round()}/${(alloc.wants.percentage * 100).round()}/${(alloc.savings.percentage * 100).round()}/${(alloc.giving.percentage * 100).round()} Budget Split',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () => widget.onNavigateToTab?.call(2), // Plan tab
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'View Plan',
                                          style: TextStyle(
                                            color: AppColors.accent,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Icon(Icons.arrow_forward_rounded, size: 13, color: AppColors.accent),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Multi-segment progress bar
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: SizedBox(
                                  height: 8,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: (alloc.needs.percentage * 100).round().clamp(1, 100),
                                        child: Container(color: AppColors.needs),
                                      ),
                                      const SizedBox(width: 2),
                                      Expanded(
                                        flex: (alloc.wants.percentage * 100).round().clamp(1, 100),
                                        child: Container(color: AppColors.wants),
                                      ),
                                      const SizedBox(width: 2),
                                      Expanded(
                                        flex: (alloc.savings.percentage * 100).round().clamp(1, 100),
                                        child: Container(color: AppColors.savings),
                                      ),
                                      const SizedBox(width: 2),
                                      Expanded(
                                        flex: (alloc.giving.percentage * 100).round().clamp(1, 100),
                                        child: Container(color: AppColors.giving),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildBucketPill(
                                      title: 'Needs',
                                      pct: (alloc.needs.percentage * 100).round(),
                                      amount: alloc.needs.targetAmount.formatted,
                                      color: AppColors.needs,
                                      icon: Icons.home_rounded,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _buildBucketPill(
                                      title: 'Wants',
                                      pct: (alloc.wants.percentage * 100).round(),
                                      amount: alloc.wants.targetAmount.formatted,
                                      color: AppColors.wants,
                                      icon: Icons.coffee_rounded,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildBucketPill(
                                      title: 'Savings',
                                      pct: (alloc.savings.percentage * 100).round(),
                                      amount: alloc.savings.targetAmount.formatted,
                                      color: AppColors.savings,
                                      icon: Icons.savings_rounded,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _buildBucketPill(
                                      title: 'Giving',
                                      pct: (alloc.giving.percentage * 100).round(),
                                      amount: alloc.giving.targetAmount.formatted,
                                      color: AppColors.giving,
                                      icon: Icons.volunteer_activism_rounded,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // 5. Commitments & DSR Alert Strip (if active commitments exist)
                    if (state.activeCommitments.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.outline.withValues(alpha: 0.6)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: (state.allocation.dsrRatio > 0.4 ? AppColors.warning : AppColors.accent)
                                        .withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Icon(
                                    Icons.account_balance_wallet_rounded,
                                    color: state.allocation.dsrRatio > 0.4 ? AppColors.warning : AppColors.accent,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${state.activeCommitments.length} Active Commitments',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Total: ${state.allocation.totalCommitments.formatted}/mo (DSR: ${(state.allocation.dsrRatio * 100).toStringAsFixed(1)}%)',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => widget.onNavigateToTab?.call(3), // Commitments tab
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Manage',
                                        style: TextStyle(
                                          color: AppColors.accent,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(width: 2),
                                      Icon(Icons.arrow_forward_rounded, size: 12, color: AppColors.accent),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    // 6. Recent Activity Header & Segmented Filter Tabs
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                'Recent Activity',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildActivityFilterChip('All', 'all'),
                                  const SizedBox(width: 6),
                                  _buildActivityFilterChip('Expenses', 'expenses'),
                                  const SizedBox(width: 6),
                                  _buildActivityFilterChip('Transfers', 'transfers'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 7. Activity Stream List
                    Builder(
                      builder: (context) {
                        final List<_ActivityFeedItem> allActivities = [
                          ...state.recentExpenses.map(_ExpenseFeedItem.new),
                          ...state.recentTransfers.map(_TransferFeedItem.new),
                        ]..sort((a, b) => b.date.compareTo(a.date));

                        final filtered = allActivities.where((act) {
                          if (_activityFilter == 'expenses') return act is _ExpenseFeedItem;
                          if (_activityFilter == 'transfers') return act is _TransferFeedItem;
                          return true;
                        }).toList();

                        if (filtered.isEmpty) {
                          return SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: AppColors.outline.withValues(alpha: 0.6)),
                                ),
                                child: Column(
                                  children: [
                                    Icon(Icons.receipt_long_rounded, size: 36, color: AppColors.primary),
                                    const SizedBox(height: 10),
                                    Text(
                                      'No transactions found',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Log your first expense or perform a transfer!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
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
                                final act = filtered[i];
                                if (act is _ExpenseFeedItem) {
                                  final item = act.item;
                                  final accountBadge = item.account != null ? ' • ${item.account!.name}' : '';

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
                                        AppIcons.badge(
                                          icon: AppIcons.getCategoryIcon(item.category.name),
                                          color: Color(item.category.colorHex),
                                          size: 18,
                                          containerSize: 42,
                                          borderRadius: 12,
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
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                '${item.category.name}$accountBadge • ${DateFormat('dd MMM').format(item.expense.date)}',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: AppColors.textSecondary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          '-${Money(item.expense.amountSen).formatted}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
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
                                          width: 42,
                                          height: 42,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: AppColors.accent.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Icon(
                                            Icons.sync_alt_rounded,
                                            color: AppColors.accent,
                                            size: 20,
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
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                'Transfer$noteText • ${DateFormat('dd MMM').format(trans.transfer.date)}',
                                                style: TextStyle(
                                                  fontSize: 11,
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
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
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
                              childCount: filtered.take(6).length,
                            ),
                          ),
                        );
                      },
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 100)),
                  ],
                ),

                // Floating Thumb Zone Action Dock (Reachable within bottom 60%)
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.outline.withValues(alpha: 0.8)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: AppColors.isDark ? 0.35 : 0.08),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => AddExpenseSheet.show(context),
                            icon: const Icon(Icons.add_rounded, size: 20),
                            label: const Text(
                              'Log Spend',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.onPrimary,
                              elevation: 0,
                              minimumSize: const Size(0, 48),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () => DailySpendingCalendarSheet.show(context),
                          icon: Icon(Icons.calendar_month_rounded, color: AppColors.textPrimary, size: 22),
                          tooltip: 'Daily Calendar',
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.surfaceHigh,
                            padding: const EdgeInsets.all(12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBucketPill({
    required String title,
    required int pct,
    required String amount,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$pct% $title',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  amount,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityFilterChip(String label, String value) {
    final isSelected = _activityFilter == value;
    return GestureDetector(
      onTap: () => setState(() => _activityFilter = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.16) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outline.withValues(alpha: 0.6),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
