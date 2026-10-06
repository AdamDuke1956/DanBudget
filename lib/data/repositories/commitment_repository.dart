import 'package:drift/drift.dart';
import '../local/app_database.dart';

class CommitmentRepository {
  final AppDatabase _db;

  CommitmentRepository(this._db);

  /// Watch all active commitments.
  Stream<List<CommitmentsTableData>> watchActiveCommitments() {
    return (_db.select(_db.commitmentsTable)
          ..where((t) => t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.dueDayOfMonth)]))
        .watch();
  }

  /// Get all active commitments once.
  Future<List<CommitmentsTableData>> getActiveCommitments() {
    return (_db.select(_db.commitmentsTable)
          ..where((t) => t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.dueDayOfMonth)]))
        .get();
  }

  /// Add a new commitment.
  Future<int> addCommitment({
    required String title,
    required String type,
    required int totalAmountSen,
    required int monthlyPaymentSen,
    required int remainingAmountSen,
    double interestRateAnnual = 0.0,
    int totalTenureMonths = 12,
    int remainingTenureMonths = 12,
    int dueDayOfMonth = 1,
  }) {
    return _db.into(_db.commitmentsTable).insert(
          CommitmentsTableCompanion.insert(
            title: title,
            type: type,
            totalAmountSen: totalAmountSen,
            monthlyPaymentSen: monthlyPaymentSen,
            remainingAmountSen: remainingAmountSen,
            interestRateAnnual: Value(interestRateAnnual),
            totalTenureMonths: Value(totalTenureMonths),
            remainingTenureMonths: Value(remainingTenureMonths),
            dueDayOfMonth: Value(dueDayOfMonth),
          ),
        );
  }

  /// Record an installment payment towards a commitment.
  /// Also logs an entry into the ExpensesTable with isCommitmentPayment = true.
  Future<void> recordPayment({
    required int commitmentId,
    required int paymentAmountSen,
    required DateTime date,
  }) async {
    await _db.transaction(() async {
      final commitment = await (_db.select(_db.commitmentsTable)
            ..where((t) => t.id.equals(commitmentId)))
          .getSingle();

      final newRemainingSen =
          (commitment.remainingAmountSen - paymentAmountSen).clamp(0, double.infinity).toInt();
      final newRemainingMonths =
          (commitment.remainingTenureMonths - 1).clamp(0, 9999);
      final isStillActive = newRemainingSen > 0 && newRemainingMonths > 0;

      // Update commitment
      await (_db.update(_db.commitmentsTable)
            ..where((t) => t.id.equals(commitmentId)))
          .write(
        CommitmentsTableCompanion(
          remainingAmountSen: Value(newRemainingSen),
          remainingTenureMonths: Value(newRemainingMonths),
          isActive: Value(isStillActive),
        ),
      );

      // Log expense under 'bills' or commitment payment
      await _db.into(_db.expensesTable).insert(
            ExpensesTableCompanion.insert(
              amountSen: paymentAmountSen,
              categoryId: 'bills',
              date: date,
              note: Value('Installment for ${commitment.title}'),
              isCommitmentPayment: const Value(true),
              commitmentId: Value(commitmentId),
            ),
          );
    });
  }

  /// Settle commitment in full early and mark inactive.
  Future<void> settleCommitment({
    required int commitmentId,
    required DateTime date,
  }) async {
    await _db.transaction(() async {
      final commitment = await (_db.select(_db.commitmentsTable)
            ..where((t) => t.id.equals(commitmentId)))
          .getSingle();

      final remainingSen = commitment.remainingAmountSen;

      await (_db.update(_db.commitmentsTable)
            ..where((t) => t.id.equals(commitmentId)))
          .write(
        const CommitmentsTableCompanion(
          remainingAmountSen: Value(0),
          remainingTenureMonths: Value(0),
          isActive: Value(false),
        ),
      );

      if (remainingSen > 0) {
        await _db.into(_db.expensesTable).insert(
              ExpensesTableCompanion.insert(
                amountSen: remainingSen,
                categoryId: 'bills',
                date: date,
                note: Value('Early settlement for ${commitment.title}'),
                isCommitmentPayment: const Value(true),
                commitmentId: Value(commitmentId),
              ),
            );
      }
    });
  }

  /// Update an existing commitment's details.
  Future<bool> updateCommitment({
    required int id,
    required String title,
    required String type,
    required int totalAmountSen,
    required int monthlyPaymentSen,
    required int remainingAmountSen,
    double interestRateAnnual = 0.0,
    int totalTenureMonths = 12,
    int remainingTenureMonths = 12,
    int dueDayOfMonth = 1,
    bool isActive = true,
  }) async {
    final rows = await (_db.update(_db.commitmentsTable)
          ..where((t) => t.id.equals(id)))
        .write(
      CommitmentsTableCompanion(
        title: Value(title),
        type: Value(type),
        totalAmountSen: Value(totalAmountSen),
        monthlyPaymentSen: Value(monthlyPaymentSen),
        remainingAmountSen: Value(remainingAmountSen),
        interestRateAnnual: Value(interestRateAnnual),
        totalTenureMonths: Value(totalTenureMonths),
        remainingTenureMonths: Value(remainingTenureMonths),
        dueDayOfMonth: Value(dueDayOfMonth),
        isActive: Value(isActive),
      ),
    );
    return rows > 0;
  }

  /// Delete or mark commitment as inactive.
  Future<int> deleteCommitment(int id) {
    return (_db.delete(_db.commitmentsTable)..where((t) => t.id.equals(id))).go();
  }
}
