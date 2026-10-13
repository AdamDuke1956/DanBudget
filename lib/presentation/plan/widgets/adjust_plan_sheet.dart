import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/money.dart';
import '../../../data/local/app_database.dart';
import '../../../data/providers/database_providers.dart';
import '../../../domain/engine/allocation_engine.dart';
import '../../../domain/engine/employment_type.dart';

class AdjustPlanSheet extends ConsumerStatefulWidget {
  final UserProfileTableData profile;
  final Money netSalary;
  final Money totalCommitments;

  const AdjustPlanSheet({
    super.key,
    required this.profile,
    required this.netSalary,
    required this.totalCommitments,
  });

  static Future<void> show(
    BuildContext context, {
    required UserProfileTableData profile,
    required Money netSalary,
    required Money totalCommitments,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AdjustPlanSheet(
        profile: profile,
        netSalary: netSalary,
        totalCommitments: totalCommitments,
      ),
    );
  }

  @override
  ConsumerState<AdjustPlanSheet> createState() => _AdjustPlanSheetState();
}

class _AdjustPlanSheetState extends ConsumerState<AdjustPlanSheet> {
  late String _selectedPreset;
  late double _needsPct;
  late double _wantsPct;
  late double _savingsPct;
  late double _givingPct;

  @override
  void initState() {
    super.initState();
    _selectedPreset = widget.profile.budgetPreset;

    final isIntern = widget.profile.employmentType == 'intern';
    final active = AllocationPreset.getPreset(
      presetKey: _selectedPreset,
      type: isIntern ? EmploymentType.intern : EmploymentType.fullTime,
      customNeeds: widget.profile.customNeedsRatio,
      customWants: widget.profile.customWantsRatio,
      customSavings: widget.profile.customSavingsRatio,
      customGiving: widget.profile.customGivingRatio,
    );

    _needsPct = (active.needs * 100).roundToDouble();
    _wantsPct = (active.wants * 100).roundToDouble();
    _savingsPct = (active.savings * 100).roundToDouble();
    _givingPct = (active.giving * 100).roundToDouble();
  }

  void _applyPreset(String key) {
    setState(() {
      _selectedPreset = key;
      final isIntern = widget.profile.employmentType == 'intern';

      if (key == 'recommended') {
        final p = isIntern ? AllocationPreset.intern : AllocationPreset.fullTime;
        _needsPct = (p.needs * 100).roundToDouble();
        _wantsPct = (p.wants * 100).roundToDouble();
        _savingsPct = (p.savings * 100).roundToDouble();
        _givingPct = (p.giving * 100).roundToDouble();
      } else if (key == 'fire_saver') {
        final p = isIntern ? AllocationPreset.fireIntern : AllocationPreset.fireFullTime;
        _needsPct = (p.needs * 100).roundToDouble();
        _wantsPct = (p.wants * 100).roundToDouble();
        _savingsPct = (p.savings * 100).roundToDouble();
        _givingPct = (p.giving * 100).roundToDouble();
      } else if (key == 'lean') {
        final p = isIntern ? AllocationPreset.leanIntern : AllocationPreset.leanFullTime;
        _needsPct = (p.needs * 100).roundToDouble();
        _wantsPct = (p.wants * 100).roundToDouble();
        _savingsPct = (p.savings * 100).roundToDouble();
        _givingPct = (p.giving * 100).roundToDouble();
      }
    });
  }

  double get _totalSum => _needsPct + _wantsPct + _savingsPct + _givingPct;

  void _autoBalance() {
    final diff = 100.0 - _totalSum;
    setState(() {
      // Add or deduct remainder from Wants or Savings
      if (_wantsPct + diff >= 5) {
        _wantsPct += diff;
      } else if (_savingsPct + diff >= 5) {
        _savingsPct += diff;
      } else {
        _needsPct += diff;
      }
    });
  }

