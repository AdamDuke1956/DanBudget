import '../../core/utils/money.dart';
import 'employment_type.dart';

/// Malaysian statutory deductions breakdown and take-home net salary.
class NetSalaryResult {
  const NetSalaryResult({
    required this.grossSalary,
    required this.allowances,
    required this.epfEmployee,
    required this.socsoEmployee,
    required this.eisEmployee,
    required this.pcbTax,
    required this.netSalary,
  });

  final Money grossSalary;
  final Money allowances;
  final Money epfEmployee;
  final Money socsoEmployee;
  final Money eisEmployee;
  final Money pcbTax;
  final Money netSalary;

  Money get totalDeductions =>
      epfEmployee + socsoEmployee + eisEmployee + pcbTax;

  Money get totalGrossIncome => grossSalary + allowances;
}

/// Calculator for Malaysian take-home pay based on official statutory contribution rules.
///
/// Rules:
/// - EPF (KWSP): 11% standard employee contribution rate on gross wage.
/// - SOCSO (PERKESO): ~0.5% employee rate capped at wage ceiling of RM 6,000 (max RM 29.75).
/// - EIS (SIP): ~0.2% employee rate capped at wage ceiling of RM 6,000 (max RM 11.90).
/// - PCB (MTD): LHDN estimated monthly tax deduction with individual relief (RM 9,000) & EPF relief (up to RM 4,000).
///
/// Interns ([EmploymentType.intern]) receive a monthly allowance / stipend that
/// is exempt from all of the above, so take-home equals the allowance.
abstract final class NetSalaryCalculator {
  /// SOCSO & EIS wage ceiling in Malaysia (RM 6,000.00)
  static const int wageCeilingSen = 600000;

  static NetSalaryResult calculate({
    required Money grossSalary,
    Money allowances = const Money(0),
    EmploymentType employmentType = EmploymentType.fullTime,
    double epfRate = 0.11, // 11% standard
    bool hasSocso = true,
    bool hasEis = true,
    bool isMalaysianCitizen = true,
  }) {
    // Intern allowance: no statutory deductions at all.
    if (employmentType == EmploymentType.intern) {
      return NetSalaryResult(
        grossSalary: grossSalary,
        allowances: allowances,
        epfEmployee: const Money(0),
        socsoEmployee: const Money(0),
        eisEmployee: const Money(0),
        pcbTax: const Money(0),
        netSalary: grossSalary + allowances,
      );
    }

    // 1. EPF (KWSP)
    final Money epf = isMalaysianCitizen
        ? grossSalary.scale(epfRate)
        : const Money(0);

    // 2. SOCSO (PERKESO) - capped at RM 6,000
    final int socsoSubjectSen = grossSalary.sen > wageCeilingSen
        ? wageCeilingSen
        : grossSalary.sen;
    // Employee share is ~0.495% (rounded to nearest 5 sen in official tables, ~0.5%)
    final Money socso =
        hasSocso ? Money((socsoSubjectSen * 0.005).round()) : const Money(0);

    // 3. EIS (SIP) - capped at RM 6,000 (0.2% employee rate)
    final int eisSubjectSen = grossSalary.sen > wageCeilingSen
        ? wageCeilingSen
        : grossSalary.sen;
    final Money eis =
        hasEis ? Money((eisSubjectSen * 0.002).round()) : const Money(0);

    // 4. PCB (Monthly Tax Deduction) estimation for single fresh graduate
    final Money pcb = _estimateMonthlyPcb(
      annualGrossIncome: Money(grossSalary.sen * 12),
      annualEpf: Money(epf.sen * 12),
    );

    // 5. Net Salary = (Gross + Allowances) - Deductions
    final Money net = (grossSalary + allowances) - (epf + socso + eis + pcb);

    return NetSalaryResult(
      grossSalary: grossSalary,
      allowances: allowances,
      epfEmployee: epf,
      socsoEmployee: socso,
      eisEmployee: eis,
      pcbTax: pcb,
      netSalary: net.sen > 0 ? net : const Money(0),
    );
  }

  /// Estimates monthly PCB tax for a single resident in Malaysia.
  /// Standard reliefs: Individual (RM 9,000) + EPF (up to RM 4,000).
  static Money _estimateMonthlyPcb({
    required Money annualGrossIncome,
    required Money annualEpf,
  }) {
    // Basic tax reliefs
    const int individualRelief = 900000; // RM 9,000
    final int epfRelief = annualEpf.sen > 400000 ? 400000 : annualEpf.sen;

    final int totalRelief = individualRelief + epfRelief;
    final int chargeableIncome = annualGrossIncome.sen - totalRelief;

    if (chargeableIncome <= 0) return const Money(0);

    // 2024/2025/2026 Malaysian Resident Income Tax Brackets (in sen)
    // 0 - 5,000: 0%
    // 5,001 - 20,000: 1%
    // 20,001 - 35,000: 3%
    // 35,001 - 50,000: 6%
    // 50,001 - 70,000: 11%
    // 70,001 - 100,000: 19%
    int annualTaxSen = 0;

    if (chargeableIncome > 7000000) {
      annualTaxSen += ((chargeableIncome - 7000000) * 0.19).round();
      annualTaxSen += (3000000 * 0.11).round(); // 50k-70k
      annualTaxSen += (1500000 * 0.06).round(); // 35k-50k
      annualTaxSen += (1500000 * 0.03).round(); // 20k-35k
      annualTaxSen += (1500000 * 0.01).round(); // 5k-20k
    } else if (chargeableIncome > 5000000) {
      annualTaxSen += ((chargeableIncome - 5000000) * 0.11).round();
      annualTaxSen += (1500000 * 0.06).round();
      annualTaxSen += (1500000 * 0.03).round();
      annualTaxSen += (1500000 * 0.01).round();
    } else if (chargeableIncome > 3500000) {
      annualTaxSen += ((chargeableIncome - 3500000) * 0.06).round();
      annualTaxSen += (1500000 * 0.03).round();
      annualTaxSen += (1500000 * 0.01).round();
    } else if (chargeableIncome > 2000000) {
      annualTaxSen += ((chargeableIncome - 2000000) * 0.03).round();
      annualTaxSen += (1500000 * 0.01).round();
    } else if (chargeableIncome > 500000) {
      annualTaxSen += ((chargeableIncome - 500000) * 0.01).round();
    }

    // Monthly PCB deduction
    return Money((annualTaxSen / 12).round());
  }
}
