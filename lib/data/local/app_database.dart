import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/user_profile_table.dart';
import 'tables/expense_categories_table.dart';
import 'tables/expenses_table.dart';
import 'tables/commitments_table.dart';
import 'tables/checklist_items_table.dart';
import 'tables/accounts_table.dart';
import 'tables/account_transfers_table.dart';
import 'tables/daily_spending_plans_table.dart';
import 'default_seeds.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  UserProfileTable,
  ExpenseCategoriesTable,
  ExpensesTable,
  CommitmentsTable,
  ChecklistItemsTable,
  AccountsTable,
  AccountTransfersTable,
  DailySpendingPlansTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 7;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'danbudget_db');
  }

  /// Ensures LHDN Form BE tax optimization tables exist for v1.6.0+.
  Future<void> ensureTaxTables() async {
    await customStatement('''
      CREATE TABLE IF NOT EXISTS tax_year_profiles (
        assessment_year INTEGER PRIMARY KEY NOT NULL,
        annual_bonus_sen INTEGER NOT NULL DEFAULT 0,
        annual_other_income_sen INTEGER NOT NULL DEFAULT 0,
        annual_pcb_override_sen INTEGER,
        zakat_fitrah_sen INTEGER NOT NULL DEFAULT 0,
        voluntary_epf_sen INTEGER NOT NULL DEFAULT 0,
        life_insurance_sen INTEGER NOT NULL DEFAULT 0,
        medical_insurance_sen INTEGER NOT NULL DEFAULT 0,
        prs_annuity_sen INTEGER NOT NULL DEFAULT 0,
        sspn_net_savings_sen INTEGER NOT NULL DEFAULT 0,
        higher_education_sen INTEGER NOT NULL DEFAULT 0,
        upskilling_sen INTEGER NOT NULL DEFAULT 0,
        housing_loan_tier TEXT NOT NULL DEFAULT 'none',
        housing_loan_interest_sen INTEGER NOT NULL DEFAULT 0,
        lifestyle_ai_sen INTEGER NOT NULL DEFAULT 0,
        lifestyle_internet_sen INTEGER NOT NULL DEFAULT 0,
        lifestyle_books_sen INTEGER NOT NULL DEFAULT 0,
        lifestyle_devices_sen INTEGER NOT NULL DEFAULT 0,
        lifestyle_courses_sen INTEGER NOT NULL DEFAULT 0,
        sports_equipment_sen INTEGER NOT NULL DEFAULT 0,
        sports_gym_facility_sen INTEGER NOT NULL DEFAULT 0,
        sports_competition_sen INTEGER NOT NULL DEFAULT 0,
        medical_serious_fertility_sen INTEGER NOT NULL DEFAULT 0,
        medical_checkup_mental_sen INTEGER NOT NULL DEFAULT 0,
        medical_dental_sen INTEGER NOT NULL DEFAULT 0,
        medical_vaccination_sen INTEGER NOT NULL DEFAULT 0,
        updated_at INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await customStatement('''
      CREATE TABLE IF NOT EXISTS tax_receipt_claims (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        assessment_year INTEGER NOT NULL,
        expense_id INTEGER,
        title TEXT NOT NULL,
        amount_sen INTEGER NOT NULL,
        bucket_id TEXT NOT NULL,
        sub_bucket_id TEXT,
        receipt_ref TEXT NOT NULL DEFAULT '',
        claimed_date INTEGER NOT NULL,
        is_auto_classified INTEGER NOT NULL DEFAULT 1
      )
    ''');
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await ensureTaxTables();
        // Seed default categories, checklist and initial profile
        await batch((b) {
          b.insertAll(expenseCategoriesTable, DefaultSeeds.defaultCategories);
          b.insertAll(checklistItemsTable, DefaultSeeds.defaultChecklist);
          b.insertAll(accountsTable, DefaultSeeds.defaultAccounts);
          b.insert(
            userProfileTable,
            const UserProfileTableCompanion(
              name: Value(''),
              isOnboarded: Value(false),
              employmentType: Value('intern'),
              grossSalarySen: Value(90000), // RM 900.00 intern allowance
              epfRate: Value(0.0),
              hasSocso: Value(false),
              hasEis: Value(false),
            ),
          );
        });
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // v1 -> v2: onboarding flag + employment type.
          // Existing prototype users are sent through onboarding once.
          await m.addColumn(userProfileTable, userProfileTable.isOnboarded);
          await m.addColumn(userProfileTable, userProfileTable.employmentType);
        }
        if (from < 3) {
          // v2 -> v3: adjustable budget preset & custom ratios
          await m.addColumn(userProfileTable, userProfileTable.budgetPreset);
          await m.addColumn(userProfileTable, userProfileTable.customNeedsRatio);
          await m.addColumn(userProfileTable, userProfileTable.customWantsRatio);
          await m.addColumn(userProfileTable, userProfileTable.customSavingsRatio);
          await m.addColumn(userProfileTable, userProfileTable.customGivingRatio);
        }
        if (from < 4) {
          // v3 -> v4: Accounts & Transfers for Money on Hand tracking
          await m.createTable(accountsTable);
          await m.createTable(accountTransfersTable);
          await m.addColumn(expensesTable, expensesTable.accountId);
          await batch((b) {
            b.insertAll(accountsTable, DefaultSeeds.defaultAccounts);
          });
        }
        if (from < 5) {
          // v4 -> v5: Rename giving category to Charity
          await (update(expenseCategoriesTable)
                ..where((tbl) => tbl.id.equals('giving')))
              .write(
            const ExpenseCategoriesTableCompanion(
              name: Value('Charity'),
            ),
          );
        }
        if (from < 6) {
          // v5 -> v6: Checklist target dates, Daily spending plans, and Workday settings
          await m.addColumn(checklistItemsTable, checklistItemsTable.targetDate);
          await m.addColumn(userProfileTable, userProfileTable.workdaysOnlySafeToSpend);
          await m.addColumn(userProfileTable, userProfileTable.defaultWorkdayTargetSen);
          await m.addColumn(userProfileTable, userProfileTable.defaultWeekendTargetSen);
          await m.createTable(dailySpendingPlansTable);
        }
        if (from < 7) {
          // v6 -> v7: LHDN Form BE Personal Income Tax Optimization Engine tables
          await ensureTaxTables();
        }
      },
      beforeOpen: (details) async {
        await ensureTaxTables();
        // Ensure legacy category names are synchronized to Charity
        await (update(expenseCategoriesTable)
              ..where((tbl) =>
                  tbl.id.equals('giving') &
                  tbl.name.isNotValue('Charity')))
            .write(
          const ExpenseCategoriesTableCompanion(
            name: Value('Charity'),
          ),
        );
      },
    );
  }
}
