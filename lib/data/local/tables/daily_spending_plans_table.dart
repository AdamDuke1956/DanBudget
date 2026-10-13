import 'package:drift/drift.dart';

class DailySpendingPlansTable extends Table {
  @override
  String get tableName => 'daily_spending_plans';

  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()(); // Date truncated to midnight
  IntColumn get targetAmountSen => integer().withDefault(const Constant(0))();
  TextColumn get whatToSpendOn => text().nullable()(); // e.g. "Lunch at office"
  TextColumn get reason => text().nullable()(); // e.g. "Workday allowance"
  BoolColumn get isWorkday => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
