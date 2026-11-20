import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../data/local/app_database.dart';
import '../../../domain/engine/debt_planner.dart';

class DebtPayoffSheet extends StatefulWidget {
  const DebtPayoffSheet({super.key, required this.commitments});

  final List<CommitmentsTableData> commitments;

  static void show(BuildContext context, List<CommitmentsTableData> commitments) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DebtPayoffSheet(commitments: commitments),
    );
  }

  @override
  State<DebtPayoffSheet> createState() => _DebtPayoffSheetState();
}

class _DebtPayoffSheetState extends State<DebtPayoffSheet> {
  bool _useSnowball = true;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final items = widget.commitments.map(_toCommitmentItem).toList();
    final plan = _useSnowball
        ? DebtPlanner.calculateSnowball(items)
        : DebtPlanner.calculateAvalanche(items);

    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: colors.surfaceHigh,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.trending_down_rounded, color: colors.accent, size: 24),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Debt Payoff Strategy',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.close_rounded, color: colors.textSecondary),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: colors.surfaceHigh,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _useSnowball = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                      decoration: BoxDecoration(
                        color: _useSnowball ? colors.accent : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.ac_unit_rounded,
                            size: 15,
                            color: _useSnowball ? Colors.white : colors.textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              'Snowball (Quick Wins)',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: _useSnowball ? Colors.white : colors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _useSnowball = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                      decoration: BoxDecoration(
                        color: !_useSnowball ? colors.accent : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bolt_rounded,
                            size: 16,
                            color: !_useSnowball ? Colors.white : colors.textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              'Avalanche (Save Fees)',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: !_useSnowball ? Colors.white : colors.textSecondary,
                              ),
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
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colors.accent.withValues(alpha: 0.3)),
            ),
            child: Text(
              _useSnowball
                  ? 'Snowball: Pay smallest balances first for quick wins and fewer monthly bills.'
                  : 'Avalanche: Pay highest interest/fee balances first to save the most money.',
              style: TextStyle(
                fontSize: 12,
                color: colors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: SurfaceCard(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Balance',
                        style: TextStyle(fontSize: 11, color: colors.textSecondary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        plan.totalRemainingDebt.formatted,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SurfaceCard(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Debt-Free In',
                        style: TextStyle(fontSize: 11, color: colors.textSecondary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '~${plan.estimatedMonthsToDebtFree} Months',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: colors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Recommended Payoff Order:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: plan.orderedCommitments.length,
              itemBuilder: (context, index) {
                final item = plan.orderedCommitments[index];
                final isTopPriority = index == 0;

                return SurfaceCard(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  color: isTopPriority
                      ? colors.primary.withValues(alpha: 0.12)
                      : colors.surfaceHigh,
                  borderColor: isTopPriority
                      ? colors.primary.withValues(alpha: 0.5)
                      : colors.outline.withValues(alpha: 0.5),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: isTopPriority ? colors.primary : colors.surface,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isTopPriority ? colors.onPrimary : colors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    item.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: colors.textPrimary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                if (isTopPriority)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colors.primary.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'Target 1st',
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: colors.primary,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${item.type.displayName} • ${item.remainingMonths} mos remaining',
                              style: TextStyle(fontSize: 11, color: colors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            item.remainingBalance.formatted,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: colors.textPrimary,
                            ),
                          ),
                          Text(
                            '${item.monthlyAmount.formatted} / mo',
                            style: TextStyle(fontSize: 10, color: colors.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  CommitmentItem _toCommitmentItem(CommitmentsTableData c) {
    CommitmentType type;
    switch (c.type.toLowerCase()) {
      case 'spaylater':
        type = CommitmentType.spayLater;
        break;
      case 'sloan':
        type = CommitmentType.sLoan;
        break;
      case 'car_loan':
        type = CommitmentType.carLoan;
        break;
      case 'mara':
        type = CommitmentType.pinjamanMara;
        break;
      case 'ptptn':
        type = CommitmentType.ptptn;
        break;
      case 'credit_card':
        type = CommitmentType.creditCard;
        break;
      case 'personal_loan':
        type = CommitmentType.personalLoan;
        break;
      default:
        type = CommitmentType.custom;
        break;
    }

    return CommitmentItem(
      id: c.id.toString(),
      name: c.title,
      type: type,
      monthlyAmount: Money(c.monthlyPaymentSen),
      totalTenureMonths: c.totalTenureMonths,
      monthsPaid: c.totalTenureMonths - c.remainingTenureMonths,
      totalOriginalAmount: Money(c.totalAmountSen),
      dueDayOfMonth: c.dueDayOfMonth,
    );
  }
}
