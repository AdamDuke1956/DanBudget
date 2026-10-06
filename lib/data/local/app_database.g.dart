// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UserProfileTableTable extends UserProfileTable
    with TableInfo<$UserProfileTableTable, UserProfileTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfileTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Fresh Grad'),
  );
  static const VerificationMeta _isOnboardedMeta = const VerificationMeta(
    'isOnboarded',
  );
  @override
  late final GeneratedColumn<bool> isOnboarded = GeneratedColumn<bool>(
    'is_onboarded',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_onboarded" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _employmentTypeMeta = const VerificationMeta(
    'employmentType',
  );
  @override
  late final GeneratedColumn<String> employmentType = GeneratedColumn<String>(
    'employment_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('intern'),
  );
  static const VerificationMeta _grossSalarySenMeta = const VerificationMeta(
    'grossSalarySen',
  );
  @override
  late final GeneratedColumn<int> grossSalarySen = GeneratedColumn<int>(
    'gross_salary_sen',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(300000),
  );
  static const VerificationMeta _fixedAllowanceSenMeta = const VerificationMeta(
    'fixedAllowanceSen',
  );
  @override
  late final GeneratedColumn<int> fixedAllowanceSen = GeneratedColumn<int>(
    'fixed_allowance_sen',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _epfRateMeta = const VerificationMeta(
    'epfRate',
  );
  @override
  late final GeneratedColumn<double> epfRate = GeneratedColumn<double>(
    'epf_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.11),
  );
  static const VerificationMeta _hasSocsoMeta = const VerificationMeta(
    'hasSocso',
  );
  @override
  late final GeneratedColumn<bool> hasSocso = GeneratedColumn<bool>(
    'has_socso',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_socso" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _hasEisMeta = const VerificationMeta('hasEis');
  @override
  late final GeneratedColumn<bool> hasEis = GeneratedColumn<bool>(
    'has_eis',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_eis" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isEpfVoluntaryExcessMeta =
      const VerificationMeta('isEpfVoluntaryExcess');
  @override
  late final GeneratedColumn<bool> isEpfVoluntaryExcess = GeneratedColumn<bool>(
    'is_epf_voluntary_excess',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_epf_voluntary_excess" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _paydayDayOfMonthMeta = const VerificationMeta(
    'paydayDayOfMonth',
  );
  @override
  late final GeneratedColumn<int> paydayDayOfMonth = GeneratedColumn<int>(
    'payday_day_of_month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(25),
  );
  static const VerificationMeta _emergencyFundMonthsTargetMeta =
      const VerificationMeta('emergencyFundMonthsTarget');
  @override
  late final GeneratedColumn<int> emergencyFundMonthsTarget =
      GeneratedColumn<int>(
        'emergency_fund_months_target',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(3),
      );
  static const VerificationMeta _currentSavingsSenMeta = const VerificationMeta(
    'currentSavingsSen',
  );
  @override
  late final GeneratedColumn<int> currentSavingsSen = GeneratedColumn<int>(
    'current_savings_sen',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _biometricLockEnabledMeta =
      const VerificationMeta('biometricLockEnabled');
  @override
  late final GeneratedColumn<bool> biometricLockEnabled = GeneratedColumn<bool>(
    'biometric_lock_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("biometric_lock_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _aiAdviceEnabledMeta = const VerificationMeta(
    'aiAdviceEnabled',
  );
  @override
  late final GeneratedColumn<bool> aiAdviceEnabled = GeneratedColumn<bool>(
    'ai_advice_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ai_advice_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _budgetPresetMeta = const VerificationMeta(
    'budgetPreset',
  );
  @override
  late final GeneratedColumn<String> budgetPreset = GeneratedColumn<String>(
    'budget_preset',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('recommended'),
  );
  static const VerificationMeta _customNeedsRatioMeta = const VerificationMeta(
    'customNeedsRatio',
  );
  @override
  late final GeneratedColumn<double> customNeedsRatio = GeneratedColumn<double>(
    'custom_needs_ratio',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customWantsRatioMeta = const VerificationMeta(
    'customWantsRatio',
  );
  @override
  late final GeneratedColumn<double> customWantsRatio = GeneratedColumn<double>(
    'custom_wants_ratio',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customSavingsRatioMeta =
      const VerificationMeta('customSavingsRatio');
  @override
  late final GeneratedColumn<double> customSavingsRatio =
      GeneratedColumn<double>(
        'custom_savings_ratio',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _customGivingRatioMeta = const VerificationMeta(
    'customGivingRatio',
  );
  @override
  late final GeneratedColumn<double> customGivingRatio =
      GeneratedColumn<double>(
        'custom_giving_ratio',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    isOnboarded,
    employmentType,
    grossSalarySen,
    fixedAllowanceSen,
    epfRate,
    hasSocso,
    hasEis,
    isEpfVoluntaryExcess,
    paydayDayOfMonth,
    emergencyFundMonthsTarget,
    currentSavingsSen,
    biometricLockEnabled,
    aiAdviceEnabled,
    budgetPreset,
    customNeedsRatio,
    customWantsRatio,
    customSavingsRatio,
    customGivingRatio,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profile';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfileTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('is_onboarded')) {
      context.handle(
        _isOnboardedMeta,
        isOnboarded.isAcceptableOrUnknown(
          data['is_onboarded']!,
          _isOnboardedMeta,
        ),
      );
    }
    if (data.containsKey('employment_type')) {
      context.handle(
        _employmentTypeMeta,
        employmentType.isAcceptableOrUnknown(
          data['employment_type']!,
          _employmentTypeMeta,
        ),
      );
    }
    if (data.containsKey('gross_salary_sen')) {
      context.handle(
        _grossSalarySenMeta,
        grossSalarySen.isAcceptableOrUnknown(
          data['gross_salary_sen']!,
          _grossSalarySenMeta,
        ),
      );
    }
    if (data.containsKey('fixed_allowance_sen')) {
      context.handle(
        _fixedAllowanceSenMeta,
        fixedAllowanceSen.isAcceptableOrUnknown(
          data['fixed_allowance_sen']!,
          _fixedAllowanceSenMeta,
        ),
      );
    }
    if (data.containsKey('epf_rate')) {
      context.handle(
        _epfRateMeta,
        epfRate.isAcceptableOrUnknown(data['epf_rate']!, _epfRateMeta),
      );
    }
    if (data.containsKey('has_socso')) {
      context.handle(
        _hasSocsoMeta,
        hasSocso.isAcceptableOrUnknown(data['has_socso']!, _hasSocsoMeta),
      );
    }
    if (data.containsKey('has_eis')) {
      context.handle(
        _hasEisMeta,
        hasEis.isAcceptableOrUnknown(data['has_eis']!, _hasEisMeta),
      );
    }
    if (data.containsKey('is_epf_voluntary_excess')) {
      context.handle(
        _isEpfVoluntaryExcessMeta,
        isEpfVoluntaryExcess.isAcceptableOrUnknown(
          data['is_epf_voluntary_excess']!,
          _isEpfVoluntaryExcessMeta,
        ),
      );
    }
    if (data.containsKey('payday_day_of_month')) {
      context.handle(
        _paydayDayOfMonthMeta,
        paydayDayOfMonth.isAcceptableOrUnknown(
          data['payday_day_of_month']!,
          _paydayDayOfMonthMeta,
        ),
      );
    }
    if (data.containsKey('emergency_fund_months_target')) {
      context.handle(
        _emergencyFundMonthsTargetMeta,
        emergencyFundMonthsTarget.isAcceptableOrUnknown(
          data['emergency_fund_months_target']!,
          _emergencyFundMonthsTargetMeta,
        ),
      );
    }
    if (data.containsKey('current_savings_sen')) {
      context.handle(
        _currentSavingsSenMeta,
        currentSavingsSen.isAcceptableOrUnknown(
          data['current_savings_sen']!,
          _currentSavingsSenMeta,
        ),
      );
    }
    if (data.containsKey('biometric_lock_enabled')) {
      context.handle(
        _biometricLockEnabledMeta,
        biometricLockEnabled.isAcceptableOrUnknown(
          data['biometric_lock_enabled']!,
          _biometricLockEnabledMeta,
        ),
      );
    }
    if (data.containsKey('ai_advice_enabled')) {
      context.handle(
        _aiAdviceEnabledMeta,
        aiAdviceEnabled.isAcceptableOrUnknown(
          data['ai_advice_enabled']!,
          _aiAdviceEnabledMeta,
        ),
      );
    }
    if (data.containsKey('budget_preset')) {
      context.handle(
        _budgetPresetMeta,
        budgetPreset.isAcceptableOrUnknown(
          data['budget_preset']!,
          _budgetPresetMeta,
        ),
      );
    }
    if (data.containsKey('custom_needs_ratio')) {
      context.handle(
        _customNeedsRatioMeta,
        customNeedsRatio.isAcceptableOrUnknown(
          data['custom_needs_ratio']!,
          _customNeedsRatioMeta,
        ),
      );
    }
    if (data.containsKey('custom_wants_ratio')) {
      context.handle(
        _customWantsRatioMeta,
        customWantsRatio.isAcceptableOrUnknown(
          data['custom_wants_ratio']!,
          _customWantsRatioMeta,
        ),
      );
    }
    if (data.containsKey('custom_savings_ratio')) {
      context.handle(
        _customSavingsRatioMeta,
        customSavingsRatio.isAcceptableOrUnknown(
          data['custom_savings_ratio']!,
          _customSavingsRatioMeta,
        ),
      );
    }
    if (data.containsKey('custom_giving_ratio')) {
      context.handle(
        _customGivingRatioMeta,
        customGivingRatio.isAcceptableOrUnknown(
          data['custom_giving_ratio']!,
          _customGivingRatioMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfileTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfileTableData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      isOnboarded:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_onboarded'],
          )!,
      employmentType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}employment_type'],
          )!,
      grossSalarySen:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}gross_salary_sen'],
          )!,
      fixedAllowanceSen:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}fixed_allowance_sen'],
          )!,
      epfRate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}epf_rate'],
          )!,
      hasSocso:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}has_socso'],
          )!,
      hasEis:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}has_eis'],
          )!,
      isEpfVoluntaryExcess:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_epf_voluntary_excess'],
          )!,
      paydayDayOfMonth:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}payday_day_of_month'],
          )!,
      emergencyFundMonthsTarget:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}emergency_fund_months_target'],
          )!,
      currentSavingsSen:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}current_savings_sen'],
          )!,
      biometricLockEnabled:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}biometric_lock_enabled'],
          )!,
      aiAdviceEnabled:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}ai_advice_enabled'],
          )!,
      budgetPreset:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}budget_preset'],
          )!,
      customNeedsRatio: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}custom_needs_ratio'],
      ),
      customWantsRatio: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}custom_wants_ratio'],
      ),
      customSavingsRatio: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}custom_savings_ratio'],
      ),
      customGivingRatio: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}custom_giving_ratio'],
      ),
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $UserProfileTableTable createAlias(String alias) {
    return $UserProfileTableTable(attachedDatabase, alias);
  }
}

