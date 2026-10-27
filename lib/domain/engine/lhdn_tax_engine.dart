import 'dart:math' as math;
import '../../core/utils/money.dart';

/// Statutory LHDN Form BE relief buckets for resident individuals in Malaysia.
enum LhdnReliefBucket {
  individualAndDependent(
    title: 'Individual & Dependent Relatives',
    shortTitle: 'Individual',
    defaultCapSen: 900000, // RM 9,000
    isAutomatic: true,
    ruleSummary:
        'Automatic RM9,000 basic relief for resident individual taxpayer (no receipt required).',
  ),
  lifestyle(
    title: 'Lifestyle (Gaya Hidup - Shared Cap)',
    shortTitle: 'Lifestyle',
    defaultCapSen: 250000, // RM 2,500
    isAutomatic: false,
    ruleSummary:
        'Shared RM2,500 cap covering AI software/app subscriptions (ChatGPT Plus, Claude Pro, GitHub Copilot for personal/study use), home broadband/mobile internet bills, books/journals, smartphones, tablets, laptops/PCs, and self-improvement courses. Excess above RM2,500 yields RM0 additional relief.',
  ),
  sportsAndFitness(
    title: 'Sports & Fitness (Separate Pot)',
    shortTitle: 'Sports & Fitness',
    defaultCapSen: 100000, // RM 1,000
    isAutomatic: false,
    ruleSummary:
        'Separate RM1,000 pot for sports equipment, gym memberships, rental/entrance fees to sports facilities, and competition registration fees (extended to self, spouse, children, and parents). Strictly EXCLUDES sports apparel and shoes.',
  ),
  medicalAndHealthcare(
    title: 'Medical & Healthcare (Shared Pot)',
    shortTitle: 'Medical & Health',
    defaultCapSen: 1000000, // RM 10,000
    isAutomatic: false,
    ruleSummary:
        'Shared RM10,000 pot for serious diseases & fertility, with strict RM1,000 sub-limits each for full health checkup/mental health/COVID-19 tests, dental treatments, and vaccinations.',
  ),
  medicalAndEducationInsurance(
    title: 'Medical & Education Insurance',
    shortTitle: 'Medical Insurance',
    defaultCapSen: 400000, // RM 4,000
    isAutomatic: false,
    ruleSummary:
        'Capped at RM4,000 for medical card, medical takaful, and education insurance premiums for self, spouse, or child.',
  ),
  lifeInsuranceAndEpf(
    title: 'Life Insurance & EPF (KWSP)',
    shortTitle: 'EPF & Life Ins.',
    defaultCapSen: 700000, // RM 7,000
    isAutomatic: false,
    ruleSummary:
        'Combined RM7,000 cap: statutory/voluntary EPF (KWSP) contributions are strictly sub-capped at RM4,000 within this bucket, plus life insurance / family takaful up to RM3,000.',
  ),
  prsAndAnnuity(
    title: 'Private Retirement Scheme (PRS) / Deferred Annuity',
    shortTitle: 'PRS & Annuity',
    defaultCapSen: 300000, // RM 3,000
    isAutomatic: false,
    ruleSummary:
        'Capped at RM3,000 for contributions to LHDN-approved Private Retirement Schemes (PRS) and deferred annuities.',
  ),
  selfEducation(
    title: 'Self Education / Upskilling',
    shortTitle: 'Self Education',
    defaultCapSen: 700000, // RM 7,000
    isAutomatic: false,
    ruleSummary:
        'Capped at RM7,000 for accredited tertiary education (Masters/PhD or selected degrees), with upskilling/skills enhancement courses sub-capped at RM2,000.',
  ),
  socsoAndEis(
    title: 'SOCSO (PERKESO) & EIS (SIP)',
    shortTitle: 'SOCSO & EIS',
    defaultCapSen: 35000, // RM 350
    isAutomatic: false,
    ruleSummary:
        'Capped at RM350 for employee statutory contributions to PERKESO (SOCSO) and Employment Insurance System (EIS/SIP).',
  ),
  sspn(
    title: 'SSPN (Net Savings)',
    shortTitle: 'SSPN Savings',
    defaultCapSen: 800000, // RM 8,000
    isAutomatic: false,
    ruleSummary:
        'Capped at RM8,000 for net savings in Simpan SSPN (total deposits minus total withdrawals during the assessment year).',
  ),
  housingLoanInterest(
    title: 'First-Time Homebuyer Loan Interest',
    shortTitle: 'Home Loan Interest',
    defaultCapSen: 700000, // Up to RM 7,000 (<=500k) or RM 5,000 (500k-750k)
    isAutomatic: false,
    ruleSummary:
        'First-time residential homebuyer loan interest: up to RM7,000 (property <= RM500k) or RM5,000 (property RM500k–RM750k).',
  );

  const LhdnReliefBucket({
    required this.title,
    required this.shortTitle,
    required this.defaultCapSen,
    required this.isAutomatic,
    required this.ruleSummary,
  });

  final String title;
  final String shortTitle;
  final int defaultCapSen;
  final bool isAutomatic;
  final String ruleSummary;

  Money get defaultAnnualCap => Money(defaultCapSen);
}

/// Property price tier for First-Time Homebuyer Loan Interest relief.
enum HousingLoanTier {
  none(
    label: 'Not Claiming / Not Applicable (RM 0 Cap)',
    capSen: 0,
  ),
  upTo500k(
    label: 'Property <= RM 500,000 (RM 7,000 Cap)',
    capSen: 700000,
  ),
  from500kTo750k(
    label: 'Property RM 500,001 – RM 750,000 (RM 5,000 Cap)',
    capSen: 500000,
  );

  const HousingLoanTier({
    required this.label,
    required this.capSen,
  });

  final String label;
  final int capSen;

  Money get annualCap => Money(capSen);
}

/// Sub-limit utilization breakdown inside shared relief pots (Lifestyle, Sports, Medical, EPF/Life, Education).
class SubBucketUtilization {
  const SubBucketUtilization({
    required this.id,
    required this.title,
    required this.rawSpent,
    required this.claimedAmount,
    this.subCap,
  });

  final String id;
  final String title;
  final Money rawSpent;
  final Money claimedAmount;
  final Money? subCap;
}

/// Utilization and cap tracking status for a single statutory LHDN relief bucket.
class BucketUtilization {
  const BucketUtilization({
    required this.bucket,
    required this.rawSpent,
    required this.claimedAmount,
    required this.annualCap,
    this.subBuckets = const [],
  });

  final LhdnReliefBucket bucket;
  final Money rawSpent;
  final Money claimedAmount;
  final Money annualCap;
  final List<SubBucketUtilization> subBuckets;

  Money get remainingHeadroom =>
      Money(math.max(0, annualCap.sen - claimedAmount.sen));

  Money get excessUnclaimable =>
      Money(math.max(0, rawSpent.sen - claimedAmount.sen));

  double get progress => annualCap.sen > 0
      ? (claimedAmount.sen / annualCap.sen).clamp(0.0, 1.0)
      : 0.0;

  bool get isSaturated => annualCap.sen > 0 && remainingHeadroom.sen == 0;

  /// Formats cap tracking status per LHDN reporting protocol:
  /// e.g. "Lifestyle: RM1,800 / RM2,500 used — RM700 remaining"
  String formatCapStatus({bool short = true}) {
    final name = short ? bucket.shortTitle : bucket.title;
    final usedStr = claimedAmount
        .format(showSen: claimedAmount.sen % 100 != 0)
        .replaceAll('RM ', 'RM');
    final capStr = annualCap
        .format(showSen: annualCap.sen % 100 != 0)
        .replaceAll('RM ', 'RM');
    final remStr = remainingHeadroom
        .format(showSen: remainingHeadroom.sen % 100 != 0)
        .replaceAll('RM ', 'RM');
    return '$name: $usedStr / $capStr used — $remStr remaining';
  }
}

/// Resident progressive income tax bracket definition (YA 2024 / 2025 / 2026).
class LhdnTaxBracket {
  const LhdnTaxBracket({
    required this.lowerSen,
    required this.upperSen,
    required this.rate,
    required this.label,
  });

  final int lowerSen;
  final int? upperSen; // null means unbounded (> RM 2,000,000)
  final double rate;
  final String label;
}

/// Breakdown of tax computed inside a specific progressive bracket band.
class TaxBracketSlice {
  const TaxBracketSlice({
    required this.bracket,
    required this.taxableAmount,
    required this.taxAmount,
  });

  final LhdnTaxBracket bracket;
  final Money taxableAmount;
  final Money taxAmount;
}

/// Actionable tax optimization recommendation generated by the engine.
class TaxOptimizationAdvisory {
  const TaxOptimizationAdvisory({
    required this.title,
    required this.message,
    required this.isWarning,
    this.targetBucket,
    this.estimatedMaxTaxSaved = Money.zero,
  });

  final String title;
  final String message;
  final bool isWarning;
  final LhdnReliefBucket? targetBucket;
  final Money estimatedMaxTaxSaved;
}

