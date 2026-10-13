import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../local/app_database.dart';
import '../models/expense_with_category.dart';
import '../repositories/profile_repository.dart';
import '../repositories/expense_repository.dart';
import '../repositories/commitment_repository.dart';
import '../repositories/checklist_repository.dart';
import '../repositories/account_repository.dart';
import '../models/transfer_with_accounts.dart';

import '../repositories/daily_plan_repository.dart';

/// Singleton instance of AppDatabase.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(ref.watch(databaseProvider));
});

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return ExpenseRepository(ref.watch(databaseProvider));
});

final commitmentRepositoryProvider = Provider<CommitmentRepository>((ref) {
  return CommitmentRepository(ref.watch(databaseProvider));
});

final checklistRepositoryProvider = Provider<ChecklistRepository>((ref) {
  return ChecklistRepository(ref.watch(databaseProvider));
});

final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  return AccountRepository(ref.watch(databaseProvider));
});

final dailyPlanRepositoryProvider = Provider<DailyPlanRepository>((ref) {
  return DailyPlanRepository(ref.watch(databaseProvider));
});

final userProfileStreamProvider = StreamProvider<UserProfileTableData>((ref) {
  return ref.watch(profileRepositoryProvider).watchProfile();
});

final categoriesStreamProvider = StreamProvider<List<ExpenseCategoriesTableData>>((ref) {
  return ref.watch(expenseRepositoryProvider).watchCategories();
});

final recentExpensesStreamProvider = StreamProvider<List<ExpenseWithCategory>>((ref) {
  return ref.watch(expenseRepositoryProvider).watchRecentExpenses();
});

final activeCommitmentsStreamProvider = StreamProvider<List<CommitmentsTableData>>((ref) {
  return ref.watch(commitmentRepositoryProvider).watchActiveCommitments();
});

final checklistStreamProvider = StreamProvider<List<ChecklistItemsTableData>>((ref) {
  return ref.watch(checklistRepositoryProvider).watchChecklistItems();
});

final accountsStreamProvider = StreamProvider<List<AccountsTableData>>((ref) {
  return ref.watch(accountRepositoryProvider).watchAccounts();
});

final liquidAccountsStreamProvider = StreamProvider<List<AccountsTableData>>((ref) {
  return ref.watch(accountRepositoryProvider).watchLiquidAccounts();
});

final totalMoneyOnHandStreamProvider = StreamProvider<int>((ref) {
  return ref.watch(accountRepositoryProvider).watchTotalLiquidBalanceSen();
});

final recentTransfersStreamProvider = StreamProvider<List<TransferWithAccounts>>((ref) {
  return ref.watch(accountRepositoryProvider).watchRecentTransfers();
});

final todayPlanStreamProvider = StreamProvider<DailySpendingPlansTableData?>((ref) {
  final now = DateTime.now();
  return ref.watch(dailyPlanRepositoryProvider).watchPlanForDate(now);
});