class UserProfileTableData extends DataClass
    implements Insertable<UserProfileTableData> {
  final int id;
  final String name;

  /// False until the user finishes the first-run onboarding wizard.
  final bool isOnboarded;

  /// 'intern' or 'fullTime' (see EmploymentType.storageValue).
  /// For interns, [grossSalarySen] stores the monthly allowance.
  final String employmentType;
  final int grossSalarySen;
  final int fixedAllowanceSen;
  final double epfRate;
  final bool hasSocso;
  final bool hasEis;
  final bool isEpfVoluntaryExcess;
  final int paydayDayOfMonth;
  final int emergencyFundMonthsTarget;
  final int currentSavingsSen;
  final bool biometricLockEnabled;
  final bool aiAdviceEnabled;

  /// 'recommended', 'fire_saver', 'lean', or 'custom'
  final String budgetPreset;
  final double? customNeedsRatio;
  final double? customWantsRatio;
  final double? customSavingsRatio;
  final double? customGivingRatio;
  final DateTime updatedAt;
  const UserProfileTableData({
    required this.id,
    required this.name,
    required this.isOnboarded,
    required this.employmentType,
    required this.grossSalarySen,
    required this.fixedAllowanceSen,
    required this.epfRate,
    required this.hasSocso,
    required this.hasEis,
    required this.isEpfVoluntaryExcess,
    required this.paydayDayOfMonth,
    required this.emergencyFundMonthsTarget,
    required this.currentSavingsSen,
    required this.biometricLockEnabled,
    required this.aiAdviceEnabled,
    required this.budgetPreset,
    this.customNeedsRatio,
    this.customWantsRatio,
    this.customSavingsRatio,
    this.customGivingRatio,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['is_onboarded'] = Variable<bool>(isOnboarded);
    map['employment_type'] = Variable<String>(employmentType);
    map['gross_salary_sen'] = Variable<int>(grossSalarySen);
    map['fixed_allowance_sen'] = Variable<int>(fixedAllowanceSen);
    map['epf_rate'] = Variable<double>(epfRate);
    map['has_socso'] = Variable<bool>(hasSocso);
    map['has_eis'] = Variable<bool>(hasEis);
    map['is_epf_voluntary_excess'] = Variable<bool>(isEpfVoluntaryExcess);
    map['payday_day_of_month'] = Variable<int>(paydayDayOfMonth);
    map['emergency_fund_months_target'] = Variable<int>(
      emergencyFundMonthsTarget,
    );
    map['current_savings_sen'] = Variable<int>(currentSavingsSen);
    map['biometric_lock_enabled'] = Variable<bool>(biometricLockEnabled);
    map['ai_advice_enabled'] = Variable<bool>(aiAdviceEnabled);
    map['budget_preset'] = Variable<String>(budgetPreset);
    if (!nullToAbsent || customNeedsRatio != null) {
      map['custom_needs_ratio'] = Variable<double>(customNeedsRatio);
    }
    if (!nullToAbsent || customWantsRatio != null) {
      map['custom_wants_ratio'] = Variable<double>(customWantsRatio);
    }
    if (!nullToAbsent || customSavingsRatio != null) {
      map['custom_savings_ratio'] = Variable<double>(customSavingsRatio);
    }
    if (!nullToAbsent || customGivingRatio != null) {
      map['custom_giving_ratio'] = Variable<double>(customGivingRatio);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserProfileTableCompanion toCompanion(bool nullToAbsent) {
    return UserProfileTableCompanion(
      id: Value(id),
      name: Value(name),
      isOnboarded: Value(isOnboarded),
      employmentType: Value(employmentType),
      grossSalarySen: Value(grossSalarySen),
      fixedAllowanceSen: Value(fixedAllowanceSen),
      epfRate: Value(epfRate),
      hasSocso: Value(hasSocso),
      hasEis: Value(hasEis),
      isEpfVoluntaryExcess: Value(isEpfVoluntaryExcess),
      paydayDayOfMonth: Value(paydayDayOfMonth),
      emergencyFundMonthsTarget: Value(emergencyFundMonthsTarget),
      currentSavingsSen: Value(currentSavingsSen),
      biometricLockEnabled: Value(biometricLockEnabled),
      aiAdviceEnabled: Value(aiAdviceEnabled),
      budgetPreset: Value(budgetPreset),
      customNeedsRatio:
          customNeedsRatio == null && nullToAbsent
              ? const Value.absent()
              : Value(customNeedsRatio),
      customWantsRatio:
          customWantsRatio == null && nullToAbsent
              ? const Value.absent()
              : Value(customWantsRatio),
      customSavingsRatio:
          customSavingsRatio == null && nullToAbsent
              ? const Value.absent()
              : Value(customSavingsRatio),
      customGivingRatio:
          customGivingRatio == null && nullToAbsent
              ? const Value.absent()
              : Value(customGivingRatio),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserProfileTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfileTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isOnboarded: serializer.fromJson<bool>(json['isOnboarded']),
      employmentType: serializer.fromJson<String>(json['employmentType']),
      grossSalarySen: serializer.fromJson<int>(json['grossSalarySen']),
      fixedAllowanceSen: serializer.fromJson<int>(json['fixedAllowanceSen']),
      epfRate: serializer.fromJson<double>(json['epfRate']),
      hasSocso: serializer.fromJson<bool>(json['hasSocso']),
      hasEis: serializer.fromJson<bool>(json['hasEis']),
      isEpfVoluntaryExcess: serializer.fromJson<bool>(
        json['isEpfVoluntaryExcess'],
      ),
      paydayDayOfMonth: serializer.fromJson<int>(json['paydayDayOfMonth']),
      emergencyFundMonthsTarget: serializer.fromJson<int>(
        json['emergencyFundMonthsTarget'],
      ),
      currentSavingsSen: serializer.fromJson<int>(json['currentSavingsSen']),
      biometricLockEnabled: serializer.fromJson<bool>(
        json['biometricLockEnabled'],
      ),
      aiAdviceEnabled: serializer.fromJson<bool>(json['aiAdviceEnabled']),
      budgetPreset: serializer.fromJson<String>(json['budgetPreset']),
      customNeedsRatio: serializer.fromJson<double?>(json['customNeedsRatio']),
      customWantsRatio: serializer.fromJson<double?>(json['customWantsRatio']),
      customSavingsRatio: serializer.fromJson<double?>(
        json['customSavingsRatio'],
      ),
      customGivingRatio: serializer.fromJson<double?>(
        json['customGivingRatio'],
      ),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'isOnboarded': serializer.toJson<bool>(isOnboarded),
      'employmentType': serializer.toJson<String>(employmentType),
      'grossSalarySen': serializer.toJson<int>(grossSalarySen),
      'fixedAllowanceSen': serializer.toJson<int>(fixedAllowanceSen),
      'epfRate': serializer.toJson<double>(epfRate),
      'hasSocso': serializer.toJson<bool>(hasSocso),
      'hasEis': serializer.toJson<bool>(hasEis),
      'isEpfVoluntaryExcess': serializer.toJson<bool>(isEpfVoluntaryExcess),
      'paydayDayOfMonth': serializer.toJson<int>(paydayDayOfMonth),
      'emergencyFundMonthsTarget': serializer.toJson<int>(
        emergencyFundMonthsTarget,
      ),
      'currentSavingsSen': serializer.toJson<int>(currentSavingsSen),
      'biometricLockEnabled': serializer.toJson<bool>(biometricLockEnabled),
      'aiAdviceEnabled': serializer.toJson<bool>(aiAdviceEnabled),
      'budgetPreset': serializer.toJson<String>(budgetPreset),
      'customNeedsRatio': serializer.toJson<double?>(customNeedsRatio),
      'customWantsRatio': serializer.toJson<double?>(customWantsRatio),
      'customSavingsRatio': serializer.toJson<double?>(customSavingsRatio),
      'customGivingRatio': serializer.toJson<double?>(customGivingRatio),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserProfileTableData copyWith({
    int? id,
    String? name,
    bool? isOnboarded,
    String? employmentType,
    int? grossSalarySen,
    int? fixedAllowanceSen,
    double? epfRate,
    bool? hasSocso,
    bool? hasEis,
    bool? isEpfVoluntaryExcess,
    int? paydayDayOfMonth,
    int? emergencyFundMonthsTarget,
    int? currentSavingsSen,
    bool? biometricLockEnabled,
    bool? aiAdviceEnabled,
    String? budgetPreset,
    Value<double?> customNeedsRatio = const Value.absent(),
    Value<double?> customWantsRatio = const Value.absent(),
    Value<double?> customSavingsRatio = const Value.absent(),
    Value<double?> customGivingRatio = const Value.absent(),
    DateTime? updatedAt,
  }) => UserProfileTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    isOnboarded: isOnboarded ?? this.isOnboarded,
    employmentType: employmentType ?? this.employmentType,
    grossSalarySen: grossSalarySen ?? this.grossSalarySen,
    fixedAllowanceSen: fixedAllowanceSen ?? this.fixedAllowanceSen,
    epfRate: epfRate ?? this.epfRate,
    hasSocso: hasSocso ?? this.hasSocso,
    hasEis: hasEis ?? this.hasEis,
    isEpfVoluntaryExcess: isEpfVoluntaryExcess ?? this.isEpfVoluntaryExcess,
    paydayDayOfMonth: paydayDayOfMonth ?? this.paydayDayOfMonth,
    emergencyFundMonthsTarget:
        emergencyFundMonthsTarget ?? this.emergencyFundMonthsTarget,
    currentSavingsSen: currentSavingsSen ?? this.currentSavingsSen,
    biometricLockEnabled: biometricLockEnabled ?? this.biometricLockEnabled,
    aiAdviceEnabled: aiAdviceEnabled ?? this.aiAdviceEnabled,
    budgetPreset: budgetPreset ?? this.budgetPreset,
    customNeedsRatio:
        customNeedsRatio.present
            ? customNeedsRatio.value
            : this.customNeedsRatio,
    customWantsRatio:
        customWantsRatio.present
            ? customWantsRatio.value
            : this.customWantsRatio,
    customSavingsRatio:
        customSavingsRatio.present
            ? customSavingsRatio.value
            : this.customSavingsRatio,
    customGivingRatio:
        customGivingRatio.present
            ? customGivingRatio.value
            : this.customGivingRatio,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UserProfileTableData copyWithCompanion(UserProfileTableCompanion data) {
    return UserProfileTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      isOnboarded:
          data.isOnboarded.present ? data.isOnboarded.value : this.isOnboarded,
      employmentType:
          data.employmentType.present
              ? data.employmentType.value
              : this.employmentType,
      grossSalarySen:
          data.grossSalarySen.present
              ? data.grossSalarySen.value
              : this.grossSalarySen,
      fixedAllowanceSen:
          data.fixedAllowanceSen.present
              ? data.fixedAllowanceSen.value
              : this.fixedAllowanceSen,
      epfRate: data.epfRate.present ? data.epfRate.value : this.epfRate,
      hasSocso: data.hasSocso.present ? data.hasSocso.value : this.hasSocso,
      hasEis: data.hasEis.present ? data.hasEis.value : this.hasEis,
      isEpfVoluntaryExcess:
          data.isEpfVoluntaryExcess.present
              ? data.isEpfVoluntaryExcess.value
              : this.isEpfVoluntaryExcess,
      paydayDayOfMonth:
          data.paydayDayOfMonth.present
              ? data.paydayDayOfMonth.value
              : this.paydayDayOfMonth,
      emergencyFundMonthsTarget:
          data.emergencyFundMonthsTarget.present
              ? data.emergencyFundMonthsTarget.value
              : this.emergencyFundMonthsTarget,
      currentSavingsSen:
          data.currentSavingsSen.present
              ? data.currentSavingsSen.value
              : this.currentSavingsSen,
      biometricLockEnabled:
          data.biometricLockEnabled.present
              ? data.biometricLockEnabled.value
              : this.biometricLockEnabled,
      aiAdviceEnabled:
          data.aiAdviceEnabled.present
              ? data.aiAdviceEnabled.value
              : this.aiAdviceEnabled,
      budgetPreset:
          data.budgetPreset.present
              ? data.budgetPreset.value
              : this.budgetPreset,
      customNeedsRatio:
          data.customNeedsRatio.present
              ? data.customNeedsRatio.value
              : this.customNeedsRatio,
      customWantsRatio:
          data.customWantsRatio.present
              ? data.customWantsRatio.value
              : this.customWantsRatio,
      customSavingsRatio:
          data.customSavingsRatio.present
              ? data.customSavingsRatio.value
              : this.customSavingsRatio,
      customGivingRatio:
          data.customGivingRatio.present
              ? data.customGivingRatio.value
              : this.customGivingRatio,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfileTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isOnboarded: $isOnboarded, ')
          ..write('employmentType: $employmentType, ')
          ..write('grossSalarySen: $grossSalarySen, ')
          ..write('fixedAllowanceSen: $fixedAllowanceSen, ')
          ..write('epfRate: $epfRate, ')
          ..write('hasSocso: $hasSocso, ')
          ..write('hasEis: $hasEis, ')
          ..write('isEpfVoluntaryExcess: $isEpfVoluntaryExcess, ')
          ..write('paydayDayOfMonth: $paydayDayOfMonth, ')
          ..write('emergencyFundMonthsTarget: $emergencyFundMonthsTarget, ')
          ..write('currentSavingsSen: $currentSavingsSen, ')
          ..write('biometricLockEnabled: $biometricLockEnabled, ')
          ..write('aiAdviceEnabled: $aiAdviceEnabled, ')
          ..write('budgetPreset: $budgetPreset, ')
          ..write('customNeedsRatio: $customNeedsRatio, ')
          ..write('customWantsRatio: $customWantsRatio, ')
          ..write('customSavingsRatio: $customSavingsRatio, ')
          ..write('customGivingRatio: $customGivingRatio, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    name,
    isOnboarded,
    employmentType,
    grossSalarySen,
    fixedAllowanceSen,
    epfRate,
    hasSocso,
    hasEis,
    isEpfVoluntaryExcess,
    paydayDayOfMonth,
    emergencyFundMonthsTarget,
    currentSavingsSen,
    biometricLockEnabled,
    aiAdviceEnabled,
    budgetPreset,
    customNeedsRatio,
    customWantsRatio,
    customSavingsRatio,
    customGivingRatio,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfileTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.isOnboarded == this.isOnboarded &&
          other.employmentType == this.employmentType &&
          other.grossSalarySen == this.grossSalarySen &&
          other.fixedAllowanceSen == this.fixedAllowanceSen &&
          other.epfRate == this.epfRate &&
          other.hasSocso == this.hasSocso &&
          other.hasEis == this.hasEis &&
          other.isEpfVoluntaryExcess == this.isEpfVoluntaryExcess &&
          other.paydayDayOfMonth == this.paydayDayOfMonth &&
          other.emergencyFundMonthsTarget == this.emergencyFundMonthsTarget &&
          other.currentSavingsSen == this.currentSavingsSen &&
          other.biometricLockEnabled == this.biometricLockEnabled &&
          other.aiAdviceEnabled == this.aiAdviceEnabled &&
          other.budgetPreset == this.budgetPreset &&
          other.customNeedsRatio == this.customNeedsRatio &&
          other.customWantsRatio == this.customWantsRatio &&
          other.customSavingsRatio == this.customSavingsRatio &&
          other.customGivingRatio == this.customGivingRatio &&
          other.updatedAt == this.updatedAt);
}

class UserProfileTableCompanion extends UpdateCompanion<UserProfileTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> isOnboarded;
  final Value<String> employmentType;
  final Value<int> grossSalarySen;
  final Value<int> fixedAllowanceSen;
  final Value<double> epfRate;
  final Value<bool> hasSocso;
  final Value<bool> hasEis;
  final Value<bool> isEpfVoluntaryExcess;
  final Value<int> paydayDayOfMonth;
  final Value<int> emergencyFundMonthsTarget;
  final Value<int> currentSavingsSen;
  final Value<bool> biometricLockEnabled;
  final Value<bool> aiAdviceEnabled;
  final Value<String> budgetPreset;
  final Value<double?> customNeedsRatio;
  final Value<double?> customWantsRatio;
  final Value<double?> customSavingsRatio;
  final Value<double?> customGivingRatio;
  final Value<DateTime> updatedAt;
  const UserProfileTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isOnboarded = const Value.absent(),
    this.employmentType = const Value.absent(),
    this.grossSalarySen = const Value.absent(),
    this.fixedAllowanceSen = const Value.absent(),
    this.epfRate = const Value.absent(),
    this.hasSocso = const Value.absent(),
    this.hasEis = const Value.absent(),
    this.isEpfVoluntaryExcess = const Value.absent(),
    this.paydayDayOfMonth = const Value.absent(),
    this.emergencyFundMonthsTarget = const Value.absent(),
    this.currentSavingsSen = const Value.absent(),
    this.biometricLockEnabled = const Value.absent(),
    this.aiAdviceEnabled = const Value.absent(),
    this.budgetPreset = const Value.absent(),
    this.customNeedsRatio = const Value.absent(),
    this.customWantsRatio = const Value.absent(),
    this.customSavingsRatio = const Value.absent(),
    this.customGivingRatio = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UserProfileTableCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isOnboarded = const Value.absent(),
    this.employmentType = const Value.absent(),
    this.grossSalarySen = const Value.absent(),
    this.fixedAllowanceSen = const Value.absent(),
    this.epfRate = const Value.absent(),
    this.hasSocso = const Value.absent(),
    this.hasEis = const Value.absent(),
    this.isEpfVoluntaryExcess = const Value.absent(),
    this.paydayDayOfMonth = const Value.absent(),
    this.emergencyFundMonthsTarget = const Value.absent(),
    this.currentSavingsSen = const Value.absent(),
    this.biometricLockEnabled = const Value.absent(),
    this.aiAdviceEnabled = const Value.absent(),
    this.budgetPreset = const Value.absent(),
    this.customNeedsRatio = const Value.absent(),
    this.customWantsRatio = const Value.absent(),
    this.customSavingsRatio = const Value.absent(),
    this.customGivingRatio = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<UserProfileTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<bool>? isOnboarded,
    Expression<String>? employmentType,
    Expression<int>? grossSalarySen,
    Expression<int>? fixedAllowanceSen,
    Expression<double>? epfRate,
    Expression<bool>? hasSocso,
    Expression<bool>? hasEis,
    Expression<bool>? isEpfVoluntaryExcess,
    Expression<int>? paydayDayOfMonth,
    Expression<int>? emergencyFundMonthsTarget,
    Expression<int>? currentSavingsSen,
    Expression<bool>? biometricLockEnabled,
    Expression<bool>? aiAdviceEnabled,
    Expression<String>? budgetPreset,
    Expression<double>? customNeedsRatio,
    Expression<double>? customWantsRatio,
    Expression<double>? customSavingsRatio,
    Expression<double>? customGivingRatio,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isOnboarded != null) 'is_onboarded': isOnboarded,
      if (employmentType != null) 'employment_type': employmentType,
      if (grossSalarySen != null) 'gross_salary_sen': grossSalarySen,
      if (fixedAllowanceSen != null) 'fixed_allowance_sen': fixedAllowanceSen,
      if (epfRate != null) 'epf_rate': epfRate,
      if (hasSocso != null) 'has_socso': hasSocso,
      if (hasEis != null) 'has_eis': hasEis,
      if (isEpfVoluntaryExcess != null)
        'is_epf_voluntary_excess': isEpfVoluntaryExcess,
      if (paydayDayOfMonth != null) 'payday_day_of_month': paydayDayOfMonth,
      if (emergencyFundMonthsTarget != null)
        'emergency_fund_months_target': emergencyFundMonthsTarget,
      if (currentSavingsSen != null) 'current_savings_sen': currentSavingsSen,
      if (biometricLockEnabled != null)
        'biometric_lock_enabled': biometricLockEnabled,
      if (aiAdviceEnabled != null) 'ai_advice_enabled': aiAdviceEnabled,
      if (budgetPreset != null) 'budget_preset': budgetPreset,
      if (customNeedsRatio != null) 'custom_needs_ratio': customNeedsRatio,
      if (customWantsRatio != null) 'custom_wants_ratio': customWantsRatio,
      if (customSavingsRatio != null)
        'custom_savings_ratio': customSavingsRatio,
      if (customGivingRatio != null) 'custom_giving_ratio': customGivingRatio,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UserProfileTableCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<bool>? isOnboarded,
    Value<String>? employmentType,
    Value<int>? grossSalarySen,
    Value<int>? fixedAllowanceSen,
    Value<double>? epfRate,
    Value<bool>? hasSocso,
    Value<bool>? hasEis,
    Value<bool>? isEpfVoluntaryExcess,
    Value<int>? paydayDayOfMonth,
    Value<int>? emergencyFundMonthsTarget,
    Value<int>? currentSavingsSen,
    Value<bool>? biometricLockEnabled,
    Value<bool>? aiAdviceEnabled,
    Value<String>? budgetPreset,
    Value<double?>? customNeedsRatio,
    Value<double?>? customWantsRatio,
    Value<double?>? customSavingsRatio,
    Value<double?>? customGivingRatio,
    Value<DateTime>? updatedAt,
  }) {
    return UserProfileTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isOnboarded: isOnboarded ?? this.isOnboarded,
      employmentType: employmentType ?? this.employmentType,
      grossSalarySen: grossSalarySen ?? this.grossSalarySen,
      fixedAllowanceSen: fixedAllowanceSen ?? this.fixedAllowanceSen,
      epfRate: epfRate ?? this.epfRate,
      hasSocso: hasSocso ?? this.hasSocso,
      hasEis: hasEis ?? this.hasEis,
      isEpfVoluntaryExcess: isEpfVoluntaryExcess ?? this.isEpfVoluntaryExcess,
      paydayDayOfMonth: paydayDayOfMonth ?? this.paydayDayOfMonth,
      emergencyFundMonthsTarget:
          emergencyFundMonthsTarget ?? this.emergencyFundMonthsTarget,
      currentSavingsSen: currentSavingsSen ?? this.currentSavingsSen,
      biometricLockEnabled: biometricLockEnabled ?? this.biometricLockEnabled,
      aiAdviceEnabled: aiAdviceEnabled ?? this.aiAdviceEnabled,
      budgetPreset: budgetPreset ?? this.budgetPreset,
      customNeedsRatio: customNeedsRatio ?? this.customNeedsRatio,
      customWantsRatio: customWantsRatio ?? this.customWantsRatio,
      customSavingsRatio: customSavingsRatio ?? this.customSavingsRatio,
      customGivingRatio: customGivingRatio ?? this.customGivingRatio,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isOnboarded.present) {
      map['is_onboarded'] = Variable<bool>(isOnboarded.value);
    }
    if (employmentType.present) {
      map['employment_type'] = Variable<String>(employmentType.value);
    }
    if (grossSalarySen.present) {
      map['gross_salary_sen'] = Variable<int>(grossSalarySen.value);
    }
    if (fixedAllowanceSen.present) {
      map['fixed_allowance_sen'] = Variable<int>(fixedAllowanceSen.value);
    }
    if (epfRate.present) {
      map['epf_rate'] = Variable<double>(epfRate.value);
    }
    if (hasSocso.present) {
      map['has_socso'] = Variable<bool>(hasSocso.value);
    }
    if (hasEis.present) {
      map['has_eis'] = Variable<bool>(hasEis.value);
    }
    if (isEpfVoluntaryExcess.present) {
      map['is_epf_voluntary_excess'] = Variable<bool>(
        isEpfVoluntaryExcess.value,
      );
    }
    if (paydayDayOfMonth.present) {
      map['payday_day_of_month'] = Variable<int>(paydayDayOfMonth.value);
    }
    if (emergencyFundMonthsTarget.present) {
      map['emergency_fund_months_target'] = Variable<int>(
        emergencyFundMonthsTarget.value,
      );
    }
    if (currentSavingsSen.present) {
      map['current_savings_sen'] = Variable<int>(currentSavingsSen.value);
    }
    if (biometricLockEnabled.present) {
      map['biometric_lock_enabled'] = Variable<bool>(
        biometricLockEnabled.value,
      );
    }
    if (aiAdviceEnabled.present) {
      map['ai_advice_enabled'] = Variable<bool>(aiAdviceEnabled.value);
    }
    if (budgetPreset.present) {
      map['budget_preset'] = Variable<String>(budgetPreset.value);
    }
    if (customNeedsRatio.present) {
      map['custom_needs_ratio'] = Variable<double>(customNeedsRatio.value);
    }
    if (customWantsRatio.present) {
      map['custom_wants_ratio'] = Variable<double>(customWantsRatio.value);
    }
    if (customSavingsRatio.present) {
      map['custom_savings_ratio'] = Variable<double>(customSavingsRatio.value);
    }
    if (customGivingRatio.present) {
      map['custom_giving_ratio'] = Variable<double>(customGivingRatio.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfileTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isOnboarded: $isOnboarded, ')
          ..write('employmentType: $employmentType, ')
          ..write('grossSalarySen: $grossSalarySen, ')
          ..write('fixedAllowanceSen: $fixedAllowanceSen, ')
          ..write('epfRate: $epfRate, ')
          ..write('hasSocso: $hasSocso, ')
          ..write('hasEis: $hasEis, ')
          ..write('isEpfVoluntaryExcess: $isEpfVoluntaryExcess, ')
          ..write('paydayDayOfMonth: $paydayDayOfMonth, ')
          ..write('emergencyFundMonthsTarget: $emergencyFundMonthsTarget, ')
          ..write('currentSavingsSen: $currentSavingsSen, ')
          ..write('biometricLockEnabled: $biometricLockEnabled, ')
          ..write('aiAdviceEnabled: $aiAdviceEnabled, ')
          ..write('budgetPreset: $budgetPreset, ')
          ..write('customNeedsRatio: $customNeedsRatio, ')
          ..write('customWantsRatio: $customWantsRatio, ')
          ..write('customSavingsRatio: $customSavingsRatio, ')
          ..write('customGivingRatio: $customGivingRatio, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ExpenseCategoriesTableTable extends ExpenseCategoriesTable
    with TableInfo<$ExpenseCategoriesTableTable, ExpenseCategoriesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpenseCategoriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorHexMeta = const VerificationMeta(
    'colorHex',
  );
  @override
  late final GeneratedColumn<int> colorHex = GeneratedColumn<int>(
    'color_hex',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bucketMeta = const VerificationMeta('bucket');
  @override
  late final GeneratedColumn<String> bucket = GeneratedColumn<String>(
    'bucket',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCustomMeta = const VerificationMeta(
    'isCustom',
  );
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
    'is_custom',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_custom" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    icon,
    colorHex,
    bucket,
    isCustom,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expense_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExpenseCategoriesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('color_hex')) {
      context.handle(
        _colorHexMeta,
        colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta),
      );
    } else if (isInserting) {
      context.missing(_colorHexMeta);
    }
    if (data.containsKey('bucket')) {
      context.handle(
        _bucketMeta,
        bucket.isAcceptableOrUnknown(data['bucket']!, _bucketMeta),
      );
    } else if (isInserting) {
      context.missing(_bucketMeta);
    }
    if (data.containsKey('is_custom')) {
      context.handle(
        _isCustomMeta,
        isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpenseCategoriesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseCategoriesTableData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      icon:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}icon'],
          )!,
      colorHex:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}color_hex'],
          )!,
      bucket:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}bucket'],
          )!,
      isCustom:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_custom'],
          )!,
      sortOrder:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}sort_order'],
          )!,
    );
  }

  @override
  $ExpenseCategoriesTableTable createAlias(String alias) {
    return $ExpenseCategoriesTableTable(attachedDatabase, alias);
  }
}