/// Result of auto-classifying a transaction or receipt description.
class TaxClassificationResult {
  const TaxClassificationResult({
    this.bucket,
    this.subBucketId,
    this.subBucketTitle,
    this.isZakatRebate = false,
    this.isExcludedWarn = false,
    required this.explanation,
  });

  final LhdnReliefBucket? bucket;
  final String? subBucketId;
  final String? subBucketTitle;
  final bool isZakatRebate;
  final bool isExcludedWarn;
  final String explanation;
}

/// Marginal tax impact simulation for a specific transaction or planned relief top-up.
class MarginalTaxImpactResult {
  const MarginalTaxImpactResult({
    required this.classification,
    required this.amount,
    required this.claimablePortion,
    required this.excessUnclaimablePortion,
    required this.marginalRate,
    required this.estimatedTaxSaved,
    required this.capStatusSummary,
    required this.marginalImpactStatement,
    this.actionableSuggestion,
  });

  final TaxClassificationResult classification;
  final Money amount;
  final Money claimablePortion;
  final Money excessUnclaimablePortion;
  final double marginalRate;
  final Money estimatedTaxSaved;
  final String capStatusSummary;
  final String marginalImpactStatement;
  final String? actionableSuggestion;
}

/// Input parameters for a complete assessment year LHDN Form BE tax calculation.
class LhdnTaxInput {
  const LhdnTaxInput({
    required this.assessmentYear,
    this.annualBaseSalary = Money.zero,
    this.annualBonuses = Money.zero,
    this.annualTaxableAllowances = Money.zero,
    this.annualOtherIncome = Money.zero,
    this.annualPcbPaid = Money.zero,
    this.zakatOrFitrahPaid = Money.zero,
    // Lifestyle sub-buckets (shared RM 2,500 cap)
    this.aiSubscriptionsSpent = Money.zero,
    this.internetBillsSpent = Money.zero,
    this.booksJournalsSpent = Money.zero,
    this.devicesSpent = Money.zero,
    this.lifestyleCoursesSpent = Money.zero,
    // Sports & Fitness (separate RM 1,000 cap)
    this.sportsEquipmentSpent = Money.zero,
    this.gymAndFacilitySpent = Money.zero,
    this.sportsCompetitionSpent = Money.zero,
    // Medical & Healthcare (shared RM 10,000 cap with RM 1,000 sub-caps)
    this.seriousDiseaseAndFertilitySpent = Money.zero,
    this.fullCheckupAndMentalHealthSpent = Money.zero,
    this.dentalTreatmentSpent = Money.zero,
    this.vaccinationSpent = Money.zero,
    // Insurance, EPF, PRS, Education, SOCSO, SSPN, Housing
    this.medicalEducationInsuranceSpent = Money.zero,
    this.epfContributionSpent = Money.zero,
    this.lifeInsuranceSpent = Money.zero,
    this.prsContributionSpent = Money.zero,
    this.higherEducationSpent = Money.zero,
    this.upskillingSpent = Money.zero,
    this.socsoAndEisSpent = Money.zero,
    this.sspnNetSavingsSpent = Money.zero,
    this.housingLoanTier = HousingLoanTier.none,
    this.housingLoanInterestSpent = Money.zero,
  });

  final int assessmentYear;
  final Money annualBaseSalary;
  final Money annualBonuses;
  final Money annualTaxableAllowances;
  final Money annualOtherIncome;
  final Money annualPcbPaid;
  final Money zakatOrFitrahPaid;

  // Lifestyle
  final Money aiSubscriptionsSpent;
  final Money internetBillsSpent;
  final Money booksJournalsSpent;
  final Money devicesSpent;
  final Money lifestyleCoursesSpent;

  // Sports
  final Money sportsEquipmentSpent;
  final Money gymAndFacilitySpent;
  final Money sportsCompetitionSpent;

  // Medical
  final Money seriousDiseaseAndFertilitySpent;
  final Money fullCheckupAndMentalHealthSpent;
  final Money dentalTreatmentSpent;
  final Money vaccinationSpent;

  // Other Statutory & Voluntary Buckets
  final Money medicalEducationInsuranceSpent;
  final Money epfContributionSpent;
  final Money lifeInsuranceSpent;
  final Money prsContributionSpent;
  final Money higherEducationSpent;
  final Money upskillingSpent;
  final Money socsoAndEisSpent;
  final Money sspnNetSavingsSpent;
  final HousingLoanTier housingLoanTier;
  final Money housingLoanInterestSpent;

  Money get totalLifestyleRaw =>
      aiSubscriptionsSpent +
      internetBillsSpent +
      booksJournalsSpent +
      devicesSpent +
      lifestyleCoursesSpent;

  Money get totalSportsRaw =>
      sportsEquipmentSpent + gymAndFacilitySpent + sportsCompetitionSpent;

  Money get totalMedicalRaw =>
      seriousDiseaseAndFertilitySpent +
      fullCheckupAndMentalHealthSpent +
      dentalTreatmentSpent +
      vaccinationSpent;

  LhdnTaxInput copyWith({
    int? assessmentYear,
    Money? annualBaseSalary,
    Money? annualBonuses,
    Money? annualTaxableAllowances,
    Money? annualOtherIncome,
    Money? annualPcbPaid,
    Money? zakatOrFitrahPaid,
    Money? aiSubscriptionsSpent,
    Money? internetBillsSpent,
    Money? booksJournalsSpent,
    Money? devicesSpent,
    Money? lifestyleCoursesSpent,
    Money? sportsEquipmentSpent,
    Money? gymAndFacilitySpent,
    Money? sportsCompetitionSpent,
    Money? seriousDiseaseAndFertilitySpent,
    Money? fullCheckupAndMentalHealthSpent,
    Money? dentalTreatmentSpent,
    Money? vaccinationSpent,
    Money? medicalEducationInsuranceSpent,
    Money? epfContributionSpent,
    Money? lifeInsuranceSpent,
    Money? prsContributionSpent,
    Money? higherEducationSpent,
    Money? upskillingSpent,
    Money? socsoAndEisSpent,
    Money? sspnNetSavingsSpent,
    HousingLoanTier? housingLoanTier,
    Money? housingLoanInterestSpent,
  }) {
    return LhdnTaxInput(
      assessmentYear: assessmentYear ?? this.assessmentYear,
      annualBaseSalary: annualBaseSalary ?? this.annualBaseSalary,
      annualBonuses: annualBonuses ?? this.annualBonuses,
      annualTaxableAllowances:
          annualTaxableAllowances ?? this.annualTaxableAllowances,
      annualOtherIncome: annualOtherIncome ?? this.annualOtherIncome,
      annualPcbPaid: annualPcbPaid ?? this.annualPcbPaid,
      zakatOrFitrahPaid: zakatOrFitrahPaid ?? this.zakatOrFitrahPaid,
      aiSubscriptionsSpent: aiSubscriptionsSpent ?? this.aiSubscriptionsSpent,
      internetBillsSpent: internetBillsSpent ?? this.internetBillsSpent,
      booksJournalsSpent: booksJournalsSpent ?? this.booksJournalsSpent,
      devicesSpent: devicesSpent ?? this.devicesSpent,
      lifestyleCoursesSpent:
          lifestyleCoursesSpent ?? this.lifestyleCoursesSpent,
      sportsEquipmentSpent: sportsEquipmentSpent ?? this.sportsEquipmentSpent,
      gymAndFacilitySpent: gymAndFacilitySpent ?? this.gymAndFacilitySpent,
      sportsCompetitionSpent:
          sportsCompetitionSpent ?? this.sportsCompetitionSpent,
      seriousDiseaseAndFertilitySpent: seriousDiseaseAndFertilitySpent ??
          this.seriousDiseaseAndFertilitySpent,
      fullCheckupAndMentalHealthSpent: fullCheckupAndMentalHealthSpent ??
          this.fullCheckupAndMentalHealthSpent,
      dentalTreatmentSpent: dentalTreatmentSpent ?? this.dentalTreatmentSpent,
      vaccinationSpent: vaccinationSpent ?? this.vaccinationSpent,
      medicalEducationInsuranceSpent:
          medicalEducationInsuranceSpent ?? this.medicalEducationInsuranceSpent,
      epfContributionSpent: epfContributionSpent ?? this.epfContributionSpent,
      lifeInsuranceSpent: lifeInsuranceSpent ?? this.lifeInsuranceSpent,
      prsContributionSpent: prsContributionSpent ?? this.prsContributionSpent,
      higherEducationSpent: higherEducationSpent ?? this.higherEducationSpent,
      upskillingSpent: upskillingSpent ?? this.upskillingSpent,
      socsoAndEisSpent: socsoAndEisSpent ?? this.socsoAndEisSpent,
      sspnNetSavingsSpent: sspnNetSavingsSpent ?? this.sspnNetSavingsSpent,
      housingLoanTier: housingLoanTier ?? this.housingLoanTier,
      housingLoanInterestSpent:
          housingLoanInterestSpent ?? this.housingLoanInterestSpent,
    );
  }
}

