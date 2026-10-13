import '../../core/utils/money.dart';
import 'employment_type.dart';

enum DsrStatus {
  healthy, // <= 35%
  moderate, // 36% - 49%
  caution, // 50% - 60% (typical bank limit for fresh grads)
  danger, // > 60% (high debt stress)
}

/// Breakdown of a single budget bucket
class BudgetBucket {
  const BudgetBucket({
    required this.name,
    required this.percentage,
    required this.targetAmount,
    required this.description,
    required this.fixedCommitmentPortion,
  });

  final String name;
  final double percentage; // e.g. 0.40 for 40%
  final Money targetAmount;
  final String description;

  /// Amount inside this bucket that is already reserved for fixed debts/commitments
  final Money fixedCommitmentPortion;

  /// Remaining flexible spendable amount in this bucket
  Money get flexibleAmount =>
      (targetAmount - fixedCommitmentPortion).sen > 0
          ? targetAmount - fixedCommitmentPortion
          : const Money(0);
}

/// Output of the Smart 40/30/20/10 Allocation Engine
class AllocationResult {
  const AllocationResult({
    required this.netSalary,
    required this.totalCommitments,
    required this.needs,
    required this.wants,
    required this.savings,
    required this.giving,
    required this.dsrRatio,
    required this.dsrStatus,
    required this.warnings,
    required this.advice,
  });

  final Money netSalary;
  final Money totalCommitments;
  final BudgetBucket needs; // 40% (or expanded if commitments > 40%)
  final BudgetBucket wants; // 30% (compressed if commitments exceed standard 40%)
  final BudgetBucket savings; // 20%
  final BudgetBucket giving; // 10% (Charity)

  final double dsrRatio; // Commitments / Net Salary (0.0 to 1.0+)
  final DsrStatus dsrStatus;
  final List<String> warnings;
  final String advice;

  /// Total sum of all buckets
  Money get totalAllocated =>
      needs.targetAmount +
      wants.targetAmount +
      savings.targetAmount +
      giving.targetAmount;
}

/// Target split of net income across the four budget buckets.
class AllocationPreset {
  const AllocationPreset({
    required this.needs,
    required this.wants,
    required this.savings,
    required this.giving,
  });

  final double needs;
  final double wants;
  final double savings;
  final double giving;

  /// Standard 40/30/20/10 rule for salaried employees.
  static const AllocationPreset fullTime = AllocationPreset(
    needs: 0.40,
    wants: 0.30,
    savings: 0.20,
    giving: 0.10,
  );

  /// Intern split: daily food & transit dominate a small allowance, so Needs
  /// gets more room while Wants and Giving are kept lean.
  static const AllocationPreset intern = AllocationPreset(
    needs: 0.60,
    wants: 0.20,
    savings: 0.15,
    giving: 0.05,
  );

  static AllocationPreset forType(EmploymentType type) =>
      type == EmploymentType.intern ? intern : fullTime;

  /// Aggressive Saver (FIRE): heavy savings focus.
  static const AllocationPreset fireFullTime = AllocationPreset(
    needs: 0.35,
    wants: 0.15,
    savings: 0.45,
    giving: 0.05,
  );

  static const AllocationPreset fireIntern = AllocationPreset(
    needs: 0.50,
    wants: 0.10,
    savings: 0.35,
    giving: 0.05,
  );

  /// Lean Survival: high essential living costs, low discretionary.
  static const AllocationPreset leanFullTime = AllocationPreset(
    needs: 0.55,
    wants: 0.20,
    savings: 0.20,
    giving: 0.05,
  );

  static const AllocationPreset leanIntern = AllocationPreset(
    needs: 0.70,
    wants: 0.15,
    savings: 0.10,
    giving: 0.05,
  );

  static AllocationPreset getPreset({
    required String presetKey,
    required EmploymentType type,
    double? customNeeds,
    double? customWants,
    double? customSavings,
    double? customGiving,
  }) {
    switch (presetKey) {
      case 'fire_saver':
        return type == EmploymentType.intern ? fireIntern : fireFullTime;
      case 'lean':
        return type == EmploymentType.intern ? leanIntern : leanFullTime;
      case 'custom':
        if (customNeeds != null &&
            customWants != null &&
            customSavings != null &&
            customGiving != null) {
          return AllocationPreset(
            needs: customNeeds,
            wants: customWants,
            savings: customSavings,
            giving: customGiving,
          );
        }
        return forType(type);
      case 'recommended':
      default:
        return forType(type);
    }
  }

  static String _pct(double v) => (v * 100).round().toString();

  /// e.g. "40 / 30 / 20 / 10"
  String get label =>
      '${_pct(needs)} / ${_pct(wants)} / ${_pct(savings)} / ${_pct(giving)}';
}

