import 'dart:convert';
import 'package:drift/drift.dart';
import '../../domain/engine/employment_type.dart';
import '../local/app_database.dart';
import '../repositories/expense_repository.dart';
import '../repositories/tax_repository.dart';

/// Result metadata returned by [BackupService.exportToBackupPayload].
class BackupExportPayload {
  final String jsonString;
  final int accountCount;
  final int transferCount;
  final int expenseCount;
  final int commitmentCount;
  final int checklistCount;
  final int dailyPlanCount;
  final int taxProfileCount;
  final int taxClaimCount;

  const BackupExportPayload({
    required this.jsonString,
    required this.accountCount,
    required this.transferCount,
    required this.expenseCount,
    required this.commitmentCount,
    required this.checklistCount,
    required this.dailyPlanCount,
    required this.taxProfileCount,
    required this.taxClaimCount,
  });
}

/// Handles complete, atomic local JSON backup and restore across all DanBudget tables.
abstract final class BackupService {
  /// Exports the full local database state as formatted JSON.
  static Future<BackupExportPayload> exportToBackupPayload(
    AppDatabase db, {
    TaxRepository? taxRepo,
  }) => db.transaction(() async {
    final profile =
        await (db.select(db.userProfileTable)..limit(1)).getSingleOrNull();
    final accounts =
        await (db.select(db.accountsTable)
          ..orderBy([(t) => OrderingTerm.asc(t.id)])).get();
    final transfers =
        await (db.select(db.accountTransfersTable)
          ..orderBy([(t) => OrderingTerm.asc(t.id)])).get();
    final expenses = await ExpenseRepository(db).getAllExpenses();
    final commitments =
        await (db.select(db.commitmentsTable)
          ..orderBy([(t) => OrderingTerm.asc(t.id)])).get();
    final checklist =
        await (db.select(db.checklistItemsTable)
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])).get();
    final dailyPlans =
        await (db.select(db.dailySpendingPlansTable)
          ..orderBy([(t) => OrderingTerm.asc(t.date)])).get();

    final effectiveTaxRepo = taxRepo ?? TaxRepository(db);
    final taxProfiles = await effectiveTaxRepo.getAllProfiles();
    final taxClaims = await effectiveTaxRepo.getAllReceiptClaims();