/// Complete LHDN Form BE Personal Income Tax Calculation & Optimization Output.
class LhdnTaxResult {
  const LhdnTaxResult({
    required this.assessmentYear,
    required this.totalGrossIncome,
    required this.totalStatutoryReliefs,
    required this.chargeableIncome,
    required this.calculatedTaxBeforeRebates,
    required this.qualifiesForIndividualRebate,
    required this.individualRebate,
    required this.zakatRebateApplied,
    required this.totalTaxRebates,
    required this.finalCalculatedTax,
    required this.annualPcbPaid,
    required this.netRefundOrPayable,
    required this.marginalTaxRate,
    required this.effectiveTaxRate,
    required this.buckets,
    required this.bracketSlices,
    required this.advisories,
    required this.complianceReminder,
  });

  final int assessmentYear;

  /// Step 1: Base Salary + Bonuses + Taxable Allowances + Other Income
  final Money totalGrossIncome;

  /// Step 2: Sum of all valid claimable categories (strictly capped per LHDN rules)
  final Money totalStatutoryReliefs;

  /// Step 3: Total Gross Income - Total Statutory Reliefs (clamped >= 0)
  final Money chargeableIncome;

  /// Step 4: Progressive resident tax before rebates (0% up to 30%)
  final Money calculatedTaxBeforeRebates;

  /// True when Chargeable Income <= RM 35,000
  final bool qualifiesForIndividualRebate;

  /// Step 5a: RM 400 individual rebate if Chargeable Income <= RM 35,000
  final Money individualRebate;

  /// Step 5b: Zakat / Fitrah 1:1 direct tax rebate applied
  final Money zakatRebateApplied;

  /// Total rebates applied (capped at calculatedTaxBeforeRebates so final tax >= 0)
  final Money totalTaxRebates;

  /// Step 5 Final: Calculated Tax minus rebates (minimum RM 0)
  final Money finalCalculatedTax;

  /// Total Monthly Tax Deductions (PCB / MTD) paid for the year
  final Money annualPcbPaid;

  /// Step 6: PCB Paid - Final Calculated Tax.
  /// Positive = Tax Refund due to user; Negative = Tax Payable owed by user.
  final Money netRefundOrPayable;

  final double marginalTaxRate;
  final double effectiveTaxRate;

  final List<BucketUtilization> buckets;
  final List<TaxBracketSlice> bracketSlices;
  final List<TaxOptimizationAdvisory> advisories;
  final String complianceReminder;

  bool get isRefund => netRefundOrPayable.sen >= 0;

  Money get estimatedRefund =>
      netRefundOrPayable.sen > 0 ? netRefundOrPayable : Money.zero;

  Money get additionalTaxPayable =>
      netRefundOrPayable.sen < 0 ? Money(-netRefundOrPayable.sen) : Money.zero;

  String get marginalRatePercentLabel =>
      '${(marginalTaxRate * 100).toStringAsFixed(marginalTaxRate * 100 == (marginalTaxRate * 100).roundToDouble() ? 0 : 1)}%';

  BucketUtilization bucketFor(LhdnReliefBucket target) =>
      buckets.firstWhere((b) => b.bucket == target);
}

/// Malaysian Personal Income Tax Optimization Engine (LHDN Form BE).
abstract final class LhdnTaxEngine {
  /// LHDN 7-Year Receipt Retention Mandate (Sections 82 & 82A Income Tax Act 1967).
  static const String complianceMandate =
      'Keep receipts and invoices under your own name for 7 years (Income Tax Act 1967, s.82 & 82A).';

  /// Chargeable income ceiling for the RM 400 individual tax rebate (RM 35,000.00).
  static const int individualRebateIncomeCeilingSen = 3500000;

  /// Statutory individual tax rebate amount (RM 400.00).
  static const int individualRebateAmountSen = 40000;

  /// Sub-limit inside EPF & Life Insurance for statutory/voluntary EPF (RM 4,000.00).
  static const int epfSubCapSen = 400000;

  /// Sub-limit inside Medical for Checkup/Mental Health, Dental, and Vaccination (RM 1,000.00 each).
  static const int medicalSubCapSen = 100000;

  /// Sub-limit inside Self Education for Upskilling / Skills Enhancement (RM 2,000.00).
  static const int upskillingSubCapSen = 200000;

  /// Official Malaysian Resident Individual Progressive Tax Brackets (0% up to 30%).
  static const List<LhdnTaxBracket> residentBrackets = [
    LhdnTaxBracket(
      lowerSen: 0,
      upperSen: 500000, // RM 0 - RM 5,000
      rate: 0.00,
      label: 'First RM 5,000 (RM 0 – RM 5,000)',
    ),
    LhdnTaxBracket(
      lowerSen: 500000,
      upperSen: 2000000, // RM 5,001 - RM 20,000
      rate: 0.01,
      label: 'Next RM 15,000 (RM 5,001 – RM 20,000)',
    ),
    LhdnTaxBracket(
      lowerSen: 2000000,
      upperSen: 3500000, // RM 20,001 - RM 35,000
      rate: 0.03,
      label: 'Next RM 15,000 (RM 20,001 – RM 35,000)',
    ),
    LhdnTaxBracket(
      lowerSen: 3500000,
      upperSen: 5000000, // RM 35,001 - RM 50,000
      rate: 0.06,
      label: 'Next RM 15,000 (RM 35,001 – RM 50,000)',
    ),
    LhdnTaxBracket(
      lowerSen: 5000000,
      upperSen: 7000000, // RM 50,001 - RM 70,000
      rate: 0.11,
      label: 'Next RM 20,000 (RM 50,001 – RM 70,000)',
    ),
    LhdnTaxBracket(
      lowerSen: 7000000,
      upperSen: 10000000, // RM 70,001 - RM 100,000
      rate: 0.19,
      label: 'Next RM 30,000 (RM 70,001 – RM 100,000)',
    ),
    LhdnTaxBracket(
      lowerSen: 10000000,
      upperSen: 40000000, // RM 100,001 - RM 400,000
      rate: 0.25,
      label: 'Next RM 300,000 (RM 100,001 – RM 400,000)',
    ),
    LhdnTaxBracket(
      lowerSen: 40000000,
      upperSen: 60000000, // RM 400,001 - RM 600,000
      rate: 0.26,
      label: 'Next RM 200,000 (RM 400,001 – RM 600,000)',
    ),
    LhdnTaxBracket(
      lowerSen: 60000000,
      upperSen: 200000000, // RM 600,001 - RM 2,000,000
      rate: 0.28,
      label: 'Next RM 1,400,000 (RM 600,001 – RM 2,000,000)',
    ),
    LhdnTaxBracket(
      lowerSen: 200000000,
      upperSen: null, // > RM 2,000,000
      rate: 0.30,
      label: 'Exceeding RM 2,000,000',
    ),
  ];