class ExpenseCategoriesTableData extends DataClass
    implements Insertable<ExpenseCategoriesTableData> {
  final String id;
  final String name;
  final String icon;
  final int colorHex;
  final String bucket;
  final bool isCustom;
  final int sortOrder;
  const ExpenseCategoriesTableData({
    required this.id,
    required this.name,
    required this.icon,
    required this.colorHex,
    required this.bucket,
    required this.isCustom,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['icon'] = Variable<String>(icon);
    map['color_hex'] = Variable<int>(colorHex);
    map['bucket'] = Variable<String>(bucket);
    map['is_custom'] = Variable<bool>(isCustom);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  ExpenseCategoriesTableCompanion toCompanion(bool nullToAbsent) {
    return ExpenseCategoriesTableCompanion(
      id: Value(id),
      name: Value(name),
      icon: Value(icon),
      colorHex: Value(colorHex),
      bucket: Value(bucket),
      isCustom: Value(isCustom),
      sortOrder: Value(sortOrder),
    );
  }

  factory ExpenseCategoriesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseCategoriesTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String>(json['icon']),
      colorHex: serializer.fromJson<int>(json['colorHex']),
      bucket: serializer.fromJson<String>(json['bucket']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String>(icon),
      'colorHex': serializer.toJson<int>(colorHex),
      'bucket': serializer.toJson<String>(bucket),
      'isCustom': serializer.toJson<bool>(isCustom),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  ExpenseCategoriesTableData copyWith({
    String? id,
    String? name,
    String? icon,
    int? colorHex,
    String? bucket,
    bool? isCustom,
    int? sortOrder,
  }) => ExpenseCategoriesTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    icon: icon ?? this.icon,
    colorHex: colorHex ?? this.colorHex,
    bucket: bucket ?? this.bucket,
    isCustom: isCustom ?? this.isCustom,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  ExpenseCategoriesTableData copyWithCompanion(
    ExpenseCategoriesTableCompanion data,
  ) {
    return ExpenseCategoriesTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      bucket: data.bucket.present ? data.bucket.value : this.bucket,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseCategoriesTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('colorHex: $colorHex, ')
          ..write('bucket: $bucket, ')
          ..write('isCustom: $isCustom, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, icon, colorHex, bucket, isCustom, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseCategoriesTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.colorHex == this.colorHex &&
          other.bucket == this.bucket &&
          other.isCustom == this.isCustom &&
          other.sortOrder == this.sortOrder);
}

class ExpenseCategoriesTableCompanion
    extends UpdateCompanion<ExpenseCategoriesTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> icon;
  final Value<int> colorHex;
  final Value<String> bucket;
  final Value<bool> isCustom;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const ExpenseCategoriesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.bucket = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExpenseCategoriesTableCompanion.insert({
    required String id,
    required String name,
    required String icon,
    required int colorHex,
    required String bucket,
    this.isCustom = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       icon = Value(icon),
       colorHex = Value(colorHex),
       bucket = Value(bucket);
  static Insertable<ExpenseCategoriesTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<int>? colorHex,
    Expression<String>? bucket,
    Expression<bool>? isCustom,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (colorHex != null) 'color_hex': colorHex,
      if (bucket != null) 'bucket': bucket,
      if (isCustom != null) 'is_custom': isCustom,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExpenseCategoriesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? icon,
    Value<int>? colorHex,
    Value<String>? bucket,
    Value<bool>? isCustom,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return ExpenseCategoriesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      colorHex: colorHex ?? this.colorHex,
      bucket: bucket ?? this.bucket,
      isCustom: isCustom ?? this.isCustom,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<int>(colorHex.value);
    }
    if (bucket.present) {
      map['bucket'] = Variable<String>(bucket.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseCategoriesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('colorHex: $colorHex, ')
          ..write('bucket: $bucket, ')
          ..write('isCustom: $isCustom, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CommitmentsTableTable extends CommitmentsTable
    with TableInfo<$CommitmentsTableTable, CommitmentsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CommitmentsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalAmountSenMeta = const VerificationMeta(
    'totalAmountSen',
  );
  @override
  late final GeneratedColumn<int> totalAmountSen = GeneratedColumn<int>(
    'total_amount_sen',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthlyPaymentSenMeta = const VerificationMeta(
    'monthlyPaymentSen',
  );
  @override
  late final GeneratedColumn<int> monthlyPaymentSen = GeneratedColumn<int>(
    'monthly_payment_sen',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remainingAmountSenMeta =
      const VerificationMeta('remainingAmountSen');
  @override
  late final GeneratedColumn<int> remainingAmountSen = GeneratedColumn<int>(
    'remaining_amount_sen',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _interestRateAnnualMeta =
      const VerificationMeta('interestRateAnnual');
  @override
  late final GeneratedColumn<double> interestRateAnnual =
      GeneratedColumn<double>(
        'interest_rate_annual',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(0.0),
      );
  static const VerificationMeta _totalTenureMonthsMeta = const VerificationMeta(
    'totalTenureMonths',
  );
  @override
  late final GeneratedColumn<int> totalTenureMonths = GeneratedColumn<int>(
    'total_tenure_months',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(12),
  );
  static const VerificationMeta _remainingTenureMonthsMeta =
      const VerificationMeta('remainingTenureMonths');
  @override
  late final GeneratedColumn<int> remainingTenureMonths = GeneratedColumn<int>(
    'remaining_tenure_months',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(12),
  );
  static const VerificationMeta _dueDayOfMonthMeta = const VerificationMeta(
    'dueDayOfMonth',
  );
  @override
  late final GeneratedColumn<int> dueDayOfMonth = GeneratedColumn<int>(
    'due_day_of_month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    type,
    totalAmountSen,
    monthlyPaymentSen,
    remainingAmountSen,
    interestRateAnnual,
    totalTenureMonths,
    remainingTenureMonths,
    dueDayOfMonth,
    isActive,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'commitments';
  @override
  VerificationContext validateIntegrity(
    Insertable<CommitmentsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('total_amount_sen')) {
      context.handle(
        _totalAmountSenMeta,
        totalAmountSen.isAcceptableOrUnknown(
          data['total_amount_sen']!,
          _totalAmountSenMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalAmountSenMeta);
    }
    if (data.containsKey('monthly_payment_sen')) {
      context.handle(
        _monthlyPaymentSenMeta,
        monthlyPaymentSen.isAcceptableOrUnknown(
          data['monthly_payment_sen']!,
          _monthlyPaymentSenMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_monthlyPaymentSenMeta);
    }
    if (data.containsKey('remaining_amount_sen')) {
      context.handle(
        _remainingAmountSenMeta,
        remainingAmountSen.isAcceptableOrUnknown(
          data['remaining_amount_sen']!,
          _remainingAmountSenMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_remainingAmountSenMeta);
    }
    if (data.containsKey('interest_rate_annual')) {
      context.handle(
        _interestRateAnnualMeta,
        interestRateAnnual.isAcceptableOrUnknown(
          data['interest_rate_annual']!,
          _interestRateAnnualMeta,
        ),
      );
    }
    if (data.containsKey('total_tenure_months')) {
      context.handle(
        _totalTenureMonthsMeta,
        totalTenureMonths.isAcceptableOrUnknown(
          data['total_tenure_months']!,
          _totalTenureMonthsMeta,
        ),
      );
    }
    if (data.containsKey('remaining_tenure_months')) {
      context.handle(
        _remainingTenureMonthsMeta,
        remainingTenureMonths.isAcceptableOrUnknown(
          data['remaining_tenure_months']!,
          _remainingTenureMonthsMeta,
        ),
      );
    }
    if (data.containsKey('due_day_of_month')) {
      context.handle(
        _dueDayOfMonthMeta,
        dueDayOfMonth.isAcceptableOrUnknown(
          data['due_day_of_month']!,
          _dueDayOfMonthMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CommitmentsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CommitmentsTableData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      title:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}title'],
          )!,
      type:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}type'],
          )!,
      totalAmountSen:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}total_amount_sen'],
          )!,
      monthlyPaymentSen:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}monthly_payment_sen'],
          )!,
      remainingAmountSen:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}remaining_amount_sen'],
          )!,
      interestRateAnnual:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}interest_rate_annual'],
          )!,
      totalTenureMonths:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}total_tenure_months'],
          )!,
      remainingTenureMonths:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}remaining_tenure_months'],
          )!,
      dueDayOfMonth:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}due_day_of_month'],
          )!,
      isActive:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_active'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  $CommitmentsTableTable createAlias(String alias) {
    return $CommitmentsTableTable(attachedDatabase, alias);
  }
}

