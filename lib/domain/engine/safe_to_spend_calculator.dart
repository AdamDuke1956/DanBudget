import '../../core/utils/money.dart';

class SafeToSpendResult {
  const SafeToSpendResult({
    required this.safeDailyAmount,
    required this.daysUntilPayday,
    required this.remainingFlexibleBudget,
    required this.unpaidCommitmentsBeforePayday,
    required this.effectiveDisposable,
    required this.isDeficit,
    this.liquidOnHand,
    this.isLiquidityConstrained = false,
  });

  /// Recommended maximum to spend each day until payday (in sen/RM)
  final Money safeDailyAmount;

  /// Number of days left until next salary credit
  final int daysUntilPayday;

  /// Remaining flexible (wants + flexible needs) budget this cycle
  final Money remainingFlexibleBudget;

  /// Commitments that must be paid before the upcoming payday
  final Money unpaidCommitmentsBeforePayday;

  /// Money left after reserving upcoming bill commitments
  final Money effectiveDisposable;

  /// True if upcoming bills exceed remaining budget
  final bool isDeficit;

  /// Total liquid money on hand in bank, eWallets, cash
  final Money? liquidOnHand;

  /// True if daily safe-to-spend is capped by actual cash in bank/wallets
  final bool isLiquidityConstrained;
}

abstract final class SafeToSpendCalculator {
  /// Computes safe daily allowance for fresh grads so they don't go broke before payday.
  static SafeToSpendResult calculate({
    required Money remainingFlexibleBudget,
    required Money unpaidCommitmentsBeforePayday,
    required DateTime currentDate,
    required int paydayDayOfMonth, // e.g. 25
    Money? liquidOnHand,
  }) {
    final int days = _daysUntilNextPayday(currentDate, paydayDayOfMonth);

    final int disposableSen =
        remainingFlexibleBudget.sen - unpaidCommitmentsBeforePayday.sen;
    final bool isDeficit = disposableSen <= 0;

    // Check if actual cash on hand is lower than the remaining theoretical budget
    final bool isConstrained = liquidOnHand != null &&
        liquidOnHand.sen > 0 &&
        liquidOnHand.sen < disposableSen;

    final int spendableSen = isConstrained ? liquidOnHand.sen : disposableSen;

    final int dailySen =
        (!isDeficit && days > 0) ? (spendableSen / days).floor() : 0;

    return SafeToSpendResult(
      safeDailyAmount: Money(dailySen),
      daysUntilPayday: days,
      remainingFlexibleBudget: remainingFlexibleBudget,
      unpaidCommitmentsBeforePayday: unpaidCommitmentsBeforePayday,
      effectiveDisposable: Money(spendableSen > 0 ? spendableSen : 0),
      isDeficit: isDeficit,
      liquidOnHand: liquidOnHand,
      isLiquidityConstrained: isConstrained,
    );
  }

  /// Calculates calendar days remaining until the next payday.
  static int _daysUntilNextPayday(DateTime now, int paydayDayOfMonth) {
    DateTime nextPayday = DateTime(now.year, now.month, paydayDayOfMonth);

    if (now.isAfter(nextPayday)) {
      // Payday for current month has passed; next payday is next month
      final nextMonth = now.month == 12 ? 1 : now.month + 1;
      final nextYear = now.month == 12 ? now.year + 1 : now.year;
      nextPayday = DateTime(nextYear, nextMonth, paydayDayOfMonth);
    }

    final diff = nextPayday.difference(DateTime(now.year, now.month, now.day)).inDays;
    return diff <= 0 ? 1 : diff; // Minimum 1 day
  }
}