  /// Executes the 6-step LHDN Form BE Personal Income Tax Calculation & Cap Tracking.
  static LhdnTaxResult calculate(LhdnTaxInput input) {
    // 1. Total Annual Gross Income = Base Salary + Bonuses + Taxable Allowances + Other Income
    final Money totalGrossIncome = input.annualBaseSalary +
        input.annualBonuses +
        input.annualTaxableAllowances +
        input.annualOtherIncome;

    // 2. Calculate Strictly-Capped Statutory Reliefs across all 11 buckets
    final List<BucketUtilization> bucketList = [];

    // (2.1) Individual & Dependent Relatives: Automatic RM 9,000
    final individualCap = LhdnReliefBucket.individualAndDependent.defaultAnnualCap;
    bucketList.add(
      BucketUtilization(
        bucket: LhdnReliefBucket.individualAndDependent,
        rawSpent: individualCap,
        claimedAmount: individualCap,
        annualCap: individualCap,
      ),
    );

    // (2.2) Lifestyle (Gaya Hidup - Shared Cap RM 2,500)
    final lifestyleCap = LhdnReliefBucket.lifestyle.defaultAnnualCap;
    final lifestyleRaw = input.totalLifestyleRaw;
    final lifestyleClaimed =
        Money(math.min(lifestyleRaw.sen, lifestyleCap.sen));
    bucketList.add(
      BucketUtilization(
        bucket: LhdnReliefBucket.lifestyle,
        rawSpent: lifestyleRaw,
        claimedAmount: lifestyleClaimed,
        annualCap: lifestyleCap,
        subBuckets: [
          SubBucketUtilization(
            id: 'ai_subscriptions',
            title: 'AI Subscriptions',
            rawSpent: input.aiSubscriptionsSpent,
            claimedAmount: input.aiSubscriptionsSpent,
          ),
          SubBucketUtilization(
            id: 'internet',
            title: 'Internet / Broadband',
            rawSpent: input.internetBillsSpent,
            claimedAmount: input.internetBillsSpent,
          ),
          SubBucketUtilization(
            id: 'books',
            title: 'Books & Journals',
            rawSpent: input.booksJournalsSpent,
            claimedAmount: input.booksJournalsSpent,
          ),
          SubBucketUtilization(
            id: 'devices',
            title: 'Devices (Phone/PC/Tablet)',
            rawSpent: input.devicesSpent,
            claimedAmount: input.devicesSpent,
          ),
          SubBucketUtilization(
            id: 'courses',
            title: 'Lifestyle Courses',
            rawSpent: input.lifestyleCoursesSpent,
            claimedAmount: input.lifestyleCoursesSpent,
          ),
        ],
      ),
    );

    // (2.3) Sports & Fitness (Separate Pot RM 1,000)
    final sportsCap = LhdnReliefBucket.sportsAndFitness.defaultAnnualCap;
    final sportsRaw = input.totalSportsRaw;
    final sportsClaimed = Money(math.min(sportsRaw.sen, sportsCap.sen));
    bucketList.add(
      BucketUtilization(
        bucket: LhdnReliefBucket.sportsAndFitness,
        rawSpent: sportsRaw,
        claimedAmount: sportsClaimed,
        annualCap: sportsCap,
        subBuckets: [
          SubBucketUtilization(
            id: 'sports_equipment',
            title: 'Equipment',
            rawSpent: input.sportsEquipmentSpent,
            claimedAmount: input.sportsEquipmentSpent,
          ),
          SubBucketUtilization(
            id: 'gym_facility',
            title: 'Gym & Facility',
            rawSpent: input.gymAndFacilitySpent,
            claimedAmount: input.gymAndFacilitySpent,
          ),
          SubBucketUtilization(
            id: 'sports_competition',
            title: 'Competitions',
            rawSpent: input.sportsCompetitionSpent,
            claimedAmount: input.sportsCompetitionSpent,
          ),
        ],
      ),
    );

    // (2.4) Medical & Healthcare (Shared Pot RM 10,000 with RM 1,000 sub-caps)
    final medicalCap = LhdnReliefBucket.medicalAndHealthcare.defaultAnnualCap;
    final int cappedCheckupSen =
        math.min(input.fullCheckupAndMentalHealthSpent.sen, medicalSubCapSen);
    final int cappedDentalSen =
        math.min(input.dentalTreatmentSpent.sen, medicalSubCapSen);
    final int cappedVaccinationSen =
        math.min(input.vaccinationSpent.sen, medicalSubCapSen);
    final int combinedMedicalEligibleSen = cappedCheckupSen +
        cappedDentalSen +
        cappedVaccinationSen +
        input.seriousDiseaseAndFertilitySpent.sen;
    final medicalClaimed =
        Money(math.min(combinedMedicalEligibleSen, medicalCap.sen));

    bucketList.add(
      BucketUtilization(
        bucket: LhdnReliefBucket.medicalAndHealthcare,
        rawSpent: input.totalMedicalRaw,
        claimedAmount: medicalClaimed,
        annualCap: medicalCap,
        subBuckets: [
          SubBucketUtilization(
            id: 'checkup_mental',
            title: 'Checkup & Mental',
            rawSpent: input.fullCheckupAndMentalHealthSpent,
            claimedAmount: Money(cappedCheckupSen),
            subCap: const Money(medicalSubCapSen),
          ),
          SubBucketUtilization(
            id: 'dental',
            title: 'Dental',
            rawSpent: input.dentalTreatmentSpent,
            claimedAmount: Money(cappedDentalSen),
            subCap: const Money(medicalSubCapSen),
          ),
          SubBucketUtilization(
            id: 'vaccination',
            title: 'Vaccination',
            rawSpent: input.vaccinationSpent,
            claimedAmount: Money(cappedVaccinationSen),
            subCap: const Money(medicalSubCapSen),
          ),
          SubBucketUtilization(
            id: 'serious_disease',
            title: 'Serious Disease / Fertility',
            rawSpent: input.seriousDiseaseAndFertilitySpent,
            claimedAmount: input.seriousDiseaseAndFertilitySpent,
          ),
        ],
      ),
    );

    // (2.5) Medical & Education Insurance (Cap RM 4,000)
    final medInsCap =
        LhdnReliefBucket.medicalAndEducationInsurance.defaultAnnualCap;
    final medInsClaimed =
        Money(math.min(input.medicalEducationInsuranceSpent.sen, medInsCap.sen));
    bucketList.add(
      BucketUtilization(
        bucket: LhdnReliefBucket.medicalAndEducationInsurance,
        rawSpent: input.medicalEducationInsuranceSpent,
        claimedAmount: medInsClaimed,
        annualCap: medInsCap,
      ),
    );

    // (2.6) Life Insurance & EPF / KWSP (Cap RM 7,000; EPF strictly sub-capped at RM 4,000)
    final epfLifeCap = LhdnReliefBucket.lifeInsuranceAndEpf.defaultAnnualCap;
    final int cappedEpfSen =
        math.min(input.epfContributionSpent.sen, epfSubCapSen);
    final int epfLifeCombinedSen = cappedEpfSen + input.lifeInsuranceSpent.sen;
    final epfLifeClaimed =
        Money(math.min(epfLifeCombinedSen, epfLifeCap.sen));
    bucketList.add(
      BucketUtilization(
        bucket: LhdnReliefBucket.lifeInsuranceAndEpf,
        rawSpent: input.epfContributionSpent + input.lifeInsuranceSpent,
        claimedAmount: epfLifeClaimed,
        annualCap: epfLifeCap,
        subBuckets: [
          SubBucketUtilization(
            id: 'epf',
            title: 'EPF / KWSP',
            rawSpent: input.epfContributionSpent,
            claimedAmount: Money(cappedEpfSen),
            subCap: const Money(epfSubCapSen),
          ),
          SubBucketUtilization(
            id: 'life_insurance',
            title: 'Life Insurance / Takaful',
            rawSpent: input.lifeInsuranceSpent,
            claimedAmount: Money(
              math.min(input.lifeInsuranceSpent.sen, epfLifeCap.sen - cappedEpfSen),
            ),
            subCap: const Money(300000),
          ),
        ],
      ),
    );

    // (2.7) Private Retirement Scheme (PRS) / Deferred Annuity (Cap RM 3,000)
    final prsCap = LhdnReliefBucket.prsAndAnnuity.defaultAnnualCap;
    final prsClaimed =
        Money(math.min(input.prsContributionSpent.sen, prsCap.sen));
    bucketList.add(
      BucketUtilization(
        bucket: LhdnReliefBucket.prsAndAnnuity,
        rawSpent: input.prsContributionSpent,
        claimedAmount: prsClaimed,
        annualCap: prsCap,
      ),
    );

    // (2.8) Self Education / Upskilling (Cap RM 7,000; Upskilling sub-capped at RM 2,000)
    final eduCap = LhdnReliefBucket.selfEducation.defaultAnnualCap;
    final int cappedUpskillingSen =
        math.min(input.upskillingSpent.sen, upskillingSubCapSen);
    final int eduCombinedSen =
        input.higherEducationSpent.sen + cappedUpskillingSen;
    final eduClaimed = Money(math.min(eduCombinedSen, eduCap.sen));
    bucketList.add(
      BucketUtilization(
        bucket: LhdnReliefBucket.selfEducation,
        rawSpent: input.higherEducationSpent + input.upskillingSpent,
        claimedAmount: eduClaimed,
        annualCap: eduCap,
        subBuckets: [
          SubBucketUtilization(
            id: 'higher_education',
            title: 'Higher Education',
            rawSpent: input.higherEducationSpent,
            claimedAmount: input.higherEducationSpent,
          ),
          SubBucketUtilization(
            id: 'upskilling',
            title: 'Upskilling',
            rawSpent: input.upskillingSpent,
            claimedAmount: Money(cappedUpskillingSen),
            subCap: const Money(upskillingSubCapSen),
          ),
        ],
      ),
    );

    // (2.9) SOCSO (PERKESO) & EIS (SIP) (Cap RM 350)
    final socsoCap = LhdnReliefBucket.socsoAndEis.defaultAnnualCap;
    final socsoClaimed =
        Money(math.min(input.socsoAndEisSpent.sen, socsoCap.sen));
    bucketList.add(
      BucketUtilization(
        bucket: LhdnReliefBucket.socsoAndEis,
        rawSpent: input.socsoAndEisSpent,
        claimedAmount: socsoClaimed,
        annualCap: socsoCap,
      ),
    );

    // (2.10) SSPN Net Savings (Cap RM 8,000)
    final sspnCap = LhdnReliefBucket.sspn.defaultAnnualCap;
    final sspnClaimed =
        Money(math.min(math.max(0, input.sspnNetSavingsSpent.sen), sspnCap.sen));
    bucketList.add(
      BucketUtilization(
        bucket: LhdnReliefBucket.sspn,
        rawSpent: input.sspnNetSavingsSpent,
        claimedAmount: sspnClaimed,
        annualCap: sspnCap,
      ),
    );

    // (2.11) First-Time Homebuyer Loan Interest (RM 7,000 if <=500k, RM 5,000 if 500k-750k, else 0)
    final housingCap = input.housingLoanTier.annualCap;
    final housingClaimed =
        Money(math.min(input.housingLoanInterestSpent.sen, housingCap.sen));
    bucketList.add(
      BucketUtilization(
        bucket: LhdnReliefBucket.housingLoanInterest,
        rawSpent: input.housingLoanInterestSpent,
        claimedAmount: housingClaimed,
        annualCap: housingCap,
      ),
    );

    // Sum all statutory reliefs
    int totalReliefsSen = 0;
    for (final u in bucketList) {
      totalReliefsSen += u.claimedAmount.sen;
    }
    final totalStatutoryReliefs = Money(totalReliefsSen);

    // 3. Chargeable Income (Pendapatan Bercukai) = Total Gross Income - Total Statutory Reliefs
    final int chargeableSen =
        math.max(0, totalGrossIncome.sen - totalStatutoryReliefs.sen);
    final chargeableIncome = Money(chargeableSen);

    // 4. Calculated Tax via Resident Progressive Tax Brackets (0% up to 30%)
    final (calculatedTaxBeforeRebates, marginalRate, bracketSlices) =
        _computeProgressiveTax(chargeableIncome);

    // 5. Tax Rebates: Individual Tax Rebate (RM 400 if Chargeable Income <= RM 35,000) + Zakat/Fitrah (1:1)
    final bool qualifiesForIndRebate =
        chargeableIncome.sen <= individualRebateIncomeCeilingSen;
    final Money individualRebate = qualifiesForIndRebate
        ? const Money(individualRebateAmountSen)
        : Money.zero;
    final Money zakatRebateApplied =
        Money(math.max(0, input.zakatOrFitrahPaid.sen));

    final int rawRebatesSen = individualRebate.sen + zakatRebateApplied.sen;
    final int finalCalculatedTaxSen =
        math.max(0, calculatedTaxBeforeRebates.sen - rawRebatesSen);

    final totalTaxRebates = Money(rawRebatesSen);
    final finalCalculatedTax = Money(finalCalculatedTaxSen);

    // 6. Final Tax Payable / Refund = (Monthly Tax Deductions / PCB Paid) - (Final Calculated Tax)
    final Money netRefundOrPayable = input.annualPcbPaid - finalCalculatedTax;

    final double effectiveTaxRate = totalGrossIncome.sen > 0
        ? (finalCalculatedTax.sen / totalGrossIncome.sen)
        : 0.0;

    final advisories = _buildOptimizationAdvisories(
      chargeableIncome: chargeableIncome,
      finalCalculatedTax: finalCalculatedTax,
      marginalRate: marginalRate,
      buckets: bucketList,
    );

    return LhdnTaxResult(
      assessmentYear: input.assessmentYear,
      totalGrossIncome: totalGrossIncome,
      totalStatutoryReliefs: totalStatutoryReliefs,
      chargeableIncome: chargeableIncome,
      calculatedTaxBeforeRebates: calculatedTaxBeforeRebates,
      qualifiesForIndividualRebate: qualifiesForIndRebate,
      individualRebate: individualRebate,
      zakatRebateApplied: zakatRebateApplied,
      totalTaxRebates: totalTaxRebates,
      finalCalculatedTax: finalCalculatedTax,
      annualPcbPaid: input.annualPcbPaid,
      netRefundOrPayable: netRefundOrPayable,
      marginalTaxRate: marginalRate,
      effectiveTaxRate: effectiveTaxRate,
      buckets: bucketList,
      bracketSlices: bracketSlices,
      advisories: advisories,
      complianceReminder: complianceMandate,
    );
  }

