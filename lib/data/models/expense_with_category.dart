import '../local/app_database.dart';

class ExpenseWithCategory {
  final ExpensesTableData expense;
  final ExpenseCategoriesTableData category;
  final AccountsTableData? account;

  const ExpenseWithCategory({
    required this.expense,
    required this.category,
    this.account,
  });
}

