import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/money.dart';
import '../../domain/engine/employment_type.dart';
import '../../domain/engine/lhdn_tax_engine.dart';
import '../../domain/engine/net_salary_calculator.dart';
import '../local/app_database.dart';
import '../models/expense_with_category.dart';
import '../repositories/tax_repository.dart';
import 'database_providers.dart';

/// An expense from the Expense Log that matches an LHDN relief bucket (or Zakat)
/// and has not yet been imported into `tax_receipt_claims`.
class AutoDetectedExpenseCandidate {
  final ExpenseWithCategory expenseWithCategory;
  final TaxClassificationResult classification;

  const AutoDetectedExpenseCandidate({
    required this.expenseWithCategory,
    required this.classification,
  });
}

/// Complete reactive state for the Malaysian Personal Income Tax Optimization Engine (LHDN Form BE).
class TaxDashboardData {
  final int assessmentYear;
  final UserProfileTableData userProfile;
  final NetSalaryResult monthlyPayslip;
  final TaxYearProfileData taxProfile;
  final List<TaxReceiptClaimData> receiptClaims;
  final List<AutoDetectedExpenseCandidate> unloggedCandidates;
  final LhdnTaxInput taxInput;
  final LhdnTaxResult taxResult;

  const TaxDashboardData({
    required this.assessmentYear,
    required this.userProfile,
    required this.monthlyPayslip,
    required this.taxProfile,
    required this.receiptClaims,
    required this.unloggedCandidates,
    required this.taxInput,
    required this.taxResult,
  });
}

