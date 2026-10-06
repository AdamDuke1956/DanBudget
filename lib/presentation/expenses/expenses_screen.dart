import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/money.dart';
import '../../core/widgets/glass_card.dart';
import '../../data/providers/database_providers.dart';
import 'widgets/add_expense_sheet.dart';

class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key});

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
  String _selectedCategoryFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final expensesAsync = ref.watch(recentExpensesStreamProvider);
    final categoriesAsync = ref.watch(categoriesStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Expense Log',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary),
            onPressed: () => AddExpenseSheet.show(context),
          ),
        ],
      ),
      body: expensesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, _) => Center(
          child: Text('Error: $err', style: const TextStyle(color: AppColors.danger)),
        ),
        data: (allExpenses) {
          // Filter expenses
          final filteredExpenses = _selectedCategoryFilter == 'all'
              ? allExpenses
              : allExpenses
                  .where((e) => e.category.id == _selectedCategoryFilter)
                  .toList();

          final int totalFilteredSen = filteredExpenses.fold(
            0,
            (sum, e) => sum + e.expense.amountSen,
          );

          return Column(
            children: [
              // Monthly total banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Filtered Spending',
                            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            Money(totalFilteredSen).formatted,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${filteredExpenses.length} items',
                          style: const TextStyle(
                            color: AppColors.accent,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Category filter pills
              categoriesAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (categories) {
                  return SizedBox(
                    height: 48,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: const Text('All'),
                            selected: _selectedCategoryFilter == 'all',
                            selectedColor: AppColors.primary,
                            backgroundColor: AppColors.surface,
                            labelStyle: TextStyle(
                              color: _selectedCategoryFilter == 'all'
                                  ? const Color(0xFF04291F)
                                  : AppColors.textSecondary,
                              fontWeight: FontWeight.bold,
                            ),
                            side: const BorderSide(color: AppColors.outline),
                            onSelected: (_) => setState(() => _selectedCategoryFilter = 'all'),
                          ),
                        ),
                        ...categories.map((cat) {
                          final isSelected = _selectedCategoryFilter == cat.id;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text('${cat.icon} ${cat.name}'),
                              selected: isSelected,
                              selectedColor: Color(cat.colorHex).withValues(alpha: 0.25),
                              backgroundColor: AppColors.surface,
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? Color(cat.colorHex)
                                    : AppColors.textSecondary,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                              side: BorderSide(
                                color: isSelected ? Color(cat.colorHex) : AppColors.outline,
                              ),
                              onSelected: (_) => setState(() => _selectedCategoryFilter = cat.id),
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),

              // Expense list
              Expanded(
                child: filteredExpenses.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('📋', style: TextStyle(fontSize: 44)),
                            const SizedBox(height: 12),
                            const Text(
                              'No transactions found',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _selectedCategoryFilter == 'all'
                                  ? 'Log an expense to start tracking'
                                  : 'No expenses under this category',
                              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        itemCount: filteredExpenses.length,
                        itemBuilder: (context, i) {
                          final item = filteredExpenses[i];
                          return Dismissible(
                            key: Key('expense_${item.expense.id}'),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: AppColors.danger.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(Icons.delete_outline_rounded, color: AppColors.danger),
                            ),
                            onDismissed: (_) {
                              ref.read(expenseRepositoryProvider).deleteExpense(item.expense.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: AppColors.surfaceHigh,
                                  content: Text(
                                    'Deleted ${item.expense.note ?? item.category.name}',
                                    style: const TextStyle(color: AppColors.textPrimary),
                                  ),
                                ),
                              );
                            },
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () => AddExpenseSheet.edit(context, item),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.outline.withValues(alpha: 0.5),
                                  ),
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
                                            '${item.category.name}${item.account != null ? ' • ${item.account!.icon} ${item.account!.name}' : ''} • ${DateFormat('EEE, dd MMM yyyy').format(item.expense.date)}',
                                            style: const TextStyle(
                                              fontSize: 11,
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
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AddExpenseSheet.show(context),
        backgroundColor: AppColors.primary,
        foregroundColor: const Color(0xFF04291F),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
