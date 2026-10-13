import 'package:drift/drift.dart';
import '../local/app_database.dart';

class DailyPlanRepository {
  final AppDatabase _db;

  DailyPlanRepository(this._db);

  DateTime _normalizeDate(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  /// Watch all custom plans in date range (inclusive).
  Stream<List<DailySpendingPlansTableData>> watchPlansForRange(
    DateTime start,
    DateTime end,
  ) {
    final s = _normalizeDate(start);
    final e = _normalizeDate(end);
    return (_db.select(_db.dailySpendingPlansTable)
          ..where((t) => t.date.isBiggerOrEqualValue(s) & t.date.isSmallerOrEqualValue(e))
          ..orderBy([(t) => OrderingTerm.asc(t.date)]))
        .watch();
  }

  /// Watch plan for a specific day.
  Stream<DailySpendingPlansTableData?> watchPlanForDate(DateTime date) {
    final d = _normalizeDate(date);
    return (_db.select(_db.dailySpendingPlansTable)..where((t) => t.date.equals(d)))
        .watchSingleOrNull();
  }

  /// Get plan for a specific day.
  Future<DailySpendingPlansTableData?> getPlanForDate(DateTime date) {
    final d = _normalizeDate(date);
    return (_db.select(_db.dailySpendingPlansTable)..where((t) => t.date.equals(d)))
        .getSingleOrNull();
  }

  /// Insert or update custom target plan for a day.
  Future<void> setPlanForDate({
    required DateTime date,
    required int targetAmountSen,
    String? whatToSpendOn,
    String? reason,
    bool? isWorkday,
  }) async {
    final d = _normalizeDate(date);
    final existing = await getPlanForDate(d);

    final isWk = isWorkday ?? (d.weekday >= DateTime.monday && d.weekday <= DateTime.friday);

    if (existing != null) {
      await (_db.update(_db.dailySpendingPlansTable)..where((t) => t.id.equals(existing.id))).write(
        DailySpendingPlansTableCompanion(
          targetAmountSen: Value(targetAmountSen),
          whatToSpendOn: Value(whatToSpendOn),
          reason: Value(reason),
          isWorkday: Value(isWk),
          updatedAt: Value(DateTime.now()),
        ),
      );
    } else {
      await _db.into(_db.dailySpendingPlansTable).insert(
        DailySpendingPlansTableCompanion.insert(
          date: d,
          targetAmountSen: Value(targetAmountSen),
          whatToSpendOn: Value(whatToSpendOn),
          reason: Value(reason),
          isWorkday: Value(isWk),
        ),
      );
    }
  }

  /// Delete a custom plan for a day.
  Future<int> deletePlanForDate(DateTime date) {
    final d = _normalizeDate(date);
    return (_db.delete(_db.dailySpendingPlansTable)..where((t) => t.date.equals(d))).go();
  }

  /// Bulk set targets for all weekdays (Monday-Friday) between startDate and endDate.
  Future<void> bulkSetWorkdays({
    required DateTime startDate,
    required DateTime endDate,
    required int targetSen,
    String whatToSpendOn = 'Lunch',
    String reason = 'Workday lunch allowance',
  }) async {
    var cur = _normalizeDate(startDate);
    final end = _normalizeDate(endDate);

    while (!cur.isAfter(end)) {
      if (cur.weekday >= DateTime.monday && cur.weekday <= DateTime.friday) {
        await setPlanForDate(
          date: cur,
          targetAmountSen: targetSen,
          whatToSpendOn: whatToSpendOn,
          reason: reason,
          isWorkday: true,
        );
      }
      cur = cur.add(const Duration(days: 1));
    }
  }
}
