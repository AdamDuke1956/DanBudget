import 'package:drift/drift.dart';
import '../../domain/engine/employment_type.dart';
import '../local/app_database.dart';

/// A recurring monthly cost offered during onboarding (e.g. My50 transit pass).
class StarterCommitment {
  const StarterCommitment({
    required this.title,
    required this.monthlyPaymentSen,
    this.dueDayOfMonth = 1,
  });

  final String title;
  final int monthlyPaymentSen;
  final int dueDayOfMonth;
}

class ProfileRepository {
  final AppDatabase _db;

  ProfileRepository(this._db);

  /// Watch single user profile.
  Stream<UserProfileTableData> watchProfile() {
    return (_db.select(_db.userProfileTable)..limit(1)).watchSingle();
  }

  /// Get profile once.
  Future<UserProfileTableData> getProfile() {
    return (_db.select(_db.userProfileTable)..limit(1)).getSingle();
  }

  /// Update user profile settings.
  Future<int> updateProfile(UserProfileTableCompanion companion) {
    return (_db.update(_db.userProfileTable)..where((t) => t.id.equals(1)))
        .write(companion.copyWith(updatedAt: Value(DateTime.now())));
  }

  /// Update gross salary & allowance.
  Future<int> updateSalary({
    required int grossSalarySen,
    int fixedAllowanceSen = 0,
    double epfRate = 0.11,
    bool hasSocso = true,
    bool hasEis = true,
    int paydayDayOfMonth = 25,
    EmploymentType? employmentType,
    String? name,
  }) {
    return updateProfile(
      UserProfileTableCompanion(
        name: name == null ? const Value.absent() : Value(name.trim()),
        grossSalarySen: Value(grossSalarySen),
        fixedAllowanceSen: Value(fixedAllowanceSen),
        epfRate: Value(epfRate),
        hasSocso: Value(hasSocso),
        hasEis: Value(hasEis),
        paydayDayOfMonth: Value(paydayDayOfMonth),
        employmentType: employmentType == null
            ? const Value.absent()
            : Value(employmentType.storageValue),
      ),
    );
  }

  /// Finish first-run onboarding: saves the profile, marks it onboarded and
  /// inserts the chosen starter commitments, all in one transaction.
  Future<void> completeOnboarding({
    required String name,
    required EmploymentType employmentType,
    required int incomeSen,
    required int paydayDayOfMonth,
    double epfRate = 0.11,
    List<StarterCommitment> starterCommitments = const [],
  }) {
    final isIntern = employmentType.isIntern;
    return _db.transaction(() async {
      await updateProfile(
        UserProfileTableCompanion(
          name: Value(name.trim()),
          employmentType: Value(employmentType.storageValue),
          grossSalarySen: Value(incomeSen),
          fixedAllowanceSen: const Value(0),
          // Interns are exempt from EPF / SOCSO / EIS.
          epfRate: Value(isIntern ? 0.0 : epfRate),
          hasSocso: Value(!isIntern),
          hasEis: Value(!isIntern),
          paydayDayOfMonth: Value(paydayDayOfMonth),
          isOnboarded: const Value(true),
        ),
      );

      for (final c in starterCommitments) {
        final yearlySen = c.monthlyPaymentSen * 12;
        await _db.into(_db.commitmentsTable).insert(
              CommitmentsTableCompanion.insert(
                title: c.title,
                type: 'other',
                totalAmountSen: yearlySen,
                monthlyPaymentSen: c.monthlyPaymentSen,
                remainingAmountSen: yearlySen,
                dueDayOfMonth: Value(c.dueDayOfMonth),
              ),
            );
      }
    });
  }

  /// Update current emergency savings balance.
  Future<int> updateSavings(int currentSavingsSen) {
    return updateProfile(
      UserProfileTableCompanion(
        currentSavingsSen: Value(currentSavingsSen),
      ),
    );
  }

  /// Update budget allocation plan preferences.
  Future<int> updateBudgetPlan({
    required String budgetPreset,
    double? customNeedsRatio,
    double? customWantsRatio,
    double? customSavingsRatio,
    double? customGivingRatio,
  }) {
    return updateProfile(
      UserProfileTableCompanion(
        budgetPreset: Value(budgetPreset),
        customNeedsRatio: Value(customNeedsRatio),
        customWantsRatio: Value(customWantsRatio),
        customSavingsRatio: Value(customSavingsRatio),
        customGivingRatio: Value(customGivingRatio),
      ),
    );
  }
}
