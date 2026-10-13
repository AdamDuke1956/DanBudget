import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/app_icons.dart';
import '../../core/utils/money.dart';
import '../../core/widgets/animated_counter.dart';
import '../../data/models/expense_with_category.dart';
import '../../data/providers/database_providers.dart';
import '../../data/providers/dashboard_provider.dart';
import 'widgets/add_expense_sheet.dart';

class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key});

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
  int _viewMode = 0; // 0: Daily Ledger, 1: Category Breakdown
  String _selectedCategoryFilter = 'all';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatDayHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final target = DateTime(date.year, date.month, date.day);

    if (target == today) {
      return 'Today, ${DateFormat('d MMM').format(date)}';
    } else if (target == yesterday) {
      return 'Yesterday, ${DateFormat('d MMM').format(date)}';
    } else {
      return DateFormat('EEE, d MMM yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final expensesAsync = ref.watch(recentExpensesStreamProvider);
    final categoriesAsync = ref.watch(categoriesStreamProvider);
    final dashboardAsync = ref.watch(dashboardStateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Expense Log',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: -0.3),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline_rounded, color: AppColors.primary, size: 24),
            tooltip: 'Add Expense',
            onPressed: () => AddExpenseSheet.show(context),
          ),
        ],
      ),
      body: expensesAsync.when(
        loading: () => Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, _) => Center(
          child: Text('Error: $err', style: TextStyle(color: AppColors.danger)),
        ),
        data: (allExpenses) {
          // Category filter
          var filtered = _selectedCategoryFilter == 'all'
              ? allExpenses
              : allExpenses.where((e) => e.category.id == _selectedCategoryFilter).toList();

          // Search query filter
          if (_searchQuery.trim().isNotEmpty) {
            final query = _searchQuery.trim().toLowerCase();
            filtered = filtered.where((e) {
              final note = (e.expense.note ?? '').toLowerCase();
              final cat = e.category.name.toLowerCase();
              final acc = (e.account?.name ?? '').toLowerCase();
              return note.contains(query) || cat.contains(query) || acc.contains(query);
            }).toList();
          }

          final int totalFilteredSen = filtered.fold(0, (sum, e) => sum + e.expense.amountSen);

          // Calculate category totals for smart chips and breakdown
          final Map<String, int> categoryTotals = {};
          final Map<String, int> categoryCounts = {};
          for (final item in allExpenses) {
            categoryTotals[item.category.id] =
                (categoryTotals[item.category.id] ?? 0) + item.expense.amountSen;
            categoryCounts[item.category.id] =
                (categoryCounts[item.category.id] ?? 0) + 1;
          }

          // Group by day for clear visual ledger
          final Map<DateTime, List<ExpenseWithCategory>> groupedByDate = {};
          for (final item in filtered) {
            final dayKey = DateTime(
              item.expense.date.year,
              item.expense.date.month,
              item.expense.date.day,
            );
            groupedByDate.putIfAbsent(dayKey, () => []).add(item);
          }
          final sortedDays = groupedByDate.keys.toList()..sort((a, b) => b.compareTo(a));

          return Stack(
            children: [
              CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                slivers: [
                  // 1. Executive Spending Analytics Banner
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColors.cardBorder),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: AppColors.isDark ? 0.25 : 0.04),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _selectedCategoryFilter == 'all'
                                      ? 'Total Recorded Spending'
                                      : 'Filtered Category Spending',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${filtered.length} entries',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            AnimatedMoneyCounter(
                              sen: totalFilteredSen,
                              style: AppTypography.moneyAmount(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            dashboardAsync.maybeWhen(
                              data: (dash) {
                                final totalBudget = dash.totalSpentThisCycle.sen + dash.remainingFlexibleBudget.sen;
                                final velocityPercent = totalBudget > 0
                                    ? (dash.totalSpentThisCycle.sen / totalBudget)
                                    : 0.0;
                                final isOnTrack = velocityPercent <= 0.8;
                                final paceColor = isOnTrack ? AppColors.success : AppColors.warning;
                                final paceLabel = isOnTrack ? 'Pace: On Track' : 'Pace: High Velocity';

                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.bolt_rounded, size: 14, color: AppColors.accent),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Daily safe pace: ${dash.safeToSpend.safeDailyAmount.formatted}/day',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: paceColor.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: paceColor.withValues(alpha: 0.35)),
                                      ),
                                      child: Text(
                                        paceLabel,
                                        style: TextStyle(
                                          color: paceColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                              orElse: () => const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 2. View Perspective Segmented Control (Linear modern tab bar)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.outline.withValues(alpha: 0.5)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _viewMode = 0),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: _viewMode == 0 ? AppColors.primary : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.format_list_bulleted_rounded,
                                        size: 16,
                                        color: _viewMode == 0 ? AppColors.onPrimary : AppColors.textSecondary,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Daily Ledger',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: _viewMode == 0 ? AppColors.onPrimary : AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _viewMode = 1),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: _viewMode == 1 ? AppColors.primary : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.pie_chart_outline_rounded,
                                        size: 16,
                                        color: _viewMode == 1 ? AppColors.onPrimary : AppColors.textSecondary,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Category Breakdown',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: _viewMode == 1 ? AppColors.onPrimary : AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 3. Search Box
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.outline.withValues(alpha: 0.6)),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (val) => setState(() => _searchQuery = val),
                          style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Search notes, merchant, or account...',
                            hintStyle: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.7), fontSize: 13),
                            prefixIcon: Icon(Icons.search_rounded, size: 20, color: AppColors.textSecondary),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.clear_rounded, size: 18, color: AppColors.textSecondary),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() => _searchQuery = '');
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 4. Smart Category Pills with Spend Amounts
                  SliverToBoxAdapter(
                    child: categoriesAsync.when(
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                      data: (categories) {
                        final allTotalSen = allExpenses.fold(0, (s, e) => s + e.expense.amountSen);
                        return Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 6),
                          child: SizedBox(
                            height: 44,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: _buildCategoryChip(
                                    label: 'All (${Money(allTotalSen).formatted})',
                                    isSelected: _selectedCategoryFilter == 'all',
                                    color: AppColors.primary,
                                    icon: Icons.apps_rounded,
                                    onTap: () => setState(() => _selectedCategoryFilter = 'all'),
                                  ),
                                ),
                                ...categories.map((cat) {
                                  final isSelected = _selectedCategoryFilter == cat.id;
                                  final catColor = Color(cat.colorHex);
                                  final catSpentSen = categoryTotals[cat.id] ?? 0;
                                  final iconData = AppIcons.getCategoryIcon(cat.name);

                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: _buildCategoryChip(
                                      label: '${cat.name} • ${Money(catSpentSen).formatted}',
                                      isSelected: isSelected,
                                      color: catColor,
                                      icon: iconData,
                                      onTap: () => setState(() => _selectedCategoryFilter = cat.id),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // 5. Dynamic Content View (Ledger Mode vs Category Mode)
                  if (_viewMode == 0) ...[
                    // LEDGER MODE
                    if (filtered.isEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 36, 20, 36),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.receipt_long_rounded,
                                    size: 32,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  _searchQuery.isNotEmpty ? 'No matches found' : 'No transactions recorded',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _searchQuery.isNotEmpty
                                      ? 'Try searching another keyword or clearing the filter.'
                                      : 'Tap the button below to record your first spend.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, dayIndex) {
                              final day = sortedDays[dayIndex];
                              final dayItems = groupedByDate[day]!;
                              final dayTotalSen = dayItems.fold<int>(0, (sum, item) => sum + item.expense.amountSen);

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(4, 14, 4, 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _formatDayHeader(day),
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textSecondary,
                                            letterSpacing: 0.2,
                                          ),
                                        ),
                                        Text(
                                          Money(dayTotalSen).formatted,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.surface,
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                        color: AppColors.outline.withValues(alpha: 0.5),
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(18),
                                      child: ListView.separated(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        itemCount: dayItems.length,
                                        separatorBuilder: (_, __) => Divider(
                                          height: 1,
                                          indent: 64,
                                          endIndent: 16,
                                          color: AppColors.outline.withValues(alpha: 0.35),
                                        ),
                                        itemBuilder: (context, itemIndex) {
                                          final item = dayItems[itemIndex];
                                          final catColor = Color(item.category.colorHex);

                                          return Dismissible(
                                            key: Key('expense_${item.expense.id}'),
                                            direction: DismissDirection.endToStart,
                                            background: Container(
                                              alignment: Alignment.centerRight,
                                              padding: const EdgeInsets.only(right: 20),
                                              color: AppColors.danger.withValues(alpha: 0.25),
                                              child: Icon(Icons.delete_outline_rounded, color: AppColors.danger),
                                            ),
                                            onDismissed: (_) {
                                              ref.read(expenseRepositoryProvider).deleteExpense(item.expense.id);
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  backgroundColor: AppColors.surfaceHigh,
                                                  content: Text(
                                                    'Deleted ${item.expense.note ?? item.category.name}',
                                                    style: TextStyle(color: AppColors.textPrimary),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: InkWell(
                                              onTap: () => AddExpenseSheet.edit(context, item),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                                child: Row(
                                                  children: [
                                                    AppIcons.badge(
                                                      icon: AppIcons.getCategoryIcon(item.category.name),
                                                      color: catColor,
                                                      size: 18,
                                                      containerSize: 40,
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
                                                            '${item.category.name}${item.account != null ? ' • ${item.account!.name}' : ''}',
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              color: AppColors.textSecondary,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
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
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                            childCount: sortedDays.length,
                          ),
                        ),
                      ),
                  ] else ...[
                    // CATEGORY BREAKDOWN MODE
                    categoriesAsync.when(
                      loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
                      error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
                      data: (categories) {
                        final totalAllSen = allExpenses.fold<int>(0, (s, e) => s + e.expense.amountSen);

                        return SliverPadding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, i) {
                                final cat = categories[i];
                                final spentSen = categoryTotals[cat.id] ?? 0;
                                final count = categoryCounts[cat.id] ?? 0;
                                final double ratio = totalAllSen > 0 ? (spentSen / totalAllSen) : 0.0;
                                final catColor = Color(cat.colorHex);

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(color: AppColors.outline.withValues(alpha: 0.5)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          AppIcons.badge(
                                            icon: AppIcons.getCategoryIcon(cat.name),
                                            color: catColor,
                                            size: 18,
                                            containerSize: 38,
                                            borderRadius: 10,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  cat.name,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: AppColors.textPrimary,
                                                  ),
                                                ),
                                                Text(
                                                  '$count transactions',
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
                                                Money(spentSen).formatted,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 15,
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                              Text(
                                                '${(ratio * 100).toStringAsFixed(1)}% of total',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: catColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: LinearProgressIndicator(
                                          value: ratio.clamp(0.0, 1.0),
                                          minHeight: 6,
                                          backgroundColor: AppColors.outline.withValues(alpha: 0.3),
                                          valueColor: AlwaysStoppedAnimation(catColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              childCount: categories.length,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),

              // Sticky Thumb-Zone Action Dock
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
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => AddExpenseSheet.show(context),
                          icon: const Icon(Icons.add_rounded, size: 20),
                          label: const Text(
                            'Log Expense',
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
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategoryChip({
    required String label,
    required bool isSelected,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.18) : AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? color : AppColors.outline.withValues(alpha: 0.6),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 14,
                color: isSelected ? color : AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? color : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