class CommitmentsTableData extends DataClass
    implements Insertable<CommitmentsTableData> {
  final int id;
  final String title;
  final String type;
  final int totalAmountSen;
  final int monthlyPaymentSen;
  final int remainingAmountSen;
  final double interestRateAnnual;
  final int totalTenureMonths;
  final int remainingTenureMonths;
  final int dueDayOfMonth;
  final bool isActive;
  final DateTime createdAt;
  const CommitmentsTableData({
    required this.id,
    required this.title,
    required this.type,
    required this.totalAmountSen,
    required this.monthlyPaymentSen,
    required this.remainingAmountSen,
    required this.interestRateAnnual,
    required this.totalTenureMonths,
    required this.remainingTenureMonths,
    required this.dueDayOfMonth,
    required this.isActive,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['type'] = Variable<String>(type);
    map['total_amount_sen'] = Variable<int>(totalAmountSen);
    map['monthly_payment_sen'] = Variable<int>(monthlyPaymentSen);
    map['remaining_amount_sen'] = Variable<int>(remainingAmountSen);
    map['interest_rate_annual'] = Variable<double>(interestRateAnnual);
    map['total_tenure_months'] = Variable<int>(totalTenureMonths);
    map['remaining_tenure_months'] = Variable<int>(remainingTenureMonths);
    map['due_day_of_month'] = Variable<int>(dueDayOfMonth);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CommitmentsTableCompanion toCompanion(bool nullToAbsent) {
    return CommitmentsTableCompanion(
      id: Value(id),
      title: Value(title),
      type: Value(type),
      totalAmountSen: Value(totalAmountSen),
      monthlyPaymentSen: Value(monthlyPaymentSen),
      remainingAmountSen: Value(remainingAmountSen),
      interestRateAnnual: Value(interestRateAnnual),
      totalTenureMonths: Value(totalTenureMonths),
      remainingTenureMonths: Value(remainingTenureMonths),
      dueDayOfMonth: Value(dueDayOfMonth),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory CommitmentsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CommitmentsTableData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      type: serializer.fromJson<String>(json['type']),
      totalAmountSen: serializer.fromJson<int>(json['totalAmountSen']),
      monthlyPaymentSen: serializer.fromJson<int>(json['monthlyPaymentSen']),
      remainingAmountSen: serializer.fromJson<int>(json['remainingAmountSen']),
      interestRateAnnual: serializer.fromJson<double>(
        json['interestRateAnnual'],
      ),
      totalTenureMonths: serializer.fromJson<int>(json['totalTenureMonths']),
      remainingTenureMonths: serializer.fromJson<int>(
        json['remainingTenureMonths'],
      ),
      dueDayOfMonth: serializer.fromJson<int>(json['dueDayOfMonth']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'type': serializer.toJson<String>(type),
      'totalAmountSen': serializer.toJson<int>(totalAmountSen),
      'monthlyPaymentSen': serializer.toJson<int>(monthlyPaymentSen),
      'remainingAmountSen': serializer.toJson<int>(remainingAmountSen),
      'interestRateAnnual': serializer.toJson<double>(interestRateAnnual),
      'totalTenureMonths': serializer.toJson<int>(totalTenureMonths),
      'remainingTenureMonths': serializer.toJson<int>(remainingTenureMonths),
      'dueDayOfMonth': serializer.toJson<int>(dueDayOfMonth),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CommitmentsTableData copyWith({
    int? id,
    String? title,
    String? type,
    int? totalAmountSen,
    int? monthlyPaymentSen,
    int? remainingAmountSen,
    double? interestRateAnnual,
    int? totalTenureMonths,
    int? remainingTenureMonths,
    int? dueDayOfMonth,
    bool? isActive,
    DateTime? createdAt,
  }) => CommitmentsTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    type: type ?? this.type,
    totalAmountSen: totalAmountSen ?? this.totalAmountSen,
    monthlyPaymentSen: monthlyPaymentSen ?? this.monthlyPaymentSen,
    remainingAmountSen: remainingAmountSen ?? this.remainingAmountSen,
    interestRateAnnual: interestRateAnnual ?? this.interestRateAnnual,
    totalTenureMonths: totalTenureMonths ?? this.totalTenureMonths,
    remainingTenureMonths: remainingTenureMonths ?? this.remainingTenureMonths,
    dueDayOfMonth: dueDayOfMonth ?? this.dueDayOfMonth,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
  );
  CommitmentsTableData copyWithCompanion(CommitmentsTableCompanion data) {
    return CommitmentsTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      type: data.type.present ? data.type.value : this.type,
      totalAmountSen:
          data.totalAmountSen.present
              ? data.totalAmountSen.value
              : this.totalAmountSen,
      monthlyPaymentSen:
          data.monthlyPaymentSen.present
              ? data.monthlyPaymentSen.value
              : this.monthlyPaymentSen,
      remainingAmountSen:
          data.remainingAmountSen.present
              ? data.remainingAmountSen.value
              : this.remainingAmountSen,
      interestRateAnnual:
          data.interestRateAnnual.present
              ? data.interestRateAnnual.value
              : this.interestRateAnnual,
      totalTenureMonths:
          data.totalTenureMonths.present
              ? data.totalTenureMonths.value
              : this.totalTenureMonths,
      remainingTenureMonths:
          data.remainingTenureMonths.present
              ? data.remainingTenureMonths.value
              : this.remainingTenureMonths,
      dueDayOfMonth:
          data.dueDayOfMonth.present
              ? data.dueDayOfMonth.value
              : this.dueDayOfMonth,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CommitmentsTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('type: $type, ')
          ..write('totalAmountSen: $totalAmountSen, ')
          ..write('monthlyPaymentSen: $monthlyPaymentSen, ')
          ..write('remainingAmountSen: $remainingAmountSen, ')
          ..write('interestRateAnnual: $interestRateAnnual, ')
          ..write('totalTenureMonths: $totalTenureMonths, ')
          ..write('remainingTenureMonths: $remainingTenureMonths, ')
          ..write('dueDayOfMonth: $dueDayOfMonth, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    type,
    totalAmountSen,
    monthlyPaymentSen,
    remainingAmountSen,
    interestRateAnnual,
    totalTenureMonths,
    remainingTenureMonths,
    dueDayOfMonth,
    isActive,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CommitmentsTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.type == this.type &&
          other.totalAmountSen == this.totalAmountSen &&
          other.monthlyPaymentSen == this.monthlyPaymentSen &&
          other.remainingAmountSen == this.remainingAmountSen &&
          other.interestRateAnnual == this.interestRateAnnual &&
          other.totalTenureMonths == this.totalTenureMonths &&
          other.remainingTenureMonths == this.remainingTenureMonths &&
          other.dueDayOfMonth == this.dueDayOfMonth &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class CommitmentsTableCompanion extends UpdateCompanion<CommitmentsTableData> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> type;
  final Value<int> totalAmountSen;
  final Value<int> monthlyPaymentSen;
  final Value<int> remainingAmountSen;
  final Value<double> interestRateAnnual;
  final Value<int> totalTenureMonths;
  final Value<int> remainingTenureMonths;
  final Value<int> dueDayOfMonth;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  const CommitmentsTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.type = const Value.absent(),
    this.totalAmountSen = const Value.absent(),
    this.monthlyPaymentSen = const Value.absent(),
    this.remainingAmountSen = const Value.absent(),
    this.interestRateAnnual = const Value.absent(),
    this.totalTenureMonths = const Value.absent(),
    this.remainingTenureMonths = const Value.absent(),
    this.dueDayOfMonth = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CommitmentsTableCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String type,
    required int totalAmountSen,
    required int monthlyPaymentSen,
    required int remainingAmountSen,
    this.interestRateAnnual = const Value.absent(),
    this.totalTenureMonths = const Value.absent(),
    this.remainingTenureMonths = const Value.absent(),
    this.dueDayOfMonth = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : title = Value(title),
       type = Value(type),
       totalAmountSen = Value(totalAmountSen),
       monthlyPaymentSen = Value(monthlyPaymentSen),
       remainingAmountSen = Value(remainingAmountSen);
  static Insertable<CommitmentsTableData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? type,
    Expression<int>? totalAmountSen,
    Expression<int>? monthlyPaymentSen,
    Expression<int>? remainingAmountSen,
    Expression<double>? interestRateAnnual,
    Expression<int>? totalTenureMonths,
    Expression<int>? remainingTenureMonths,
    Expression<int>? dueDayOfMonth,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (type != null) 'type': type,
      if (totalAmountSen != null) 'total_amount_sen': totalAmountSen,
      if (monthlyPaymentSen != null) 'monthly_payment_sen': monthlyPaymentSen,
      if (remainingAmountSen != null)
        'remaining_amount_sen': remainingAmountSen,
      if (interestRateAnnual != null)
        'interest_rate_annual': interestRateAnnual,
      if (totalTenureMonths != null) 'total_tenure_months': totalTenureMonths,
      if (remainingTenureMonths != null)
        'remaining_tenure_months': remainingTenureMonths,
      if (dueDayOfMonth != null) 'due_day_of_month': dueDayOfMonth,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CommitmentsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? type,
    Value<int>? totalAmountSen,
    Value<int>? monthlyPaymentSen,
    Value<int>? remainingAmountSen,
    Value<double>? interestRateAnnual,
    Value<int>? totalTenureMonths,
    Value<int>? remainingTenureMonths,
    Value<int>? dueDayOfMonth,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
  }) {
    return CommitmentsTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      totalAmountSen: totalAmountSen ?? this.totalAmountSen,
      monthlyPaymentSen: monthlyPaymentSen ?? this.monthlyPaymentSen,
      remainingAmountSen: remainingAmountSen ?? this.remainingAmountSen,
      interestRateAnnual: interestRateAnnual ?? this.interestRateAnnual,
      totalTenureMonths: totalTenureMonths ?? this.totalTenureMonths,
      remainingTenureMonths:
          remainingTenureMonths ?? this.remainingTenureMonths,
      dueDayOfMonth: dueDayOfMonth ?? this.dueDayOfMonth,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (totalAmountSen.present) {
      map['total_amount_sen'] = Variable<int>(totalAmountSen.value);
    }
    if (monthlyPaymentSen.present) {
      map['monthly_payment_sen'] = Variable<int>(monthlyPaymentSen.value);
    }
    if (remainingAmountSen.present) {
      map['remaining_amount_sen'] = Variable<int>(remainingAmountSen.value);
    }
    if (interestRateAnnual.present) {
      map['interest_rate_annual'] = Variable<double>(interestRateAnnual.value);
    }
    if (totalTenureMonths.present) {
      map['total_tenure_months'] = Variable<int>(totalTenureMonths.value);
    }
    if (remainingTenureMonths.present) {
      map['remaining_tenure_months'] = Variable<int>(
        remainingTenureMonths.value,
      );
    }
    if (dueDayOfMonth.present) {
      map['due_day_of_month'] = Variable<int>(dueDayOfMonth.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CommitmentsTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('type: $type, ')
          ..write('totalAmountSen: $totalAmountSen, ')
          ..write('monthlyPaymentSen: $monthlyPaymentSen, ')
          ..write('remainingAmountSen: $remainingAmountSen, ')
          ..write('interestRateAnnual: $interestRateAnnual, ')
          ..write('totalTenureMonths: $totalTenureMonths, ')
          ..write('remainingTenureMonths: $remainingTenureMonths, ')
          ..write('dueDayOfMonth: $dueDayOfMonth, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AccountsTableTable extends AccountsTable
    with TableInfo<$AccountsTableTable, AccountsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('bank'),
  );
  static const VerificationMeta _balanceSenMeta = const VerificationMeta(
    'balanceSen',
  );
  @override
  late final GeneratedColumn<int> balanceSen = GeneratedColumn<int>(
    'balance_sen',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('🏦'),
  );
  static const VerificationMeta _colorHexMeta = const VerificationMeta(
    'colorHex',
  );
  @override
  late final GeneratedColumn<int> colorHex = GeneratedColumn<int>(
    'color_hex',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0xFF00B074),
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isLiquidOnHandMeta = const VerificationMeta(
    'isLiquidOnHand',
  );
  @override
  late final GeneratedColumn<bool> isLiquidOnHand = GeneratedColumn<bool>(
    'is_liquid_on_hand',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_liquid_on_hand" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    balanceSen,
    icon,
    colorHex,
    isDefault,
    isLiquidOnHand,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<AccountsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('balance_sen')) {
      context.handle(
        _balanceSenMeta,
        balanceSen.isAcceptableOrUnknown(data['balance_sen']!, _balanceSenMeta),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('color_hex')) {
      context.handle(
        _colorHexMeta,
        colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta),
      );
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    if (data.containsKey('is_liquid_on_hand')) {
      context.handle(
        _isLiquidOnHandMeta,
        isLiquidOnHand.isAcceptableOrUnknown(
          data['is_liquid_on_hand']!,
          _isLiquidOnHandMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccountsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountsTableData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      type:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}type'],
          )!,
      balanceSen:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}balance_sen'],
          )!,
      icon:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}icon'],
          )!,
      colorHex:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}color_hex'],
          )!,
      isDefault:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_default'],
          )!,
      isLiquidOnHand:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_liquid_on_hand'],
          )!,
      updatedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}updated_at'],
          )!,
    );
  }

  @override
  $AccountsTableTable createAlias(String alias) {
    return $AccountsTableTable(attachedDatabase, alias);
  }
}

