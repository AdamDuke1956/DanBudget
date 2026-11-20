import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_icons.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../data/models/expense_with_category.dart';

class ExpenseLedger extends StatelessWidget {
  const ExpenseLedger({
    super.key,
    required this.expenses,
    required this.hasSearch,
    required this.onEdit,
    required this.onDelete,
  });

  final List<ExpenseWithCategory> expenses;
  final bool hasSearch;
  final ValueChanged<ExpenseWithCategory> onEdit;
  final ValueChanged<ExpenseWithCategory> onDelete;

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return SliverToBoxAdapter(child: _EmptyLedger(hasSearch: hasSearch));
    }

    final groups = <DateTime, List<ExpenseWithCategory>>{};
    for (final item in expenses) {
      final date = item.expense.date;
      final day = DateTime(date.year, date.month, date.day);
      groups.putIfAbsent(day, () => []).add(item);
    }
    final days = groups.keys.toList()..sort((a, b) => b.compareTo(a));

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
      sliver: SliverList.builder(
        itemCount: days.length,
        itemBuilder: (context, index) {
          final day = days[index];
          return _LedgerDay(
            day: day,
            expenses: groups[day]!,
            onEdit: onEdit,
            onDelete: onDelete,
          );
        },
      ),
    );
  }
}

class _EmptyLedger extends StatelessWidget {
  const _EmptyLedger({required this.hasSearch});

  final bool hasSearch;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 36, 20, 36),
      child: Column(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: colors.primary.withValues(alpha: 0.12),
            child: Icon(
              Icons.receipt_long_rounded,
              size: 32,
              color: colors.primary,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            hasSearch ? 'No matches found' : 'No transactions recorded',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            hasSearch
                ? 'Try another keyword or clear the filter.'
                : 'Tap Log Expense below to record a spend.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _LedgerDay extends StatelessWidget {
  const _LedgerDay({
    required this.day,
    required this.expenses,
    required this.onEdit,
    required this.onDelete,
  });

  final DateTime day;
  final List<ExpenseWithCategory> expenses;
  final ValueChanged<ExpenseWithCategory> onEdit;
  final ValueChanged<ExpenseWithCategory> onDelete;

  String _dayLabel() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    if (day == today) {
      return 'Today, ${DateFormat('d MMM').format(day)}';
    }
    if (day == yesterday) {
      return 'Yesterday, ${DateFormat('d MMM').format(day)}';
    }
    return DateFormat('EEE, d MMM yyyy').format(day);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final totalSen = expenses.fold<int>(
      0,
      (sum, item) => sum + item.expense.amountSen,
    );
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 14, 4, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  _dayLabel(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  Money(totalSen).formatted,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        SurfaceCard(
          padding: EdgeInsets.zero,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: ListView.separated(
              primary: false,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: expenses.length,
              separatorBuilder:
                  (_, __) => Divider(
                    height: 1,
                    indent: 64,
                    endIndent: 16,
                    color: colors.outline.withValues(alpha: 0.35),
                  ),
              itemBuilder: (context, index) {
                final item = expenses[index];
                return _ExpenseRow(
                  item: item,
                  onEdit: () => onEdit(item),
                  onDelete: () => onDelete(item),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _ExpenseRow extends StatelessWidget {
  const _ExpenseRow({
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  final ExpenseWithCategory item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final name = item.expense.note ?? item.category.name;
    final account = item.account;
    final subtitle =
        account == null
            ? item.category.name
            : '${item.category.name} • ${account.name}';

    return Dismissible(
      key: Key('expense_${item.expense.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: colors.danger.withValues(alpha: 0.25),
        child: Icon(Icons.delete_outline_rounded, color: colors.danger),
      ),
      onDismissed: (_) {
        onDelete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: colors.surfaceHigh,
            content: Text(
              'Deleted $name',
              style: TextStyle(color: colors.textPrimary),
            ),
          ),
        );
      },
      child: InkWell(
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: LayoutBuilder(
            builder:
                (context, constraints) => Row(
                  children: [
                    AppIcons.badge(
                      icon: AppIcons.getCategoryIcon(item.category.name),
                      color: Color(item.category.colorHex),
                      size: 18,
                      containerSize: 40,
                      borderRadius: 10,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: constraints.maxWidth * 0.6,
                      ),
                      child: Text(
                        '-${Money(item.expense.amountSen).formatted}',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
          ),
        ),
      ),
    );
  }
}
