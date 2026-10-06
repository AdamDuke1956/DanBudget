import 'package:drift/drift.dart';
import '../local/app_database.dart';

class ChecklistRepository {
  final AppDatabase _db;

  ChecklistRepository(this._db);

  /// Watch all checklist items sorted by sortOrder.
  Stream<List<ChecklistItemsTableData>> watchChecklistItems() {
    return (_db.select(_db.checklistItemsTable)
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .watch();
  }

  /// Toggle checklist item completed status.
  Future<int> toggleItem(String id, bool isCompleted) {
    return (_db.update(_db.checklistItemsTable)..where((t) => t.id.equals(id))).write(
      ChecklistItemsTableCompanion(
        isCompleted: Value(isCompleted),
        completedAt: Value(isCompleted ? DateTime.now() : null),
      ),
    );
  }

  /// Add custom starter pack checklist item.
  Future<int> addItem({
    required String title,
    required String category,
    required String description,
  }) {
    final id = 'custom_${DateTime.now().millisecondsSinceEpoch}';
    return _db.into(_db.checklistItemsTable).insert(
      ChecklistItemsTableCompanion(
        id: Value(id),
        title: Value(title),
        category: Value(category),
        description: Value(description),
        isCompleted: const Value(false),
        sortOrder: const Value(99),
      ),
    );
  }
}
