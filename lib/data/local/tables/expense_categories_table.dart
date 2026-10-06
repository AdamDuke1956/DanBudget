import 'package:drift/drift.dart';

class ExpenseCategoriesTable extends Table {
  @override
  String get tableName => 'expense_categories';

  TextColumn get id => text()(); // e.g. 'food', 'toll', 'petrol'
  TextColumn get name => text()(); // e.g. 'Food & Dining'
  TextColumn get icon => text()(); // Emoji or icon identifier, e.g. '🍜'
  IntColumn get colorHex => integer()(); // e.g. 0xFFFF9F43
  // Bucket enum value stored as string: 'needs', 'wants', 'savings', 'giving'
  TextColumn get bucket => text()();
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
