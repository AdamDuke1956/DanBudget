import 'package:drift/drift.dart';

class ChecklistItemsTable extends Table {
  @override
  String get tableName => 'checklist_items';

  TextColumn get id => text()(); // e.g. 'epf_iakaun', 'lhdn_mytax'
  TextColumn get title => text()();
  TextColumn get description => text()();
  // Category: 'statutory', 'banking', 'protection', 'debt', 'savings'
  TextColumn get category => text()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get targetDate => dateTime().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