final taxDashboardProvider = Provider<AsyncValue<TaxDashboardData>>((ref) {
  final year = ref.watch(selectedTaxYearProvider);
  final userProfileAsync = ref.watch(userProfileStreamProvider);
  final taxProfileAsync = ref.watch(taxYearProfileStreamProvider);
  final claimsAsync = ref.watch(taxReceiptClaimsStreamProvider);
  final expensesAsync = ref.watch(recentExpensesStreamProvider);

  if (userProfileAsync.isLoading ||
      taxProfileAsync.isLoading ||
      claimsAsync.isLoading ||
      expensesAsync.isLoading) {
    return const AsyncValue.loading();
  }

  if (userProfileAsync.hasError) {
    return AsyncValue.error(
      userProfileAsync.error!,
      userProfileAsync.stackTrace ?? StackTrace.current,
    );
  }
  if (taxProfileAsync.hasError) {
    return AsyncValue.error(
      taxProfileAsync.error!,
      taxProfileAsync.stackTrace ?? StackTrace.current,
    );
  }
  if (claimsAsync.hasError) {
    return AsyncValue.error(
      claimsAsync.error!,
      claimsAsync.stackTrace ?? StackTrace.current,
    );
  }
  if (expensesAsync.hasError) {
    return AsyncValue.error(
      expensesAsync.error!,
      expensesAsync.stackTrace ?? StackTrace.current,
    );
  }

  final userProfile = userProfileAsync.value!;
  final taxProfile = taxProfileAsync.value!;
  final receiptClaims = claimsAsync.value!;
  final recentExpenses = expensesAsync.value!;

  final empType = EmploymentType.fromStorage(userProfile.employmentType);
  final monthlyPayslip = NetSalaryCalculator.calculate(
    grossSalary: Money(userProfile.grossSalarySen),
    allowances: Money(userProfile.fixedAllowanceSen),
    employmentType: empType,
    epfRate: userProfile.epfRate,
    hasSocso: userProfile.hasSocso,
    hasEis: userProfile.hasEis,
  );

  // Aggregate itemized receipt claims by bucket and subBucketId
  int claimedAiSen = 0;
  int claimedInternetSen = 0;
  int claimedBooksSen = 0;
  int claimedDevicesSen = 0;
  int claimedCoursesSen = 0;

  int claimedSportsEquipmentSen = 0;
  int claimedSportsGymSen = 0;
  int claimedSportsCompSen = 0;

  int claimedMedicalSeriousSen = 0;
  int claimedMedicalCheckupSen = 0;
  int claimedMedicalDentalSen = 0;
  int claimedMedicalVaccineSen = 0;

  int claimedMedicalInsSen = 0;
  int claimedLifeInsSen = 0;
  int claimedVolEpfSen = 0;
  int claimedPrsSen = 0;
  int claimedHigherEdSen = 0;
  int claimedUpskillingSen = 0;
  int claimedSocsoEisExtraSen = 0;
  int claimedSspnSen = 0;
  int claimedHousingInterestSen = 0;

  final claimedExpenseIds = <int>{};

  for (final claim in receiptClaims) {
    if (claim.expenseId != null) {
      claimedExpenseIds.add(claim.expenseId!);
    }
    switch (claim.bucket) {
      case LhdnReliefBucket.individualAndDependent:
        break;
      case LhdnReliefBucket.lifestyle:
        switch (claim.subBucketId) {
          case 'ai_subscriptions':
            claimedAiSen += claim.amountSen;
            break;
          case 'internet':
            claimedInternetSen += claim.amountSen;
            break;
          case 'books':
            claimedBooksSen += claim.amountSen;
            break;
          case 'devices':
            claimedDevicesSen += claim.amountSen;
            break;
          case 'courses':
            claimedCoursesSen += claim.amountSen;
            break;
          default:
            claimedAiSen += claim.amountSen;
            break;
        }
        break;
      case LhdnReliefBucket.sportsAndFitness:
        switch (claim.subBucketId) {
          case 'sports_equipment':
            claimedSportsEquipmentSen += claim.amountSen;
            break;
          case 'gym_facility':
            claimedSportsGymSen += claim.amountSen;
            break;
          case 'sports_competition':
            claimedSportsCompSen += claim.amountSen;
            break;
          default:
            claimedSportsEquipmentSen += claim.amountSen;
            break;
        }
        break;
      case LhdnReliefBucket.medicalAndHealthcare:
        switch (claim.subBucketId) {
          case 'checkup_mental':
            claimedMedicalCheckupSen += claim.amountSen;
            break;
          case 'dental':
            claimedMedicalDentalSen += claim.amountSen;
            break;
          case 'vaccination':
            claimedMedicalVaccineSen += claim.amountSen;
            break;
          default:
            claimedMedicalSeriousSen += claim.amountSen;
            break;
        }
        break;
      case LhdnReliefBucket.medicalAndEducationInsurance:
        claimedMedicalInsSen += claim.amountSen;
        break;
      case LhdnReliefBucket.lifeInsuranceAndEpf:
        if (claim.subBucketId == 'epf') {
          claimedVolEpfSen += claim.amountSen;
        } else {
          claimedLifeInsSen += claim.amountSen;
        }
        break;
      case LhdnReliefBucket.prsAndAnnuity:
        claimedPrsSen += claim.amountSen;
        break;
      case LhdnReliefBucket.selfEducation:
        if (claim.subBucketId == 'upskilling') {
          claimedUpskillingSen += claim.amountSen;
        } else {
          claimedHigherEdSen += claim.amountSen;
        }
        break;
      case LhdnReliefBucket.socsoAndEis:
        claimedSocsoEisExtraSen += claim.amountSen;
        break;
      case LhdnReliefBucket.sspn:
        claimedSspnSen += claim.amountSen;
        break;
      case LhdnReliefBucket.housingLoanInterest:
        claimedHousingInterestSen += claim.amountSen;
        break;
    }
  }

  // Scan recent expenses in the selected year that haven't been logged yet
  final unloggedCandidates = <AutoDetectedExpenseCandidate>[];
  for (final item in recentExpenses) {
    final exp = item.expense;
    if (exp.date.year != year) continue;
    if (claimedExpenseIds.contains(exp.id)) continue;
    final note = (exp.note ?? '').trim();
    if (note.isEmpty) continue;

    final classification = LhdnTaxEngine.classifyTransaction(
      description: note,
      categoryName: item.category.name,
    );
    if (classification.bucket != null ||
        classification.isZakatRebate ||
        classification.isExcludedWarn) {
      unloggedCandidates.add(
        AutoDetectedExpenseCandidate(
          expenseWithCategory: item,
          classification: classification,
        ),
      );
    }
  }

  // Interns receive an exempted stipend/allowance with no EPF, SOCSO, EIS or PCB tax.
  final annualBaseSalary = empType.isIntern
      ? Money.zero
      : Money(userProfile.grossSalarySen * 12);
  final annualAllowances = empType.isIntern
      ? Money.zero
      : Money(userProfile.fixedAllowanceSen * 12);
  final statutoryAnnualEpf = monthlyPayslip.epfEmployee.sen * 12;
  final statutoryAnnualSocsoEis =
      (monthlyPayslip.socsoEmployee.sen + monthlyPayslip.eisEmployee.sen) * 12;
  final defaultAnnualPcb = monthlyPayslip.pcbTax.sen * 12;

  final totalEpfSen =
      statutoryAnnualEpf + taxProfile.voluntaryEpfSen + claimedVolEpfSen;
  final totalSocsoEisSen = statutoryAnnualSocsoEis + claimedSocsoEisExtraSen;
  final effectiveAnnualPcbSen =
      taxProfile.annualPcbOverrideSen ?? defaultAnnualPcb;

  final housingTier = taxProfile.housingLoanTier;
  final totalHousingInterestSen =
      taxProfile.housingLoanInterestSen + claimedHousingInterestSen;

  final taxInput = LhdnTaxInput(
    assessmentYear: year,
    annualBaseSalary: annualBaseSalary,
    annualBonuses: Money(taxProfile.annualBonusSen),
    annualTaxableAllowances: annualAllowances,
    annualOtherIncome: Money(taxProfile.annualOtherIncomeSen),
    annualPcbPaid: Money(effectiveAnnualPcbSen),
    zakatOrFitrahPaid: Money(taxProfile.zakatFitrahSen),
    aiSubscriptionsSpent:
        Money(taxProfile.lifestyleAiSen + claimedAiSen),
    internetBillsSpent:
        Money(taxProfile.lifestyleInternetSen + claimedInternetSen),
    booksJournalsSpent:
        Money(taxProfile.lifestyleBooksSen + claimedBooksSen),
    devicesSpent: Money(taxProfile.lifestyleDevicesSen + claimedDevicesSen),
    lifestyleCoursesSpent:
        Money(taxProfile.lifestyleCoursesSen + claimedCoursesSen),
    sportsEquipmentSpent:
        Money(taxProfile.sportsEquipmentSen + claimedSportsEquipmentSen),
    gymAndFacilitySpent:
        Money(taxProfile.sportsGymFacilitySen + claimedSportsGymSen),
    sportsCompetitionSpent:
        Money(taxProfile.sportsCompetitionSen + claimedSportsCompSen),
    seriousDiseaseAndFertilitySpent: Money(
      taxProfile.medicalSeriousFertilitySen + claimedMedicalSeriousSen,
    ),
    fullCheckupAndMentalHealthSpent: Money(
      taxProfile.medicalCheckupMentalSen + claimedMedicalCheckupSen,
    ),
    dentalTreatmentSpent:
        Money(taxProfile.medicalDentalSen + claimedMedicalDentalSen),
    vaccinationSpent:
        Money(taxProfile.medicalVaccinationSen + claimedMedicalVaccineSen),
    medicalEducationInsuranceSpent:
        Money(taxProfile.medicalInsuranceSen + claimedMedicalInsSen),
    epfContributionSpent: Money(totalEpfSen),
    lifeInsuranceSpent:
        Money(taxProfile.lifeInsuranceSen + claimedLifeInsSen),
    prsContributionSpent: Money(taxProfile.prsAnnuitySen + claimedPrsSen),
    higherEducationSpent:
        Money(taxProfile.higherEducationSen + claimedHigherEdSen),
    upskillingSpent: Money(taxProfile.upskillingSen + claimedUpskillingSen),
    socsoAndEisSpent: Money(totalSocsoEisSen),
    sspnNetSavingsSpent: Money(taxProfile.sspnNetSavingsSen + claimedSspnSen),
    housingLoanTier: housingTier,
    housingLoanInterestSpent: Money(totalHousingInterestSen),
  );

  final taxResult = LhdnTaxEngine.calculate(taxInput);

  return AsyncValue.data(
    TaxDashboardData(
      assessmentYear: year,
      userProfile: userProfile,
      monthlyPayslip: monthlyPayslip,
      taxProfile: taxProfile,
      receiptClaims: receiptClaims,
      unloggedCandidates: unloggedCandidates,
      taxInput: taxInput,
      taxResult: taxResult,
    ),
  );
});
