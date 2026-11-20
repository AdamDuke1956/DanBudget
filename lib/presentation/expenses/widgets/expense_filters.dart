import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_icons.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../data/local/app_database.dart';

enum ExpenseView { ledger, categories }

class ExpenseFilters extends StatelessWidget {
  const ExpenseFilters({
    super.key,
    required this.view,
    required this.onViewChanged,
    required this.searchController,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.categories,
    required this.totalSen,
    required this.categoryTotals,
    required this.categoryFilter,
    required this.onCategoryChanged,
  });

  final ExpenseView view;
  final ValueChanged<ExpenseView> onViewChanged;
  final TextEditingController searchController;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final List<ExpenseCategoriesTableData>? categories;
  final int totalSen;
  final Map<String, int> categoryTotals;
  final String categoryFilter;
  final ValueChanged<String> onCategoryChanged;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: SurfaceCard(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            padding: const EdgeInsets.all(4),
            borderRadius: 10,
            child: Row(
              children: [
                Expanded(
                  child: _ViewButton(
                    label: 'Daily Ledger',
                    icon: Icons.format_list_bulleted_rounded,
                    selected: view == ExpenseView.ledger,
                    onPressed: () => onViewChanged(ExpenseView.ledger),
                  ),
                ),
                Expanded(
                  child: _ViewButton(
                    label: 'By Category',
                    icon: Icons.pie_chart_outline_rounded,
                    selected: view == ExpenseView.categories,
                    onPressed: () => onViewChanged(ExpenseView.categories),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
            child: TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              style: TextStyle(color: colors.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search notes, merchant, or account...',
                hintStyle: TextStyle(color: colors.textSecondary, fontSize: 13),
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                suffixIcon:
                    searchQuery.isNotEmpty
                        ? IconButton(
                          tooltip: 'Clear search',
                          icon: const Icon(Icons.clear_rounded, size: 18),
                          onPressed: () {
                            searchController.clear();
                            onSearchChanged('');
                          },
                        )
                        : null,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
              ),
            ),
          ),
        ),
        if (categories case final available?)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 6),
              child: SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _CategoryChip(
                      label: 'All (${Money(totalSen).formatted})',
                      selected: categoryFilter == 'all',
                      color: colors.primary,
                      icon: Icons.apps_rounded,
                      onTap: () => onCategoryChanged('all'),
                    ),
                    for (final category in available)
                      _CategoryChip(
                        label:
                            '${category.name} • ${Money(categoryTotals[category.id] ?? 0).formatted}',
                        selected: categoryFilter == category.id,
                        color: Color(category.colorHex),
                        icon: AppIcons.getCategoryIcon(category.name),
                        onTap: () => onCategoryChanged(category.id),
                      ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ViewButton extends StatelessWidget {
  const _ViewButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Semantics(
      selected: selected,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: selected ? colors.primary : null,
          foregroundColor: selected ? colors.onPrimary : colors.textSecondary,
          minimumSize: const Size(0, 44),
          padding: const EdgeInsets.symmetric(horizontal: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 210),
          child: Text(label, maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
        avatar: Icon(icon, size: 14, color: colors.textSecondary),
        onSelected: (_) => onTap(),
        selected: selected,
        showCheckmark: false,
        materialTapTargetSize: MaterialTapTargetSize.padded,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        backgroundColor: colors.surface,
        selectedColor: colors.surfaceHigh,
        side: BorderSide(color: selected ? color : colors.cardBorder),
        labelStyle: TextStyle(
          fontSize: 12,
          fontWeight: selected ? FontWeight.bold : FontWeight.w500,
          color: colors.textPrimary,
        ),
      ),
    );
  }
}
