import '../../core/utils/money.dart';

enum CommitmentType {
  spayLater('SPayLater', 'Shopee Buy-Now-Pay-Later', 0.015), // ~1.5% per month fee
  sLoan('Shopee SLoan', 'Cash loan facility', 0.18), // ~18% p.a.
  carLoan('Car Loan', 'Hire Purchase', 0.035), // ~3.5% flat rate
  pinjamanMara('Pinjaman MARA', 'MARA Education Loan', 0.0), // Low / zero interest with rebates
  ptptn('PTPTN', 'Higher Education Fund', 0.01), // 1% Ujrah
  creditCard('Credit Card', 'Revolving credit balance', 0.15), // 15-18% p.a.
  personalLoan('Personal Loan', 'Bank personal financing', 0.08),
  custom('Other Commitment', 'User defined commitment', 0.0);

  const CommitmentType(this.displayName, this.subtitle, this.defaultAnnualRate);
  final String displayName;
  final String subtitle;
  final double defaultAnnualRate;
}

class CommitmentItem {
  const CommitmentItem({
    required this.id,
    required this.name,
    required this.type,
    required this.monthlyAmount,
    required this.totalTenureMonths,
    required this.monthsPaid,
    this.totalOriginalAmount,
    this.dueDayOfMonth = 1,
  });

  final String id;
  final String name;
  final CommitmentType type;
  final Money monthlyAmount;
  final int totalTenureMonths;
  final int monthsPaid;
  final Money? totalOriginalAmount;
  final int dueDayOfMonth;

  int get remainingMonths =>
      (totalTenureMonths - monthsPaid) > 0 ? (totalTenureMonths - monthsPaid) : 0;

  double get progressRatio =>
      totalTenureMonths > 0 ? (monthsPaid / totalTenureMonths).clamp(0.0, 1.0) : 1.0;

  Money get remainingBalance =>
      Money(monthlyAmount.sen * remainingMonths);

  bool get isPaidOff => remainingMonths == 0;
}

class DebtPayoffPlan {
  const DebtPayoffPlan({
    required this.strategyName,
    required this.orderedCommitments,
    required this.totalRemainingDebt,
    required this.estimatedMonthsToDebtFree,
    required this.totalMonthlyCommitments,
  });

  final String strategyName;
  final List<CommitmentItem> orderedCommitments;
  final Money totalRemainingDebt;
  final int estimatedMonthsToDebtFree;
  final Money totalMonthlyCommitments;
}

abstract final class DebtPlanner {
  /// Simulates Debt Snowball strategy: pays off the smallest remaining balances first
  /// for quick psychological motivation for young adults.
  static DebtPayoffPlan calculateSnowball(List<CommitmentItem> activeItems) {
    final active = activeItems.where((c) => !c.isPaidOff).toList();
    active.sort((a, b) => a.remainingBalance.sen.compareTo(b.remainingBalance.sen));

    int totalDebtSen = 0;
    int totalMonthlySen = 0;
    int maxMonths = 0;

    for (final item in active) {
      totalDebtSen += item.remainingBalance.sen;
      totalMonthlySen += item.monthlyAmount.sen;
      if (item.remainingMonths > maxMonths) {
        maxMonths = item.remainingMonths;
      }
    }

    return DebtPayoffPlan(
      strategyName: 'Debt Snowball (Smallest Balance First)',
      orderedCommitments: active,
      totalRemainingDebt: Money(totalDebtSen),
      estimatedMonthsToDebtFree: maxMonths,
      totalMonthlyCommitments: Money(totalMonthlySen),
    );
  }

  /// Simulates Debt Avalanche strategy: prioritizes highest interest/fee rate first
  /// (e.g. SLoan / Credit Card before PTPTN / MARA) to save the most money.
  static DebtPayoffPlan calculateAvalanche(List<CommitmentItem> activeItems) {
    final active = activeItems.where((c) => !c.isPaidOff).toList();
    active.sort((a, b) => b.type.defaultAnnualRate.compareTo(a.type.defaultAnnualRate));

    int totalDebtSen = 0;
    int totalMonthlySen = 0;
    int maxMonths = 0;

    for (final item in active) {
      totalDebtSen += item.remainingBalance.sen;
      totalMonthlySen += item.monthlyAmount.sen;
      if (item.remainingMonths > maxMonths) {
        maxMonths = item.remainingMonths;
      }
    }

    return DebtPayoffPlan(
      strategyName: 'Debt Avalanche (Highest Interest First)',
      orderedCommitments: active,
      totalRemainingDebt: Money(totalDebtSen),
      estimatedMonthsToDebtFree: maxMonths,
      totalMonthlyCommitments: Money(totalMonthlySen),
    );
  }
}