  /// Computes progressive tax across Malaysia's resident brackets (0% to 30%).
  static (Money, double, List<TaxBracketSlice>) _computeProgressiveTax(
    Money chargeableIncome,
  ) {
    final int incomeSen = chargeableIncome.sen;
    int totalTaxSen = 0;
    double marginalRate = 0.0;
    final List<TaxBracketSlice> slices = [];

    for (final bracket in residentBrackets) {
      if (incomeSen <= bracket.lowerSen) continue;

      final int taxableInBandSen = bracket.upperSen != null
          ? math.min(incomeSen, bracket.upperSen!) - bracket.lowerSen
          : incomeSen - bracket.lowerSen;

      final int taxInBandSen = (taxableInBandSen * bracket.rate).round();
      totalTaxSen += taxInBandSen;
      marginalRate = bracket.rate;

      slices.add(
        TaxBracketSlice(
          bracket: bracket,
          taxableAmount: Money(taxableInBandSen),
          taxAmount: Money(taxInBandSen),
        ),
      );
    }

    return (Money(totalTaxSen), marginalRate, slices);
  }

  /// Auto-categorizes a transaction note, merchant, or category into its legal LHDN relief bucket.
  static TaxClassificationResult classifyTransaction({
    required String description,
    String? categoryName,
  }) {
    final text =
        '${description.toLowerCase()} ${(categoryName ?? '').toLowerCase()}'
            .trim();

    // 1. Check explicit Sports Apparel / Footwear exclusion FIRST
    if (_matchesAny(text, const [
      'running shoe',
      'running shoes',
      'sports shoe',
      'sports shoes',
      'sneaker',
      'sneakers',
      'futsal boot',
      'football boot',
      'badminton shoe',
      'jersey',
      'sportswear',
      'sports attire',
      'gym wear',
      'gym shirt',
      'gym shorts',
      'compression tights',
      'sports bra',
      'tracksuit',
      'athletic apparel',
    ])) {
      return const TaxClassificationResult(
        isExcludedWarn: true,
        subBucketTitle: 'Excluded Sports Apparel / Shoes',
        explanation:
            'LHDN Sports & Fitness relief (RM1,000 cap) covers sports equipment, gym memberships, facility rentals, and competition registration fees, but strictly EXCLUDES sports attire, jerseys, and footwear/shoes.',
      );
    }

    // 2. Zakat / Fitrah (1:1 Direct Tax Rebate)
    if (_matchesAny(text, const [
      'zakat',
      'fitrah',
      'ppz',
      'lembaga zakat',
      'lzs',
      'mawip',
      'zakat pendapatan',
      'zakat simpanan',
    ])) {
      return const TaxClassificationResult(
        isZakatRebate: true,
        subBucketTitle: 'Zakat / Fitrah (1:1 Direct Tax Rebate)',
        explanation:
            'Qualifies as a 1:1 Direct Tax Rebate under Section 6A(3) Income Tax Act. Every RM1 of Zakat/Fitrah directly reduces your calculated tax ringgit-for-ringgit.',
      );
    }

    // 3. Lifestyle - AI Subscriptions (Shared RM 2,500 cap)
    if (_matchesAny(text, const [
      'chatgpt',
      'openai',
      'claude',
      'anthropic',
      'copilot',
      'github copilot',
      'cursor',
      'midjourney',
      'perplexity',
      'gemini advanced',
      'ai subscription',
      'ai app',
      'notion ai',
      'poe subscription',
    ])) {
      return const TaxClassificationResult(
        bucket: LhdnReliefBucket.lifestyle,
        subBucketId: 'ai_subscriptions',
        subBucketTitle: 'AI Software / App Subscription (Gaya Hidup)',
        explanation:
            'Eligible under Lifestyle (Gaya Hidup) RM2,500 shared cap for personal/study AI software & app subscriptions. Shares the same RM2,500 pot with internet bills, books, and devices.',
      );
    }

    // 4. Lifestyle - Home Broadband & Mobile Internet (Shared RM 2,500 cap)
    if (_matchesAny(text, const [
      'unifi',
      'time fibre',
      'time internet',
      'maxis',
      'celcomdigi',
      'celcom',
      'digi',
      'u mobile',
      'umobile',
      'yes 5g',
      'starlink',
      'astro fibre',
      'broadband',
      'internet bill',
      'wifi bill',
      'postpaid',
      'mobile data',
    ])) {
      return const TaxClassificationResult(
        bucket: LhdnReliefBucket.lifestyle,
        subBucketId: 'internet',
        subBucketTitle: 'Home Broadband / Mobile Internet',
        explanation:
            'Monthly internet/broadband subscription registered under your own legal name is claimable under the Lifestyle RM2,500 shared pot.',
      );
    }

    // 5. Lifestyle - Smartphones, Tablets, Laptops / PCs (Shared RM 2,500 cap)
    if (_matchesAny(text, const [
      'iphone',
      'ipad',
      'macbook',
      'imac',
      'galaxy tab',
      'samsung s2',
      'pixel phone',
      'smartphone',
      'tablet',
      'laptop',
      'notebook pc',
      'desktop pc',
    ])) {
      return const TaxClassificationResult(
        bucket: LhdnReliefBucket.lifestyle,
        subBucketId: 'devices',
        subBucketTitle: 'Smartphone / Tablet / Laptop / PC',
        explanation:
            'Purchase of personal smartphone, tablet, or computer/laptop qualifies under the Lifestyle RM2,500 shared pot.',
      );
    }

    // 6. Lifestyle - Books, Journals & Publications (Shared RM 2,500 cap)
    if (_matchesAny(text, const [
      'kinokuniya',
      'popular bookstore',
      'bookxcess',
      'mph bookstore',
      'tsutaya',
      'kindle book',
      'ebook',
      'textbook',
      'novel',
      'journal',
      'magazine',
      'newspaper',
      'book purchase',
      'buku',
    ])) {
      return const TaxClassificationResult(
        bucket: LhdnReliefBucket.lifestyle,
        subBucketId: 'books',
        subBucketTitle: 'Books / Journals / Publications',
        explanation:
            'Physical or digital books, journals, magazines, and newspapers are eligible under the Lifestyle RM2,500 shared pot.',
      );
    }

    // 7. Sports & Fitness (Separate RM 1,000 Pot)
    if (_matchesAny(text, const [
      'gym',
      'anytime fitness',
      'celebrity fitness',
      'fitness first',
      'chi fitness',
      'babel',
      'futsal court',
      'badminton court',
      'swimming pool',
      'sports complex',
    ])) {
      return const TaxClassificationResult(
        bucket: LhdnReliefBucket.sportsAndFitness,
        subBucketId: 'gym_facility',
        subBucketTitle: 'Gym Membership & Sports Facility Rental',
        explanation:
            'Claimable under the separate RM1,000 Sports & Fitness pot.',
      );
    }
    if (_matchesAny(text, const [
      'marathon',
      'klscm',
      'fun run',
      'tournament fee',
      'competition registration',
    ])) {
      return const TaxClassificationResult(
        bucket: LhdnReliefBucket.sportsAndFitness,
        subBucketId: 'sports_competition',
        subBucketTitle: 'Sports Competition Registration Fee',
        explanation:
            'Competition registration fees are claimable under the separate RM1,000 Sports & Fitness pot.',
      );
    }
    if (_matchesAny(text, const [
      'decathlon',
      'yonex',
      'racket',
      'racquet',
      'shuttlecock',
      'dumbbell',
      'kettlebell',
      'yoga mat',
      'pickleball',
      'sports equipment',
    ])) {
      return const TaxClassificationResult(
        bucket: LhdnReliefBucket.sportsAndFitness,
        subBucketId: 'sports_equipment',
        subBucketTitle: 'Sports Equipment (Separate RM1,000 Pot)',
        explanation:
            'Sports equipment qualifies under the separate RM1,000 Sports & Fitness pot (excludes apparel and shoes).',
      );
    }

    // 8. Medical - Dental (RM 1,000 sub-limit inside RM 10,000 Medical pot)
    if (_matchesAny(text, const [
      'dental',
      'dentist',
      'pergigian',
      'klinik gigi',
      'scaling',
      'tooth filling',
      'tooth extraction',
      'root canal',
      'wisdom tooth',
    ])) {
      return const TaxClassificationResult(
        bucket: LhdnReliefBucket.medicalAndHealthcare,
        subBucketId: 'dental',
        subBucketTitle: 'Dental Treatment (RM1,000 Sub-Cap)',
        explanation:
            'Eligible under Medical & Healthcare (RM10,000 shared pot), subject to the RM1,000 dental treatment sub-limit.',
      );
    }

    // 9. Medical - Vaccinations (RM 1,000 sub-limit inside RM 10,000 Medical pot)
    if (_matchesAny(text, const [
      'vaccine',
      'vaccination',
      'vaksin',
      'flu shot',
      'influenza',
      'hpv',
      'pneumococcal',
      'meningococcal',
      'hepatitis',
      'typhoid',
    ])) {
      return const TaxClassificationResult(
        bucket: LhdnReliefBucket.medicalAndHealthcare,
        subBucketId: 'vaccination',
        subBucketTitle: 'Approved Vaccinations (RM1,000 Sub-Cap)',
        explanation:
            'Approved vaccinations are claimable up to the RM1,000 sub-limit within the RM10,000 Medical & Healthcare pot.',
      );
    }

    // 10. Medical - Full Health Checkup / Mental Health / COVID-19 (RM 1,000 sub-limit)
    if (_matchesAny(text, const [
      'health checkup',
      'health screening',
      'full blood test',
      'medical checkup',
      'pathlab',
      'bp healthcare',
      'mental health',
      'psychiatrist',
      'psychologist',
      'clinical therapy',
      'counselling',
      'covid test',
      'rtk',
      'pcr test',
      'pemeriksaan kesihatan',
      'checkup',
    ])) {
      return const TaxClassificationResult(
        bucket: LhdnReliefBucket.medicalAndHealthcare,
        subBucketId: 'checkup_mental',
        subBucketTitle: 'Full Health Checkup / Mental Health (RM1,000 Sub-Cap)',
        explanation:
            'Full medical checkup, mental health consultation, and COVID-19 tests are claimable up to the RM1,000 sub-limit within the RM10,000 Medical pot.',
      );
    }

    // 11. Medical - Serious Disease / Fertility (RM 10,000 shared pot)
    if (_matchesAny(text, const [
      'fertility',
      'ivf',
      'iui',
      'chemotherapy',
      'dialysis',
      'cancer treatment',
      'serious disease',
      'surgery',
      'hospital bill',
    ])) {
      return const TaxClassificationResult(
        bucket: LhdnReliefBucket.medicalAndHealthcare,
        subBucketId: 'serious_disease',
        subBucketTitle: 'Serious Disease / Fertility Treatment',
        explanation:
            'Treatment for serious diseases or fertility procedures is claimable up to the full RM10,000 Medical & Healthcare cap.',
      );
    }

    // 12. Medical & Education Insurance (RM 4,000 Cap)
    if (_matchesAny(text, const [
      'medical card',
      'medical insurance',
      'medical takaful',
      'takaful perubatan',
      'education insurance',
      'education takaful',
      'prudential medical',
      'aia medical',
      'great eastern medical',
      'etiqa medical',
      'allianz medical',
    ])) {
      return const TaxClassificationResult(
        bucket: LhdnReliefBucket.medicalAndEducationInsurance,
        subBucketId: 'medical_insurance',
        subBucketTitle: 'Medical & Education Insurance / Takaful',
        explanation:
            'Medical and education insurance/takaful premiums are claimable up to RM4,000 per assessment year.',
      );
    }

    // 13. Life Insurance & EPF (RM 7,000 Cap; EPF RM 4,000 sub-cap)
    if (_matchesAny(text, const [
      'kwsp',
      'epf',
      'i-saraan',
      'i-simpan',
      'voluntary epf',
    ])) {
      return const TaxClassificationResult(
        bucket: LhdnReliefBucket.lifeInsuranceAndEpf,
        subBucketId: 'epf',
        subBucketTitle: 'EPF / KWSP Contribution (RM4,000 Sub-Cap)',
        explanation:
            'Statutory and voluntary EPF (KWSP) contributions are claimable up to RM4,000 within the RM7,000 Life Insurance & EPF bucket.',
      );
    }
    if (_matchesAny(text, const [
      'life insurance',
      'family takaful',
      'hibah takaful',
      'term life',
      'insurans nyawa',
      'takaful keluarga',
    ])) {
      return const TaxClassificationResult(
        bucket: LhdnReliefBucket.lifeInsuranceAndEpf,
        subBucketId: 'life_insurance',
        subBucketTitle: 'Life Insurance / Family Takaful',
        explanation:
            'Life insurance and family takaful premiums are claimable up to RM3,000 alongside EPF (RM4,000) within the RM7,000 combined bucket.',
      );
    }

    // 14. Private Retirement Scheme (PRS) (RM 3,000 Cap)
    if (_matchesAny(text, const [
      'prs',
      'private retirement',
      'skim persaraan swasta',
      'ppa',
      'principal prs',
      'public mutual prs',
      'kenanga prs',
      'deferred annuity',
    ])) {
      return const TaxClassificationResult(
        bucket: LhdnReliefBucket.prsAndAnnuity,
        subBucketId: 'prs',
        subBucketTitle: 'Private Retirement Scheme (PRS)',
        explanation:
            'Contributions to approved Private Retirement Schemes (PRS) are claimable up to RM3,000.',
      );
    }

    // 15. SSPN Net Savings (RM 8,000 Cap)
    if (_matchesAny(text, const [
      'sspn',
      'simpan sspn',
      'sspn prime',
      'sspn plus',
    ])) {
      return const TaxClassificationResult(
        bucket: LhdnReliefBucket.sspn,
        subBucketId: 'sspn',
        subBucketTitle: 'Simpan SSPN Net Deposit',
        explanation:
            'Net annual deposit (deposits minus withdrawals) in Simpan SSPN is claimable up to RM8,000.',
      );
    }

    // 16. Self Education & Upskilling (RM 7,000 Cap; Upskilling RM 2,000 sub-cap)
    if (_matchesAny(text, const [
      'upskilling',
      'coursera',
      'udemy',
      'edx',
      'aws certification',
      'azure certification',
      'google cloud cert',
      'coding bootcamp',
      'professional certification',
      'hrd corp course',
    ])) {
      return const TaxClassificationResult(
        bucket: LhdnReliefBucket.selfEducation,
        subBucketId: 'upskilling',
        subBucketTitle: 'Upskilling / Skills Enhancement (RM2,000 Sub-Cap)',
        explanation:
            'Recognized upskilling and self-enhancement courses are claimable up to RM2,000 within the RM7,000 Self Education relief bucket.',
      );
    }
    if (_matchesAny(text, const [
      'master degree',
      'masters tuition',
      'phd tuition',
      'university tuition',
      'acca fee',
      'cfa exam',
      'postgraduate',
      'yuran pengajian',
      'tuition fee',
    ])) {
      return const TaxClassificationResult(
        bucket: LhdnReliefBucket.selfEducation,
        subBucketId: 'higher_education',
        subBucketTitle: 'Tertiary / Postgraduate Education',
        explanation:
            'Tuition fees for Masters/PhD or accredited Degree/Professional qualifications are claimable up to RM7,000.',
      );
    }

    // 17. SOCSO & EIS (RM 350 Cap)
    if (_matchesAny(text, const ['socso', 'perkeso', 'eis', 'sip'])) {
      return const TaxClassificationResult(
        bucket: LhdnReliefBucket.socsoAndEis,
        subBucketId: 'socso_eis',
        subBucketTitle: 'SOCSO (PERKESO) & EIS (SIP)',
        explanation:
            'Employee statutory contributions to PERKESO and EIS are claimable up to RM350.',
      );
    }

    // 18. First-Time Homebuyer Loan Interest (Up to RM 7,000 / RM 5,000)
    if (_matchesAny(text, const [
      'housing loan interest',
      'home loan interest',
      'mortgage interest',
      'first home interest',
      'faedah pinjaman perumahan',
    ])) {
      return const TaxClassificationResult(
        bucket: LhdnReliefBucket.housingLoanInterest,
        subBucketId: 'housing_loan_interest',
        subBucketTitle: 'First-Time Homebuyer Loan Interest',
        explanation:
            'First-time homebuyer residential loan interest is claimable up to RM7,000 (property <= RM500k) or RM5,000 (RM500k–RM750k).',
      );
    }

    // 19. Default: Non-deductible everyday expense
    return const TaxClassificationResult(
      explanation:
          'Personal living expenses (food, groceries, petrol, tolls, rent, and general shopping) are not tax-deductible under LHDN Form BE.',
    );
  }

