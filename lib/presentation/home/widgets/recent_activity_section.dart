import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_icons.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../data/models/expense_with_category.dart';
import '../../../data/models/transfer_with_accounts.dart';

sealed class ActivityFeedItem {
  DateTime get date;
}

class ExpenseFeedItem extends ActivityFeedItem {
  ExpenseFeedItem(this.item);
  final ExpenseWithCategory item;

  @override
  DateTime get date => item.expense.date;
}

class TransferFeedItem extends ActivityFeedItem {
  TransferFeedItem(this.item);
  final TransferWithAccounts item;

  @override
  DateTime get date => item.transfer.date;
}

class RecentActivityHeader extends StatelessWidget {
  const RecentActivityHeader({
    super.key,
    required this.activeFilter,
    required this.onFilterChanged,
  });

  final String activeFilter;
  final ValueChanged<String> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Row(
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
              color: colors.textPrimary,
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
              _FilterChip(
                label: 'All',
                isSelected: activeFilter == 'all',
                onTap: () => onFilterChanged('all'),
              ),
              const SizedBox(width: 6),
              _FilterChip(
                label: 'Expenses',
                isSelected: activeFilter == 'expenses',
                onTap: () => onFilterChanged('expenses'),
              ),
              const SizedBox(width: 6),
              _FilterChip(
                label: 'Transfers',
                isSelected: activeFilter == 'transfers',
                onTap: () => onFilterChanged('transfers'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary.withValues(alpha: 0.16) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? colors.primary : colors.cardBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? colors.primary : colors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class RecentActivityEmptyCard extends StatelessWidget {
  const RecentActivityEmptyCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return SurfaceCard(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      child: Column(
        children: [
          Icon(Icons.receipt_long_rounded, size: 28, color: colors.textSecondary),
          const SizedBox(height: 10),
          Text(
            'No activity yet',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Log a spend to get started.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class ActivityFeedRow extends StatelessWidget {
  const ActivityFeedRow({super.key, required this.activity});

  final ActivityFeedItem activity;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final act = activity;

    if (act is ExpenseFeedItem) {
      final item = act.item;
      final accountBadge = item.account != null ? ' • ${item.account!.name}' : '';

      return SurfaceCard(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            AppIcons.badge(
              icon: AppIcons.getCategoryIcon(item.category.name),
              color: Color(item.category.colorHex),
              size: 18,
              containerSize: 42,
              borderRadius: 10,
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
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${item.category.name}$accountBadge • ${DateFormat('dd MMM').format(item.expense.date)}',
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
            Text(
              '-${Money(item.expense.amountSen).formatted}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
      );
    }

    if (act is TransferFeedItem) {
      final trans = act.item;
      final fromName = trans.fromAccount?.name ?? 'Account';
      final toName = trans.toAccount?.name ?? 'Account';
      final noteText = trans.transfer.note != null ? ' • ${trans.transfer.note}' : '';

      return SurfaceCard(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        borderColor: colors.accent.withValues(alpha: 0.25),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.sync_alt_rounded,
                color: colors.accent,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$fromName -> $toName',
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
                    'Transfer$noteText • ${DateFormat('dd MMM').format(trans.transfer.date)}',
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: colors.accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                Money(trans.transfer.amountSen).formatted,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: colors.accent,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