  Future<void> _savePlan() async {
    if (_totalSum != 100.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Allocation total is ${_totalSum.toInt()}%. Please balance to 100%.'),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    await ref.read(profileRepositoryProvider).updateBudgetPlan(
          budgetPreset: _selectedPreset,
          customNeedsRatio: _needsPct / 100.0,
          customWantsRatio: _wantsPct / 100.0,
          customSavingsRatio: _savingsPct / 100.0,
          customGivingRatio: _givingPct / 100.0,
        );

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.surfaceHigh,
          content: Text(
            'Budget allocation updated!',
            style: TextStyle(color: AppColors.textPrimary),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isIntern = widget.profile.employmentType == 'intern';

    final needsRinggit = widget.netSalary.scale(_needsPct / 100.0);
    final wantsRinggit = widget.netSalary.scale(_wantsPct / 100.0);
    final savingsRinggit = widget.netSalary.scale(_savingsPct / 100.0);
    final givingRinggit = widget.netSalary.scale(_givingPct / 100.0);

    final commitmentsExceedNeeds =
        widget.totalCommitments.sen > 0 && widget.totalCommitments.sen > needsRinggit.sen;

    final isBalanced = _totalSum == 100.0;

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: 24 + bottomInset,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
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
                  color: AppColors.outline,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Adjust Budget Plan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isBalanced
                        ? AppColors.success.withValues(alpha: 0.15)
                        : AppColors.danger.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isBalanced ? AppColors.success : AppColors.danger,
                    ),
                  ),
                  child: Text(
                    isBalanced ? '100% Balanced' : '${_totalSum.toInt()}% / 100%',
                    style: TextStyle(
                      color: isBalanced ? AppColors.success : AppColors.danger,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Customize how your ${isIntern ? "RM 900 allowance" : "net take-home pay"} is split across buckets.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),

            Text(
              'Plan Strategy Presets',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildPresetChip(
                  key: 'recommended',
                  label: isIntern ? 'Recommended (60/20/15/5)' : 'Recommended (40/30/20/10)',
                  icon: Icons.recommend_rounded,
                ),
                _buildPresetChip(
                  key: 'fire_saver',
                  label: isIntern ? 'FIRE Saver (50/10/35/5)' : 'FIRE Saver (35/15/45/5)',
                  icon: Icons.savings_rounded,
                ),
                _buildPresetChip(
                  key: 'lean',
                  label: isIntern ? 'Lean / Survival (70/15/10/5)' : 'Lean (55/20/20/5)',
                  icon: Icons.shield_rounded,
                ),
                _buildPresetChip(
                  key: 'custom',
                  label: 'Custom Sliders',
                  icon: Icons.tune_rounded,
                ),
              ],
            ),
            const SizedBox(height: 16),

            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 12,
                child: Row(
                  children: [
                    if (_needsPct > 0)
                      Expanded(
                        flex: _needsPct.toInt(),
                        child: Container(color: AppColors.needs),
                      ),
                    if (_wantsPct > 0)
                      Expanded(
                        flex: _wantsPct.toInt(),
                        child: Container(color: AppColors.wants),
                      ),
                    if (_savingsPct > 0)
                      Expanded(
                        flex: _savingsPct.toInt(),
                        child: Container(color: AppColors.savings),
                      ),
                    if (_givingPct > 0)
                      Expanded(
                        flex: _givingPct.toInt(),
                        child: Container(color: AppColors.giving),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            if (commitmentsExceedNeeds)
              Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded, color: AppColors.warning, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Your fixed loans (${widget.totalCommitments.formatted}) exceed this Needs cap (${needsRinggit.formatted}). Needs will automatically expand to keep you solvent.',
                        style: TextStyle(fontSize: 11, color: AppColors.textPrimary, height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),

            _buildSliderRow(
              name: 'Needs (Bills & Survival)',
              pct: _needsPct,
              amount: needsRinggit,
              color: AppColors.needs,
              onChanged: (val) {
                setState(() {
                  _selectedPreset = 'custom';
                  _needsPct = val;
                });
              },
            ),
            _buildSliderRow(
              name: 'Wants (Lifestyle & Leisure)',
              pct: _wantsPct,
              amount: wantsRinggit,
              color: AppColors.wants,
              onChanged: (val) {
                setState(() {
                  _selectedPreset = 'custom';
                  _wantsPct = val;
                });
              },
            ),
            _buildSliderRow(
              name: 'Savings & Emergency Fund',
              pct: _savingsPct,
              amount: savingsRinggit,
              color: AppColors.savings,
              onChanged: (val) {
                setState(() {
                  _selectedPreset = 'custom';
                  _savingsPct = val;
                });
              },
            ),
            _buildSliderRow(
              name: 'Charity',
              pct: _givingPct,
              amount: givingRinggit,
              color: AppColors.giving,
              onChanged: (val) {
                setState(() {
                  _selectedPreset = 'custom';
                  _givingPct = val;
                });
              },
            ),

            if (!isBalanced) ...[
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: _autoBalance,
                icon: const Icon(Icons.auto_fix_high_rounded, size: 16),
                label: const Text('Auto-Balance to 100%'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ],

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: isBalanced ? _savePlan : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                disabledBackgroundColor: AppColors.surfaceHigh,
                disabledForegroundColor: AppColors.textSecondary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                elevation: 0,
              ),
              child: Text(
                isBalanced ? 'Save Budget Plan' : 'Balance to 100% to Save',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetChip({
    required String key,
    required String label,
    required IconData icon,
  }) {
    final isSelected = _selectedPreset == key;
    return ChoiceChip(
      avatar: Icon(
        icon,
        size: 15,
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
      ),
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.primary.withValues(alpha: 0.22),
      backgroundColor: AppColors.surfaceHigh,
      labelStyle: TextStyle(
        fontSize: 12,
        color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? AppColors.primary : AppColors.outline,
      ),
      onSelected: (_) => _applyPreset(key),
    );
  }

  Widget _buildSliderRow({
    required String name,
    required double pct,
    required Money amount,
    required Color color,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            Text(
              '${pct.toInt()}% (${amount.formatted})',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: color,
            thumbColor: color,
            inactiveTrackColor: AppColors.surfaceHigh,
            trackHeight: 4,
          ),
          child: Slider(
            value: pct.clamp(0.0, 100.0),
            min: 0,
            max: 100,
            divisions: 20, // 5% increments
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