class AccountsTableData extends DataClass
    implements Insertable<AccountsTableData> {
  final int id;
  final String name;
  final String type;
  final int balanceSen;
  final String icon;
  final int colorHex;
  final bool isDefault;

  /// If true, included in "Total Money on Hand". If false (e.g. locked ASB/FD), excluded.
  final bool isLiquidOnHand;
  final DateTime updatedAt;
  const AccountsTableData({
    required this.id,
    required this.name,
    required this.type,
    required this.balanceSen,
    required this.icon,
    required this.colorHex,
    required this.isDefault,
    required this.isLiquidOnHand,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['balance_sen'] = Variable<int>(balanceSen);
    map['icon'] = Variable<String>(icon);
    map['color_hex'] = Variable<int>(colorHex);
    map['is_default'] = Variable<bool>(isDefault);
    map['is_liquid_on_hand'] = Variable<bool>(isLiquidOnHand);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AccountsTableCompanion toCompanion(bool nullToAbsent) {
    return AccountsTableCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      balanceSen: Value(balanceSen),
      icon: Value(icon),
      colorHex: Value(colorHex),
      isDefault: Value(isDefault),
      isLiquidOnHand: Value(isLiquidOnHand),
      updatedAt: Value(updatedAt),
    );
  }

  factory AccountsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountsTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      balanceSen: serializer.fromJson<int>(json['balanceSen']),
      icon: serializer.fromJson<String>(json['icon']),
      colorHex: serializer.fromJson<int>(json['colorHex']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      isLiquidOnHand: serializer.fromJson<bool>(json['isLiquidOnHand']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'balanceSen': serializer.toJson<int>(balanceSen),
      'icon': serializer.toJson<String>(icon),
      'colorHex': serializer.toJson<int>(colorHex),
      'isDefault': serializer.toJson<bool>(isDefault),
      'isLiquidOnHand': serializer.toJson<bool>(isLiquidOnHand),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AccountsTableData copyWith({
    int? id,
    String? name,
    String? type,
    int? balanceSen,
    String? icon,
    int? colorHex,
    bool? isDefault,
    bool? isLiquidOnHand,
    DateTime? updatedAt,
  }) => AccountsTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    balanceSen: balanceSen ?? this.balanceSen,
    icon: icon ?? this.icon,
    colorHex: colorHex ?? this.colorHex,
    isDefault: isDefault ?? this.isDefault,
    isLiquidOnHand: isLiquidOnHand ?? this.isLiquidOnHand,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AccountsTableData copyWithCompanion(AccountsTableCompanion data) {
    return AccountsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      balanceSen:
          data.balanceSen.present ? data.balanceSen.value : this.balanceSen,
      icon: data.icon.present ? data.icon.value : this.icon,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      isLiquidOnHand:
          data.isLiquidOnHand.present
              ? data.isLiquidOnHand.value
              : this.isLiquidOnHand,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('balanceSen: $balanceSen, ')
          ..write('icon: $icon, ')
          ..write('colorHex: $colorHex, ')
          ..write('isDefault: $isDefault, ')
          ..write('isLiquidOnHand: $isLiquidOnHand, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    type,
    balanceSen,
    icon,
    colorHex,
    isDefault,
    isLiquidOnHand,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.balanceSen == this.balanceSen &&
          other.icon == this.icon &&
          other.colorHex == this.colorHex &&
          other.isDefault == this.isDefault &&
          other.isLiquidOnHand == this.isLiquidOnHand &&
          other.updatedAt == this.updatedAt);
}

class AccountsTableCompanion extends UpdateCompanion<AccountsTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> type;
  final Value<int> balanceSen;
  final Value<String> icon;
  final Value<int> colorHex;
  final Value<bool> isDefault;
  final Value<bool> isLiquidOnHand;
  final Value<DateTime> updatedAt;
  const AccountsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.balanceSen = const Value.absent(),
    this.icon = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.isLiquidOnHand = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AccountsTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.type = const Value.absent(),
    this.balanceSen = const Value.absent(),
    this.icon = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.isLiquidOnHand = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<AccountsTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<int>? balanceSen,
    Expression<String>? icon,
    Expression<int>? colorHex,
    Expression<bool>? isDefault,
    Expression<bool>? isLiquidOnHand,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (balanceSen != null) 'balance_sen': balanceSen,
      if (icon != null) 'icon': icon,
      if (colorHex != null) 'color_hex': colorHex,
      if (isDefault != null) 'is_default': isDefault,
      if (isLiquidOnHand != null) 'is_liquid_on_hand': isLiquidOnHand,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AccountsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? type,
    Value<int>? balanceSen,
    Value<String>? icon,
    Value<int>? colorHex,
    Value<bool>? isDefault,
    Value<bool>? isLiquidOnHand,
    Value<DateTime>? updatedAt,
  }) {
    return AccountsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      balanceSen: balanceSen ?? this.balanceSen,
      icon: icon ?? this.icon,
      colorHex: colorHex ?? this.colorHex,
      isDefault: isDefault ?? this.isDefault,
      isLiquidOnHand: isLiquidOnHand ?? this.isLiquidOnHand,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (balanceSen.present) {
      map['balance_sen'] = Variable<int>(balanceSen.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<int>(colorHex.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (isLiquidOnHand.present) {
      map['is_liquid_on_hand'] = Variable<bool>(isLiquidOnHand.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('balanceSen: $balanceSen, ')
          ..write('icon: $icon, ')
          ..write('colorHex: $colorHex, ')
          ..write('isDefault: $isDefault, ')
          ..write('isLiquidOnHand: $isLiquidOnHand, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTableTable extends ExpensesTable
    with TableInfo<$ExpensesTableTable, ExpensesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _amountSenMeta = const VerificationMeta(
    'amountSen',
  );
  @override
  late final GeneratedColumn<int> amountSen = GeneratedColumn<int>(
    'amount_sen',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES expense_categories (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCommitmentPaymentMeta =
      const VerificationMeta('isCommitmentPayment');
  @override
  late final GeneratedColumn<bool> isCommitmentPayment = GeneratedColumn<bool>(
    'is_commitment_payment',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_commitment_payment" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _commitmentIdMeta = const VerificationMeta(
    'commitmentId',
  );
  @override
  late final GeneratedColumn<int> commitmentId = GeneratedColumn<int>(
    'commitment_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES commitments (id)',
    ),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id)',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    amountSen,
    categoryId,
    date,
    note,
    isCommitmentPayment,
    commitmentId,
    accountId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExpensesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amount_sen')) {
      context.handle(
        _amountSenMeta,
        amountSen.isAcceptableOrUnknown(data['amount_sen']!, _amountSenMeta),
      );
    } else if (isInserting) {
      context.missing(_amountSenMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('is_commitment_payment')) {
      context.handle(
        _isCommitmentPaymentMeta,
        isCommitmentPayment.isAcceptableOrUnknown(
          data['is_commitment_payment']!,
          _isCommitmentPaymentMeta,
        ),
      );
    }
    if (data.containsKey('commitment_id')) {
      context.handle(
        _commitmentIdMeta,
        commitmentId.isAcceptableOrUnknown(
          data['commitment_id']!,
          _commitmentIdMeta,
        ),
      );
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpensesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpensesTableData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      amountSen:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}amount_sen'],
          )!,
      categoryId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}category_id'],
          )!,
      date:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}date'],
          )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      isCommitmentPayment:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_commitment_payment'],
          )!,
      commitmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}commitment_id'],
      ),
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  $ExpensesTableTable createAlias(String alias) {
    return $ExpensesTableTable(attachedDatabase, alias);
  }
}

class ExpensesTableData extends DataClass
    implements Insertable<ExpensesTableData> {
  final int id;
  final int amountSen;
  final String categoryId;
  final DateTime date;
  final String? note;
  final bool isCommitmentPayment;
  final int? commitmentId;
  final int? accountId;
  final DateTime createdAt;
  const ExpensesTableData({
    required this.id,
    required this.amountSen,
    required this.categoryId,
    required this.date,
    this.note,
    required this.isCommitmentPayment,
    this.commitmentId,
    this.accountId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['amount_sen'] = Variable<int>(amountSen);
    map['category_id'] = Variable<String>(categoryId);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['is_commitment_payment'] = Variable<bool>(isCommitmentPayment);
    if (!nullToAbsent || commitmentId != null) {
      map['commitment_id'] = Variable<int>(commitmentId);
    }
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<int>(accountId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ExpensesTableCompanion toCompanion(bool nullToAbsent) {
    return ExpensesTableCompanion(
      id: Value(id),
      amountSen: Value(amountSen),
      categoryId: Value(categoryId),
      date: Value(date),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      isCommitmentPayment: Value(isCommitmentPayment),
      commitmentId:
          commitmentId == null && nullToAbsent
              ? const Value.absent()
              : Value(commitmentId),
      accountId:
          accountId == null && nullToAbsent
              ? const Value.absent()
              : Value(accountId),
      createdAt: Value(createdAt),
    );
  }

  factory ExpensesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpensesTableData(
      id: serializer.fromJson<int>(json['id']),
      amountSen: serializer.fromJson<int>(json['amountSen']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      date: serializer.fromJson<DateTime>(json['date']),
      note: serializer.fromJson<String?>(json['note']),
      isCommitmentPayment: serializer.fromJson<bool>(
        json['isCommitmentPayment'],
      ),
      commitmentId: serializer.fromJson<int?>(json['commitmentId']),
      accountId: serializer.fromJson<int?>(json['accountId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'amountSen': serializer.toJson<int>(amountSen),
      'categoryId': serializer.toJson<String>(categoryId),
      'date': serializer.toJson<DateTime>(date),
      'note': serializer.toJson<String?>(note),
      'isCommitmentPayment': serializer.toJson<bool>(isCommitmentPayment),
      'commitmentId': serializer.toJson<int?>(commitmentId),
      'accountId': serializer.toJson<int?>(accountId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ExpensesTableData copyWith({
    int? id,
    int? amountSen,
    String? categoryId,
    DateTime? date,
    Value<String?> note = const Value.absent(),
    bool? isCommitmentPayment,
    Value<int?> commitmentId = const Value.absent(),
    Value<int?> accountId = const Value.absent(),
    DateTime? createdAt,
  }) => ExpensesTableData(
    id: id ?? this.id,
    amountSen: amountSen ?? this.amountSen,
    categoryId: categoryId ?? this.categoryId,
    date: date ?? this.date,
    note: note.present ? note.value : this.note,
    isCommitmentPayment: isCommitmentPayment ?? this.isCommitmentPayment,
    commitmentId: commitmentId.present ? commitmentId.value : this.commitmentId,
    accountId: accountId.present ? accountId.value : this.accountId,
    createdAt: createdAt ?? this.createdAt,
  );
  ExpensesTableData copyWithCompanion(ExpensesTableCompanion data) {
    return ExpensesTableData(
      id: data.id.present ? data.id.value : this.id,
      amountSen: data.amountSen.present ? data.amountSen.value : this.amountSen,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      date: data.date.present ? data.date.value : this.date,
      note: data.note.present ? data.note.value : this.note,
      isCommitmentPayment:
          data.isCommitmentPayment.present
              ? data.isCommitmentPayment.value
              : this.isCommitmentPayment,
      commitmentId:
          data.commitmentId.present
              ? data.commitmentId.value
              : this.commitmentId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesTableData(')
          ..write('id: $id, ')
          ..write('amountSen: $amountSen, ')
          ..write('categoryId: $categoryId, ')
          ..write('date: $date, ')
          ..write('note: $note, ')
          ..write('isCommitmentPayment: $isCommitmentPayment, ')
          ..write('commitmentId: $commitmentId, ')
          ..write('accountId: $accountId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    amountSen,
    categoryId,
    date,
    note,
    isCommitmentPayment,
    commitmentId,
    accountId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpensesTableData &&
          other.id == this.id &&
          other.amountSen == this.amountSen &&
          other.categoryId == this.categoryId &&
          other.date == this.date &&
          other.note == this.note &&
          other.isCommitmentPayment == this.isCommitmentPayment &&
          other.commitmentId == this.commitmentId &&
          other.accountId == this.accountId &&
          other.createdAt == this.createdAt);
}

class ExpensesTableCompanion extends UpdateCompanion<ExpensesTableData> {
  final Value<int> id;
  final Value<int> amountSen;
  final Value<String> categoryId;
  final Value<DateTime> date;
  final Value<String?> note;
  final Value<bool> isCommitmentPayment;
  final Value<int?> commitmentId;
  final Value<int?> accountId;
  final Value<DateTime> createdAt;
  const ExpensesTableCompanion({
    this.id = const Value.absent(),
    this.amountSen = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.date = const Value.absent(),
    this.note = const Value.absent(),
    this.isCommitmentPayment = const Value.absent(),
    this.commitmentId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ExpensesTableCompanion.insert({
    this.id = const Value.absent(),
    required int amountSen,
    required String categoryId,
    required DateTime date,
    this.note = const Value.absent(),
    this.isCommitmentPayment = const Value.absent(),
    this.commitmentId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : amountSen = Value(amountSen),
       categoryId = Value(categoryId),
       date = Value(date);
  static Insertable<ExpensesTableData> custom({
    Expression<int>? id,
    Expression<int>? amountSen,
    Expression<String>? categoryId,
    Expression<DateTime>? date,
    Expression<String>? note,
    Expression<bool>? isCommitmentPayment,
    Expression<int>? commitmentId,
    Expression<int>? accountId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amountSen != null) 'amount_sen': amountSen,
      if (categoryId != null) 'category_id': categoryId,
      if (date != null) 'date': date,
      if (note != null) 'note': note,
      if (isCommitmentPayment != null)
        'is_commitment_payment': isCommitmentPayment,
      if (commitmentId != null) 'commitment_id': commitmentId,
      if (accountId != null) 'account_id': accountId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ExpensesTableCompanion copyWith({
    Value<int>? id,
    Value<int>? amountSen,
    Value<String>? categoryId,
    Value<DateTime>? date,
    Value<String?>? note,
    Value<bool>? isCommitmentPayment,
    Value<int?>? commitmentId,
    Value<int?>? accountId,
    Value<DateTime>? createdAt,
  }) {
    return ExpensesTableCompanion(
      id: id ?? this.id,
      amountSen: amountSen ?? this.amountSen,
      categoryId: categoryId ?? this.categoryId,
      date: date ?? this.date,
      note: note ?? this.note,
      isCommitmentPayment: isCommitmentPayment ?? this.isCommitmentPayment,
      commitmentId: commitmentId ?? this.commitmentId,
      accountId: accountId ?? this.accountId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (amountSen.present) {
      map['amount_sen'] = Variable<int>(amountSen.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (isCommitmentPayment.present) {
      map['is_commitment_payment'] = Variable<bool>(isCommitmentPayment.value);
    }
    if (commitmentId.present) {
      map['commitment_id'] = Variable<int>(commitmentId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesTableCompanion(')
          ..write('id: $id, ')
          ..write('amountSen: $amountSen, ')
          ..write('categoryId: $categoryId, ')
          ..write('date: $date, ')
          ..write('note: $note, ')
          ..write('isCommitmentPayment: $isCommitmentPayment, ')
          ..write('commitmentId: $commitmentId, ')
          ..write('accountId: $accountId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ChecklistItemsTableTable extends ChecklistItemsTable
    with TableInfo<$ChecklistItemsTableTable, ChecklistItemsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChecklistItemsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    category,
    isCompleted,
    completedAt,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'checklist_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChecklistItemsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChecklistItemsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChecklistItemsTableData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      title:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}title'],
          )!,
      description:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}description'],
          )!,
      category:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}category'],
          )!,
      isCompleted:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_completed'],
          )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      sortOrder:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}sort_order'],
          )!,
    );
  }

  @override
  $ChecklistItemsTableTable createAlias(String alias) {
    return $ChecklistItemsTableTable(attachedDatabase, alias);
  }
}

class ChecklistItemsTableData extends DataClass
    implements Insertable<ChecklistItemsTableData> {
  final String id;
  final String title;
  final String description;
  final String category;
  final bool isCompleted;
  final DateTime? completedAt;
  final int sortOrder;
  const ChecklistItemsTableData({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.isCompleted,
    this.completedAt,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['category'] = Variable<String>(category);
    map['is_completed'] = Variable<bool>(isCompleted);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  ChecklistItemsTableCompanion toCompanion(bool nullToAbsent) {
    return ChecklistItemsTableCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      category: Value(category),
      isCompleted: Value(isCompleted),
      completedAt:
          completedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(completedAt),
      sortOrder: Value(sortOrder),
    );
  }

  factory ChecklistItemsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChecklistItemsTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      category: serializer.fromJson<String>(json['category']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'category': serializer.toJson<String>(category),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  ChecklistItemsTableData copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    bool? isCompleted,
    Value<DateTime?> completedAt = const Value.absent(),
    int? sortOrder,
  }) => ChecklistItemsTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    category: category ?? this.category,
    isCompleted: isCompleted ?? this.isCompleted,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  ChecklistItemsTableData copyWithCompanion(ChecklistItemsTableCompanion data) {
    return ChecklistItemsTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      category: data.category.present ? data.category.value : this.category,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistItemsTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('completedAt: $completedAt, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    category,
    isCompleted,
    completedAt,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChecklistItemsTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.category == this.category &&
          other.isCompleted == this.isCompleted &&
          other.completedAt == this.completedAt &&
          other.sortOrder == this.sortOrder);
}

class ChecklistItemsTableCompanion
    extends UpdateCompanion<ChecklistItemsTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> description;
  final Value<String> category;
  final Value<bool> isCompleted;
  final Value<DateTime?> completedAt;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const ChecklistItemsTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChecklistItemsTableCompanion.insert({
    required String id,
    required String title,
    required String description,
    required String category,
    this.isCompleted = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       description = Value(description),
       category = Value(category);
  static Insertable<ChecklistItemsTableData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? category,
    Expression<bool>? isCompleted,
    Expression<DateTime>? completedAt,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (completedAt != null) 'completed_at': completedAt,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChecklistItemsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? description,
    Value<String>? category,
    Value<bool>? isCompleted,
    Value<DateTime?>? completedAt,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return ChecklistItemsTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistItemsTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('completedAt: $completedAt, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AccountTransfersTableTable extends AccountTransfersTable
    with TableInfo<$AccountTransfersTableTable, AccountTransfersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountTransfersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _fromAccountIdMeta = const VerificationMeta(
    'fromAccountId',
  );
  @override
  late final GeneratedColumn<int> fromAccountId = GeneratedColumn<int>(
    'from_account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id)',
    ),
  );
  static const VerificationMeta _toAccountIdMeta = const VerificationMeta(
    'toAccountId',
  );
  @override
  late final GeneratedColumn<int> toAccountId = GeneratedColumn<int>(
    'to_account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id)',
    ),
  );
  static const VerificationMeta _amountSenMeta = const VerificationMeta(
    'amountSen',
  );
  @override
  late final GeneratedColumn<int> amountSen = GeneratedColumn<int>(
    'amount_sen',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fromAccountId,
    toAccountId,
    amountSen,
    date,
    note,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'account_transfers';
  @override
  VerificationContext validateIntegrity(
    Insertable<AccountTransfersTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('from_account_id')) {
      context.handle(
        _fromAccountIdMeta,
        fromAccountId.isAcceptableOrUnknown(
          data['from_account_id']!,
          _fromAccountIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fromAccountIdMeta);
    }
    if (data.containsKey('to_account_id')) {
      context.handle(
        _toAccountIdMeta,
        toAccountId.isAcceptableOrUnknown(
          data['to_account_id']!,
          _toAccountIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_toAccountIdMeta);
    }
    if (data.containsKey('amount_sen')) {
      context.handle(
        _amountSenMeta,
        amountSen.isAcceptableOrUnknown(data['amount_sen']!, _amountSenMeta),
      );
    } else if (isInserting) {
      context.missing(_amountSenMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccountTransfersTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountTransfersTableData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      fromAccountId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}from_account_id'],
          )!,
      toAccountId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}to_account_id'],
          )!,
      amountSen:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}amount_sen'],
          )!,
      date:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}date'],
          )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  $AccountTransfersTableTable createAlias(String alias) {
    return $AccountTransfersTableTable(attachedDatabase, alias);
  }
}

class AccountTransfersTableData extends DataClass
    implements Insertable<AccountTransfersTableData> {
  final int id;
  final int fromAccountId;
  final int toAccountId;
  final int amountSen;
  final DateTime date;
  final String? note;
  final DateTime createdAt;
  const AccountTransfersTableData({
    required this.id,
    required this.fromAccountId,
    required this.toAccountId,
    required this.amountSen,
    required this.date,
    this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['from_account_id'] = Variable<int>(fromAccountId);
    map['to_account_id'] = Variable<int>(toAccountId);
    map['amount_sen'] = Variable<int>(amountSen);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AccountTransfersTableCompanion toCompanion(bool nullToAbsent) {
    return AccountTransfersTableCompanion(
      id: Value(id),
      fromAccountId: Value(fromAccountId),
      toAccountId: Value(toAccountId),
      amountSen: Value(amountSen),
      date: Value(date),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory AccountTransfersTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountTransfersTableData(
      id: serializer.fromJson<int>(json['id']),
      fromAccountId: serializer.fromJson<int>(json['fromAccountId']),
      toAccountId: serializer.fromJson<int>(json['toAccountId']),
      amountSen: serializer.fromJson<int>(json['amountSen']),
      date: serializer.fromJson<DateTime>(json['date']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fromAccountId': serializer.toJson<int>(fromAccountId),
      'toAccountId': serializer.toJson<int>(toAccountId),
      'amountSen': serializer.toJson<int>(amountSen),
      'date': serializer.toJson<DateTime>(date),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AccountTransfersTableData copyWith({
    int? id,
    int? fromAccountId,
    int? toAccountId,
    int? amountSen,
    DateTime? date,
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
  }) => AccountTransfersTableData(
    id: id ?? this.id,
    fromAccountId: fromAccountId ?? this.fromAccountId,
    toAccountId: toAccountId ?? this.toAccountId,
    amountSen: amountSen ?? this.amountSen,
    date: date ?? this.date,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  AccountTransfersTableData copyWithCompanion(
    AccountTransfersTableCompanion data,
  ) {
    return AccountTransfersTableData(
      id: data.id.present ? data.id.value : this.id,
      fromAccountId:
          data.fromAccountId.present
              ? data.fromAccountId.value
              : this.fromAccountId,
      toAccountId:
          data.toAccountId.present ? data.toAccountId.value : this.toAccountId,
      amountSen: data.amountSen.present ? data.amountSen.value : this.amountSen,
      date: data.date.present ? data.date.value : this.date,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountTransfersTableData(')
          ..write('id: $id, ')
          ..write('fromAccountId: $fromAccountId, ')
          ..write('toAccountId: $toAccountId, ')
          ..write('amountSen: $amountSen, ')
          ..write('date: $date, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    fromAccountId,
    toAccountId,
    amountSen,
    date,
    note,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountTransfersTableData &&
          other.id == this.id &&
          other.fromAccountId == this.fromAccountId &&
          other.toAccountId == this.toAccountId &&
          other.amountSen == this.amountSen &&
          other.date == this.date &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class AccountTransfersTableCompanion
    extends UpdateCompanion<AccountTransfersTableData> {
  final Value<int> id;
  final Value<int> fromAccountId;
  final Value<int> toAccountId;
  final Value<int> amountSen;
  final Value<DateTime> date;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  const AccountTransfersTableCompanion({
    this.id = const Value.absent(),
    this.fromAccountId = const Value.absent(),
    this.toAccountId = const Value.absent(),
    this.amountSen = const Value.absent(),
    this.date = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AccountTransfersTableCompanion.insert({
    this.id = const Value.absent(),
    required int fromAccountId,
    required int toAccountId,
    required int amountSen,
    this.date = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : fromAccountId = Value(fromAccountId),
       toAccountId = Value(toAccountId),
       amountSen = Value(amountSen);
  static Insertable<AccountTransfersTableData> custom({
    Expression<int>? id,
    Expression<int>? fromAccountId,
    Expression<int>? toAccountId,
    Expression<int>? amountSen,
    Expression<DateTime>? date,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fromAccountId != null) 'from_account_id': fromAccountId,
      if (toAccountId != null) 'to_account_id': toAccountId,
      if (amountSen != null) 'amount_sen': amountSen,
      if (date != null) 'date': date,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AccountTransfersTableCompanion copyWith({
    Value<int>? id,
    Value<int>? fromAccountId,
    Value<int>? toAccountId,
    Value<int>? amountSen,
    Value<DateTime>? date,
    Value<String?>? note,
    Value<DateTime>? createdAt,
  }) {
    return AccountTransfersTableCompanion(
      id: id ?? this.id,
      fromAccountId: fromAccountId ?? this.fromAccountId,
      toAccountId: toAccountId ?? this.toAccountId,
      amountSen: amountSen ?? this.amountSen,
      date: date ?? this.date,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fromAccountId.present) {
      map['from_account_id'] = Variable<int>(fromAccountId.value);
    }
    if (toAccountId.present) {
      map['to_account_id'] = Variable<int>(toAccountId.value);
    }
    if (amountSen.present) {
      map['amount_sen'] = Variable<int>(amountSen.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountTransfersTableCompanion(')
          ..write('id: $id, ')
          ..write('fromAccountId: $fromAccountId, ')
          ..write('toAccountId: $toAccountId, ')
          ..write('amountSen: $amountSen, ')
          ..write('date: $date, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserProfileTableTable userProfileTable = $UserProfileTableTable(
    this,
  );
  late final $ExpenseCategoriesTableTable expenseCategoriesTable =
      $ExpenseCategoriesTableTable(this);
  late final $CommitmentsTableTable commitmentsTable = $CommitmentsTableTable(
    this,
  );
  late final $AccountsTableTable accountsTable = $AccountsTableTable(this);
  late final $ExpensesTableTable expensesTable = $ExpensesTableTable(this);
  late final $ChecklistItemsTableTable checklistItemsTable =
      $ChecklistItemsTableTable(this);
  late final $AccountTransfersTableTable accountTransfersTable =
      $AccountTransfersTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    userProfileTable,
    expenseCategoriesTable,
    commitmentsTable,
    accountsTable,
    expensesTable,
    checklistItemsTable,
    accountTransfersTable,
  ];
}

typedef $$UserProfileTableTableCreateCompanionBuilder =
    UserProfileTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<bool> isOnboarded,
      Value<String> employmentType,
      Value<int> grossSalarySen,
      Value<int> fixedAllowanceSen,
      Value<double> epfRate,
      Value<bool> hasSocso,
      Value<bool> hasEis,
      Value<bool> isEpfVoluntaryExcess,
      Value<int> paydayDayOfMonth,
      Value<int> emergencyFundMonthsTarget,
      Value<int> currentSavingsSen,
      Value<bool> biometricLockEnabled,
      Value<bool> aiAdviceEnabled,
      Value<String> budgetPreset,
      Value<double?> customNeedsRatio,
      Value<double?> customWantsRatio,
      Value<double?> customSavingsRatio,
      Value<double?> customGivingRatio,
      Value<DateTime> updatedAt,
    });
typedef $$UserProfileTableTableUpdateCompanionBuilder =
    UserProfileTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<bool> isOnboarded,
      Value<String> employmentType,
      Value<int> grossSalarySen,
      Value<int> fixedAllowanceSen,
      Value<double> epfRate,
      Value<bool> hasSocso,
      Value<bool> hasEis,
      Value<bool> isEpfVoluntaryExcess,
      Value<int> paydayDayOfMonth,
      Value<int> emergencyFundMonthsTarget,
      Value<int> currentSavingsSen,
      Value<bool> biometricLockEnabled,
      Value<bool> aiAdviceEnabled,
      Value<String> budgetPreset,
      Value<double?> customNeedsRatio,
      Value<double?> customWantsRatio,
      Value<double?> customSavingsRatio,
      Value<double?> customGivingRatio,
      Value<DateTime> updatedAt,
    });

class $$UserProfileTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfileTableTable> {
  $$UserProfileTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOnboarded => $composableBuilder(
    column: $table.isOnboarded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get employmentType => $composableBuilder(
    column: $table.employmentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get grossSalarySen => $composableBuilder(
    column: $table.grossSalarySen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fixedAllowanceSen => $composableBuilder(
    column: $table.fixedAllowanceSen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get epfRate => $composableBuilder(
    column: $table.epfRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasSocso => $composableBuilder(
    column: $table.hasSocso,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasEis => $composableBuilder(
    column: $table.hasEis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEpfVoluntaryExcess => $composableBuilder(
    column: $table.isEpfVoluntaryExcess,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get paydayDayOfMonth => $composableBuilder(
    column: $table.paydayDayOfMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get emergencyFundMonthsTarget => $composableBuilder(
    column: $table.emergencyFundMonthsTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentSavingsSen => $composableBuilder(
    column: $table.currentSavingsSen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get biometricLockEnabled => $composableBuilder(
    column: $table.biometricLockEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get aiAdviceEnabled => $composableBuilder(
    column: $table.aiAdviceEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get budgetPreset => $composableBuilder(
    column: $table.budgetPreset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get customNeedsRatio => $composableBuilder(
    column: $table.customNeedsRatio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get customWantsRatio => $composableBuilder(
    column: $table.customWantsRatio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get customSavingsRatio => $composableBuilder(
    column: $table.customSavingsRatio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get customGivingRatio => $composableBuilder(
    column: $table.customGivingRatio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProfileTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfileTableTable> {
  $$UserProfileTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOnboarded => $composableBuilder(
    column: $table.isOnboarded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get employmentType => $composableBuilder(
    column: $table.employmentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get grossSalarySen => $composableBuilder(
    column: $table.grossSalarySen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fixedAllowanceSen => $composableBuilder(
    column: $table.fixedAllowanceSen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get epfRate => $composableBuilder(
    column: $table.epfRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasSocso => $composableBuilder(
    column: $table.hasSocso,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasEis => $composableBuilder(
    column: $table.hasEis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEpfVoluntaryExcess => $composableBuilder(
    column: $table.isEpfVoluntaryExcess,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get paydayDayOfMonth => $composableBuilder(
    column: $table.paydayDayOfMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get emergencyFundMonthsTarget => $composableBuilder(
    column: $table.emergencyFundMonthsTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentSavingsSen => $composableBuilder(
    column: $table.currentSavingsSen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get biometricLockEnabled => $composableBuilder(
    column: $table.biometricLockEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get aiAdviceEnabled => $composableBuilder(
    column: $table.aiAdviceEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get budgetPreset => $composableBuilder(
    column: $table.budgetPreset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get customNeedsRatio => $composableBuilder(
    column: $table.customNeedsRatio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get customWantsRatio => $composableBuilder(
    column: $table.customWantsRatio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get customSavingsRatio => $composableBuilder(
    column: $table.customSavingsRatio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get customGivingRatio => $composableBuilder(
    column: $table.customGivingRatio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfileTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfileTableTable> {
  $$UserProfileTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isOnboarded => $composableBuilder(
    column: $table.isOnboarded,
    builder: (column) => column,
  );

  GeneratedColumn<String> get employmentType => $composableBuilder(
    column: $table.employmentType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get grossSalarySen => $composableBuilder(
    column: $table.grossSalarySen,
    builder: (column) => column,
  );

  GeneratedColumn<int> get fixedAllowanceSen => $composableBuilder(
    column: $table.fixedAllowanceSen,
    builder: (column) => column,
  );

  GeneratedColumn<double> get epfRate =>
      $composableBuilder(column: $table.epfRate, builder: (column) => column);

  GeneratedColumn<bool> get hasSocso =>
      $composableBuilder(column: $table.hasSocso, builder: (column) => column);

  GeneratedColumn<bool> get hasEis =>
      $composableBuilder(column: $table.hasEis, builder: (column) => column);

  GeneratedColumn<bool> get isEpfVoluntaryExcess => $composableBuilder(
    column: $table.isEpfVoluntaryExcess,
    builder: (column) => column,
  );

  GeneratedColumn<int> get paydayDayOfMonth => $composableBuilder(
    column: $table.paydayDayOfMonth,
    builder: (column) => column,
  );

  GeneratedColumn<int> get emergencyFundMonthsTarget => $composableBuilder(
    column: $table.emergencyFundMonthsTarget,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentSavingsSen => $composableBuilder(
    column: $table.currentSavingsSen,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get biometricLockEnabled => $composableBuilder(
    column: $table.biometricLockEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get aiAdviceEnabled => $composableBuilder(
    column: $table.aiAdviceEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get budgetPreset => $composableBuilder(
    column: $table.budgetPreset,
    builder: (column) => column,
  );

  GeneratedColumn<double> get customNeedsRatio => $composableBuilder(
    column: $table.customNeedsRatio,
    builder: (column) => column,
  );

  GeneratedColumn<double> get customWantsRatio => $composableBuilder(
    column: $table.customWantsRatio,
    builder: (column) => column,
  );

  GeneratedColumn<double> get customSavingsRatio => $composableBuilder(
    column: $table.customSavingsRatio,
    builder: (column) => column,
  );

  GeneratedColumn<double> get customGivingRatio => $composableBuilder(
    column: $table.customGivingRatio,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserProfileTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfileTableTable,
          UserProfileTableData,
          $$UserProfileTableTableFilterComposer,
          $$UserProfileTableTableOrderingComposer,
          $$UserProfileTableTableAnnotationComposer,
          $$UserProfileTableTableCreateCompanionBuilder,
          $$UserProfileTableTableUpdateCompanionBuilder,
          (
            UserProfileTableData,
            BaseReferences<
              _$AppDatabase,
              $UserProfileTableTable,
              UserProfileTableData
            >,
          ),
          UserProfileTableData,
          PrefetchHooks Function()
        > {
  $$UserProfileTableTableTableManager(
    _$AppDatabase db,
    $UserProfileTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$UserProfileTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$UserProfileTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$UserProfileTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> isOnboarded = const Value.absent(),
                Value<String> employmentType = const Value.absent(),
                Value<int> grossSalarySen = const Value.absent(),
                Value<int> fixedAllowanceSen = const Value.absent(),
                Value<double> epfRate = const Value.absent(),
                Value<bool> hasSocso = const Value.absent(),
                Value<bool> hasEis = const Value.absent(),
                Value<bool> isEpfVoluntaryExcess = const Value.absent(),
                Value<int> paydayDayOfMonth = const Value.absent(),
                Value<int> emergencyFundMonthsTarget = const Value.absent(),
                Value<int> currentSavingsSen = const Value.absent(),
                Value<bool> biometricLockEnabled = const Value.absent(),
                Value<bool> aiAdviceEnabled = const Value.absent(),
                Value<String> budgetPreset = const Value.absent(),
                Value<double?> customNeedsRatio = const Value.absent(),
                Value<double?> customWantsRatio = const Value.absent(),
                Value<double?> customSavingsRatio = const Value.absent(),
                Value<double?> customGivingRatio = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => UserProfileTableCompanion(
                id: id,
                name: name,
                isOnboarded: isOnboarded,
                employmentType: employmentType,
                grossSalarySen: grossSalarySen,
                fixedAllowanceSen: fixedAllowanceSen,
                epfRate: epfRate,
                hasSocso: hasSocso,
                hasEis: hasEis,
                isEpfVoluntaryExcess: isEpfVoluntaryExcess,
                paydayDayOfMonth: paydayDayOfMonth,
                emergencyFundMonthsTarget: emergencyFundMonthsTarget,
                currentSavingsSen: currentSavingsSen,
                biometricLockEnabled: biometricLockEnabled,
                aiAdviceEnabled: aiAdviceEnabled,
                budgetPreset: budgetPreset,
                customNeedsRatio: customNeedsRatio,
                customWantsRatio: customWantsRatio,
                customSavingsRatio: customSavingsRatio,
                customGivingRatio: customGivingRatio,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> isOnboarded = const Value.absent(),
                Value<String> employmentType = const Value.absent(),
                Value<int> grossSalarySen = const Value.absent(),
                Value<int> fixedAllowanceSen = const Value.absent(),
                Value<double> epfRate = const Value.absent(),
                Value<bool> hasSocso = const Value.absent(),
                Value<bool> hasEis = const Value.absent(),
                Value<bool> isEpfVoluntaryExcess = const Value.absent(),
                Value<int> paydayDayOfMonth = const Value.absent(),
                Value<int> emergencyFundMonthsTarget = const Value.absent(),
                Value<int> currentSavingsSen = const Value.absent(),
                Value<bool> biometricLockEnabled = const Value.absent(),
                Value<bool> aiAdviceEnabled = const Value.absent(),
                Value<String> budgetPreset = const Value.absent(),
                Value<double?> customNeedsRatio = const Value.absent(),
                Value<double?> customWantsRatio = const Value.absent(),
                Value<double?> customSavingsRatio = const Value.absent(),
                Value<double?> customGivingRatio = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => UserProfileTableCompanion.insert(
                id: id,
                name: name,
                isOnboarded: isOnboarded,
                employmentType: employmentType,
                grossSalarySen: grossSalarySen,
                fixedAllowanceSen: fixedAllowanceSen,
                epfRate: epfRate,
                hasSocso: hasSocso,
                hasEis: hasEis,
                isEpfVoluntaryExcess: isEpfVoluntaryExcess,
                paydayDayOfMonth: paydayDayOfMonth,
                emergencyFundMonthsTarget: emergencyFundMonthsTarget,
                currentSavingsSen: currentSavingsSen,
                biometricLockEnabled: biometricLockEnabled,
                aiAdviceEnabled: aiAdviceEnabled,
                budgetPreset: budgetPreset,
                customNeedsRatio: customNeedsRatio,
                customWantsRatio: customWantsRatio,
                customSavingsRatio: customSavingsRatio,
                customGivingRatio: customGivingRatio,
                updatedAt: updatedAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProfileTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfileTableTable,
      UserProfileTableData,
      $$UserProfileTableTableFilterComposer,
      $$UserProfileTableTableOrderingComposer,
      $$UserProfileTableTableAnnotationComposer,
      $$UserProfileTableTableCreateCompanionBuilder,
      $$UserProfileTableTableUpdateCompanionBuilder,
      (
        UserProfileTableData,
        BaseReferences<
          _$AppDatabase,
          $UserProfileTableTable,
          UserProfileTableData
        >,
      ),
      UserProfileTableData,
      PrefetchHooks Function()
    >;
typedef $$ExpenseCategoriesTableTableCreateCompanionBuilder =
    ExpenseCategoriesTableCompanion Function({
      required String id,
      required String name,
      required String icon,
      required int colorHex,
      required String bucket,
      Value<bool> isCustom,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$ExpenseCategoriesTableTableUpdateCompanionBuilder =
    ExpenseCategoriesTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> icon,
      Value<int> colorHex,
      Value<String> bucket,
      Value<bool> isCustom,
      Value<int> sortOrder,
      Value<int> rowid,
    });

final class $$ExpenseCategoriesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ExpenseCategoriesTableTable,
          ExpenseCategoriesTableData
        > {
  $$ExpenseCategoriesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ExpensesTableTable, List<ExpensesTableData>>
  _expensesTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.expensesTable,
    aliasName: $_aliasNameGenerator(
      db.expenseCategoriesTable.id,
      db.expensesTable.categoryId,
    ),
  );

  $$ExpensesTableTableProcessedTableManager get expensesTableRefs {
    final manager = $$ExpensesTableTableTableManager(
      $_db,
      $_db.expensesTable,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_expensesTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExpenseCategoriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $ExpenseCategoriesTableTable> {
  $$ExpenseCategoriesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bucket => $composableBuilder(
    column: $table.bucket,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> expensesTableRefs(
    Expression<bool> Function($$ExpensesTableTableFilterComposer f) f,
  ) {
    final $$ExpensesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expensesTable,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableTableFilterComposer(
            $db: $db,
            $table: $db.expensesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExpenseCategoriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpenseCategoriesTableTable> {
  $$ExpenseCategoriesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bucket => $composableBuilder(
    column: $table.bucket,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExpenseCategoriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpenseCategoriesTableTable> {
  $$ExpenseCategoriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<String> get bucket =>
      $composableBuilder(column: $table.bucket, builder: (column) => column);

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  Expression<T> expensesTableRefs<T extends Object>(
    Expression<T> Function($$ExpensesTableTableAnnotationComposer a) f,
  ) {
    final $$ExpensesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expensesTable,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.expensesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExpenseCategoriesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpenseCategoriesTableTable,
          ExpenseCategoriesTableData,
          $$ExpenseCategoriesTableTableFilterComposer,
          $$ExpenseCategoriesTableTableOrderingComposer,
          $$ExpenseCategoriesTableTableAnnotationComposer,
          $$ExpenseCategoriesTableTableCreateCompanionBuilder,
          $$ExpenseCategoriesTableTableUpdateCompanionBuilder,
          (ExpenseCategoriesTableData, $$ExpenseCategoriesTableTableReferences),
          ExpenseCategoriesTableData,
          PrefetchHooks Function({bool expensesTableRefs})
        > {
  $$ExpenseCategoriesTableTableTableManager(
    _$AppDatabase db,
    $ExpenseCategoriesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ExpenseCategoriesTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$ExpenseCategoriesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$ExpenseCategoriesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<int> colorHex = const Value.absent(),
                Value<String> bucket = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExpenseCategoriesTableCompanion(
                id: id,
                name: name,
                icon: icon,
                colorHex: colorHex,
                bucket: bucket,
                isCustom: isCustom,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String icon,
                required int colorHex,
                required String bucket,
                Value<bool> isCustom = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExpenseCategoriesTableCompanion.insert(
                id: id,
                name: name,
                icon: icon,
                colorHex: colorHex,
                bucket: bucket,
                isCustom: isCustom,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$ExpenseCategoriesTableTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({expensesTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (expensesTableRefs) db.expensesTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (expensesTableRefs)
                    await $_getPrefetchedData<
                      ExpenseCategoriesTableData,
                      $ExpenseCategoriesTableTable,
                      ExpensesTableData
                    >(
                      currentTable: table,
                      referencedTable: $$ExpenseCategoriesTableTableReferences
                          ._expensesTableRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$ExpenseCategoriesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).expensesTableRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.categoryId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ExpenseCategoriesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpenseCategoriesTableTable,
      ExpenseCategoriesTableData,
      $$ExpenseCategoriesTableTableFilterComposer,
      $$ExpenseCategoriesTableTableOrderingComposer,
      $$ExpenseCategoriesTableTableAnnotationComposer,
      $$ExpenseCategoriesTableTableCreateCompanionBuilder,
      $$ExpenseCategoriesTableTableUpdateCompanionBuilder,
      (ExpenseCategoriesTableData, $$ExpenseCategoriesTableTableReferences),
      ExpenseCategoriesTableData,
      PrefetchHooks Function({bool expensesTableRefs})
    >;
typedef $$CommitmentsTableTableCreateCompanionBuilder =
    CommitmentsTableCompanion Function({
      Value<int> id,
      required String title,
      required String type,
      required int totalAmountSen,
      required int monthlyPaymentSen,
      required int remainingAmountSen,
      Value<double> interestRateAnnual,
      Value<int> totalTenureMonths,
      Value<int> remainingTenureMonths,
      Value<int> dueDayOfMonth,
      Value<bool> isActive,
      Value<DateTime> createdAt,
    });
typedef $$CommitmentsTableTableUpdateCompanionBuilder =
    CommitmentsTableCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> type,
      Value<int> totalAmountSen,
      Value<int> monthlyPaymentSen,
      Value<int> remainingAmountSen,
      Value<double> interestRateAnnual,
      Value<int> totalTenureMonths,
      Value<int> remainingTenureMonths,
      Value<int> dueDayOfMonth,
      Value<bool> isActive,
      Value<DateTime> createdAt,
    });

final class $$CommitmentsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CommitmentsTableTable,
          CommitmentsTableData
        > {
  $$CommitmentsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ExpensesTableTable, List<ExpensesTableData>>
  _expensesTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.expensesTable,
    aliasName: $_aliasNameGenerator(
      db.commitmentsTable.id,
      db.expensesTable.commitmentId,
    ),
  );

  $$ExpensesTableTableProcessedTableManager get expensesTableRefs {
    final manager = $$ExpensesTableTableTableManager(
      $_db,
      $_db.expensesTable,
    ).filter((f) => f.commitmentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_expensesTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CommitmentsTableTableFilterComposer
    extends Composer<_$AppDatabase, $CommitmentsTableTable> {
  $$CommitmentsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalAmountSen => $composableBuilder(
    column: $table.totalAmountSen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get monthlyPaymentSen => $composableBuilder(
    column: $table.monthlyPaymentSen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get remainingAmountSen => $composableBuilder(
    column: $table.remainingAmountSen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get interestRateAnnual => $composableBuilder(
    column: $table.interestRateAnnual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalTenureMonths => $composableBuilder(
    column: $table.totalTenureMonths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get remainingTenureMonths => $composableBuilder(
    column: $table.remainingTenureMonths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueDayOfMonth => $composableBuilder(
    column: $table.dueDayOfMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> expensesTableRefs(
    Expression<bool> Function($$ExpensesTableTableFilterComposer f) f,
  ) {
    final $$ExpensesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expensesTable,
      getReferencedColumn: (t) => t.commitmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableTableFilterComposer(
            $db: $db,
            $table: $db.expensesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CommitmentsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CommitmentsTableTable> {
  $$CommitmentsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalAmountSen => $composableBuilder(
    column: $table.totalAmountSen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get monthlyPaymentSen => $composableBuilder(
    column: $table.monthlyPaymentSen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get remainingAmountSen => $composableBuilder(
    column: $table.remainingAmountSen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get interestRateAnnual => $composableBuilder(
    column: $table.interestRateAnnual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalTenureMonths => $composableBuilder(
    column: $table.totalTenureMonths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get remainingTenureMonths => $composableBuilder(
    column: $table.remainingTenureMonths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueDayOfMonth => $composableBuilder(
    column: $table.dueDayOfMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CommitmentsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CommitmentsTableTable> {
  $$CommitmentsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get totalAmountSen => $composableBuilder(
    column: $table.totalAmountSen,
    builder: (column) => column,
  );

  GeneratedColumn<int> get monthlyPaymentSen => $composableBuilder(
    column: $table.monthlyPaymentSen,
    builder: (column) => column,
  );

  GeneratedColumn<int> get remainingAmountSen => $composableBuilder(
    column: $table.remainingAmountSen,
    builder: (column) => column,
  );

  GeneratedColumn<double> get interestRateAnnual => $composableBuilder(
    column: $table.interestRateAnnual,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalTenureMonths => $composableBuilder(
    column: $table.totalTenureMonths,
    builder: (column) => column,
  );

  GeneratedColumn<int> get remainingTenureMonths => $composableBuilder(
    column: $table.remainingTenureMonths,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dueDayOfMonth => $composableBuilder(
    column: $table.dueDayOfMonth,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> expensesTableRefs<T extends Object>(
    Expression<T> Function($$ExpensesTableTableAnnotationComposer a) f,
  ) {
    final $$ExpensesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expensesTable,
      getReferencedColumn: (t) => t.commitmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.expensesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CommitmentsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CommitmentsTableTable,
          CommitmentsTableData,
          $$CommitmentsTableTableFilterComposer,
          $$CommitmentsTableTableOrderingComposer,
          $$CommitmentsTableTableAnnotationComposer,
          $$CommitmentsTableTableCreateCompanionBuilder,
          $$CommitmentsTableTableUpdateCompanionBuilder,
          (CommitmentsTableData, $$CommitmentsTableTableReferences),
          CommitmentsTableData,
          PrefetchHooks Function({bool expensesTableRefs})
        > {
  $$CommitmentsTableTableTableManager(
    _$AppDatabase db,
    $CommitmentsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$CommitmentsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$CommitmentsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$CommitmentsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> totalAmountSen = const Value.absent(),
                Value<int> monthlyPaymentSen = const Value.absent(),
                Value<int> remainingAmountSen = const Value.absent(),
                Value<double> interestRateAnnual = const Value.absent(),
                Value<int> totalTenureMonths = const Value.absent(),
                Value<int> remainingTenureMonths = const Value.absent(),
                Value<int> dueDayOfMonth = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CommitmentsTableCompanion(
                id: id,
                title: title,
                type: type,
                totalAmountSen: totalAmountSen,
                monthlyPaymentSen: monthlyPaymentSen,
                remainingAmountSen: remainingAmountSen,
                interestRateAnnual: interestRateAnnual,
                totalTenureMonths: totalTenureMonths,
                remainingTenureMonths: remainingTenureMonths,
                dueDayOfMonth: dueDayOfMonth,
                isActive: isActive,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required String type,
                required int totalAmountSen,
                required int monthlyPaymentSen,
                required int remainingAmountSen,
                Value<double> interestRateAnnual = const Value.absent(),
                Value<int> totalTenureMonths = const Value.absent(),
                Value<int> remainingTenureMonths = const Value.absent(),
                Value<int> dueDayOfMonth = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CommitmentsTableCompanion.insert(
                id: id,
                title: title,
                type: type,
                totalAmountSen: totalAmountSen,
                monthlyPaymentSen: monthlyPaymentSen,
                remainingAmountSen: remainingAmountSen,
                interestRateAnnual: interestRateAnnual,
                totalTenureMonths: totalTenureMonths,
                remainingTenureMonths: remainingTenureMonths,
                dueDayOfMonth: dueDayOfMonth,
                isActive: isActive,
                createdAt: createdAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$CommitmentsTableTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({expensesTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (expensesTableRefs) db.expensesTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (expensesTableRefs)
                    await $_getPrefetchedData<
                      CommitmentsTableData,
                      $CommitmentsTableTable,
                      ExpensesTableData
                    >(
                      currentTable: table,
                      referencedTable: $$CommitmentsTableTableReferences
                          ._expensesTableRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$CommitmentsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).expensesTableRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.commitmentId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CommitmentsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CommitmentsTableTable,
      CommitmentsTableData,
      $$CommitmentsTableTableFilterComposer,
      $$CommitmentsTableTableOrderingComposer,
      $$CommitmentsTableTableAnnotationComposer,
      $$CommitmentsTableTableCreateCompanionBuilder,
      $$CommitmentsTableTableUpdateCompanionBuilder,
      (CommitmentsTableData, $$CommitmentsTableTableReferences),
      CommitmentsTableData,
      PrefetchHooks Function({bool expensesTableRefs})
    >;
typedef $$AccountsTableTableCreateCompanionBuilder =
    AccountsTableCompanion Function({
      Value<int> id,
      required String name,
      Value<String> type,
      Value<int> balanceSen,
      Value<String> icon,
      Value<int> colorHex,
      Value<bool> isDefault,
      Value<bool> isLiquidOnHand,
      Value<DateTime> updatedAt,
    });
typedef $$AccountsTableTableUpdateCompanionBuilder =
    AccountsTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> type,
      Value<int> balanceSen,
      Value<String> icon,
      Value<int> colorHex,
      Value<bool> isDefault,
      Value<bool> isLiquidOnHand,
      Value<DateTime> updatedAt,
    });

final class $$AccountsTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $AccountsTableTable, AccountsTableData> {
  $$AccountsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ExpensesTableTable, List<ExpensesTableData>>
  _expensesTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.expensesTable,
    aliasName: $_aliasNameGenerator(
      db.accountsTable.id,
      db.expensesTable.accountId,
    ),
  );

  $$ExpensesTableTableProcessedTableManager get expensesTableRefs {
    final manager = $$ExpensesTableTableTableManager(
      $_db,
      $_db.expensesTable,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_expensesTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AccountsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTableTable> {
  $$AccountsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get balanceSen => $composableBuilder(
    column: $table.balanceSen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLiquidOnHand => $composableBuilder(
    column: $table.isLiquidOnHand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> expensesTableRefs(
    Expression<bool> Function($$ExpensesTableTableFilterComposer f) f,
  ) {
    final $$ExpensesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expensesTable,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableTableFilterComposer(
            $db: $db,
            $table: $db.expensesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccountsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTableTable> {
  $$AccountsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get balanceSen => $composableBuilder(
    column: $table.balanceSen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLiquidOnHand => $composableBuilder(
    column: $table.isLiquidOnHand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AccountsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTableTable> {
  $$AccountsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get balanceSen => $composableBuilder(
    column: $table.balanceSen,
    builder: (column) => column,
  );

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<bool> get isLiquidOnHand => $composableBuilder(
    column: $table.isLiquidOnHand,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> expensesTableRefs<T extends Object>(
    Expression<T> Function($$ExpensesTableTableAnnotationComposer a) f,
  ) {
    final $$ExpensesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expensesTable,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.expensesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccountsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccountsTableTable,
          AccountsTableData,
          $$AccountsTableTableFilterComposer,
          $$AccountsTableTableOrderingComposer,
          $$AccountsTableTableAnnotationComposer,
          $$AccountsTableTableCreateCompanionBuilder,
          $$AccountsTableTableUpdateCompanionBuilder,
          (AccountsTableData, $$AccountsTableTableReferences),
          AccountsTableData,
          PrefetchHooks Function({bool expensesTableRefs})
        > {
  $$AccountsTableTableTableManager(_$AppDatabase db, $AccountsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$AccountsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$AccountsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$AccountsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> balanceSen = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<int> colorHex = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<bool> isLiquidOnHand = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => AccountsTableCompanion(
                id: id,
                name: name,
                type: type,
                balanceSen: balanceSen,
                icon: icon,
                colorHex: colorHex,
                isDefault: isDefault,
                isLiquidOnHand: isLiquidOnHand,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String> type = const Value.absent(),
                Value<int> balanceSen = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<int> colorHex = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<bool> isLiquidOnHand = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => AccountsTableCompanion.insert(
                id: id,
                name: name,
                type: type,
                balanceSen: balanceSen,
                icon: icon,
                colorHex: colorHex,
                isDefault: isDefault,
                isLiquidOnHand: isLiquidOnHand,
                updatedAt: updatedAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$AccountsTableTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({expensesTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (expensesTableRefs) db.expensesTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (expensesTableRefs)
                    await $_getPrefetchedData<
                      AccountsTableData,
                      $AccountsTableTable,
                      ExpensesTableData
                    >(
                      currentTable: table,
                      referencedTable: $$AccountsTableTableReferences
                          ._expensesTableRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$AccountsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).expensesTableRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.accountId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$AccountsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccountsTableTable,
      AccountsTableData,
      $$AccountsTableTableFilterComposer,
      $$AccountsTableTableOrderingComposer,
      $$AccountsTableTableAnnotationComposer,
      $$AccountsTableTableCreateCompanionBuilder,
      $$AccountsTableTableUpdateCompanionBuilder,
      (AccountsTableData, $$AccountsTableTableReferences),
      AccountsTableData,
      PrefetchHooks Function({bool expensesTableRefs})
    >;
typedef $$ExpensesTableTableCreateCompanionBuilder =
    ExpensesTableCompanion Function({
      Value<int> id,
      required int amountSen,
      required String categoryId,
      required DateTime date,
      Value<String?> note,
      Value<bool> isCommitmentPayment,
      Value<int?> commitmentId,
      Value<int?> accountId,
      Value<DateTime> createdAt,
    });
typedef $$ExpensesTableTableUpdateCompanionBuilder =
    ExpensesTableCompanion Function({
      Value<int> id,
      Value<int> amountSen,
      Value<String> categoryId,
      Value<DateTime> date,
      Value<String?> note,
      Value<bool> isCommitmentPayment,
      Value<int?> commitmentId,
      Value<int?> accountId,
      Value<DateTime> createdAt,
    });

final class $$ExpensesTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $ExpensesTableTable, ExpensesTableData> {
  $$ExpensesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ExpenseCategoriesTableTable _categoryIdTable(_$AppDatabase db) =>
      db.expenseCategoriesTable.createAlias(
        $_aliasNameGenerator(
          db.expensesTable.categoryId,
          db.expenseCategoriesTable.id,
        ),
      );

  $$ExpenseCategoriesTableTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<String>('category_id')!;

    final manager = $$ExpenseCategoriesTableTableTableManager(
      $_db,
      $_db.expenseCategoriesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CommitmentsTableTable _commitmentIdTable(_$AppDatabase db) =>
      db.commitmentsTable.createAlias(
        $_aliasNameGenerator(
          db.expensesTable.commitmentId,
          db.commitmentsTable.id,
        ),
      );

  $$CommitmentsTableTableProcessedTableManager? get commitmentId {
    final $_column = $_itemColumn<int>('commitment_id');
    if ($_column == null) return null;
    final manager = $$CommitmentsTableTableTableManager(
      $_db,
      $_db.commitmentsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_commitmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AccountsTableTable _accountIdTable(_$AppDatabase db) =>
      db.accountsTable.createAlias(
        $_aliasNameGenerator(db.expensesTable.accountId, db.accountsTable.id),
      );

  $$AccountsTableTableProcessedTableManager? get accountId {
    final $_column = $_itemColumn<int>('account_id');
    if ($_column == null) return null;
    final manager = $$AccountsTableTableTableManager(
      $_db,
      $_db.accountsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExpensesTableTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTableTable> {
  $$ExpensesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountSen => $composableBuilder(
    column: $table.amountSen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCommitmentPayment => $composableBuilder(
    column: $table.isCommitmentPayment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ExpenseCategoriesTableTableFilterComposer get categoryId {
    final $$ExpenseCategoriesTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.categoryId,
          referencedTable: $db.expenseCategoriesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ExpenseCategoriesTableTableFilterComposer(
                $db: $db,
                $table: $db.expenseCategoriesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$CommitmentsTableTableFilterComposer get commitmentId {
    final $$CommitmentsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.commitmentId,
      referencedTable: $db.commitmentsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CommitmentsTableTableFilterComposer(
            $db: $db,
            $table: $db.commitmentsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableTableFilterComposer get accountId {
    final $$AccountsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableFilterComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpensesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTableTable> {
  $$ExpensesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountSen => $composableBuilder(
    column: $table.amountSen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCommitmentPayment => $composableBuilder(
    column: $table.isCommitmentPayment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ExpenseCategoriesTableTableOrderingComposer get categoryId {
    final $$ExpenseCategoriesTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.categoryId,
          referencedTable: $db.expenseCategoriesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ExpenseCategoriesTableTableOrderingComposer(
                $db: $db,
                $table: $db.expenseCategoriesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$CommitmentsTableTableOrderingComposer get commitmentId {
    final $$CommitmentsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.commitmentId,
      referencedTable: $db.commitmentsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CommitmentsTableTableOrderingComposer(
            $db: $db,
            $table: $db.commitmentsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableTableOrderingComposer get accountId {
    final $$AccountsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableOrderingComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpensesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTableTable> {
  $$ExpensesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountSen =>
      $composableBuilder(column: $table.amountSen, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get isCommitmentPayment => $composableBuilder(
    column: $table.isCommitmentPayment,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ExpenseCategoriesTableTableAnnotationComposer get categoryId {
    final $$ExpenseCategoriesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.categoryId,
          referencedTable: $db.expenseCategoriesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ExpenseCategoriesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.expenseCategoriesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$CommitmentsTableTableAnnotationComposer get commitmentId {
    final $$CommitmentsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.commitmentId,
      referencedTable: $db.commitmentsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CommitmentsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.commitmentsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableTableAnnotationComposer get accountId {
    final $$AccountsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpensesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpensesTableTable,
          ExpensesTableData,
          $$ExpensesTableTableFilterComposer,
          $$ExpensesTableTableOrderingComposer,
          $$ExpensesTableTableAnnotationComposer,
          $$ExpensesTableTableCreateCompanionBuilder,
          $$ExpensesTableTableUpdateCompanionBuilder,
          (ExpensesTableData, $$ExpensesTableTableReferences),
          ExpensesTableData,
          PrefetchHooks Function({
            bool categoryId,
            bool commitmentId,
            bool accountId,
          })
        > {
  $$ExpensesTableTableTableManager(_$AppDatabase db, $ExpensesTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ExpensesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$ExpensesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$ExpensesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> amountSen = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> isCommitmentPayment = const Value.absent(),
                Value<int?> commitmentId = const Value.absent(),
                Value<int?> accountId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ExpensesTableCompanion(
                id: id,
                amountSen: amountSen,
                categoryId: categoryId,
                date: date,
                note: note,
                isCommitmentPayment: isCommitmentPayment,
                commitmentId: commitmentId,
                accountId: accountId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int amountSen,
                required String categoryId,
                required DateTime date,
                Value<String?> note = const Value.absent(),
                Value<bool> isCommitmentPayment = const Value.absent(),
                Value<int?> commitmentId = const Value.absent(),
                Value<int?> accountId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ExpensesTableCompanion.insert(
                id: id,
                amountSen: amountSen,
                categoryId: categoryId,
                date: date,
                note: note,
                isCommitmentPayment: isCommitmentPayment,
                commitmentId: commitmentId,
                accountId: accountId,
                createdAt: createdAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$ExpensesTableTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            categoryId = false,
            commitmentId = false,
            accountId = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (categoryId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.categoryId,
                            referencedTable: $$ExpensesTableTableReferences
                                ._categoryIdTable(db),
                            referencedColumn:
                                $$ExpensesTableTableReferences
                                    ._categoryIdTable(db)
                                    .id,
                          )
                          as T;
                }
                if (commitmentId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.commitmentId,
                            referencedTable: $$ExpensesTableTableReferences
                                ._commitmentIdTable(db),
                            referencedColumn:
                                $$ExpensesTableTableReferences
                                    ._commitmentIdTable(db)
                                    .id,
                          )
                          as T;
                }
                if (accountId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.accountId,
                            referencedTable: $$ExpensesTableTableReferences
                                ._accountIdTable(db),
                            referencedColumn:
                                $$ExpensesTableTableReferences
                                    ._accountIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ExpensesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpensesTableTable,
      ExpensesTableData,
      $$ExpensesTableTableFilterComposer,
      $$ExpensesTableTableOrderingComposer,
      $$ExpensesTableTableAnnotationComposer,
      $$ExpensesTableTableCreateCompanionBuilder,
      $$ExpensesTableTableUpdateCompanionBuilder,
      (ExpensesTableData, $$ExpensesTableTableReferences),
      ExpensesTableData,
      PrefetchHooks Function({
        bool categoryId,
        bool commitmentId,
        bool accountId,
      })
    >;
typedef $$ChecklistItemsTableTableCreateCompanionBuilder =
    ChecklistItemsTableCompanion Function({
      required String id,
      required String title,
      required String description,
      required String category,
      Value<bool> isCompleted,
      Value<DateTime?> completedAt,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$ChecklistItemsTableTableUpdateCompanionBuilder =
    ChecklistItemsTableCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> description,
      Value<String> category,
      Value<bool> isCompleted,
      Value<DateTime?> completedAt,
      Value<int> sortOrder,
      Value<int> rowid,
    });

class $$ChecklistItemsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ChecklistItemsTableTable> {
  $$ChecklistItemsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChecklistItemsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ChecklistItemsTableTable> {
  $$ChecklistItemsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChecklistItemsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChecklistItemsTableTable> {
  $$ChecklistItemsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$ChecklistItemsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChecklistItemsTableTable,
          ChecklistItemsTableData,
          $$ChecklistItemsTableTableFilterComposer,
          $$ChecklistItemsTableTableOrderingComposer,
          $$ChecklistItemsTableTableAnnotationComposer,
          $$ChecklistItemsTableTableCreateCompanionBuilder,
          $$ChecklistItemsTableTableUpdateCompanionBuilder,
          (
            ChecklistItemsTableData,
            BaseReferences<
              _$AppDatabase,
              $ChecklistItemsTableTable,
              ChecklistItemsTableData
            >,
          ),
          ChecklistItemsTableData,
          PrefetchHooks Function()
        > {
  $$ChecklistItemsTableTableTableManager(
    _$AppDatabase db,
    $ChecklistItemsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ChecklistItemsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$ChecklistItemsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$ChecklistItemsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChecklistItemsTableCompanion(
                id: id,
                title: title,
                description: description,
                category: category,
                isCompleted: isCompleted,
                completedAt: completedAt,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String description,
                required String category,
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChecklistItemsTableCompanion.insert(
                id: id,
                title: title,
                description: description,
                category: category,
                isCompleted: isCompleted,
                completedAt: completedAt,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChecklistItemsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChecklistItemsTableTable,
      ChecklistItemsTableData,
      $$ChecklistItemsTableTableFilterComposer,
      $$ChecklistItemsTableTableOrderingComposer,
      $$ChecklistItemsTableTableAnnotationComposer,
      $$ChecklistItemsTableTableCreateCompanionBuilder,
      $$ChecklistItemsTableTableUpdateCompanionBuilder,
      (
        ChecklistItemsTableData,
        BaseReferences<
          _$AppDatabase,
          $ChecklistItemsTableTable,
          ChecklistItemsTableData
        >,
      ),
      ChecklistItemsTableData,
      PrefetchHooks Function()
    >;
typedef $$AccountTransfersTableTableCreateCompanionBuilder =
    AccountTransfersTableCompanion Function({
      Value<int> id,
      required int fromAccountId,
      required int toAccountId,
      required int amountSen,
      Value<DateTime> date,
      Value<String?> note,
      Value<DateTime> createdAt,
    });
typedef $$AccountTransfersTableTableUpdateCompanionBuilder =
    AccountTransfersTableCompanion Function({
      Value<int> id,
      Value<int> fromAccountId,
      Value<int> toAccountId,
      Value<int> amountSen,
      Value<DateTime> date,
      Value<String?> note,
      Value<DateTime> createdAt,
    });

final class $$AccountTransfersTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $AccountTransfersTableTable,
          AccountTransfersTableData
        > {
  $$AccountTransfersTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AccountsTableTable _fromAccountIdTable(_$AppDatabase db) =>
      db.accountsTable.createAlias(
        $_aliasNameGenerator(
          db.accountTransfersTable.fromAccountId,
          db.accountsTable.id,
        ),
      );

  $$AccountsTableTableProcessedTableManager get fromAccountId {
    final $_column = $_itemColumn<int>('from_account_id')!;

    final manager = $$AccountsTableTableTableManager(
      $_db,
      $_db.accountsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_fromAccountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AccountsTableTable _toAccountIdTable(_$AppDatabase db) =>
      db.accountsTable.createAlias(
        $_aliasNameGenerator(
          db.accountTransfersTable.toAccountId,
          db.accountsTable.id,
        ),
      );

  $$AccountsTableTableProcessedTableManager get toAccountId {
    final $_column = $_itemColumn<int>('to_account_id')!;

    final manager = $$AccountsTableTableTableManager(
      $_db,
      $_db.accountsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_toAccountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AccountTransfersTableTableFilterComposer
    extends Composer<_$AppDatabase, $AccountTransfersTableTable> {
  $$AccountTransfersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountSen => $composableBuilder(
    column: $table.amountSen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableTableFilterComposer get fromAccountId {
    final $$AccountsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fromAccountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableFilterComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableTableFilterComposer get toAccountId {
    final $$AccountsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toAccountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableFilterComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AccountTransfersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountTransfersTableTable> {
  $$AccountTransfersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountSen => $composableBuilder(
    column: $table.amountSen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableTableOrderingComposer get fromAccountId {
    final $$AccountsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fromAccountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableOrderingComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableTableOrderingComposer get toAccountId {
    final $$AccountsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toAccountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableOrderingComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AccountTransfersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountTransfersTableTable> {
  $$AccountTransfersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountSen =>
      $composableBuilder(column: $table.amountSen, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$AccountsTableTableAnnotationComposer get fromAccountId {
    final $$AccountsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fromAccountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableTableAnnotationComposer get toAccountId {
    final $$AccountsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toAccountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AccountTransfersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccountTransfersTableTable,
          AccountTransfersTableData,
          $$AccountTransfersTableTableFilterComposer,
          $$AccountTransfersTableTableOrderingComposer,
          $$AccountTransfersTableTableAnnotationComposer,
          $$AccountTransfersTableTableCreateCompanionBuilder,
          $$AccountTransfersTableTableUpdateCompanionBuilder,
          (AccountTransfersTableData, $$AccountTransfersTableTableReferences),
          AccountTransfersTableData,
          PrefetchHooks Function({bool fromAccountId, bool toAccountId})
        > {
  $$AccountTransfersTableTableTableManager(
    _$AppDatabase db,
    $AccountTransfersTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$AccountTransfersTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$AccountTransfersTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$AccountTransfersTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> fromAccountId = const Value.absent(),
                Value<int> toAccountId = const Value.absent(),
                Value<int> amountSen = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AccountTransfersTableCompanion(
                id: id,
                fromAccountId: fromAccountId,
                toAccountId: toAccountId,
                amountSen: amountSen,
                date: date,
                note: note,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int fromAccountId,
                required int toAccountId,
                required int amountSen,
                Value<DateTime> date = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AccountTransfersTableCompanion.insert(
                id: id,
                fromAccountId: fromAccountId,
                toAccountId: toAccountId,
                amountSen: amountSen,
                date: date,
                note: note,
                createdAt: createdAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$AccountTransfersTableTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            fromAccountId = false,
            toAccountId = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (fromAccountId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.fromAccountId,
                            referencedTable:
                                $$AccountTransfersTableTableReferences
                                    ._fromAccountIdTable(db),
                            referencedColumn:
                                $$AccountTransfersTableTableReferences
                                    ._fromAccountIdTable(db)
                                    .id,
                          )
                          as T;
                }
                if (toAccountId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.toAccountId,
                            referencedTable:
                                $$AccountTransfersTableTableReferences
                                    ._toAccountIdTable(db),
                            referencedColumn:
                                $$AccountTransfersTableTableReferences
                                    ._toAccountIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AccountTransfersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccountTransfersTableTable,
      AccountTransfersTableData,
      $$AccountTransfersTableTableFilterComposer,
      $$AccountTransfersTableTableOrderingComposer,
      $$AccountTransfersTableTableAnnotationComposer,
      $$AccountTransfersTableTableCreateCompanionBuilder,
      $$AccountTransfersTableTableUpdateCompanionBuilder,
      (AccountTransfersTableData, $$AccountTransfersTableTableReferences),
      AccountTransfersTableData,
      PrefetchHooks Function({bool fromAccountId, bool toAccountId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserProfileTableTableTableManager get userProfileTable =>
      $$UserProfileTableTableTableManager(_db, _db.userProfileTable);
  $$ExpenseCategoriesTableTableTableManager get expenseCategoriesTable =>
      $$ExpenseCategoriesTableTableTableManager(
        _db,
        _db.expenseCategoriesTable,
      );
  $$CommitmentsTableTableTableManager get commitmentsTable =>
      $$CommitmentsTableTableTableManager(_db, _db.commitmentsTable);
  $$AccountsTableTableTableManager get accountsTable =>
      $$AccountsTableTableTableManager(_db, _db.accountsTable);
  $$ExpensesTableTableTableManager get expensesTable =>
      $$ExpensesTableTableTableManager(_db, _db.expensesTable);
  $$ChecklistItemsTableTableTableManager get checklistItemsTable =>
      $$ChecklistItemsTableTableTableManager(_db, _db.checklistItemsTable);
  $$AccountTransfersTableTableTableManager get accountTransfersTable =>
      $$AccountTransfersTableTableTableManager(_db, _db.accountTransfersTable);
}
