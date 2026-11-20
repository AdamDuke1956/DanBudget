import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_icons.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../data/local/app_database.dart';
import '../../../data/providers/database_providers.dart';
import 'add_commitment_sheet.dart';
import 'add_spaylater_sheet.dart';

class DetailedCommitmentCard extends ConsumerWidget {
  const DetailedCommitmentCard({
    super.key,
    required this.commitment,
    required this.isSpay,
  });

  final CommitmentsTableData commitment;
  final bool isSpay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final c = commitment;
    final progress = c.totalTenureMonths > 0
        ? ((c.totalTenureMonths - c.remainingTenureMonths) / c.totalTenureMonths).clamp(0.0, 1.0)
        : 0.0;
    final monthsPaid = (c.totalTenureMonths - c.remainingTenureMonths).clamp(0, 999);
    final brandColor = isSpay ? const Color(0xFFEE4D2D) : colors.primary;

    return Dismissible(
      key: Key(isSpay ? 'spaylater_${c.id}' : 'commitment_${c.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: colors.danger.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(Icons.delete_outline_rounded, color: colors.danger),
      ),
      onDismissed: (_) {
        ref.read(commitmentRepositoryProvider).deleteCommitment(c.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Deleted commitment ${c.title}')),
        );
      },
      child: SurfaceCard(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        borderColor: isSpay
            ? const Color(0xFFEE4D2D).withValues(alpha: 0.25)
            : colors.cardBorder,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: brandColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: isSpay
                      ? const Text('🛍️', style: TextStyle(fontSize: 20))
                      : Icon(AppIcons.getCommitmentIcon(c.type), size: 20, color: brandColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    c.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: colors.textPrimary),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: Icon(Icons.edit_outlined, size: 18, color: colors.textSecondary),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                  tooltip: 'Edit item',
                  onPressed: () =>
                      isSpay ? AddSpayLaterSheet.edit(context, c) : AddCommitmentSheet.edit(context, c),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: colors.surfaceHigh,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Due on ${c.dueDayOfMonth}th',
                          style: TextStyle(
                            fontSize: 10,
                            color: colors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: colors.accent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${c.remainingTenureMonths} mo left',
                          style: TextStyle(
                            fontSize: 10,
                            color: colors.accent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          Money(c.monthlyPaymentSen).formatted,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: colors.textPrimary,
                          ),
                        ),
                      ),
                      Text('/ month', style: TextStyle(fontSize: 10, color: colors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    '$monthsPaid of ${c.totalTenureMonths} months paid',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11, color: colors.textSecondary),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'Remaining: ${Money(c.remainingAmountSen).formatted} of ${Money(c.totalAmountSen).formatted}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: colors.surfaceHigh,
                valueColor: AlwaysStoppedAnimation<Color>(brandColor),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              alignment: WrapAlignment.end,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 6,
              children: [
                TextButton(
                  onPressed: () => CommitmentDialogs.confirmSettlement(context, ref, c),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    'Settle Early',
                    style: TextStyle(
                      color: colors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => CommitmentDialogs.confirmPayment(context, ref, c),
                  icon: Icon(Icons.check_circle_outline_rounded, size: 16, color: colors.primary),
                  label: Text(
                    isSpay ? 'Pay 1 Mo (${Money(c.monthlyPaymentSen).formatted})' : 'Record Payment',
                    style: TextStyle(color: colors.primary, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: colors.primary.withValues(alpha: 0.12),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CompactCommitmentCard extends ConsumerWidget {
  const CompactCommitmentCard({
    super.key,
    required this.commitment,
    required this.isSpay,
  });

  final CommitmentsTableData commitment;
  final bool isSpay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final c = commitment;
    final brandColor = isSpay ? const Color(0xFFEE4D2D) : colors.primary;

    return Dismissible(
      key: Key('compact_${c.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: colors.danger.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(Icons.delete_outline_rounded, color: colors.danger),
      ),
      onDismissed: (_) {
        ref.read(commitmentRepositoryProvider).deleteCommitment(c.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Deleted ${c.title}')),
        );
      },
      child: SurfaceCard(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: brandColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                isSpay ? Icons.shopping_bag_rounded : AppIcons.getCommitmentIcon(c.type),
                size: 16,
                color: brandColor,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: colors.textPrimary),
                  ),
                  Text(
                    'Due ${c.dueDayOfMonth}th • ${c.remainingTenureMonths} mo left',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 10, color: colors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      Money(c.monthlyPaymentSen).formatted,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: colors.textPrimary),
                    ),
                  ),
                  Text(
                    'Rem: ${Money(c.remainingAmountSen).formatted}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 10, color: colors.textSecondary),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert_rounded, size: 16, color: colors.textSecondary),
              color: colors.surfaceHigh,
              onSelected: (val) {
                if (val == 'pay') CommitmentDialogs.confirmPayment(context, ref, c);
                if (val == 'settle') CommitmentDialogs.confirmSettlement(context, ref, c);
                if (val == 'edit') {
                  isSpay ? AddSpayLaterSheet.edit(context, c) : AddCommitmentSheet.edit(context, c);
                }
              },
              itemBuilder: (ctx) => [
                PopupMenuItem(value: 'pay', child: Text('Pay 1 Mo (${Money(c.monthlyPaymentSen).formatted})')),
                const PopupMenuItem(value: 'settle', child: Text('Settle Early')),
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

abstract final class CommitmentDialogs {
  static void confirmPayment(BuildContext context, WidgetRef ref, CommitmentsTableData c) {
    showDialog(
      context: context,
      builder: (ctx) {
        final colors = AppColors.of(ctx);
        return AlertDialog(
          backgroundColor: colors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Record Payment for ${c.title}?', style: TextStyle(color: colors.textPrimary, fontSize: 18)),
          content: Text(
            'Record 1 installment of ${Money(c.monthlyPaymentSen).formatted} and log it as an expense.',
            style: TextStyle(color: colors.textSecondary, fontSize: 13),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Cancel', style: TextStyle(color: colors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                await ref.read(commitmentRepositoryProvider).recordPayment(
                      commitmentId: c.id,
                      paymentAmountSen: c.monthlyPaymentSen,
                      date: DateTime.now(),
                    );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Recorded payment of ${Money(c.monthlyPaymentSen).formatted}!')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  static void confirmSettlement(BuildContext context, WidgetRef ref, CommitmentsTableData c) {
    showDialog(
      context: context,
      builder: (ctx) {
        final colors = AppColors.of(ctx);
        return AlertDialog(
          backgroundColor: colors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Settle ${c.title} Early?', style: TextStyle(color: colors.textPrimary, fontSize: 18)),
          content: Text(
            'Settle the remaining balance of ${Money(c.remainingAmountSen).formatted} in full and mark this commitment complete.',
            style: TextStyle(color: colors.textSecondary, fontSize: 13),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Cancel', style: TextStyle(color: colors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                await ref.read(commitmentRepositoryProvider).settleCommitment(
                      commitmentId: c.id,
                      date: DateTime.now(),
                    );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Settled ${c.title} in full (${Money(c.remainingAmountSen).formatted})!')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.accent,
                foregroundColor: colors.onAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Settle in Full'),
            ),
          ],
        );
      },
    );
  }
}