  /// Simulates the exact Marginal Tax Impact of adding a new expense or contribution.
  static MarginalTaxImpactResult simulateExpenseImpact({
    required LhdnTaxInput currentInput,
    required String description,
    required Money amount,
    LhdnReliefBucket? overrideBucket,
  }) {
    final currentResult = calculate(currentInput);
    final classification = overrideBucket != null
        ? TaxClassificationResult(
            bucket: overrideBucket,
            subBucketTitle: overrideBucket.shortTitle,
            explanation: overrideBucket.ruleSummary,
          )
        : classifyTransaction(description: description);

    final double marginalRate = currentResult.marginalTaxRate;
    final int marginalPct = (marginalRate * 100).round();

    // Case A: Excluded item warning (e.g. sports shoes / apparel)
    if (classification.isExcludedWarn) {
      final sportsBucket =
          currentResult.bucketFor(LhdnReliefBucket.sportsAndFitness);
      return MarginalTaxImpactResult(
        classification: classification,
        amount: amount,
        claimablePortion: Money.zero,
        excessUnclaimablePortion: amount,
        marginalRate: marginalRate,
        estimatedTaxSaved: Money.zero,
        capStatusSummary: sportsBucket.formatCapStatus(short: true),
        marginalImpactStatement:
            'RM 0.00 tax saved — LHDN Sports & Fitness relief strictly EXCLUDES sports attire, jerseys, and footwear/shoes.',
        actionableSuggestion: _buildUnsaturatedSuggestion(
          currentResult,
          saturatedOrExcludedTitle: 'Sports Apparel/Shoes (Excluded)',
        ),
      );
    }

    // Case B: Zakat / Fitrah 1:1 Direct Tax Rebate
    if (classification.isZakatRebate) {
      final updatedInput = currentInput.copyWith(
        zakatOrFitrahPaid: currentInput.zakatOrFitrahPaid + amount,
      );
      final updatedResult = calculate(updatedInput);
      final taxSaved = Money(
        math.max(
          0,
          currentResult.finalCalculatedTax.sen -
              updatedResult.finalCalculatedTax.sen,
        ),
      );
      return MarginalTaxImpactResult(
        classification: classification,
        amount: amount,
        claimablePortion: amount,
        excessUnclaimablePortion: Money.zero,
        marginalRate: 1.0,
        estimatedTaxSaved: taxSaved,
        capStatusSummary:
            'Zakat / Fitrah 1:1 Direct Tax Rebate (Current: ${currentInput.zakatOrFitrahPaid.formattedCompact})',
        marginalImpactStatement:
            'Adding this ${amount.formattedCompact} Zakat/Fitrah contribution saves you ${taxSaved.formatted} directly (1:1 statutory tax rebate under Section 6A(3) ITA 1967).',
      );
    }

    // Case C: Non-deductible expense
    if (classification.bucket == null) {
      return MarginalTaxImpactResult(
        classification: classification,
        amount: amount,
        claimablePortion: Money.zero,
        excessUnclaimablePortion: amount,
        marginalRate: marginalRate,
        estimatedTaxSaved: Money.zero,
        capStatusSummary: 'No matching LHDN Form BE statutory relief bucket.',
        marginalImpactStatement:
            'Adding "$description" (${amount.formattedCompact}) saves RM 0.00 in tax because it is a general non-deductible expense.',
        actionableSuggestion: _buildUnsaturatedSuggestion(currentResult),
      );
    }

    // Case D: Eligible LHDN Relief Bucket
    final bucket = classification.bucket!;
    final updatedInput = _applyExpenseToInput(
      currentInput,
      bucket,
      classification.subBucketId,
      amount,
    );
    final updatedResult = calculate(updatedInput);

    final oldUtil = currentResult.bucketFor(bucket);
    final newUtil = updatedResult.bucketFor(bucket);

    final claimableDelta = Money(
      math.max(0, newUtil.claimedAmount.sen - oldUtil.claimedAmount.sen),
    );
    final excessDelta = Money(
      math.max(0, amount.sen - claimableDelta.sen),
    );

    final actualTaxDelta = Money(
      math.max(
        0,
        currentResult.finalCalculatedTax.sen -
            updatedResult.finalCalculatedTax.sen,
      ),
    );
    final pureMarginalSaving = claimableDelta.scale(marginalRate);
    final bool unlockedRebate = !currentResult.qualifiesForIndividualRebate &&
        updatedResult.qualifiesForIndividualRebate;

    final Money reportedTaxSaved = unlockedRebate
        ? actualTaxDelta
        : (actualTaxDelta.sen > 0 ? actualTaxDelta : pureMarginalSaving);

    String impactStatement;
    String? suggestion;

    if (claimableDelta.sen == 0) {
      impactStatement =
          'Adding this ${amount.formattedCompact} "$description" yields RM 0.00 in tax refund because your ${bucket.shortTitle} cap (${oldUtil.annualCap.formattedCompact}) is already saturated.';
      suggestion = _buildUnsaturatedSuggestion(
        updatedResult,
        exclude: bucket,
        saturatedOrExcludedTitle: bucket.shortTitle,
      );
    } else if (excessDelta.sen > 0) {
      impactStatement =
          'Partial Cap Hit: Only ${claimableDelta.formattedCompact} of ${amount.formattedCompact} fits inside ${bucket.shortTitle}, saving you ${reportedTaxSaved.formatted} in tax refund because you are in the $marginalPct% bracket (${excessDelta.formattedCompact} excess above cap yields RM 0).';
      suggestion = _buildUnsaturatedSuggestion(
        updatedResult,
        exclude: bucket,
        saturatedOrExcludedTitle: bucket.shortTitle,
      );
    } else {
      impactStatement =
          'Adding this ${amount.formattedCompact} $description saves you ${reportedTaxSaved.formatted} in tax refund because you are in the $marginalPct% bracket.${unlockedRebate ? " Bonus: This also drops your Chargeable Income <= RM35,000, unlocking the RM400 Individual Tax Rebate!" : ""}';
    }

    return MarginalTaxImpactResult(
      classification: classification,
      amount: amount,
      claimablePortion: claimableDelta,
      excessUnclaimablePortion: excessDelta,
      marginalRate: marginalRate,
      estimatedTaxSaved: reportedTaxSaved,
      capStatusSummary: newUtil.formatCapStatus(short: true),
      marginalImpactStatement: impactStatement,
      actionableSuggestion: suggestion,
    );
  }

