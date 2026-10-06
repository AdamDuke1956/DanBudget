import 'package:drift/drift.dart';
import '../local/app_database.dart';
import '../models/transfer_with_accounts.dart';

class AccountRepository {
  final AppDatabase _db;

  AccountRepository(this._db);

  /// Watch all accounts ordered by id.
  Stream<List<AccountsTableData>> watchAccounts() {
    return (_db.select(_db.accountsTable)
          ..orderBy([(t) => OrderingTerm.asc(t.id)]))
        .watch();
  }

  /// Get all accounts.
  Future<List<AccountsTableData>> getAccounts() {
    return (_db.select(_db.accountsTable)
          ..orderBy([(t) => OrderingTerm.asc(t.id)]))
        .get();
  }

  /// Watch only liquid accounts (that count towards Total Money on Hand).
  Stream<List<AccountsTableData>> watchLiquidAccounts() {
    return (_db.select(_db.accountsTable)
          ..where((t) => t.isLiquidOnHand.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.id)]))
        .watch();
  }

  /// Watch total liquid balance in sen.
  Stream<int> watchTotalLiquidBalanceSen() {
    return watchLiquidAccounts().map((accounts) {
      return accounts.fold<int>(0, (sum, acc) => sum + acc.balanceSen);
    });
  }

  /// Get single account by ID.
  Future<AccountsTableData?> getAccount(int id) {
    return (_db.select(_db.accountsTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Get default account (e.g. Main Bank or TnG).
  Future<AccountsTableData?> getDefaultAccount() async {
    final defaultAcc = await (_db.select(_db.accountsTable)
          ..where((t) => t.isDefault.equals(true))
          ..limit(1))
        .getSingleOrNull();
    if (defaultAcc != null) return defaultAcc;
    // Fallback to first account
    return (_db.select(_db.accountsTable)..limit(1)).getSingleOrNull();
  }

  /// Add a new account.
  Future<int> addAccount({
    required String name,
    required String type,
    int initialBalanceSen = 0,
    String icon = '🏦',
    int colorHex = 0xFF00B074,
    bool isDefault = false,
    bool isLiquidOnHand = true,
  }) async {
    return _db.transaction(() async {
      if (isDefault) {
        // Clear existing default
        await (_db.update(_db.accountsTable))
            .write(const AccountsTableCompanion(isDefault: Value(false)));
      }
      return _db.into(_db.accountsTable).insert(
            AccountsTableCompanion.insert(
              name: name,
              type: Value(type),
              balanceSen: Value(initialBalanceSen),
              icon: Value(icon),
              colorHex: Value(colorHex),
              isDefault: Value(isDefault),
              isLiquidOnHand: Value(isLiquidOnHand),
            ),
          );
    });
  }

  /// Update account details.
  Future<bool> updateAccount({
    required int id,
    required String name,
    required String type,
    required String icon,
    required int colorHex,
    required bool isDefault,
    required bool isLiquidOnHand,
  }) async {
    return _db.transaction(() async {
      if (isDefault) {
        await (_db.update(_db.accountsTable))
            .write(const AccountsTableCompanion(isDefault: Value(false)));
      }
      final rows = await (_db.update(_db.accountsTable)..where((t) => t.id.equals(id))).write(
        AccountsTableCompanion(
          name: Value(name),
          type: Value(type),
          icon: Value(icon),
          colorHex: Value(colorHex),
          isDefault: Value(isDefault),
          isLiquidOnHand: Value(isLiquidOnHand),
          updatedAt: Value(DateTime.now()),
        ),
      );
      return rows > 0;
    });
  }

  /// Set the exact balance of an account (reconciliation).
  Future<bool> setAccountBalance(int accountId, int newBalanceSen) async {
    final rows = await (_db.update(_db.accountsTable)..where((t) => t.id.equals(accountId))).write(
      AccountsTableCompanion(
        balanceSen: Value(newBalanceSen),
        updatedAt: Value(DateTime.now()),
      ),
    );
    return rows > 0;
  }

  /// Adjust account balance by delta (positive or negative).
  Future<void> adjustBalance(int accountId, int deltaSen) async {
    final acc = await getAccount(accountId);
    if (acc != null) {
      await setAccountBalance(accountId, acc.balanceSen + deltaSen);
    }
  }

  /// Transfer funds between two accounts.
  Future<int> transferFunds({
    required int fromAccountId,
    required int toAccountId,
    required int amountSen,
    String? note,
    DateTime? date,
  }) async {
    if (fromAccountId == toAccountId) {
      throw ArgumentError('Source and destination accounts must be different');
    }
    if (amountSen <= 0) {
      throw ArgumentError('Transfer amount must be positive');
    }

    final transferDate = date ?? DateTime.now();

    return _db.transaction(() async {
      // 1. Deduct from source
      final fromAcc = await (_db.select(_db.accountsTable)..where((t) => t.id.equals(fromAccountId))).getSingle();
      await (_db.update(_db.accountsTable)..where((t) => t.id.equals(fromAccountId))).write(
        AccountsTableCompanion(
          balanceSen: Value(fromAcc.balanceSen - amountSen),
          updatedAt: Value(DateTime.now()),
        ),
      );

      // 2. Add to destination
      final toAcc = await (_db.select(_db.accountsTable)..where((t) => t.id.equals(toAccountId))).getSingle();
      await (_db.update(_db.accountsTable)..where((t) => t.id.equals(toAccountId))).write(
        AccountsTableCompanion(
          balanceSen: Value(toAcc.balanceSen + amountSen),
          updatedAt: Value(DateTime.now()),
        ),
      );

      // 3. Record transfer
      return _db.into(_db.accountTransfersTable).insert(
            AccountTransfersTableCompanion.insert(
              fromAccountId: fromAccountId,
              toAccountId: toAccountId,
              amountSen: amountSen,
              date: Value(transferDate),
              note: Value(note),
            ),
          );
    });
  }

  /// Delete a transfer and refund the moved balances.
  Future<void> deleteTransfer(int transferId) async {
    return _db.transaction(() async {
      final transfer = await (_db.select(_db.accountTransfersTable)..where((t) => t.id.equals(transferId))).getSingleOrNull();
      if (transfer == null) return;

      // Reverse balances
      final fromAcc = await getAccount(transfer.fromAccountId);
      if (fromAcc != null) {
        await setAccountBalance(fromAcc.id, fromAcc.balanceSen + transfer.amountSen);
      }
      final toAcc = await getAccount(transfer.toAccountId);
      if (toAcc != null) {
        await setAccountBalance(toAcc.id, toAcc.balanceSen - transfer.amountSen);
      }

      await (_db.delete(_db.accountTransfersTable)..where((t) => t.id.equals(transferId))).go();
    });
  }

  /// Watch recent transfers with accounts joined.
  Stream<List<TransferWithAccounts>> watchRecentTransfers({int limit = 50}) {
    final query = _db.select(_db.accountTransfersTable)
      ..orderBy([(t) => OrderingTerm.desc(t.date)])
      ..limit(limit);

    return query.watch().asyncMap((transfers) async {
      final accounts = await getAccounts();
      final accountMap = {for (final a in accounts) a.id: a};

      return transfers.map((t) {
        return TransferWithAccounts(
          transfer: t,
          fromAccount: accountMap[t.fromAccountId],
          toAccount: accountMap[t.toAccountId],
        );
      }).toList();
    });
  }

  /// Delete account by ID.
  Future<int> deleteAccount(int id) async {
    return (_db.delete(_db.accountsTable)..where((t) => t.id.equals(id))).go();
  }
}