    final data = <String, dynamic>{
      'exportedAt': DateTime.now().toIso8601String(),
      'version': '1.6.6',
      'schemaVersion': db.schemaVersion,
      'appName': 'DanBudget',
      if (profile != null)
        'profile': {
          'name': profile.name,
          'isOnboarded': profile.isOnboarded,
          'employmentType': profile.employmentType,
          'grossSalarySen': profile.grossSalarySen,
          'fixedAllowanceSen': profile.fixedAllowanceSen,
          'epfRate': profile.epfRate,
          'hasSocso': profile.hasSocso,
          'hasEis': profile.hasEis,
          'isEpfVoluntaryExcess': profile.isEpfVoluntaryExcess,
          'paydayDayOfMonth': profile.paydayDayOfMonth,
          'emergencyFundMonthsTarget': profile.emergencyFundMonthsTarget,
          'currentSavingsSen': profile.currentSavingsSen,
          'biometricLockEnabled': profile.biometricLockEnabled,
          'aiAdviceEnabled': profile.aiAdviceEnabled,
          'budgetPreset': profile.budgetPreset,
          'customNeedsRatio': profile.customNeedsRatio,
          'customWantsRatio': profile.customWantsRatio,
          'customSavingsRatio': profile.customSavingsRatio,
          'customGivingRatio': profile.customGivingRatio,
          'workdaysOnlySafeToSpend': profile.workdaysOnlySafeToSpend,
          'defaultWorkdayTargetSen': profile.defaultWorkdayTargetSen,
          'defaultWeekendTargetSen': profile.defaultWeekendTargetSen,
          'updatedAt': profile.updatedAt.toIso8601String(),
        },
      'accounts':
          accounts
              .map(
                (a) => {
                  'id': a.id,
                  'name': a.name,
                  'type': a.type,
                  'balanceSen': a.balanceSen,
                  'icon': a.icon,
                  'colorHex': a.colorHex,
                  'isDefault': a.isDefault,
                  'isLiquidOnHand': a.isLiquidOnHand,
                  'updatedAt': a.updatedAt.toIso8601String(),
                },
              )
              .toList(),
      'accountTransfers':
          transfers
              .map(
                (t) => {
                  'id': t.id,
                  'fromAccountId': t.fromAccountId,
                  'toAccountId': t.toAccountId,
                  'amountSen': t.amountSen,
                  'date': t.date.toIso8601String(),
                  'note': t.note,
                  'createdAt': t.createdAt.toIso8601String(),
                },
              )
              .toList(),
      'expenses':
          expenses
              .map(
                (e) => {
                  'id': e.expense.id,
                  'amountSen': e.expense.amountSen,
                  'category': e.category.name,
                  'categoryId': e.expense.categoryId,
                  'date': e.expense.date.toIso8601String(),
                  'note': e.expense.note,
                  'isCommitment': e.expense.isCommitmentPayment,
                  'commitmentId': e.expense.commitmentId,
                  'accountId': e.expense.accountId,
                  'createdAt': e.expense.createdAt.toIso8601String(),
                },
              )
              .toList(),
      'commitments':
          commitments
              .map(
                (c) => {
                  'id': c.id,
                  'title': c.title,
                  'type': c.type,
                  'totalAmountSen': c.totalAmountSen,
                  'monthlyPaymentSen': c.monthlyPaymentSen,
                  'remainingAmountSen': c.remainingAmountSen,
                  'interestRateAnnual': c.interestRateAnnual,
                  'totalTenureMonths': c.totalTenureMonths,
                  'remainingTenureMonths': c.remainingTenureMonths,
                  'dueDayOfMonth': c.dueDayOfMonth,
                  'isActive': c.isActive,
                  'createdAt': c.createdAt.toIso8601String(),
                },
              )
              .toList(),
      'checklist':
          checklist
              .map(
                (i) => {
                  'id': i.id,
                  'title': i.title,
                  'description': i.description,
                  'category': i.category,
                  'isCompleted': i.isCompleted,
                  'completedAt': i.completedAt?.toIso8601String(),
                  'targetDate': i.targetDate?.toIso8601String(),
                  'sortOrder': i.sortOrder,
                },
              )
              .toList(),
      'dailySpendingPlans':
          dailyPlans
              .map(
                (p) => {
                  'id': p.id,
                  'date': p.date.toIso8601String(),
                  'targetAmountSen': p.targetAmountSen,
                  'whatToSpendOn': p.whatToSpendOn,
                  'reason': p.reason,
                  'isWorkday': p.isWorkday,
                  'updatedAt': p.updatedAt.toIso8601String(),
                },
              )
              .toList(),
      'taxProfiles': taxProfiles.map((p) => p.toJson()).toList(),
      'taxReceiptClaims': taxClaims.map((c) => c.toJson()).toList(),
    };

