import 'package:drift/drift.dart';
import 'accounts_table.dart';

class AccountTransfersTable extends Table {
  @override
  String get tableName => 'account_transfers';

  IntColumn get id => integer().autoIncrement()();
  @ReferenceName('outgoingTransfers')
  IntColumn get fromAccountId => integer().references(AccountsTable, #id)();

  @ReferenceName('incomingTransfers')
  IntColumn get toAccountId => integer().references(AccountsTable, #id)();
  IntColumn get amountSen => integer()();
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
