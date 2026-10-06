import 'package:drift/drift.dart';

class UserProfileTable extends Table {
  @override
  String get tableName => 'user_profile';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withDefault(const Constant('Fresh Grad'))();

  // Onboarding & employment
  /// False until the user finishes the first-run onboarding wizard.
  BoolColumn get isOnboarded => boolean().withDefault(const Constant(false))();

  /// 'intern' or 'fullTime' (see EmploymentType.storageValue).
  /// For interns, [grossSalarySen] stores the monthly allowance.
  TextColumn get employmentType => text().withDefault(const Constant('intern'))();

  // Financial fields stored in sen (1 Ringgit = 100 sen)
  IntColumn get grossSalarySen => integer().withDefault(const Constant(300000))(); // RM 3,000.00
  IntColumn get fixedAllowanceSen => integer().withDefault(const Constant(0))();
  
  // Statutory settings
  RealColumn get epfRate => real().withDefault(const Constant(0.11))(); // 11%
  BoolColumn get hasSocso => boolean().withDefault(const Constant(true))();
  BoolColumn get hasEis => boolean().withDefault(const Constant(true))();
  BoolColumn get isEpfVoluntaryExcess => boolean().withDefault(const Constant(false))();

  // Payday and savings goals
  IntColumn get paydayDayOfMonth => integer().withDefault(const Constant(25))();
  IntColumn get emergencyFundMonthsTarget => integer().withDefault(const Constant(3))();
  IntColumn get currentSavingsSen => integer().withDefault(const Constant(0))();

  // App preferences
  BoolColumn get biometricLockEnabled => boolean().withDefault(const Constant(false))();
  BoolColumn get aiAdviceEnabled => boolean().withDefault(const Constant(true))();

  // Budget allocation plan preferences
  /// 'recommended', 'fire_saver', 'lean', or 'custom'
  TextColumn get budgetPreset => text().withDefault(const Constant('recommended'))();
  RealColumn get customNeedsRatio => real().nullable()();
  RealColumn get customWantsRatio => real().nullable()();
  RealColumn get customSavingsRatio => real().nullable()();
  RealColumn get customGivingRatio => real().nullable()();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
