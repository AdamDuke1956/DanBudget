import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/money.dart';
import '../../../data/providers/database_providers.dart';
import '../../../data/repositories/tax_repository.dart';
import '../../../domain/engine/lhdn_tax_engine.dart';

class TaxProfileEditSheet extends ConsumerStatefulWidget {
  final TaxYearProfileData initialProfile;
  final Money defaultAnnualPcb;

  const TaxProfileEditSheet({
    super.key,
    required this.initialProfile,
    required this.defaultAnnualPcb,
  });

  @override
  ConsumerState<TaxProfileEditSheet> createState() =>
      _TaxProfileEditSheetState();
}

class _TaxProfileEditSheetState extends ConsumerState<TaxProfileEditSheet> {
  late final TextEditingController _bonusCtrl;
  late final TextEditingController _otherIncomeCtrl;
  late final TextEditingController _pcbOverrideCtrl;
  late final TextEditingController _zakatCtrl;

  late final TextEditingController _volEpfCtrl;
  late final TextEditingController _lifeInsCtrl;
  late final TextEditingController _medInsCtrl;
  late final TextEditingController _prsCtrl;
  late final TextEditingController _sspnCtrl;

  late final TextEditingController _higherEdCtrl;
  late final TextEditingController _upskillingCtrl;
  late final TextEditingController _housingInterestCtrl;

  late final TextEditingController _aiCtrl;
  late final TextEditingController _internetCtrl;
  late final TextEditingController _booksCtrl;
  late final TextEditingController _devicesCtrl;
  late final TextEditingController _coursesCtrl;

  late final TextEditingController _sportsEqCtrl;
  late final TextEditingController _sportsGymCtrl;
  late final TextEditingController _sportsCompCtrl;

  late final TextEditingController _medSeriousCtrl;
  late final TextEditingController _medCheckupCtrl;
  late final TextEditingController _medDentalCtrl;
  late final TextEditingController _medVaccineCtrl;

  late HousingLoanTier _housingTier;
  late bool _useCustomPcb;

  String _senToInput(int sen) {
    if (sen <= 0) return '';
    final rm = sen / 100.0;
    return rm == rm.roundToDouble()
        ? rm.toInt().toString()
        : rm.toStringAsFixed(2);
  }

  int _inputToSen(String text) {
    final parsed = Money.tryParse(text);
    return parsed?.sen ?? 0;
  }

  @override
  void initState() {
    super.initState();
    final p = widget.initialProfile;
    _useCustomPcb = p.annualPcbOverrideSen != null;
    _housingTier = p.housingLoanTier;

    _bonusCtrl = TextEditingController(text: _senToInput(p.annualBonusSen));
    _otherIncomeCtrl =
        TextEditingController(text: _senToInput(p.annualOtherIncomeSen));
    _pcbOverrideCtrl = TextEditingController(
      text: p.annualPcbOverrideSen != null
          ? _senToInput(p.annualPcbOverrideSen!)
          : _senToInput(widget.defaultAnnualPcb.sen),
    );
    _zakatCtrl = TextEditingController(text: _senToInput(p.zakatFitrahSen));

    _volEpfCtrl = TextEditingController(text: _senToInput(p.voluntaryEpfSen));
    _lifeInsCtrl = TextEditingController(text: _senToInput(p.lifeInsuranceSen));
    _medInsCtrl =
        TextEditingController(text: _senToInput(p.medicalInsuranceSen));
    _prsCtrl = TextEditingController(text: _senToInput(p.prsAnnuitySen));
    _sspnCtrl = TextEditingController(text: _senToInput(p.sspnNetSavingsSen));

    _higherEdCtrl =
        TextEditingController(text: _senToInput(p.higherEducationSen));
    _upskillingCtrl = TextEditingController(text: _senToInput(p.upskillingSen));
    _housingInterestCtrl =
        TextEditingController(text: _senToInput(p.housingLoanInterestSen));

    _aiCtrl = TextEditingController(text: _senToInput(p.lifestyleAiSen));
    _internetCtrl =
        TextEditingController(text: _senToInput(p.lifestyleInternetSen));
    _booksCtrl = TextEditingController(text: _senToInput(p.lifestyleBooksSen));
    _devicesCtrl =
        TextEditingController(text: _senToInput(p.lifestyleDevicesSen));
    _coursesCtrl =
        TextEditingController(text: _senToInput(p.lifestyleCoursesSen));

    _sportsEqCtrl =
        TextEditingController(text: _senToInput(p.sportsEquipmentSen));
    _sportsGymCtrl =
        TextEditingController(text: _senToInput(p.sportsGymFacilitySen));
    _sportsCompCtrl =
        TextEditingController(text: _senToInput(p.sportsCompetitionSen));

    _medSeriousCtrl =
        TextEditingController(text: _senToInput(p.medicalSeriousFertilitySen));
    _medCheckupCtrl =
        TextEditingController(text: _senToInput(p.medicalCheckupMentalSen));
    _medDentalCtrl =
        TextEditingController(text: _senToInput(p.medicalDentalSen));
    _medVaccineCtrl =
        TextEditingController(text: _senToInput(p.medicalVaccinationSen));
  }