    return BackupExportPayload(
      jsonString: const JsonEncoder.withIndent('  ').convert(data),
      accountCount: accounts.length,
      transferCount: transfers.length,
      expenseCount: expenses.length,
      commitmentCount: commitments.length,
      checklistCount: checklist.length,
      dailyPlanCount: dailyPlans.length,
      taxProfileCount: taxProfiles.length,
      taxClaimCount: taxClaims.length,
    );
  });

  /// Restores a JSON backup atomically inside a single database transaction.
  ///
  /// Any parsing or constraint error rolls back all changes (including tax tables)
  /// so partial failures never wipe existing data.
  static Future<void> restoreFromJson(
    AppDatabase db,
    String jsonText, {
    TaxRepository? taxRepo,
  }) async {
    final dynamic decoded = jsonDecode(jsonText);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException(
        'Invalid backup format: root must be a JSON object.',
      );
    }
    if (decoded['appName'] != null && decoded['appName'] != 'DanBudget') {
      throw const FormatException(
        'Unsupported backup file: expected a DanBudget backup.',
      );
    }
    if (decoded.containsKey('profile') &&
        decoded['profile'] is! Map<String, dynamic>) {
      throw const FormatException('Invalid profile in backup.');
    }
    for (final section in const [
      'accounts',
      'accountTransfers',
      'expenses',
      'commitments',
      'checklist',
      'dailySpendingPlans',
      'taxProfiles',
      'taxReceiptClaims',
    ]) {
      if (decoded.containsKey(section) && decoded[section] is! List) {
        throw FormatException('Invalid $section in backup.');
      }
    }

    await db.ensureTaxTables();
    final effectiveTaxRepo = taxRepo ?? TaxRepository(db);

    await db.transaction(() async {
      // 1. User Profile
      if (decoded['profile'] is Map<String, dynamic>) {
        final p = decoded['profile'] as Map<String, dynamic>;
        final profileQuery = db.select(db.userProfileTable)
          ..where((t) => t.id.equals(1));
        final current = await profileQuery.getSingleOrNull();
        final empStorage =
            p['employmentType'] != null
                ? EmploymentType.fromStorage(
                  p['employmentType'] as String?,
                ).storageValue
                : current?.employmentType ??
                    EmploymentType.fullTime.storageValue;
        final isIntern = empStorage == EmploymentType.intern.storageValue;

        final companion = UserProfileTableCompanion(
          name: Value((p['name'] as String?) ?? ''),
          isOnboarded: Value((p['isOnboarded'] as bool?) ?? true),
          employmentType: Value(empStorage),
          grossSalarySen: Value(
            (p['grossSalarySen'] as num?)?.toInt() ?? 300000,
          ),
          fixedAllowanceSen: Value(
            (p['fixedAllowanceSen'] as num?)?.toInt() ?? 0,
          ),
          epfRate: Value(
            (p['epfRate'] as num?)?.toDouble() ??
                current?.epfRate ??
                (isIntern ? 0.0 : 0.11),
          ),
          hasSocso: Value(
            (p['hasSocso'] as bool?) ?? current?.hasSocso ?? !isIntern,
          ),
          hasEis: Value((p['hasEis'] as bool?) ?? current?.hasEis ?? !isIntern),
          isEpfVoluntaryExcess: Value(
            (p['isEpfVoluntaryExcess'] as bool?) ??
                current?.isEpfVoluntaryExcess ??
                false,
          ),
          paydayDayOfMonth: Value(
            (p['paydayDayOfMonth'] as num?)?.toInt() ?? 25,
          ),
          emergencyFundMonthsTarget: Value(
            (p['emergencyFundMonthsTarget'] as num?)?.toInt() ??
                current?.emergencyFundMonthsTarget ??
                3,
          ),
          currentSavingsSen: Value(
            (p['currentSavingsSen'] as num?)?.toInt() ?? 0,
          ),
          biometricLockEnabled: Value(
            (p['biometricLockEnabled'] as bool?) ??
                current?.biometricLockEnabled ??
                false,
          ),
          aiAdviceEnabled: Value(
            (p['aiAdviceEnabled'] as bool?) ?? current?.aiAdviceEnabled ?? true,
          ),
          budgetPreset: Value(
            (p['budgetPreset'] as String?) ??
                current?.budgetPreset ??
                'recommended',
          ),
          customNeedsRatio:
              p.containsKey('customNeedsRatio')
                  ? Value((p['customNeedsRatio'] as num?)?.toDouble())
                  : const Value.absent(),
          customWantsRatio:
              p.containsKey('customWantsRatio')
                  ? Value((p['customWantsRatio'] as num?)?.toDouble())
                  : const Value.absent(),
          customSavingsRatio:
              p.containsKey('customSavingsRatio')
                  ? Value((p['customSavingsRatio'] as num?)?.toDouble())
                  : const Value.absent(),
          customGivingRatio:
              p.containsKey('customGivingRatio')
                  ? Value((p['customGivingRatio'] as num?)?.toDouble())
                  : const Value.absent(),
          workdaysOnlySafeToSpend: Value(
            (p['workdaysOnlySafeToSpend'] as bool?) ??
                current?.workdaysOnlySafeToSpend ??
                false,
          ),
          defaultWorkdayTargetSen: Value(
            (p['defaultWorkdayTargetSen'] as num?)?.toInt() ??
                current?.defaultWorkdayTargetSen ??
                1000,
          ),
          defaultWeekendTargetSen: Value(
            (p['defaultWeekendTargetSen'] as num?)?.toInt() ??
                current?.defaultWeekendTargetSen ??
                2000,
          ),
          updatedAt: Value(
            _parseOptionalDate(p['updatedAt'] as String?) ?? DateTime.now(),
          ),
        );

        final updated = await (db.update(db.userProfileTable)
          ..where((t) => t.id.equals(1))).write(companion);
        if (updated == 0) {
          await db
              .into(db.userProfileTable)
              .insert(companion.copyWith(id: const Value(1)));
        }
      }

      final hasAccounts = decoded['accounts'] is List;
      final hasTransfers = decoded['accountTransfers'] is List;
      final hasCommitments = decoded['commitments'] is List;
      final hasExpenses = decoded['expenses'] is List;

      // Clear child tables before parent tables to preserve referential integrity.
      if (hasTransfers || hasAccounts) {
        await db.delete(db.accountTransfersTable).go();
      }
      if (hasExpenses) {
        await db.delete(db.expensesTable).go();
      } else {
        if (hasAccounts) {
          await db
              .update(db.expensesTable)
              .write(const ExpensesTableCompanion(accountId: Value(null)));
        }
        if (hasCommitments) {
          await db
              .update(db.expensesTable)
              .write(const ExpensesTableCompanion(commitmentId: Value(null)));
        }
      }
      if (hasCommitments) {
        await db.delete(db.commitmentsTable).go();
      }
      if (hasAccounts) {
        await db.delete(db.accountsTable).go();
      }

      // 2. Accounts
      final Map<int, int> accountIdMap = {};
      if (hasAccounts) {
        for (final item in decoded['accounts'] as List) {
          if (item is! Map<String, dynamic>) {
            throw const FormatException('Invalid account entry in backup.');
          }
          final rawId = (item['id'] as num?)?.toInt();
          final updatedAt =
              item['updatedAt'] != null
                  ? (DateTime.tryParse(item['updatedAt'] as String) ??
                      DateTime.now())
                  : DateTime.now();

          final insertedId = await db
              .into(db.accountsTable)
              .insert(
                AccountsTableCompanion.insert(
                  id: rawId != null ? Value(rawId) : const Value.absent(),
                  name: item['name'] as String,
                  type: Value((item['type'] as String?) ?? 'bank'),
                  balanceSen: Value((item['balanceSen'] as num?)?.toInt() ?? 0),
                  icon: Value((item['icon'] as String?) ?? '🏦'),
                  colorHex: Value(
                    (item['colorHex'] as num?)?.toInt() ?? 0xFF00B074,
                  ),
                  isDefault: Value((item['isDefault'] as bool?) ?? false),
                  isLiquidOnHand: Value(
                    (item['isLiquidOnHand'] as bool?) ?? true,
                  ),
                  updatedAt: Value(updatedAt),
                ),
              );
          if (rawId != null) {
            accountIdMap[rawId] = insertedId;
          }
        }
      }

      final validAccountIds =
          (await db.select(db.accountsTable).get()).map((a) => a.id).toSet();

      // 3. Account Transfers
      if (hasTransfers) {
        for (final item in decoded['accountTransfers'] as List) {
          if (item is! Map<String, dynamic>) {
            throw const FormatException(
              'Invalid account transfer entry in backup.',
            );
          }
          final rawFrom = (item['fromAccountId'] as num?)?.toInt();
          final rawTo = (item['toAccountId'] as num?)?.toInt();
          if (rawFrom == null || rawTo == null) {
            throw const FormatException(
              'Account transfer missing source or destination account.',
            );
          }
          final fromId = accountIdMap[rawFrom] ?? rawFrom;
          final toId = accountIdMap[rawTo] ?? rawTo;
          if (!validAccountIds.contains(fromId) ||
              !validAccountIds.contains(toId)) {
            throw const FormatException(
              'Account transfer references a missing account.',
            );
          }

          final rawId = (item['id'] as num?)?.toInt();
          final date =
              item['date'] != null
                  ? (DateTime.tryParse(item['date'] as String) ??
                      DateTime.now())
                  : DateTime.now();
          final createdAt =
              item['createdAt'] != null
                  ? (DateTime.tryParse(item['createdAt'] as String) ?? date)
                  : date;

          await db
              .into(db.accountTransfersTable)
              .insert(
                AccountTransfersTableCompanion.insert(
                  id: rawId != null ? Value(rawId) : const Value.absent(),
                  fromAccountId: fromId,
                  toAccountId: toId,
                  amountSen: (item['amountSen'] as num).toInt(),
                  date: Value(date),
                  note: Value(item['note'] as String?),
                  createdAt: Value(createdAt),
                ),
              );
        }
      }

      // 4. Commitments
      final Map<int, int> commitmentIdMap = {};
      if (hasCommitments) {
        for (final item in decoded['commitments'] as List) {
          if (item is! Map<String, dynamic>) {
            throw const FormatException('Invalid commitment entry in backup.');
          }
          final rawId = (item['id'] as num?)?.toInt();
          final remaining = (item['remainingAmountSen'] as num?)?.toInt() ?? 0;
          final createdAt =
              item['createdAt'] != null
                  ? (DateTime.tryParse(item['createdAt'] as String) ??
                      DateTime.now())
                  : DateTime.now();

          final insertedId = await db
              .into(db.commitmentsTable)
              .insert(
                CommitmentsTableCompanion.insert(
                  id: rawId != null ? Value(rawId) : const Value.absent(),
                  title: (item['title'] as String?) ?? 'Commitment',
                  type: (item['type'] as String?) ?? 'other',
                  totalAmountSen:
                      (item['totalAmountSen'] as num?)?.toInt() ?? remaining,
                  monthlyPaymentSen:
                      (item['monthlyPaymentSen'] as num?)?.toInt() ?? 0,
                  remainingAmountSen: remaining,
                  interestRateAnnual: Value(
                    (item['interestRateAnnual'] as num?)?.toDouble() ?? 0.0,
                  ),
                  totalTenureMonths: Value(
                    (item['totalTenureMonths'] as num?)?.toInt() ?? 12,
                  ),
                  remainingTenureMonths: Value(
                    (item['remainingTenureMonths'] as num?)?.toInt() ?? 1,
                  ),
                  dueDayOfMonth: Value(
                    (item['dueDayOfMonth'] as num?)?.toInt() ?? 1,
                  ),
                  isActive: Value((item['isActive'] as bool?) ?? true),
                  createdAt: Value(createdAt),
                ),
              );
          if (rawId != null) {
            commitmentIdMap[rawId] = insertedId;
          }
        }
      }

      final validCommitmentIds =
          (await db.select(db.commitmentsTable).get()).map((c) => c.id).toSet();

      // 5. Expenses
      final Map<int, int> expenseIdMap = {};
      if (hasExpenses) {
        final categories = await db.select(db.expenseCategoriesTable).get();
        final catById = {for (final c in categories) c.id: c.id};
        final catByName = {
          for (final c in categories) c.name.toLowerCase(): c.id,
          if (catById.containsKey('giving'))
            'family & giving (mak ayah)': 'giving',
        };
        final defaultCatId =
            categories.isNotEmpty ? categories.first.id : 'food';

        for (final item in decoded['expenses'] as List) {
          if (item is! Map<String, dynamic>) {
            throw const FormatException('Invalid expense entry in backup.');
          }
          final rawId = (item['id'] as num?)?.toInt();
          final rawCatId = item['categoryId'] as String?;
          final catName = (item['category'] as String?)?.toLowerCase() ?? '';
          final categoryId =
              (rawCatId != null && catById.containsKey(rawCatId))
                  ? rawCatId
                  : (catByName[catName] ?? defaultCatId);

          final date =
              item['date'] != null
                  ? (DateTime.tryParse(item['date'] as String) ??
                      DateTime.now())
                  : DateTime.now();
          final createdAt =
              item['createdAt'] != null
                  ? (DateTime.tryParse(item['createdAt'] as String) ?? date)
                  : date;

          final rawAccountId = (item['accountId'] as num?)?.toInt();
          int? resolvedAccountId;
          if (rawAccountId != null) {
            final mapped = accountIdMap[rawAccountId] ?? rawAccountId;
            if (validAccountIds.contains(mapped)) {
              resolvedAccountId = mapped;
            }
          }

          final rawCommitmentId = (item['commitmentId'] as num?)?.toInt();
          int? resolvedCommitmentId;
          if (rawCommitmentId != null) {
            final mapped = commitmentIdMap[rawCommitmentId] ?? rawCommitmentId;
            if (validCommitmentIds.contains(mapped)) {
              resolvedCommitmentId = mapped;
            }
          }

          final insertedId = await db
              .into(db.expensesTable)
              .insert(
                ExpensesTableCompanion.insert(
                  id: rawId != null ? Value(rawId) : const Value.absent(),
                  amountSen: (item['amountSen'] as num?)?.toInt() ?? 0,
                  categoryId: categoryId,
                  date: date,
                  note: Value(item['note'] as String?),
                  isCommitmentPayment: Value(
                    (item['isCommitment'] as bool?) ?? false,
                  ),
                  commitmentId: Value(resolvedCommitmentId),
                  accountId: Value(resolvedAccountId),
                  createdAt: Value(createdAt),
                ),
              );
          if (rawId != null) {
            expenseIdMap[rawId] = insertedId;
          }
        }
      }

      // 6. Daily Spending Plans
      if (decoded['dailySpendingPlans'] is List) {
        await db.delete(db.dailySpendingPlansTable).go();
        for (final item in decoded['dailySpendingPlans'] as List) {
          if (item is! Map<String, dynamic>) {
            throw const FormatException('Invalid daily plan entry in backup.');
          }
          final rawId = (item['id'] as num?)?.toInt();
          final dateStr = item['date'] as String?;
          final parsedDate =
              dateStr != null ? DateTime.tryParse(dateStr) : null;
          if (parsedDate == null) {
            throw const FormatException('Daily plan missing valid date.');
          }
          final updatedAt =
              item['updatedAt'] != null
                  ? (DateTime.tryParse(item['updatedAt'] as String) ??
                      DateTime.now())
                  : DateTime.now();

          await db
              .into(db.dailySpendingPlansTable)
              .insert(
                DailySpendingPlansTableCompanion.insert(
                  id: rawId != null ? Value(rawId) : const Value.absent(),
                  date: parsedDate,
                  targetAmountSen: Value(
                    (item['targetAmountSen'] as num?)?.toInt() ?? 0,
                  ),
                  whatToSpendOn: Value(item['whatToSpendOn'] as String?),
                  reason: Value(item['reason'] as String?),
                  isWorkday: Value((item['isWorkday'] as bool?) ?? false),
                  updatedAt: Value(updatedAt),
                ),
              );
        }
      }

      // 7. Checklist
      if (decoded['checklist'] is List) {
        for (final item in decoded['checklist'] as List) {
          if (item is! Map<String, dynamic>) {
            throw const FormatException('Invalid checklist entry in backup.');
          }
          if (item['id'] == null) continue;
          final id = item['id'].toString();
          final isCompleted = (item['isCompleted'] as bool?) ?? false;
          final completedAt =
              item.containsKey('completedAt')
                  ? _parseOptionalDate(item['completedAt'] as String?)
                  : (isCompleted ? DateTime.now() : null);
          final hasTargetDate = item.containsKey('targetDate');
          final targetDate = _parseOptionalDate(item['targetDate'] as String?);

          final existing =
              await (db.select(db.checklistItemsTable)
                ..where((t) => t.id.equals(id))).getSingleOrNull();

          if (existing != null) {
            await (db.update(db.checklistItemsTable)
              ..where((t) => t.id.equals(id))).write(
              ChecklistItemsTableCompanion(
                title:
                    item['title'] != null
                        ? Value(item['title'] as String)
                        : const Value.absent(),
                description:
                    item['description'] != null
                        ? Value(item['description'] as String)
                        : const Value.absent(),
                category:
                    item['category'] != null
                        ? Value(item['category'] as String)
                        : const Value.absent(),
                isCompleted: Value(isCompleted),
                completedAt: Value(completedAt),
                targetDate:
                    hasTargetDate ? Value(targetDate) : const Value.absent(),
                sortOrder:
                    item['sortOrder'] != null
                        ? Value((item['sortOrder'] as num).toInt())
                        : const Value.absent(),
              ),
            );
          } else {
            await db
                .into(db.checklistItemsTable)
                .insert(
                  ChecklistItemsTableCompanion.insert(
                    id: id,
                    title: (item['title'] as String?) ?? 'Checklist Goal',
                    description: (item['description'] as String?) ?? '',
                    category: (item['category'] as String?) ?? 'banking',
                    isCompleted: Value(isCompleted),
                    completedAt: Value(completedAt),
                    targetDate: Value(targetDate),
                    sortOrder: Value(
                      (item['sortOrder'] as num?)?.toInt() ?? 99,
                    ),
                  ),
                );
          }
        }
      }

      // 8. Tax Profiles & Receipt Claims (atomic inside the same transaction)
      if (decoded['taxProfiles'] is List ||
          decoded['taxReceiptClaims'] is List) {
        await effectiveTaxRepo.clearAllTaxDataInTransaction();

        if (decoded['taxProfiles'] is List) {
          for (final item in decoded['taxProfiles'] as List) {
            if (item is! Map<String, dynamic>) {
              throw const FormatException(
                'Invalid tax profile entry in backup.',
              );
            }
            await effectiveTaxRepo.upsertProfileInTransaction(
              TaxYearProfileData.fromJson(item),
            );
          }
        }

        if (decoded['taxReceiptClaims'] is List) {
          for (final item in decoded['taxReceiptClaims'] as List) {
            if (item is! Map<String, dynamic>) {
              throw const FormatException(
                'Invalid tax receipt claim entry in backup.',
              );
            }
            final claim = TaxReceiptClaimData.fromJson(item);
            final mappedExpenseId =
                claim.expenseId != null
                    ? (expenseIdMap[claim.expenseId!] ?? claim.expenseId)
                    : null;
            await effectiveTaxRepo.insertReceiptClaimInTransaction(
              claim,
              overrideExpenseId: mappedExpenseId,
            );
          }
        }
      }
    });

    effectiveTaxRepo.notifyChanged();
  }

  static DateTime? _parseOptionalDate(String? date) =>
      date == null ? null : DateTime.parse(date);
}
