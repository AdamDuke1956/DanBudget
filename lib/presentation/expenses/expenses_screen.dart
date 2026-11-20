import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/app_icons.dart';
import '../../core/utils/money.dart';
import '../../core/widgets/surface_card.dart';
import '../../data/providers/database_providers.dart';
import '../../data/providers/dashboard_provider.dart';
import '../tax/tax_optimizer_screen.dart';
import 'widgets/add_expense_sheet.dart';
import 'widgets/expense_filters.dart';
import 'widgets/expense_ledger.dart';
import 'widgets/expense_summary_card.dart';

class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key});

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
  ExpenseView _view = ExpenseView.ledger;
  String _selectedCategoryFilter = 'all';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final expensesAsync = ref.watch(recentExpensesStreamProvider);
    final categoriesAsync = ref.watch(categoriesStreamProvider);
    final dashboardAsync = ref.watch(dashboardStateProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text(
          'Expense Log',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: -0.3,
          ),
        ),
        backgroundColor: colors.background,
        elevation: 0,
        actions: [
          if (!(dashboardAsync.value?.employmentType.isIntern ?? false))
            IconButton(
              icon: Icon(
                Icons.account_balance_rounded,
                color: colors.accent,
                size: 22,
              ),
              tooltip: 'LHDN Tax Relief Classifier',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const TaxOptimizerScreen()),
                );
              },
            ),
          IconButton(
            icon: Icon(
              Icons.add_circle_outline_rounded,
              color: colors.primary,
              size: 24,
            ),
            tooltip: 'Add Expense',
            onPressed: () => AddExpenseSheet.show(context),
          ),
        ],
      ),
      body: expensesAsync.when(
        loading:
            () =>
                Center(child: CircularProgressIndicator(color: colors.primary)),
        error:
            (err, _) => Center(
              child: Text(
                'Error: $err',
                style: TextStyle(color: colors.danger),
              ),
            ),
        data: (allExpenses) {
          var filtered =
              _selectedCategoryFilter == 'all'
                  ? allExpenses
                  : allExpenses
                      .where((e) => e.category.id == _selectedCategoryFilter)
                      .toList();

          if (_searchQuery.trim().isNotEmpty) {
            final query = _searchQuery.trim().toLowerCase();
            filtered =
                filtered.where((e) {
                  final note = (e.expense.note ?? '').toLowerCase();
                  final cat = e.category.name.toLowerCase();
                  final acc = (e.account?.name ?? '').toLowerCase();
                  return note.contains(query) ||
                      cat.contains(query) ||
                      acc.contains(query);
                }).toList();
          }

          final int totalFilteredSen = filtered.fold(
            0,
            (sum, e) => sum + e.expense.amountSen,
          );

          final Map<String, int> categoryTotals = {};
          final Map<String, int> categoryCounts = {};
          var totalAllSen = 0;
          for (final item in allExpenses) {
            totalAllSen += item.expense.amountSen;
            categoryTotals[item.category.id] =
                (categoryTotals[item.category.id] ?? 0) +
                item.expense.amountSen;
            categoryCounts[item.category.id] =
                (categoryCounts[item.category.id] ?? 0) + 1;
          }

          return Stack(
            children: [
              CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  SliverToBoxAdapter(
                    child: ExpenseSummaryCard(
                      totalSen: totalFilteredSen,
                      entryCount: filtered.length,
                      hasCategoryFilter: _selectedCategoryFilter != 'all',
                      dashboard: dashboardAsync.maybeWhen(
                        data: (value) => value,
                        orElse: () => null,
                      ),
                    ),
                  ),
                  ExpenseFilters(
                    view: _view,
                    onViewChanged: (value) => setState(() => _view = value),
                    searchController: _searchController,
                    searchQuery: _searchQuery,
                    onSearchChanged:
                        (value) => setState(() => _searchQuery = value),
                    categories: categoriesAsync.maybeWhen(
                      data: (value) => value,
                      orElse: () => null,
                    ),
                    totalSen: totalAllSen,
                    categoryTotals: categoryTotals,
                    categoryFilter: _selectedCategoryFilter,
                    onCategoryChanged:
                        (value) =>
                            setState(() => _selectedCategoryFilter = value),
                  ),
                  if (_view == ExpenseView.ledger)
                    ExpenseLedger(
                      expenses: filtered,
                      hasSearch: _searchQuery.isNotEmpty,
                      onEdit: (item) => AddExpenseSheet.edit(context, item),
                      onDelete:
                          (item) => ref
                              .read(expenseRepositoryProvider)
                              .deleteExpense(item.expense.id),
                    )
                  else
                    categoriesAsync.when(
                      loading:
                          () => const SliverToBoxAdapter(
                            child: SizedBox.shrink(),
                          ),
                      error:
                          (_, __) => const SliverToBoxAdapter(
                            child: SizedBox.shrink(),
                          ),
                      data: (categories) {
                        return SliverPadding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate((context, i) {
                              final cat = categories[i];
                              final spentSen = categoryTotals[cat.id] ?? 0;
                              final count = categoryCounts[cat.id] ?? 0;
                              final double ratio =
                                  totalAllSen > 0
                                      ? (spentSen / totalAllSen)
                                      : 0.0;
                              final catColor = Color(cat.colorHex);

                              return SurfaceCard(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        AppIcons.badge(
                                          icon: AppIcons.getCategoryIcon(
                                            cat.name,
                                          ),
                                          color: catColor,
                                          size: 18,
                                          containerSize: 38,
                                          borderRadius: 10,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                cat.name,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                  color: colors.textPrimary,
                                                ),
                                              ),
                                              Text(
                                                '$count transactions',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: colors.textSecondary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          flex: 3,
                                          child: Align(
                                            alignment:
                                                AlignmentDirectional.centerEnd,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  Money(spentSen).formatted,
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 15,
                                                    color: colors.textPrimary,
                                                  ),
                                                ),
                                                Text(
                                                  '${(ratio * 100).toStringAsFixed(1)}% of total',
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    color: colors.textSecondary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: LinearProgressIndicator(
                                        value: ratio.clamp(0.0, 1.0),
                                        minHeight: 6,
                                        backgroundColor: colors.outline
                                            .withValues(alpha: 0.3),
                                        valueColor: AlwaysStoppedAnimation(
                                          catColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }, childCount: categories.length),
                          ),
                        );
                      },
                    ),
                ],
              ),

              Positioned(
                left: 20,
                right: 20,
                bottom: 16,
                child: SurfaceCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => AddExpenseSheet.show(context),
                      icon: const Icon(Icons.add_rounded, size: 20),
                      label: const Text('Log Expense'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        foregroundColor: colors.onPrimary,
                        elevation: 0,
                        minimumSize: const Size(0, 48),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