  static LhdnTaxInput _applyExpenseToInput(
    LhdnTaxInput input,
    LhdnReliefBucket bucket,
    String? subBucketId,
    Money amount,
  ) {
    switch (bucket) {
      case LhdnReliefBucket.individualAndDependent:
        return input;
      case LhdnReliefBucket.lifestyle:
        switch (subBucketId) {
          case 'ai_subscriptions':
            return input.copyWith(
              aiSubscriptionsSpent: input.aiSubscriptionsSpent + amount,
            );
          case 'internet':
            return input.copyWith(
              internetBillsSpent: input.internetBillsSpent + amount,
            );
          case 'books':
            return input.copyWith(
              booksJournalsSpent: input.booksJournalsSpent + amount,
            );
          case 'devices':
            return input.copyWith(
              devicesSpent: input.devicesSpent + amount,
            );
          default:
            return input.copyWith(
              lifestyleCoursesSpent: input.lifestyleCoursesSpent + amount,
            );
        }
      case LhdnReliefBucket.sportsAndFitness:
        switch (subBucketId) {
          case 'gym_facility':
            return input.copyWith(
              gymAndFacilitySpent: input.gymAndFacilitySpent + amount,
            );
          case 'sports_competition':
            return input.copyWith(
              sportsCompetitionSpent: input.sportsCompetitionSpent + amount,
            );
          default:
            return input.copyWith(
              sportsEquipmentSpent: input.sportsEquipmentSpent + amount,
            );
        }
      case LhdnReliefBucket.medicalAndHealthcare:
        switch (subBucketId) {
          case 'dental':
            return input.copyWith(
              dentalTreatmentSpent: input.dentalTreatmentSpent + amount,
            );
          case 'vaccination':
            return input.copyWith(
              vaccinationSpent: input.vaccinationSpent + amount,
            );
          case 'checkup_mental':
            return input.copyWith(
              fullCheckupAndMentalHealthSpent:
                  input.fullCheckupAndMentalHealthSpent + amount,
            );
          default:
            return input.copyWith(
              seriousDiseaseAndFertilitySpent:
                  input.seriousDiseaseAndFertilitySpent + amount,
            );
        }
      case LhdnReliefBucket.medicalAndEducationInsurance:
        return input.copyWith(
          medicalEducationInsuranceSpent:
              input.medicalEducationInsuranceSpent + amount,
        );
      case LhdnReliefBucket.lifeInsuranceAndEpf:
        if (subBucketId == 'epf') {
          return input.copyWith(
            epfContributionSpent: input.epfContributionSpent + amount,
          );
        }
        return input.copyWith(
          lifeInsuranceSpent: input.lifeInsuranceSpent + amount,
        );
      case LhdnReliefBucket.prsAndAnnuity:
        return input.copyWith(
          prsContributionSpent: input.prsContributionSpent + amount,
        );
      case LhdnReliefBucket.selfEducation:
        if (subBucketId == 'upskilling') {
          return input.copyWith(
            upskillingSpent: input.upskillingSpent + amount,
          );
        }
        return input.copyWith(
          higherEducationSpent: input.higherEducationSpent + amount,
        );
      case LhdnReliefBucket.socsoAndEis:
        return input.copyWith(
          socsoAndEisSpent: input.socsoAndEisSpent + amount,
        );
      case LhdnReliefBucket.sspn:
        return input.copyWith(
          sspnNetSavingsSpent: input.sspnNetSavingsSpent + amount,
        );
      case LhdnReliefBucket.housingLoanInterest:
        final tier = input.housingLoanTier == HousingLoanTier.none
            ? HousingLoanTier.upTo500k
            : input.housingLoanTier;
        return input.copyWith(
          housingLoanTier: tier,
          housingLoanInterestSpent: input.housingLoanInterestSpent + amount,
        );
    }
  }

