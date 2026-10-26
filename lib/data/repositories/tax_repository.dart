import 'dart:async';
import 'package:drift/drift.dart';

import '../../domain/engine/lhdn_tax_engine.dart';
import '../local/app_database.dart';

/// Persisted annual tax configuration & manual statutory relief adjustments
/// for a specific LHDN Year of Assessment (Tahun Taksiran).
class TaxYearProfileData {
  final int assessmentYear;
  final int annualBonusSen;
  final int annualOtherIncomeSen;
  final int? annualPcbOverrideSen;
  final int zakatFitrahSen;
  final int voluntaryEpfSen;
  final int lifeInsuranceSen;
  final int medicalInsuranceSen;
  final int prsAnnuitySen;
  final int sspnNetSavingsSen;
  final int higherEducationSen;
  final int upskillingSen;
  final HousingLoanTier housingLoanTier;
  final int housingLoanInterestSen;

  // Manual base adjustments for receipt-based buckets (in addition to logged receipt claims)
  final int lifestyleAiSen;
  final int lifestyleInternetSen;
  final int lifestyleBooksSen;
  final int lifestyleDevicesSen;
  final int lifestyleCoursesSen;
  final int sportsEquipmentSen;
  final int sportsGymFacilitySen;
  final int sportsCompetitionSen;
  final int medicalSeriousFertilitySen;
  final int medicalCheckupMentalSen;
  final int medicalDentalSen;
  final int medicalVaccinationSen;
  final DateTime updatedAt;

  const TaxYearProfileData({
    required this.assessmentYear,
    this.annualBonusSen = 0,
    this.annualOtherIncomeSen = 0,
    this.annualPcbOverrideSen,
    this.zakatFitrahSen = 0,
    this.voluntaryEpfSen = 0,
    this.lifeInsuranceSen = 0,
    this.medicalInsuranceSen = 0,
    this.prsAnnuitySen = 0,
    this.sspnNetSavingsSen = 0,
    this.higherEducationSen = 0,
    this.upskillingSen = 0,
    this.housingLoanTier = HousingLoanTier.none,
    this.housingLoanInterestSen = 0,
    this.lifestyleAiSen = 0,
    this.lifestyleInternetSen = 0,
    this.lifestyleBooksSen = 0,
    this.lifestyleDevicesSen = 0,
    this.lifestyleCoursesSen = 0,
    this.sportsEquipmentSen = 0,
    this.sportsGymFacilitySen = 0,
    this.sportsCompetitionSen = 0,
    this.medicalSeriousFertilitySen = 0,
    this.medicalCheckupMentalSen = 0,
    this.medicalDentalSen = 0,
    this.medicalVaccinationSen = 0,
    required this.updatedAt,
  });

