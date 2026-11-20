import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/money.dart';
import '../../domain/engine/allocation_engine.dart';
import '../../domain/engine/debt_planner.dart';
import '../../domain/engine/employment_type.dart';
import '../../domain/engine/financial_health_score.dart';
import '../../domain/engine/net_salary_calculator.dart';
import '../../domain/engine/safe_to_spend_calculator.dart';
import '../local/app_database.dart';
import '../models/expense_with_category.dart';
import '../models/transfer_with_accounts.dart';
import 'database_providers.dart';

class DashboardState {
  final UserProfileTableData profile;
  final NetSalaryResult netSalary;
  final AllocationResult allocation;
  final SafeToSpendResult safeToSpend;
  final HealthScoreResult healthScore;
  final List<ExpenseWithCategory> recentExpenses;
  final List<CommitmentsTableData> activeCommitments;
  final List<AccountsTableData> accounts;
  final List<TransferWithAccounts> recentTransfers;
  final Money totalLiquidOnHand;
  final Money totalSpentThisCycle;
  final Money remainingFlexibleBudget;

  /// Parsed employment type of [profile].
  EmploymentType get employmentType =>
      EmploymentType.fromStorage(profile.employmentType);

  const DashboardState({
    required this.profile,
    required this.netSalary,
    required this.allocation,
    required this.safeToSpend,
    required this.healthScore,
    required this.recentExpenses,
    required this.activeCommitments,
    required this.accounts,
    required this.recentTransfers,
    required this.totalLiquidOnHand,
    required this.totalSpentThisCycle,
    required this.remainingFlexibleBudget,
  });
}