  static String? _buildUnsaturatedSuggestion(
    LhdnTaxResult result, {
    LhdnReliefBucket? exclude,
    String? saturatedOrExcludedTitle,
  }) {
    final prs = result.bucketFor(LhdnReliefBucket.prsAndAnnuity);
    final sspn = result.bucketFor(LhdnReliefBucket.sspn);
    final sports = result.bucketFor(LhdnReliefBucket.sportsAndFitness);

    final parts = <String>[];
    if (exclude != LhdnReliefBucket.prsAndAnnuity &&
        prs.remainingHeadroom.sen > 0) {
      parts.add('voluntary PRS (${prs.remainingHeadroom.formattedCompact} left)');
    }
    if (exclude != LhdnReliefBucket.sspn && sspn.remainingHeadroom.sen > 0) {
      parts.add('Simpan SSPN (${sspn.remainingHeadroom.formattedCompact} left)');
    }
    if (exclude != LhdnReliefBucket.sportsAndFitness &&
        sports.remainingHeadroom.sen > 0) {
      parts.add(
        'Sports & Fitness (${sports.remainingHeadroom.formattedCompact} left)',
      );
    }

    if (parts.isEmpty) return null;
    final prefix = saturatedOrExcludedTitle != null
        ? 'Since $saturatedOrExcludedTitle is already saturated or excluded, redirect funds before Dec 31 into unsaturated buckets: '
        : 'Consider topping up unsaturated buckets before Dec 31: ';
    return '$prefix${parts.join(", ")}.';
  }

  static List<TaxOptimizationAdvisory> _buildOptimizationAdvisories({
    required Money chargeableIncome,
    required Money finalCalculatedTax,
    required double marginalRate,
    required List<BucketUtilization> buckets,
  }) {
    final List<TaxOptimizationAdvisory> advisories = [];
    final int marginalPct = (marginalRate * 100).round();

    // 1. Saturated / Overflowing Bucket Warnings
    for (final util in buckets) {
      if (util.bucket.isAutomatic || util.annualCap.sen == 0) continue;
      if (util.excessUnclaimable.sen > 0) {
        advisories.add(
          TaxOptimizationAdvisory(
            title: '${util.bucket.shortTitle} cap reached',
            message:
                '${util.formatCapStatus(short: true)}. ${util.excessUnclaimable.formattedCompact} over the cap earns no extra relief. Try PRS or SSPN before Dec 31.',
            isWarning: true,
            targetBucket: util.bucket,
          ),
        );
      }
    }

    // 2. RM 35,000 Individual Rebate Cliff Opportunity
    if (chargeableIncome.sen > individualRebateIncomeCeilingSen &&
        chargeableIncome.sen <= 4300000) {
      final gap =
          Money(chargeableIncome.sen - individualRebateIncomeCeilingSen);
      final marginalSave = gap.scale(marginalRate);
      final totalUnlock = marginalSave + const Money(individualRebateAmountSen);
      advisories.add(
        TaxOptimizationAdvisory(
          title: '${gap.formattedCompact} from the RM400 rebate',
          message:
              'Claim ${gap.formattedCompact} more in reliefs before Dec 31 to bring chargeable income down to RM35,000 and unlock it.',
          isWarning: false,
          estimatedMaxTaxSaved: totalUnlock,
        ),
      );
    }

    // 3. Unsaturated High-Impact Buckets
    final lifestyle =
        buckets.firstWhere((b) => b.bucket == LhdnReliefBucket.lifestyle);
    if (lifestyle.remainingHeadroom.sen > 0) {
      advisories.add(
        TaxOptimizationAdvisory(
          title: 'Lifestyle relief room left',
          message:
              '${lifestyle.formatCapStatus(short: true)}. AI tools, broadband, books and devices share this pot.',
          isWarning: false,
          targetBucket: LhdnReliefBucket.lifestyle,
          estimatedMaxTaxSaved: lifestyle.remainingHeadroom.scale(marginalRate),
        ),
      );
    }

    final prs =
        buckets.firstWhere((b) => b.bucket == LhdnReliefBucket.prsAndAnnuity);
    if (prs.remainingHeadroom.sen > 0 && marginalRate > 0) {
      advisories.add(
        TaxOptimizationAdvisory(
          title: 'Top up PRS before Dec 31',
          message:
              '${prs.formatCapStatus(short: true)}. Could save up to ${prs.remainingHeadroom.scale(marginalRate).formatted} in tax.',
          isWarning: false,
          targetBucket: LhdnReliefBucket.prsAndAnnuity,
          estimatedMaxTaxSaved: prs.remainingHeadroom.scale(marginalRate),
        ),
      );
    }

    final sspn = buckets.firstWhere((b) => b.bucket == LhdnReliefBucket.sspn);
    if (sspn.remainingHeadroom.sen > 0 && marginalRate > 0) {
      advisories.add(
        TaxOptimizationAdvisory(
          title: 'Simpan SSPN net savings',
          message:
              '${sspn.formatCapStatus(short: true)}. Could save up to ${sspn.remainingHeadroom.scale(marginalRate).formatted} at your $marginalPct% rate.',
          isWarning: false,
          targetBucket: LhdnReliefBucket.sspn,
          estimatedMaxTaxSaved: sspn.remainingHeadroom.scale(marginalRate),
        ),
      );
    }

    if (finalCalculatedTax.sen > 0) {
      advisories.add(
        TaxOptimizationAdvisory(
          title: 'Zakat and fitrah rebate',
          message:
              'Zakat paid this year offsets your RM ${finalCalculatedTax.ringgit.toStringAsFixed(2)} tax 1:1, not at your $marginalPct% rate.',
          isWarning: false,
          estimatedMaxTaxSaved: finalCalculatedTax,
        ),
      );
    }

    return advisories;
  }

  static bool _matchesAny(String text, List<String> keywords) {
    for (final kw in keywords) {
      if (text.contains(kw)) return true;
    }
    return false;
  }
}
