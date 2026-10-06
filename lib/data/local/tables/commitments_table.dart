import 'package:drift/drift.dart';

class CommitmentsTable extends Table {
  @override
  String get tableName => 'commitments';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()(); // e.g. "SPayLater (Phone)", "Myvi Hire Purchase"
  // Commitment type: 'spaylater', 'sloan', 'car_loan', 'ptptn', 'mara', 'credit_card', 'personal_loan', 'other'
  TextColumn get type => text()();

  // Financial amounts in sen
  IntColumn get totalAmountSen => integer()();
  IntColumn get monthlyPaymentSen => integer()();
  IntColumn get remainingAmountSen => integer()();

  RealColumn get interestRateAnnual => real().withDefault(const Constant(0.0))();
  IntColumn get totalTenureMonths => integer().withDefault(const Constant(12))();
  IntColumn get remainingTenureMonths => integer().withDefault(const Constant(12))();

  // Due day of month (e.g. 10th of every month)
  IntColumn get dueDayOfMonth => integer().withDefault(const Constant(1))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