  @override
  void dispose() {
    for (final c in [
      _bonusCtrl,
      _otherIncomeCtrl,
      _pcbOverrideCtrl,
      _zakatCtrl,
      _volEpfCtrl,
      _lifeInsCtrl,
      _medInsCtrl,
      _prsCtrl,
      _sspnCtrl,
      _higherEdCtrl,
      _upskillingCtrl,
      _housingInterestCtrl,
      _aiCtrl,
      _internetCtrl,
      _booksCtrl,
      _devicesCtrl,
      _coursesCtrl,
      _sportsEqCtrl,
      _sportsGymCtrl,
      _sportsCompCtrl,
      _medSeriousCtrl,
      _medCheckupCtrl,
      _medDentalCtrl,
      _medVaccineCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final updated = widget.initialProfile.copyWith(
      annualBonusSen: _inputToSen(_bonusCtrl.text),
      annualOtherIncomeSen: _inputToSen(_otherIncomeCtrl.text),
      annualPcbOverrideSen:
          _useCustomPcb ? _inputToSen(_pcbOverrideCtrl.text) : null,
      clearPcbOverride: !_useCustomPcb,
      zakatFitrahSen: _inputToSen(_zakatCtrl.text),
      voluntaryEpfSen: _inputToSen(_volEpfCtrl.text),
      lifeInsuranceSen: _inputToSen(_lifeInsCtrl.text),
      medicalInsuranceSen: _inputToSen(_medInsCtrl.text),
      prsAnnuitySen: _inputToSen(_prsCtrl.text),
      sspnNetSavingsSen: _inputToSen(_sspnCtrl.text),
      higherEducationSen: _inputToSen(_higherEdCtrl.text),
      upskillingSen: _inputToSen(_upskillingCtrl.text),
      housingLoanTier: _housingTier,
      housingLoanInterestSen: _housingTier == HousingLoanTier.none
          ? 0
          : _inputToSen(_housingInterestCtrl.text),
      lifestyleAiSen: _inputToSen(_aiCtrl.text),
      lifestyleInternetSen: _inputToSen(_internetCtrl.text),
      lifestyleBooksSen: _inputToSen(_booksCtrl.text),
      lifestyleDevicesSen: _inputToSen(_devicesCtrl.text),
      lifestyleCoursesSen: _inputToSen(_coursesCtrl.text),
      sportsEquipmentSen: _inputToSen(_sportsEqCtrl.text),
      sportsGymFacilitySen: _inputToSen(_sportsGymCtrl.text),
      sportsCompetitionSen: _inputToSen(_sportsCompCtrl.text),
      medicalSeriousFertilitySen: _inputToSen(_medSeriousCtrl.text),
      medicalCheckupMentalSen: _inputToSen(_medCheckupCtrl.text),
      medicalDentalSen: _inputToSen(_medDentalCtrl.text),
      medicalVaccinationSen: _inputToSen(_medVaccineCtrl.text),
      updatedAt: DateTime.now(),
    );

    await ref.read(taxRepositoryProvider).saveTaxYearProfile(updated);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: colors.bgSecondary,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + bottomInset),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.borderSubtle,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Configure YA ${widget.initialProfile.assessmentYear} Tax & Reliefs',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, color: colors.textMuted),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    _SectionHeader(
                      title: '1. Annual Income, PCB & Zakat Rebate',
                      subtitle:
                          'Base salary & statutory EPF/SOCSO/EIS are synced automatically from your Plan payslip.',
                      colors: colors,
                    ),
                    _MoneyField(
                      label: 'Annual Bonuses (RM)',
                      hint: '0.00',
                      controller: _bonusCtrl,
                      colors: colors,
                    ),
                    _MoneyField(
                      label: 'Other Taxable Income (RM)',
                      hint: 'Freelance, commissions, side income',
                      controller: _otherIncomeCtrl,
                      colors: colors,
                    ),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Override Annual PCB Paid (Potongan Cukai Bulanan)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        'Default from payslip: ${widget.defaultAnnualPcb.formatted}/year',
                        style: TextStyle(fontSize: 12, color: colors.textMuted),
                      ),
                      value: _useCustomPcb,
                      activeColor: colors.accentPrimary,
                      onChanged: (val) => setState(() => _useCustomPcb = val),
                    ),
                    if (_useCustomPcb)
                      _MoneyField(
                        label: 'Total PCB Deducted for the Year (EA Form) (RM)',
                        hint: '0.00',
                        controller: _pcbOverrideCtrl,
                        colors: colors,
                      ),
                    _MoneyField(
                      label: 'Zakat / Fitrah Paid (1:1 Direct Tax Rebate) (RM)',
                      hint: 'Deducts 100% ringgit-for-ringgit from tax',
                      controller: _zakatCtrl,
                      colors: colors,
                    ),
                    const SizedBox(height: 16),
                    _SectionHeader(
                      title: '2. Insurance, Retirement & SSPN Reliefs',
                      subtitle:
                          'Strict statutory caps are automatically enforced by the engine.',
                      colors: colors,
                    ),
                    _MoneyField(
                      label: 'Voluntary EPF (KWSP i-Saraan / Self Top-Up) (RM)',
                      hint: 'Shares RM4,000 EPF sub-cap with statutory EPF',
                      controller: _volEpfCtrl,
                      colors: colors,
                    ),
                    _MoneyField(
                      label: 'Life Insurance / Family Takaful Premiums (RM)',
                      hint: 'Up to RM3,000 (+ unutilized EPF up to RM7,000 total)',
                      controller: _lifeInsCtrl,
                      colors: colors,
                    ),
                    _MoneyField(
                      label: 'Medical & Education Insurance / Takaful (RM)',
                      hint: 'Capped at RM4,000',
                      controller: _medInsCtrl,
                      colors: colors,
                    ),
                    _MoneyField(
                      label:
                          'Private Retirement Scheme (PRS) / Deferred Annuity (RM)',
                      hint: 'Capped at RM3,000',
                      controller: _prsCtrl,
                      colors: colors,
                    ),
                    _MoneyField(
                      label: 'SSPN Net Savings (Deposits minus Withdrawals) (RM)',
                      hint: 'Capped at RM8,000',
                      controller: _sspnCtrl,
                      colors: colors,
                    ),
                    const SizedBox(height: 16),
                    _SectionHeader(
                      title: '3. Self Education & First-Time Homebuyer Loan',
                      subtitle:
                          'Education capped at RM7,000 (Upskilling sub-cap RM2,000).',
                      colors: colors,
                    ),
                    _MoneyField(
                      label: 'Higher Education / Professional Qualifications (RM)',
                      hint: 'Masters, PhD, or approved courses (up to RM7,000)',
                      controller: _higherEdCtrl,
                      colors: colors,
                    ),
                    _MoneyField(
                      label: 'Upskilling & Self-Enhancement Courses (RM)',
                      hint: 'Sub-capped at RM2,000 within RM7,000 Education pot',
                      controller: _upskillingCtrl,
                      colors: colors,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'First-Time Homebuyer Housing Loan Interest Tier',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<HousingLoanTier>(
                      value: _housingTier,
                      isExpanded: true,
                      dropdownColor: colors.bgElevated,
                      style: TextStyle(color: colors.textPrimary, fontSize: 13),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: colors.bgPrimary,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colors.borderSubtle),
                        ),
                      ),
                      items: HousingLoanTier.values
                          .map(
                            (t) => DropdownMenuItem(
                              value: t,
                              child: Text(
                                t.label,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _housingTier = val);
                        }
                      },
                    ),
                    if (_housingTier != HousingLoanTier.none) ...[
                      const SizedBox(height: 10),
                      _MoneyField(
                        label: 'Annual Housing Loan Interest Paid (RM)',
                        hint: 'Capped at ${_housingTier.annualCap.formatted}',
                        controller: _housingInterestCtrl,
                        colors: colors,
                      ),
                    ],
                    const SizedBox(height: 16),
                    _SectionHeader(
                      title: '4. Direct Lifestyle, Sports & Medical Totals',
                      subtitle:
                          'Optional base totals in addition to itemized receipts logged in the Receipt Classifier.',
                      colors: colors,
                    ),
                    _MoneyField(
                      label:
                          'Lifestyle: AI Subscriptions (ChatGPT, Claude, Copilot) (RM)',
                      hint: 'Shares RM2,500 Gaya Hidup cap',
                      controller: _aiCtrl,
                      colors: colors,
                    ),
                    _MoneyField(
                      label: 'Lifestyle: Home Broadband & Mobile Internet (RM)',
                      hint: 'Shares RM2,500 Gaya Hidup cap',
                      controller: _internetCtrl,
                      colors: colors,
                    ),
                    _MoneyField(
                      label: 'Lifestyle: Books, Journals & Magazines (RM)',
                      hint: 'Shares RM2,500 Gaya Hidup cap',
                      controller: _booksCtrl,
                      colors: colors,
                    ),
                    _MoneyField(
                      label: 'Lifestyle: Smartphone, Tablet, PC / Laptop (RM)',
                      hint: 'Shares RM2,500 Gaya Hidup cap',
                      controller: _devicesCtrl,
                      colors: colors,
                    ),
                    _MoneyField(
                      label: 'Lifestyle: Hobby / Self-Improvement Courses (RM)',
                      hint: 'Shares RM2,500 Gaya Hidup cap',
                      controller: _coursesCtrl,
                      colors: colors,
                    ),
                    _MoneyField(
                      label: 'Sports: Equipment (Excludes Shoes/Apparel) (RM)',
                      hint: 'Shares RM1,000 Sports cap',
                      controller: _sportsEqCtrl,
                      colors: colors,
                    ),
                    _MoneyField(
                      label: 'Sports: Gym Membership & Facility Rental (RM)',
                      hint: 'Shares RM1,000 Sports cap',
                      controller: _sportsGymCtrl,
                      colors: colors,
                    ),
                    _MoneyField(
                      label: 'Sports: Competition Registration Fees (RM)',
                      hint: 'Shares RM1,000 Sports cap',
                      controller: _sportsCompCtrl,
                      colors: colors,
                    ),
                    _MoneyField(
                      label: 'Medical: Serious Diseases & Fertility (RM)',
                      hint: 'Shares RM10,000 Medical cap',
                      controller: _medSeriousCtrl,
                      colors: colors,
                    ),
                    _MoneyField(
                      label: 'Medical: Full Checkup / Mental Health / COVID (RM)',
                      hint: 'Sub-capped at RM1,000',
                      controller: _medCheckupCtrl,
                      colors: colors,
                    ),
                    _MoneyField(
                      label: 'Medical: Dental Treatment (RM)',
                      hint: 'Sub-capped at RM1,000',
                      controller: _medDentalCtrl,
                      colors: colors,
                    ),
                    _MoneyField(
                      label: 'Medical: Vaccinations (RM)',
                      hint: 'Sub-capped at RM1,000',
                      controller: _medVaccineCtrl,
                      colors: colors,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: const Text('Save Tax Configuration'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.accentPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final AppPalette colors;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: colors.accentPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(fontSize: 11.5, color: colors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _MoneyField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final AppPalette colors;

  const _MoneyField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: TextStyle(color: colors.textPrimary, fontSize: 13.5),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: TextStyle(color: colors.textSecondary, fontSize: 12.5),
          hintStyle: TextStyle(color: colors.textMuted, fontSize: 12),
          prefixText: 'RM ',
          prefixStyle: TextStyle(
            color: colors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          filled: true,
          fillColor: colors.bgPrimary,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colors.borderSubtle),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colors.borderSubtle),
          ),
        ),
      ),
    );
  }
}
