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
    this.workdaysUntilPayday = 0,
    this.weekendDaysUntilPayday = 0,
    this.todayCustomTarget,
    this.todayWhatToSpendOn,
    this.todayReason,
    this.todayIsWorkday = false,
    this.workdaysOnly = false,
    this.nextPaydayDate,
  });

  /// Recommended maximum to spend each day until payday (in sen/RM)
  final Money safeDailyAmount;

  /// Number of days left until next salary credit
  final int daysUntilPayday;

  /// Number of working days (Monday-Friday) until payday
  final int workdaysUntilPayday;

  /// Number of weekend days (Saturday-Sunday) until payday
  final int weekendDaysUntilPayday;

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

  /// User custom target for today if planned
  final Money? todayCustomTarget;
  final String? todayWhatToSpendOn;
  final String? todayReason;
  final bool todayIsWorkday;
  final bool workdaysOnly;
  final DateTime? nextPaydayDate;
}

abstract final class SafeToSpendCalculator {
  /// Computes safe daily allowance for fresh grads so they don't go broke before payday.
  static SafeToSpendResult calculate({
    required Money remainingFlexibleBudget,
    required Money unpaidCommitmentsBeforePayday,
    required DateTime currentDate,
    required int paydayDayOfMonth, // e.g. 25
    Money? liquidOnHand,
    bool workdaysOnly = false,
    Money? todayCustomTarget,
    String? todayWhatToSpendOn,
    String? todayReason,
    bool? todayIsWorkday,
  }) {
    final DateTime nextPayday = _getNextPayday(currentDate, paydayDayOfMonth);
    final int days = _daysUntilNextPayday(currentDate, paydayDayOfMonth);
    final int workdays = _countWorkdays(currentDate, nextPayday);
    final int weekends = (days - workdays).clamp(0, days);

    final int disposableSen =
        remainingFlexibleBudget.sen - unpaidCommitmentsBeforePayday.sen;
    final bool isDeficit = disposableSen <= 0;

    // Check if actual cash on hand is lower than the remaining theoretical budget
    final bool isConstrained = liquidOnHand != null &&
        liquidOnHand.sen > 0 &&
        liquidOnHand.sen < disposableSen;

    final int spendableSen = isConstrained ? liquidOnHand.sen : disposableSen;

    // If workdaysOnly mode is active, divide by workdays if today is a workday or positive workdays
    final int divisor = (workdaysOnly && workdays > 0) ? workdays : days;
    final int dailySen =
        (!isDeficit && divisor > 0) ? (spendableSen / divisor).floor() : 0;

    final bool isWk = todayIsWorkday ??
        (currentDate.weekday >= DateTime.monday &&
            currentDate.weekday <= DateTime.friday);

    return SafeToSpendResult(
      safeDailyAmount: Money(dailySen),
      daysUntilPayday: days,
      workdaysUntilPayday: workdays,
      weekendDaysUntilPayday: weekends,
      remainingFlexibleBudget: remainingFlexibleBudget,
      unpaidCommitmentsBeforePayday: unpaidCommitmentsBeforePayday,
      effectiveDisposable: Money(spendableSen > 0 ? spendableSen : 0),
      isDeficit: isDeficit,
      liquidOnHand: liquidOnHand,
      isLiquidityConstrained: isConstrained,
      todayCustomTarget: todayCustomTarget,
      todayWhatToSpendOn: todayWhatToSpendOn,
      todayReason: todayReason,
      todayIsWorkday: isWk,
      workdaysOnly: workdaysOnly,
      nextPaydayDate: nextPayday,
    );
  }

  /// Calculates calendar days remaining until the next payday.
  static int _daysUntilNextPayday(DateTime now, int paydayDayOfMonth) {
    final nextPayday = _getNextPayday(now, paydayDayOfMonth);
    final diff = nextPayday.difference(DateTime(now.year, now.month, now.day)).inDays;
    return diff <= 0 ? 1 : diff; // Minimum 1 day
  }

  /// Gets next payday DateTime.
  static DateTime _getNextPayday(DateTime now, int paydayDayOfMonth) {
    DateTime nextPayday = DateTime(now.year, now.month, paydayDayOfMonth);

    if (now.isAfter(nextPayday)) {
      // Payday for current month has passed; next payday is next month
      final nextMonth = now.month == 12 ? 1 : now.month + 1;
      final nextYear = now.month == 12 ? now.year + 1 : now.year;
      nextPayday = DateTime(nextYear, nextMonth, paydayDayOfMonth);
    }
    return nextPayday;
  }

  /// Counts Monday-Friday days between start (inclusive) and end (exclusive).
  static int _countWorkdays(DateTime start, DateTime end) {
    int count = 0;
    DateTime cur = DateTime(start.year, start.month, start.day);
    final finish = DateTime(end.year, end.month, end.day);
    while (cur.isBefore(finish)) {
      if (cur.weekday >= DateTime.monday && cur.weekday <= DateTime.friday) {
        count++;
      }
      cur = cur.add(const Duration(days: 1));
    }
    return count > 0 ? count : 1;
  }
}
