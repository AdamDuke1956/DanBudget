import 'package:drift/drift.dart';

class AccountsTable extends Table {
  @override
  String get tableName => 'accounts';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()(); // e.g. "Main Bank", "Touch 'n Go", "Cash"
  // Type: 'bank', 'ewallet', 'cash', 'savings'
  TextColumn get type => text().withDefault(const Constant('bank'))();
  IntColumn get balanceSen => integer().withDefault(const Constant(0))();
  TextColumn get icon => text().withDefault(const Constant('🏦'))();
  IntColumn get colorHex => integer().withDefault(const Constant(0xFF00B074))();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  /// If true, included in "Total Money on Hand". If false (e.g. locked ASB/FD), excluded.
  BoolColumn get isLiquidOnHand => boolean().withDefault(const Constant(true))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
