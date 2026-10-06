import 'package:drift/drift.dart';
import 'expense_categories_table.dart';
import 'commitments_table.dart';
import 'accounts_table.dart';

class ExpensesTable extends Table {
  @override
  String get tableName => 'expenses';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get amountSen => integer()();
  TextColumn get categoryId => text().references(ExpenseCategoriesTable, #id)();
  DateTimeColumn get date => dateTime()();
  TextColumn get note => text().nullable()();
  BoolColumn get isCommitmentPayment => boolean().withDefault(const Constant(false))();
  IntColumn get commitmentId => integer().nullable().references(CommitmentsTable, #id)();
  IntColumn get accountId => integer().nullable().references(AccountsTable, #id)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