  factory TaxYearProfileData.empty(int year) {
    return TaxYearProfileData(
      assessmentYear: year,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  factory TaxYearProfileData.fromRow(QueryRow row) {
    final tierStr = row.read<String>('housing_loan_tier');
    final tier = HousingLoanTier.values.firstWhere(
      (t) => t.name == tierStr,
      orElse: () => HousingLoanTier.none,
    );
    return TaxYearProfileData(
      assessmentYear: row.read<int>('assessment_year'),
      annualBonusSen: row.read<int>('annual_bonus_sen'),
      annualOtherIncomeSen: row.read<int>('annual_other_income_sen'),
      annualPcbOverrideSen: row.readNullable<int>('annual_pcb_override_sen'),
      zakatFitrahSen: row.read<int>('zakat_fitrah_sen'),
      voluntaryEpfSen: row.read<int>('voluntary_epf_sen'),
      lifeInsuranceSen: row.read<int>('life_insurance_sen'),
      medicalInsuranceSen: row.read<int>('medical_insurance_sen'),
      prsAnnuitySen: row.read<int>('prs_annuity_sen'),
      sspnNetSavingsSen: row.read<int>('sspn_net_savings_sen'),
      higherEducationSen: row.read<int>('higher_education_sen'),
      upskillingSen: row.read<int>('upskilling_sen'),
      housingLoanTier: tier,
      housingLoanInterestSen: row.read<int>('housing_loan_interest_sen'),
      lifestyleAiSen: row.read<int>('lifestyle_ai_sen'),
      lifestyleInternetSen: row.read<int>('lifestyle_internet_sen'),
      lifestyleBooksSen: row.read<int>('lifestyle_books_sen'),
      lifestyleDevicesSen: row.read<int>('lifestyle_devices_sen'),
      lifestyleCoursesSen: row.read<int>('lifestyle_courses_sen'),
      sportsEquipmentSen: row.read<int>('sports_equipment_sen'),
      sportsGymFacilitySen: row.read<int>('sports_gym_facility_sen'),
      sportsCompetitionSen: row.read<int>('sports_competition_sen'),
      medicalSeriousFertilitySen: row.read<int>('medical_serious_fertility_sen'),
      medicalCheckupMentalSen: row.read<int>('medical_checkup_mental_sen'),
      medicalDentalSen: row.read<int>('medical_dental_sen'),
      medicalVaccinationSen: row.read<int>('medical_vaccination_sen'),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        row.read<int>('updated_at'),
      ),
    );
  }

  TaxYearProfileData copyWith({
    int? assessmentYear,
    int? annualBonusSen,
    int? annualOtherIncomeSen,
    int? annualPcbOverrideSen,
    bool clearPcbOverride = false,
    int? zakatFitrahSen,
    int? voluntaryEpfSen,
    int? lifeInsuranceSen,
    int? medicalInsuranceSen,
    int? prsAnnuitySen,
    int? sspnNetSavingsSen,
    int? higherEducationSen,
    int? upskillingSen,
    HousingLoanTier? housingLoanTier,
    int? housingLoanInterestSen,
    int? lifestyleAiSen,
    int? lifestyleInternetSen,
    int? lifestyleBooksSen,
    int? lifestyleDevicesSen,
    int? lifestyleCoursesSen,
    int? sportsEquipmentSen,
    int? sportsGymFacilitySen,
    int? sportsCompetitionSen,
    int? medicalSeriousFertilitySen,
    int? medicalCheckupMentalSen,
    int? medicalDentalSen,
    int? medicalVaccinationSen,
    DateTime? updatedAt,
  }) {
    return TaxYearProfileData(
      assessmentYear: assessmentYear ?? this.assessmentYear,
      annualBonusSen: annualBonusSen ?? this.annualBonusSen,
      annualOtherIncomeSen: annualOtherIncomeSen ?? this.annualOtherIncomeSen,
      annualPcbOverrideSen: clearPcbOverride
          ? null
          : (annualPcbOverrideSen ?? this.annualPcbOverrideSen),
      zakatFitrahSen: zakatFitrahSen ?? this.zakatFitrahSen,
      voluntaryEpfSen: voluntaryEpfSen ?? this.voluntaryEpfSen,
      lifeInsuranceSen: lifeInsuranceSen ?? this.lifeInsuranceSen,
      medicalInsuranceSen: medicalInsuranceSen ?? this.medicalInsuranceSen,
      prsAnnuitySen: prsAnnuitySen ?? this.prsAnnuitySen,
      sspnNetSavingsSen: sspnNetSavingsSen ?? this.sspnNetSavingsSen,
      higherEducationSen: higherEducationSen ?? this.higherEducationSen,
      upskillingSen: upskillingSen ?? this.upskillingSen,
      housingLoanTier: housingLoanTier ?? this.housingLoanTier,
      housingLoanInterestSen:
          housingLoanInterestSen ?? this.housingLoanInterestSen,
      lifestyleAiSen: lifestyleAiSen ?? this.lifestyleAiSen,
      lifestyleInternetSen: lifestyleInternetSen ?? this.lifestyleInternetSen,
      lifestyleBooksSen: lifestyleBooksSen ?? this.lifestyleBooksSen,
      lifestyleDevicesSen: lifestyleDevicesSen ?? this.lifestyleDevicesSen,
      lifestyleCoursesSen: lifestyleCoursesSen ?? this.lifestyleCoursesSen,
      sportsEquipmentSen: sportsEquipmentSen ?? this.sportsEquipmentSen,
      sportsGymFacilitySen: sportsGymFacilitySen ?? this.sportsGymFacilitySen,
      sportsCompetitionSen: sportsCompetitionSen ?? this.sportsCompetitionSen,
      medicalSeriousFertilitySen:
          medicalSeriousFertilitySen ?? this.medicalSeriousFertilitySen,
      medicalCheckupMentalSen:
          medicalCheckupMentalSen ?? this.medicalCheckupMentalSen,
      medicalDentalSen: medicalDentalSen ?? this.medicalDentalSen,
      medicalVaccinationSen:
          medicalVaccinationSen ?? this.medicalVaccinationSen,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'assessmentYear': assessmentYear,
        'annualBonusSen': annualBonusSen,
        'annualOtherIncomeSen': annualOtherIncomeSen,
        'annualPcbOverrideSen': annualPcbOverrideSen,
        'zakatFitrahSen': zakatFitrahSen,
        'voluntaryEpfSen': voluntaryEpfSen,
        'lifeInsuranceSen': lifeInsuranceSen,
        'medicalInsuranceSen': medicalInsuranceSen,
        'prsAnnuitySen': prsAnnuitySen,
        'sspnNetSavingsSen': sspnNetSavingsSen,
        'higherEducationSen': higherEducationSen,
        'upskillingSen': upskillingSen,
        'housingLoanTier': housingLoanTier.name,
        'housingLoanInterestSen': housingLoanInterestSen,
        'lifestyleAiSen': lifestyleAiSen,
        'lifestyleInternetSen': lifestyleInternetSen,
        'lifestyleBooksSen': lifestyleBooksSen,
        'lifestyleDevicesSen': lifestyleDevicesSen,
        'lifestyleCoursesSen': lifestyleCoursesSen,
        'sportsEquipmentSen': sportsEquipmentSen,
        'sportsGymFacilitySen': sportsGymFacilitySen,
        'sportsCompetitionSen': sportsCompetitionSen,
        'medicalSeriousFertilitySen': medicalSeriousFertilitySen,
        'medicalCheckupMentalSen': medicalCheckupMentalSen,
        'medicalDentalSen': medicalDentalSen,
        'medicalVaccinationSen': medicalVaccinationSen,
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory TaxYearProfileData.fromJson(Map<String, dynamic> json) {
    final tierStr = json['housingLoanTier'] as String? ?? 'none';
    final tier = HousingLoanTier.values.firstWhere(
      (t) => t.name == tierStr,
      orElse: () => HousingLoanTier.none,
    );
    return TaxYearProfileData(
      assessmentYear: (json['assessmentYear'] as num?)?.toInt() ?? DateTime.now().year,
      annualBonusSen: (json['annualBonusSen'] as num?)?.toInt() ?? 0,
      annualOtherIncomeSen: (json['annualOtherIncomeSen'] as num?)?.toInt() ?? 0,
      annualPcbOverrideSen: (json['annualPcbOverrideSen'] as num?)?.toInt(),
      zakatFitrahSen: (json['zakatFitrahSen'] as num?)?.toInt() ?? 0,
      voluntaryEpfSen: (json['voluntaryEpfSen'] as num?)?.toInt() ?? 0,
      lifeInsuranceSen: (json['lifeInsuranceSen'] as num?)?.toInt() ?? 0,
      medicalInsuranceSen: (json['medicalInsuranceSen'] as num?)?.toInt() ?? 0,
      prsAnnuitySen: (json['prsAnnuitySen'] as num?)?.toInt() ?? 0,
      sspnNetSavingsSen: (json['sspnNetSavingsSen'] as num?)?.toInt() ?? 0,
      higherEducationSen: (json['higherEducationSen'] as num?)?.toInt() ?? 0,
      upskillingSen: (json['upskillingSen'] as num?)?.toInt() ?? 0,
      housingLoanTier: tier,
      housingLoanInterestSen: (json['housingLoanInterestSen'] as num?)?.toInt() ?? 0,
      lifestyleAiSen: (json['lifestyleAiSen'] as num?)?.toInt() ?? 0,
      lifestyleInternetSen: (json['lifestyleInternetSen'] as num?)?.toInt() ?? 0,
      lifestyleBooksSen: (json['lifestyleBooksSen'] as num?)?.toInt() ?? 0,
      lifestyleDevicesSen: (json['lifestyleDevicesSen'] as num?)?.toInt() ?? 0,
      lifestyleCoursesSen: (json['lifestyleCoursesSen'] as num?)?.toInt() ?? 0,
      sportsEquipmentSen: (json['sportsEquipmentSen'] as num?)?.toInt() ?? 0,
      sportsGymFacilitySen: (json['sportsGymFacilitySen'] as num?)?.toInt() ?? 0,
      sportsCompetitionSen: (json['sportsCompetitionSen'] as num?)?.toInt() ?? 0,
      medicalSeriousFertilitySen:
          (json['medicalSeriousFertilitySen'] as num?)?.toInt() ?? 0,
      medicalCheckupMentalSen:
          (json['medicalCheckupMentalSen'] as num?)?.toInt() ?? 0,
      medicalDentalSen: (json['medicalDentalSen'] as num?)?.toInt() ?? 0,
      medicalVaccinationSen:
          (json['medicalVaccinationSen'] as num?)?.toInt() ?? 0,
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}

/// An itemized tax receipt / transaction claim mapped to an LHDN relief bucket.
class TaxReceiptClaimData {
  final int id;
  final int assessmentYear;
  final int? expenseId;
  final String title;
  final int amountSen;
  final LhdnReliefBucket bucket;
  final String? subBucketId;
  final String receiptRef;
  final DateTime claimedDate;
  final bool isAutoClassified;

  const TaxReceiptClaimData({
    required this.id,
    required this.assessmentYear,
    this.expenseId,
    required this.title,
    required this.amountSen,
    required this.bucket,
    this.subBucketId,
    this.receiptRef = '',
    required this.claimedDate,
    this.isAutoClassified = true,
  });

  factory TaxReceiptClaimData.fromRow(QueryRow row) {
    final bucketStr = row.read<String>('bucket_id');
    final bucket = LhdnReliefBucket.values.firstWhere(
      (b) => b.name == bucketStr,
      orElse: () => LhdnReliefBucket.lifestyle,
    );
    return TaxReceiptClaimData(
      id: row.read<int>('id'),
      assessmentYear: row.read<int>('assessment_year'),
      expenseId: row.readNullable<int>('expense_id'),
      title: row.read<String>('title'),
      amountSen: row.read<int>('amount_sen'),
      bucket: bucket,
      subBucketId: row.readNullable<String>('sub_bucket_id'),
      receiptRef: row.read<String>('receipt_ref'),
      claimedDate: DateTime.fromMillisecondsSinceEpoch(
        row.read<int>('claimed_date'),
      ),
      isAutoClassified: row.read<int>('is_auto_classified') != 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'assessmentYear': assessmentYear,
        'expenseId': expenseId,
        'title': title,
        'amountSen': amountSen,
        'bucket': bucket.name,
        'subBucketId': subBucketId,
        'receiptRef': receiptRef,
        'claimedDate': claimedDate.toIso8601String(),
        'isAutoClassified': isAutoClassified,
      };

  factory TaxReceiptClaimData.fromJson(Map<String, dynamic> json) {
    final bucketStr = json['bucket'] as String? ?? 'lifestyle';
    final bucket = LhdnReliefBucket.values.firstWhere(
      (b) => b.name == bucketStr,
      orElse: () => LhdnReliefBucket.lifestyle,
    );
    return TaxReceiptClaimData(
      id: (json['id'] as num?)?.toInt() ?? 0,
      assessmentYear:
          (json['assessmentYear'] as num?)?.toInt() ?? DateTime.now().year,
      expenseId: (json['expenseId'] as num?)?.toInt(),
      title: json['title'] as String? ?? '',
      amountSen: (json['amountSen'] as num?)?.toInt() ?? 0,
      bucket: bucket,
      subBucketId: json['subBucketId'] as String?,
      receiptRef: json['receiptRef'] as String? ?? '',
      claimedDate: DateTime.tryParse(json['claimedDate'] as String? ?? '') ??
          DateTime.now(),
      isAutoClassified: json['isAutoClassified'] as bool? ?? true,
    );
  }
}

/// Repository for LHDN Personal Income Tax Optimization (Form BE) persistence.
class TaxRepository {
  final AppDatabase _db;
  final StreamController<void> _changeController =
      StreamController<void>.broadcast();

  TaxRepository(this._db);

  void _notifyListeners() {
    if (!_changeController.isClosed) {
      _changeController.add(null);
    }
  }

  /// Ensures tables exist and fetches the [TaxYearProfileData] for [year].
  Future<TaxYearProfileData> getTaxYearProfile(int year) async {
    await _db.ensureTaxTables();
    final rows = await _db.customSelect(
      'SELECT * FROM tax_year_profiles WHERE assessment_year = ?',
      variables: [Variable.withInt(year)],
    ).get();

    if (rows.isEmpty) {
      return TaxYearProfileData.empty(year);
    }
    return TaxYearProfileData.fromRow(rows.first);
  }

  /// Reactive stream of [TaxYearProfileData] for [year].
  Stream<TaxYearProfileData> watchTaxYearProfile(int year) {
    return Stream<TaxYearProfileData>.multi((controller) {
      var active = true;
      Future<void> emit() async {
        try {
          final data = await getTaxYearProfile(year);
          if (active && !controller.isClosed) {
            controller.add(data);
          }
        } catch (e, st) {
          if (active && !controller.isClosed) {
            controller.addError(e, st);
          }
        }
      }

      emit();
      final sub = _changeController.stream.listen((_) => emit());
      controller.onCancel = () {
        active = false;
        return sub.cancel();
      };
    });
  }

  /// Saves or updates the [TaxYearProfileData].
  Future<void> saveTaxYearProfile(TaxYearProfileData profile) async {
    await _db.ensureTaxTables();
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    await _db.customStatement(
      '''
      INSERT INTO tax_year_profiles (
        assessment_year,
        annual_bonus_sen,
        annual_other_income_sen,
        annual_pcb_override_sen,
        zakat_fitrah_sen,
        voluntary_epf_sen,
        life_insurance_sen,
        medical_insurance_sen,
        prs_annuity_sen,
        sspn_net_savings_sen,
        higher_education_sen,
        upskilling_sen,
        housing_loan_tier,
        housing_loan_interest_sen,
        lifestyle_ai_sen,
        lifestyle_internet_sen,
        lifestyle_books_sen,
        lifestyle_devices_sen,
        lifestyle_courses_sen,
        sports_equipment_sen,
        sports_gym_facility_sen,
        sports_competition_sen,
        medical_serious_fertility_sen,
        medical_checkup_mental_sen,
        medical_dental_sen,
        medical_vaccination_sen,
        updated_at
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ON CONFLICT(assessment_year) DO UPDATE SET
        annual_bonus_sen = excluded.annual_bonus_sen,
        annual_other_income_sen = excluded.annual_other_income_sen,
        annual_pcb_override_sen = excluded.annual_pcb_override_sen,
        zakat_fitrah_sen = excluded.zakat_fitrah_sen,
        voluntary_epf_sen = excluded.voluntary_epf_sen,
        life_insurance_sen = excluded.life_insurance_sen,
        medical_insurance_sen = excluded.medical_insurance_sen,
        prs_annuity_sen = excluded.prs_annuity_sen,
        sspn_net_savings_sen = excluded.sspn_net_savings_sen,
        higher_education_sen = excluded.higher_education_sen,
        upskilling_sen = excluded.upskilling_sen,
        housing_loan_tier = excluded.housing_loan_tier,
        housing_loan_interest_sen = excluded.housing_loan_interest_sen,
        lifestyle_ai_sen = excluded.lifestyle_ai_sen,
        lifestyle_internet_sen = excluded.lifestyle_internet_sen,
        lifestyle_books_sen = excluded.lifestyle_books_sen,
        lifestyle_devices_sen = excluded.lifestyle_devices_sen,
        lifestyle_courses_sen = excluded.lifestyle_courses_sen,
        sports_equipment_sen = excluded.sports_equipment_sen,
        sports_gym_facility_sen = excluded.sports_gym_facility_sen,
        sports_competition_sen = excluded.sports_competition_sen,
        medical_serious_fertility_sen = excluded.medical_serious_fertility_sen,
        medical_checkup_mental_sen = excluded.medical_checkup_mental_sen,
        medical_dental_sen = excluded.medical_dental_sen,
        medical_vaccination_sen = excluded.medical_vaccination_sen,
        updated_at = excluded.updated_at
      ''',
      [
        profile.assessmentYear,
        profile.annualBonusSen,
        profile.annualOtherIncomeSen,
        profile.annualPcbOverrideSen,
        profile.zakatFitrahSen,
        profile.voluntaryEpfSen,
        profile.lifeInsuranceSen,
        profile.medicalInsuranceSen,
        profile.prsAnnuitySen,
        profile.sspnNetSavingsSen,
        profile.higherEducationSen,
        profile.upskillingSen,
        profile.housingLoanTier.name,
        profile.housingLoanInterestSen,
        profile.lifestyleAiSen,
        profile.lifestyleInternetSen,
        profile.lifestyleBooksSen,
        profile.lifestyleDevicesSen,
        profile.lifestyleCoursesSen,
        profile.sportsEquipmentSen,
        profile.sportsGymFacilitySen,
        profile.sportsCompetitionSen,
        profile.medicalSeriousFertilitySen,
        profile.medicalCheckupMentalSen,
        profile.medicalDentalSen,
        profile.medicalVaccinationSen,
        nowMs,
      ],
    );
    _notifyListeners();
  }

  /// Fetches all itemized receipt claims for [year], newest first.
  Future<List<TaxReceiptClaimData>> getReceiptClaims(int year) async {
    await _db.ensureTaxTables();
    final rows = await _db.customSelect(
      'SELECT * FROM tax_receipt_claims WHERE assessment_year = ? ORDER BY claimed_date DESC, id DESC',
      variables: [Variable.withInt(year)],
    ).get();
    return rows.map(TaxReceiptClaimData.fromRow).toList();
  }

  /// Reactive stream of itemized receipt claims for [year].
  Stream<List<TaxReceiptClaimData>> watchReceiptClaims(int year) {
    return Stream<List<TaxReceiptClaimData>>.multi((controller) {
      var active = true;
      Future<void> emit() async {
        try {
          final data = await getReceiptClaims(year);
          if (active && !controller.isClosed) {
            controller.add(data);
          }
        } catch (e, st) {
          if (active && !controller.isClosed) {
            controller.addError(e, st);
          }
        }
      }

      emit();
      final sub = _changeController.stream.listen((_) => emit());
      controller.onCancel = () {
        active = false;
        return sub.cancel();
      };
    });
  }

  /// Adds a new tax receipt claim.
  Future<int> addReceiptClaim({
    required int assessmentYear,
    int? expenseId,
    required String title,
    required int amountSen,
    required LhdnReliefBucket bucket,
    String? subBucketId,
    String receiptRef = '',
    DateTime? claimedDate,
    bool isAutoClassified = true,
  }) async {
    await _db.ensureTaxTables();
    final dateMs = (claimedDate ?? DateTime.now()).millisecondsSinceEpoch;
    final id = await _db.customInsert(
      '''
      INSERT INTO tax_receipt_claims (
        assessment_year,
        expense_id,
        title,
        amount_sen,
        bucket_id,
        sub_bucket_id,
        receipt_ref,
        claimed_date,
        is_auto_classified
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
      ''',
      variables: [
        Variable.withInt(assessmentYear),
        expenseId != null
            ? Variable.withInt(expenseId)
            : const Variable<int>(null),
        Variable.withString(title),
        Variable.withInt(amountSen),
        Variable.withString(bucket.name),
        subBucketId != null
            ? Variable.withString(subBucketId)
            : const Variable<String>(null),
        Variable.withString(receiptRef),
        Variable.withInt(dateMs),
        Variable.withInt(isAutoClassified ? 1 : 0),
      ],
    );
    _notifyListeners();
    return id;
  }

  /// Deletes a receipt claim by [id].
  Future<void> deleteReceiptClaim(int id) async {
    await _db.ensureTaxTables();
    await _db.customStatement(
      'DELETE FROM tax_receipt_claims WHERE id = ?',
      [id],
    );
    _notifyListeners();
  }

  /// Clears all tax profiles and receipt claims (used in factory reset / restore).
  Future<void> clearAllTaxData() async {
    await _db.ensureTaxTables();
    await _db.customStatement('DELETE FROM tax_receipt_claims');
    await _db.customStatement('DELETE FROM tax_year_profiles');
    _notifyListeners();
  }

  /// Fetches all profiles across all years (for JSON backup).
  Future<List<TaxYearProfileData>> getAllProfiles() async {
    await _db.ensureTaxTables();
    final rows = await _db.customSelect('SELECT * FROM tax_year_profiles').get();
    return rows.map(TaxYearProfileData.fromRow).toList();
  }

  /// Fetches all receipt claims across all years (for JSON backup).
  Future<List<TaxReceiptClaimData>> getAllReceiptClaims() async {
    await _db.ensureTaxTables();
    final rows = await _db
        .customSelect('SELECT * FROM tax_receipt_claims ORDER BY id ASC')
        .get();
    return rows.map(TaxReceiptClaimData.fromRow).toList();
  }
}
