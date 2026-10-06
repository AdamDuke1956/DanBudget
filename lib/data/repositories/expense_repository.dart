import 'package:drift/drift.dart';
import '../local/app_database.dart';
import '../models/expense_with_category.dart';

class ExpenseRepository {
  final AppDatabase _db;

  ExpenseRepository(this._db);

  /// Watch all categories sorted by sortOrder.
  Stream<List<ExpenseCategoriesTableData>> watchCategories() {
    return (_db.select(_db.expenseCategoriesTable)
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .watch();
  }

  /// Get category by ID.
  Future<ExpenseCategoriesTableData?> getCategory(String id) {
    return (_db.select(_db.expenseCategoriesTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Watch recent expenses with their category and account info joined.
  Stream<List<ExpenseWithCategory>> watchRecentExpenses({int limit = 50}) {
    final query = _db.select(_db.expensesTable).join([
      innerJoin(
        _db.expenseCategoriesTable,
        _db.expenseCategoriesTable.id.equalsExp(_db.expensesTable.categoryId),
      ),
      leftOuterJoin(
        _db.accountsTable,
        _db.accountsTable.id.equalsExp(_db.expensesTable.accountId),
      ),
    ])
      ..orderBy([OrderingTerm.desc(_db.expensesTable.date)])
      ..limit(limit);

    return query.watch().map((rows) {
      return rows.map((row) {
        return ExpenseWithCategory(
          expense: row.readTable(_db.expensesTable),
          category: row.readTable(_db.expenseCategoriesTable),
          account: row.readTableOrNull(_db.accountsTable),
        );
      }).toList();
    });
  }

  /// Watch expenses for a specific month.
  Stream<List<ExpenseWithCategory>> watchExpensesForMonth(DateTime month) {
    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

    final query = _db.select(_db.expensesTable).join([
      innerJoin(
        _db.expenseCategoriesTable,
        _db.expenseCategoriesTable.id.equalsExp(_db.expensesTable.categoryId),
      ),
      leftOuterJoin(
        _db.accountsTable,
        _db.accountsTable.id.equalsExp(_db.expensesTable.accountId),
      ),
    ])
      ..where(_db.expensesTable.date.isBiggerOrEqualValue(startOfMonth))
      ..where(_db.expensesTable.date.isSmallerOrEqualValue(endOfMonth))
      ..orderBy([OrderingTerm.desc(_db.expensesTable.date)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return ExpenseWithCategory(
          expense: row.readTable(_db.expensesTable),
          category: row.readTable(_db.expenseCategoriesTable),
          account: row.readTableOrNull(_db.accountsTable),
        );
      }).toList();
    });
  }

  /// Insert a new expense and deduct balance from the selected account if provided.
  Future<int> addExpense({
    required int amountSen,
    required String categoryId,
    required DateTime date,
    String? note,
    bool isCommitmentPayment = false,
    int? commitmentId,
    int? accountId,
  }) {
    return _db.transaction(() async {
      final expenseId = await _db.into(_db.expensesTable).insert(
            ExpensesTableCompanion.insert(
              amountSen: amountSen,
              categoryId: categoryId,
              date: date,
              note: Value(note),
              isCommitmentPayment: Value(isCommitmentPayment),
              commitmentId: Value(commitmentId),
              accountId: Value(accountId),
            ),
          );

      if (accountId != null) {
        final acc = await (_db.select(_db.accountsTable)..where((t) => t.id.equals(accountId))).getSingleOrNull();
        if (acc != null) {
          await (_db.update(_db.accountsTable)..where((t) => t.id.equals(accountId))).write(
            AccountsTableCompanion(
              balanceSen: Value(acc.balanceSen - amountSen),
              updatedAt: Value(DateTime.now()),
            ),
          );
        }
      }

      return expenseId;
    });
  }

  /// Update an existing expense, adjusting account balances if amount or account changed.
  Future<bool> updateExpense({
    required int id,
    required int amountSen,
    required String categoryId,
    required DateTime date,
    String? note,
    int? accountId,
  }) async {
    return _db.transaction(() async {
      final oldExpense = await (_db.select(_db.expensesTable)..where((t) => t.id.equals(id))).getSingleOrNull();
      if (oldExpense == null) return false;

      // Reverse old account deduction if it was attached
      if (oldExpense.accountId != null) {
        final oldAcc = await (_db.select(_db.accountsTable)..where((t) => t.id.equals(oldExpense.accountId!))).getSingleOrNull();
        if (oldAcc != null) {
          await (_db.update(_db.accountsTable)..where((t) => t.id.equals(oldAcc.id))).write(
            AccountsTableCompanion(
              balanceSen: Value(oldAcc.balanceSen + oldExpense.amountSen),
              updatedAt: Value(DateTime.now()),
            ),
          );
        }
      }

      // Apply new account deduction if provided or keep previous if not explicitly passed
      final targetAccountId = accountId ?? oldExpense.accountId;
      if (targetAccountId != null) {
        final newAcc = await (_db.select(_db.accountsTable)..where((t) => t.id.equals(targetAccountId))).getSingleOrNull();
        if (newAcc != null) {
          await (_db.update(_db.accountsTable)..where((t) => t.id.equals(newAcc.id))).write(
            AccountsTableCompanion(
              balanceSen: Value(newAcc.balanceSen - amountSen),
              updatedAt: Value(DateTime.now()),
            ),
          );
        }
      }

      final rows = await (_db.update(_db.expensesTable)..where((t) => t.id.equals(id))).write(
        ExpensesTableCompanion(
          amountSen: Value(amountSen),
          categoryId: Value(categoryId),
          date: Value(date),
          note: Value(note),
          accountId: Value(targetAccountId),
        ),
      );
      return rows > 0;
    });
  }

  /// Delete an expense by ID and refund the deducted amount to the account if attached.
  Future<int> deleteExpense(int id) {
    return _db.transaction(() async {
      final expense = await (_db.select(_db.expensesTable)..where((t) => t.id.equals(id))).getSingleOrNull();
      if (expense != null && expense.accountId != null) {
        final acc = await (_db.select(_db.accountsTable)..where((t) => t.id.equals(expense.accountId!))).getSingleOrNull();
        if (acc != null) {
          await (_db.update(_db.accountsTable)..where((t) => t.id.equals(acc.id))).write(
            AccountsTableCompanion(
              balanceSen: Value(acc.balanceSen + expense.amountSen),
              updatedAt: Value(DateTime.now()),
            ),
          );
        }
      }
      return (_db.delete(_db.expensesTable)..where((t) => t.id.equals(id))).go();
    });
  }

  /// Get all expenses with category and account information for export.
  Future<List<ExpenseWithCategory>> getAllExpenses() async {
    final query = _db.select(_db.expensesTable).join([
      innerJoin(
        _db.expenseCategoriesTable,
        _db.expenseCategoriesTable.id.equalsExp(_db.expensesTable.categoryId),
      ),
      leftOuterJoin(
        _db.accountsTable,
        _db.accountsTable.id.equalsExp(_db.expensesTable.accountId),
      ),
    ])..orderBy([OrderingTerm.desc(_db.expensesTable.date)]);

    final rows = await query.get();
    return rows.map((row) {
      return ExpenseWithCategory(
        expense: row.readTable(_db.expensesTable),
        category: row.readTable(_db.expenseCategoriesTable),
        account: row.readTableOrNull(_db.accountsTable),
      );
    }).toList();
  }
}