/// Smart 40/30/20/10 AI Budget Planner Engine
abstract final class AllocationEngine {
  static AllocationResult calculate({
    required Money netSalary,
    required Money totalCommitments,
    EmploymentType employmentType = EmploymentType.fullTime,
    AllocationPreset? targetPreset,
  }) {
    if (netSalary.sen <= 0) {
      return _emptyResult(totalCommitments);
    }

    final preset = targetPreset ?? AllocationPreset.forType(employmentType);
    final double dsr = totalCommitments.sen / netSalary.sen;
    final DsrStatus status = _evaluateDsrStatus(dsr);
    final List<String> warnings = [];

    // Default target proportions come from the active preset
    double needsRatio = preset.needs;
    double wantsRatio = preset.wants;
    double savingsRatio = preset.savings;
    double givingRatio = preset.giving;

    final Money standardNeeds = netSalary.scale(preset.needs);

    if (totalCommitments.sen > standardNeeds.sen) {
      // Commitments overflow the standard Needs bucket!
      // Dynamically expand Needs to cover all fixed debts so user doesn't default.
      final double commitmentRatio = totalCommitments.sen / netSalary.sen;
      needsRatio = commitmentRatio;

      warnings.add(
        'Fixed commitments (${(commitmentRatio * 100).toStringAsFixed(1)}%) exceed standard ${(preset.needs * 100).round()}% Needs.',
      );

      final double remainingProportion = 1.0 - needsRatio;

      if (remainingProportion <= 0.10) {
        // Extreme debt stress: Commitments consume >= 90% of salary
        wantsRatio = 0.0;
        savingsRatio = remainingProportion > 0 ? remainingProportion : 0.0;
        givingRatio = 0.0;
        warnings.add(
          'Critical Debt Level: DSR is ${(dsr * 100).toStringAsFixed(1)}%. Non-essential spending suspended.',
        );
      } else if (remainingProportion < 0.60) {
        // High debt: Compress Wants first to protect Savings and Giving
        // Keep Giving at its preset share if possible
        givingRatio =
            remainingProportion > 0.20 ? preset.giving : (remainingProportion * 0.3);
        // Keep minimum savings floor of 10%
        final double remainingForSavingsAndWants =
            remainingProportion - givingRatio;
        savingsRatio = remainingForSavingsAndWants * 0.6;
        wantsRatio = remainingForSavingsAndWants * 0.4;
      }
    }

    if (dsr > 0.60) {
      warnings.add(
        'Danger: DSR is above 60%. Most Malaysian banks will reject new loan applications.',
      );
    } else if (dsr > 0.40) {
      warnings.add(
        'Caution: DSR is ${(dsr * 100).toStringAsFixed(1)}%. Avoid adding new BNPL or installment plans.',
      );
    }

    final Money needsAmount = netSalary.scale(needsRatio);
    final Money wantsAmount = netSalary.scale(wantsRatio);
    final Money savingsAmount = netSalary.scale(savingsRatio);
    final Money givingAmount = netSalary.scale(givingRatio);

    final String advice = _generateAdvice(dsr, status, totalCommitments);

    return AllocationResult(
      netSalary: netSalary,
      totalCommitments: totalCommitments,
      needs: BudgetBucket(
        name: 'Needs',
        percentage: needsRatio,
        targetAmount: needsAmount,
        description: 'Living essentials: Food, Toll, Petrol, Rent, & Debts',
        fixedCommitmentPortion: totalCommitments,
      ),
      wants: BudgetBucket(
        name: 'Wants',
        percentage: wantsRatio,
        targetAmount: wantsAmount,
        description: 'Lifestyle: Dining out, Entertainment, Shopping',
        fixedCommitmentPortion: const Money(0),
      ),
      savings: BudgetBucket(
        name: 'Savings',
        percentage: savingsRatio,
        targetAmount: savingsAmount,
        description: 'Emergency fund, ASB, Tabung Haji, Investments',
        fixedCommitmentPortion: const Money(0),
      ),
      giving: BudgetBucket(
        name: 'Charity',
        percentage: givingRatio,
        targetAmount: givingAmount,
        description: 'Sedekah, Zakat Pendapatan, Donations',
        fixedCommitmentPortion: const Money(0),
      ),
      dsrRatio: dsr,
      dsrStatus: status,
      warnings: warnings,
      advice: advice,
    );
  }

  static DsrStatus _evaluateDsrStatus(double dsr) {
    if (dsr <= 0.35) return DsrStatus.healthy;
    if (dsr <= 0.49) return DsrStatus.moderate;
    if (dsr <= 0.60) return DsrStatus.caution;
    return DsrStatus.danger;
  }

  static String _generateAdvice(
    double dsr,
    DsrStatus status,
    Money commitments,
  ) {
    if (commitments.sen == 0) {
      return 'Great clean slate! You have 0 fixed debts. Build your 3-month emergency fund first before taking on any car loans or SPayLater.';
    }
    switch (status) {
      case DsrStatus.healthy:
        return 'Healthy commitment ratio. Your debt is under 35% of take-home pay, leaving plenty of room for savings and lifestyle.';
      case DsrStatus.moderate:
        return 'Moderate commitments. Stick strictly to your 30% Wants limit so your emergency savings remain untouched.';
      case DsrStatus.caution:
        return 'Approaching the safe debt ceiling. Prioritize paying off high-interest BNPL (SPayLater/SLoan) before buying new gadgets.';
      case DsrStatus.danger:
        return 'High debt risk! Over 60% of your salary is tied up in commitments. Avoid all new installments and consider snowballing small balances.';
    }
  }

  static AllocationResult _emptyResult(Money commitments) {
    return AllocationResult(
      netSalary: const Money(0),
      totalCommitments: commitments,
      needs: const BudgetBucket(
        name: 'Needs',
        percentage: 0.4,
        targetAmount: Money(0),
        description: '',
        fixedCommitmentPortion: Money(0),
      ),
      wants: const BudgetBucket(
        name: 'Wants',
        percentage: 0.3,
        targetAmount: Money(0),
        description: '',
        fixedCommitmentPortion: Money(0),
      ),
      savings: const BudgetBucket(
        name: 'Savings',
        percentage: 0.2,
        targetAmount: Money(0),
        description: '',
        fixedCommitmentPortion: Money(0),
      ),
      giving: const BudgetBucket(
        name: 'Charity',
        percentage: 0.1,
        targetAmount: Money(0),
        description: '',
        fixedCommitmentPortion: Money(0),
      ),
      dsrRatio: 0.0,
      dsrStatus: DsrStatus.healthy,
      warnings: const ['No net income entered yet.'],
      advice: 'Enter your monthly salary to generate your customized 40/30/20/10 budget.',
    );
  }
}
