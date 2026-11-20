import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/surface_card.dart';
import '../../data/providers/dashboard_provider.dart';
import '../expenses/widgets/add_expense_sheet.dart';
import 'widgets/budget_split_strip_card.dart';
import 'widgets/commitments_summary_strip.dart';
import 'widgets/daily_spending_calendar_sheet.dart';
import 'widgets/home_status_header.dart';
import 'widgets/money_on_hand_hero.dart';
import 'widgets/recent_activity_section.dart';
import 'widgets/safe_to_spend_card.dart';

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
  String _activityFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final stateAsync = ref.watch(dashboardStateProvider);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: stateAsync.when(
          loading: () => Center(
            child: CircularProgressIndicator(color: colors.primary),
          ),
          error: (err, _) => Center(
            child: Text('Error: $err', style: TextStyle(color: colors.danger)),
          ),
          data: (state) {
            final List<ActivityFeedItem> allActivities = [
              ...state.recentExpenses.map(ExpenseFeedItem.new),
              ...state.recentTransfers.map(TransferFeedItem.new),
            ]..sort((a, b) => b.date.compareTo(a.date));

            final filteredActivities = allActivities.where((act) {
              if (_activityFilter == 'expenses') return act is ExpenseFeedItem;
              if (_activityFilter == 'transfers') return act is TransferFeedItem;
              return true;
            }).toList();

            return Stack(
              children: [
                CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                        child: HomeStatusHeader(
                          state: state,
                          onOpenMore: () => widget.onNavigateToTab?.call(4),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
                        child: SafeToSpendCard(state: state),
                      ),
                    ),
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
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                        child: BudgetSplitStripCard(
                          allocation: state.allocation,
                          onViewPlan: () => widget.onNavigateToTab?.call(2),
                        ),
                      ),
                    ),
                    if (state.activeCommitments.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                          child: CommitmentsSummaryStrip(
                            state: state,
                            onManage: () => widget.onNavigateToTab?.call(3),
                          ),
                        ),
                      ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                        child: RecentActivityHeader(
                          activeFilter: _activityFilter,
                          onFilterChanged: (val) => setState(() => _activityFilter = val),
                        ),
                      ),
                    ),
                    if (filteredActivities.isEmpty)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          child: RecentActivityEmptyCard(),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, i) => ActivityFeedRow(activity: filteredActivities[i]),
                            childCount: filteredActivities.take(6).length,
                          ),
                        ),
                      ),
                    const SliverToBoxAdapter(child: SizedBox(height: 100)),
                  ],
                ),
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 16,
                  child: SurfaceCard(
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
                              backgroundColor: colors.primary,
                              foregroundColor: colors.onPrimary,
                              elevation: 0,
                              minimumSize: const Size(0, 48),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () => DailySpendingCalendarSheet.show(context),
                          icon: Icon(Icons.calendar_month_rounded, color: colors.textPrimary, size: 22),
                          tooltip: 'Daily Calendar',
                          style: IconButton.styleFrom(
                            backgroundColor: colors.surfaceHigh,
                            padding: const EdgeInsets.all(12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
}
