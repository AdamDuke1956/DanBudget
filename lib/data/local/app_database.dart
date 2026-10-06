import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/user_profile_table.dart';
import 'tables/expense_categories_table.dart';
import 'tables/expenses_table.dart';
import 'tables/commitments_table.dart';
import 'tables/checklist_items_table.dart';
import 'tables/accounts_table.dart';
import 'tables/account_transfers_table.dart';
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
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 4;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'danbudget_db');
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
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
      },
    );
  }
}