final dashboardStateProvider = Provider<AsyncValue<DashboardState>>((ref) {
  final profileAsync = ref.watch(userProfileStreamProvider);
  final commitmentsAsync = ref.watch(activeCommitmentsStreamProvider);
  final expensesAsync = ref.watch(recentExpensesStreamProvider);
  final accountsAsync = ref.watch(accountsStreamProvider);
  final transfersAsync = ref.watch(recentTransfersStreamProvider);
  final todayPlanAsync = ref.watch(todayPlanStreamProvider);

  if (profileAsync is AsyncError) {
    return AsyncError(profileAsync.error!, profileAsync.stackTrace!);
  }
  if (commitmentsAsync is AsyncError) {
    return AsyncError(commitmentsAsync.error!, commitmentsAsync.stackTrace!);
  }
  if (expensesAsync is AsyncError) {
    return AsyncError(expensesAsync.error!, expensesAsync.stackTrace!);
  }
  if (accountsAsync is AsyncError) {
    return AsyncError(accountsAsync.error!, accountsAsync.stackTrace!);
  }
  if (transfersAsync is AsyncError) {
    return AsyncError(transfersAsync.error!, transfersAsync.stackTrace!);
  }

  if (profileAsync is AsyncLoading ||
      commitmentsAsync is AsyncLoading ||
      expensesAsync is AsyncLoading ||
      accountsAsync is AsyncLoading ||
      transfersAsync is AsyncLoading) {
    return const AsyncLoading();
  }

  final profile = profileAsync.value!;
  final now = DateTime.now();
  final int payday = profile.paydayDayOfMonth;
  final DateTime cycleStart = now.day >= payday
      ? DateTime(now.year, now.month, payday)
      : DateTime(now.year, now.month - 1, payday);

  final cycleSpentAsync = ref.watch(cycleSpentStreamProvider(cycleStart));
  if (cycleSpentAsync is AsyncError) {
    return AsyncError(cycleSpentAsync.error!, cycleSpentAsync.stackTrace!);
  }
  if (cycleSpentAsync is AsyncLoading) {
    return const AsyncLoading();
  }

  final commitments = commitmentsAsync.value ?? [];
  final recentExpenses = expensesAsync.value ?? [];
  final accounts = accountsAsync.value ?? [];
  final recentTransfers = transfersAsync.value ?? [];


  final employmentType = EmploymentType.fromStorage(profile.employmentType);
  final netSalary = NetSalaryCalculator.calculate(
    grossSalary: Money(profile.grossSalarySen),
    allowances: Money(profile.fixedAllowanceSen),
    employmentType: employmentType,
    epfRate: profile.epfRate,
    hasSocso: profile.hasSocso,
    hasEis: profile.hasEis,
    isMalaysianCitizen: true,
  );

  final int totalCommitmentSen = commitments.fold<int>(
    0,
    (sum, c) => sum + c.monthlyPaymentSen,
  );
  final totalCommitments = Money(totalCommitmentSen);

  final targetPreset = AllocationPreset.getPreset(
    presetKey: profile.budgetPreset,
    type: employmentType,
    customNeeds: profile.customNeedsRatio,
    customWants: profile.customWantsRatio,
    customSavings: profile.customSavingsRatio,
    customGiving: profile.customGivingRatio,
  );

  final allocation = AllocationEngine.calculate(
    netSalary: netSalary.netSalary,
    totalCommitments: totalCommitments,
    employmentType: employmentType,
    targetPreset: targetPreset,
  );

  final int spentSen = cycleSpentAsync.value ?? 0;
  final totalSpent = Money(spentSen);

  final int totalLiquidSen = accounts
      .where((a) => a.isLiquidOnHand)
      .fold<int>(0, (sum, a) => sum + a.balanceSen);
  final totalLiquidOnHand = Money(totalLiquidSen);

  // Flexible budget = (Needs flexible + Wants) - spent this cycle
  final int flexibleCapSen =
      allocation.needs.flexibleAmount.sen + allocation.wants.targetAmount.sen;
  final int remainingSen =
      (flexibleCapSen - spentSen).clamp(0, double.infinity).toInt();
  final remainingFlexible = Money(remainingSen);

  final todayPlan = todayPlanAsync.asData?.value;

  final safeToSpend = SafeToSpendCalculator.calculate(
    remainingFlexibleBudget: remainingFlexible,
    unpaidCommitmentsBeforePayday: const Money(0),
    currentDate: now,
    paydayDayOfMonth: payday,
    liquidOnHand: totalLiquidOnHand,
    workdaysOnly: profile.workdaysOnlySafeToSpend,
    todayCustomTarget: todayPlan != null && todayPlan.targetAmountSen > 0
        ? Money(todayPlan.targetAmountSen)
        : null,
    todayWhatToSpendOn: todayPlan?.whatToSpendOn,
    todayReason: todayPlan?.reason,
    todayIsWorkday: todayPlan?.isWorkday,
  );

  final domainCommitments = commitments.map((c) {
    final type = _mapCommitmentType(c.type);
    final monthsPaid = (c.totalTenureMonths - c.remainingTenureMonths).clamp(0, 999);
    return CommitmentItem(
      id: c.id.toString(),
      name: c.title,
      type: type,
      monthlyAmount: Money(c.monthlyPaymentSen),
      totalTenureMonths: c.totalTenureMonths,
      monthsPaid: monthsPaid,
      totalOriginalAmount: Money(c.totalAmountSen),
      dueDayOfMonth: c.dueDayOfMonth,
    );
  }).toList();

  final healthScore = FinancialHealthEngine.evaluate(
    netSalary: netSalary.netSalary,
    totalCommitments: totalCommitments,
    currentEmergencyFund: Money(profile.currentSavingsSen),
    monthlySavingsTarget: allocation.savings.targetAmount,
    activeCommitments: domainCommitments,
  );

  return AsyncData(
    DashboardState(
      profile: profile,
      netSalary: netSalary,
      allocation: allocation,
      safeToSpend: safeToSpend,
      healthScore: healthScore,
      recentExpenses: recentExpenses,
      activeCommitments: commitments,
      accounts: accounts,
      recentTransfers: recentTransfers,
      totalLiquidOnHand: totalLiquidOnHand,
      totalSpentThisCycle: totalSpent,
      remainingFlexibleBudget: remainingFlexible,
    ),
  );
});

CommitmentType _mapCommitmentType(String type) {
  switch (type.toLowerCase()) {
    case 'spaylater':
      return CommitmentType.spayLater;
    case 'sloan':
      return CommitmentType.sLoan;
    case 'car_loan':
      return CommitmentType.carLoan;
    case 'ptptn':
      return CommitmentType.ptptn;
    case 'mara':
      return CommitmentType.pinjamanMara;
    case 'credit_card':
      return CommitmentType.creditCard;
    case 'personal_loan':
      return CommitmentType.personalLoan;
    default:
      return CommitmentType.custom;
  }
}
