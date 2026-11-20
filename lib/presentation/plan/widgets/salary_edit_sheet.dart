import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/money.dart';
import '../../../data/local/app_database.dart';
import '../../../data/providers/database_providers.dart';
import '../../../domain/engine/employment_type.dart';

class SalaryEditSheet extends ConsumerStatefulWidget {
  const SalaryEditSheet({super.key, required this.profile});

  final UserProfileTableData profile;

  static Future<void> show(BuildContext context, UserProfileTableData profile) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SalaryEditSheet(profile: profile),
    );
  }

  @override
  ConsumerState<SalaryEditSheet> createState() => _SalaryEditSheetState();
}

class _SalaryEditSheetState extends ConsumerState<SalaryEditSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _grossSalaryController;
  late final TextEditingController _allowancesController;
  late final TextEditingController _paydayController;
  late double _epfRate;
  late EmploymentType _employmentType;

  bool get _isIntern => _employmentType.isIntern;

  @override
  void initState() {
    super.initState();
    _employmentType = EmploymentType.fromStorage(widget.profile.employmentType);
    _nameController = TextEditingController(text: widget.profile.name);
    _grossSalaryController = TextEditingController(
      text: (widget.profile.grossSalarySen / 100).toStringAsFixed(0),
    );
    _allowancesController = TextEditingController(
      text: (widget.profile.fixedAllowanceSen / 100).toStringAsFixed(0),
    );
    _paydayController = TextEditingController(
      text: widget.profile.paydayDayOfMonth.toString(),
    );
    _epfRate = widget.profile.epfRate > 0 ? widget.profile.epfRate : 0.11;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _grossSalaryController.dispose();
    _allowancesController.dispose();
    _paydayController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final grossRinggit = double.tryParse(
            _grossSalaryController.text.trim().replaceAll(',', '')) ??
        (_isIntern ? 900 : 3000);
    final allowanceRinggit =
        double.tryParse(_allowancesController.text.trim()) ?? 0;
    final payday =
        (int.tryParse(_paydayController.text.trim()) ?? 25).clamp(1, 28);
    final name = _nameController.text.trim();

    await ref.read(profileRepositoryProvider).updateSalary(
          name: name.isEmpty ? widget.profile.name : name,
          employmentType: _employmentType,
          grossSalarySen: Money.fromRinggit(grossRinggit).sen,
          fixedAllowanceSen:
              _isIntern ? 0 : Money.fromRinggit(allowanceRinggit).sen,
          epfRate: _isIntern ? 0.0 : _epfRate,
          hasSocso: !_isIntern,
          hasEis: !_isIntern,
          paydayDayOfMonth: payday,
        );

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Updated profile & income settings')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: 24 + bottomInset,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: colors.outline,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Profile & Income Setup',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _isIntern
                  ? 'Intern allowances are take-home: no EPF, SOCSO or EIS deductions.'
                  : 'Malaysian EPF, SOCSO, EIS & PCB are calculated automatically.',
              style: TextStyle(fontSize: 12, color: colors.textSecondary),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              maxLength: 24,
              style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold),
              decoration: _inputDecoration(
                colors: colors,
                label: 'Your Name',
                icon: Icons.person_rounded,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Employment Status',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                for (final type in EmploymentType.values) ...[
                  Expanded(
                    child: _buildChoiceChip(
                      colors: colors,
                      label: '${type.emoji} ${type.label}',
                      selected: _employmentType == type,
                      onSelected: () => setState(() => _employmentType = type),
                    ),
                  ),
                  if (type != EmploymentType.values.last) const SizedBox(width: 8),
                ],
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _grossSalaryController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold),
              decoration: _inputDecoration(
                colors: colors,
                label: '${_employmentType.incomeLabel} (RM)',
                prefixText: 'RM ',
                icon: Icons.attach_money_rounded,
              ),
            ),
            const SizedBox(height: 12),
            if (!_isIntern) ...[
              TextField(
                controller: _allowancesController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(color: colors.textPrimary),
                decoration: _inputDecoration(
                  colors: colors,
                  label: 'Fixed Allowances (Transport / Phone)',
                  prefixText: 'RM ',
                  icon: Icons.card_giftcard_rounded,
                ),
              ),
              const SizedBox(height: 12),
            ],
            TextField(
              controller: _paydayController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: colors.textPrimary),
              decoration: _inputDecoration(
                colors: colors,
                label: 'Payday of the Month (e.g. 25th)',
                icon: Icons.calendar_month_rounded,
              ),
            ),
            const SizedBox(height: 16),
            if (!_isIntern) ...[
              Text(
                'EPF (KWSP) Employee Contribution Rate',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildChoiceChip(
                      colors: colors,
                      label: '11% (Standard)',
                      selected: _epfRate == 0.11,
                      onSelected: () => setState(() => _epfRate = 0.11),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildChoiceChip(
                      colors: colors,
                      label: '9% (Reduced)',
                      selected: _epfRate == 0.09,
                      onSelected: () => setState(() => _epfRate = 0.09),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ] else
              const SizedBox(height: 4),
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                'Update Settings',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceChip({
    required AppPalette colors,
    required String label,
    required bool selected,
    required VoidCallback onSelected,
  }) {
    return ChoiceChip(
      label: Center(child: Text(label)),
      selected: selected,
      showCheckmark: false,
      selectedColor: colors.primary.withValues(alpha: 0.25),
      backgroundColor: colors.surfaceHigh,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      labelStyle: TextStyle(
        color: selected ? colors.primary : colors.textSecondary,
        fontWeight: FontWeight.bold,
      ),
      side: BorderSide(
        color: selected ? colors.primary : colors.outline,
      ),
      onSelected: (_) => onSelected(),
    );
  }

  InputDecoration _inputDecoration({
    required AppPalette colors,
    required String label,
    required IconData icon,
    String? prefixText,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: colors.textSecondary, fontSize: 13),
      prefixText: prefixText,
      prefixStyle: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold),
      prefixIcon: Icon(icon, color: colors.primary, size: 20),
      counterText: '',
      filled: true,
      fillColor: colors.surfaceHigh,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: colors.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: colors.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: colors.primary, width: 2),
      ),
    );
  }
}
