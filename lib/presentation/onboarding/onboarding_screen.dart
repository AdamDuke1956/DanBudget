import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/money.dart';
import '../../data/providers/database_providers.dart';
import '../../domain/engine/employment_type.dart';
import '../../domain/engine/net_salary_calculator.dart';
import 'widgets/employment_step.dart';
import 'widgets/income_step.dart';
import 'widgets/name_step.dart';
import 'widgets/onboarding_widgets.dart';
import 'widgets/payday_step.dart';

/// First-run wizard: name -> employment type -> income -> payday & starters.
///
/// On completion the profile is saved with `isOnboarded = true`; the root
/// router (`AppRoot`) reacts to the profile stream and swaps in the main app.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  static const int _totalSteps = 4;
  static const int _lastStep = _totalSteps - 1;
  static const Duration _pageDuration = Duration(milliseconds: 350);

  final PageController _pageController = PageController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _incomeController = TextEditingController();

  int _step = 0;
  bool _saving = false;

  EmploymentType? _employmentType;
  double _epfRate = 0.11;
  int _payday = 25;

  /// True once the user typed / tapped an amount, so we stop overwriting it
  /// with the default when they switch employment type.
  bool _incomeEdited = false;
  bool _startersTouched = false;
  final Set<String> _starterIds = {};

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _incomeController.dispose();
    super.dispose();
  }

  double get _incomeRinggit =>
      IncomeStep.parseRinggit(_incomeController.text) ?? 0;

  bool get _canContinue {
    switch (_step) {
      case 0:
        return _nameController.text.trim().isNotEmpty;
      case 1:
        return _employmentType != null;
      case 2:
        final amount = _incomeRinggit;
        return amount > 0 && amount <= 999999;
      default:
        return true;
    }
  }

  Money get _netIncome {
    final type = _employmentType ?? EmploymentType.intern;
    return NetSalaryCalculator.calculate(
      grossSalary: Money.fromRinggit(_incomeRinggit),
      employmentType: type,
      epfRate: _epfRate,
    ).netSalary;
  }

  void _onEmploymentSelected(EmploymentType type) {
    setState(() {
      _employmentType = type;
      if (!_incomeEdited) {
        _incomeController.text = type.isIntern ? '900' : '3000';
      }
      if (!_startersTouched) {
        _starterIds
          ..clear()
          ..addAll(type.isIntern ? {'my50'} : <String>{});
      }
    });
  }

  void _onIncomeChanged(String _) => setState(() => _incomeEdited = true);

  void _onIncomePreset(int ringgit) {
    setState(() {
      _incomeEdited = true;
      _incomeController.text = ringgit.toString();
    });
  }

  void _onStarterToggled(String id) {
    setState(() {
      _startersTouched = true;
      if (!_starterIds.add(id)) _starterIds.remove(id);
    });
  }

  Future<void> _goToStep(int step) async {
    FocusScope.of(context).unfocus();
    setState(() => _step = step);
    await _pageController.animateToPage(
      step,
      duration: _pageDuration,
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _next() async {
    if (!_canContinue || _saving) return;
    if (_step < _lastStep) {
      await _goToStep(_step + 1);
    } else {
      await _finish();
    }
  }

  Future<void> _back() async {
    if (_step == 0 || _saving) return;
    await _goToStep(_step - 1);
  }

  Future<void> _finish() async {
    final type = _employmentType;
    if (type == null) return;

    setState(() => _saving = true);
    HapticFeedback.mediumImpact();

    try {
      await ref.read(profileRepositoryProvider).completeOnboarding(
            name: _nameController.text,
            employmentType: type,
            incomeSen: Money.fromRinggit(_incomeRinggit).sen,
            paydayDayOfMonth: _payday,
            epfRate: _epfRate,
            starterCommitments: kStarterOptions
                .where((o) => _starterIds.contains(o.id))
                .map((o) => o.toCommitment())
                .toList(),
          );
      // Success: the profile stream emits isOnboarded = true and AppRoot
      // swaps this screen out, so there is nothing else to do here.
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Couldn't save your setup. Please try again. ($e)")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _StepPage(
                      child: NameStep(
                        controller: _nameController,
                        onChanged: (_) => setState(() {}),
                        onSubmitted: _next,
                      ),
                    ),
                    _StepPage(
                      child: EmploymentStep(
                        selected: _employmentType,
                        onSelected: _onEmploymentSelected,
                      ),
                    ),
                    _StepPage(
                      child: IncomeStep(
                        employmentType:
                            _employmentType ?? EmploymentType.intern,
                        controller: _incomeController,
                        onChanged: _onIncomeChanged,
                        onPresetSelected: _onIncomePreset,
                        epfRate: _epfRate,
                        onEpfRateChanged: (v) => setState(() => _epfRate = v),
                      ),
                    ),
                    _StepPage(
                      child: PaydayStep(
                        employmentType:
                            _employmentType ?? EmploymentType.intern,
                        netIncome: _netIncome,
                        payday: _payday,
                        onPaydayChanged: (v) => setState(() => _payday = v),
                        selectedStarterIds: _starterIds,
                        onStarterToggled: _onStarterToggled,
                      ),
                    ),
                  ],
                ),
              ),
              _buildBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 24, 0),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _step == 0 ? 0 : 1,
              child: IconButton(
                key: const Key('onboarding_back_button'),
                onPressed: _step == 0 ? null : _back,
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          Expanded(
            child: OnboardingProgressBar(
              currentStep: _step,
              totalSteps: _totalSteps,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${_step + 1}/$_totalSteps',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final isLast = _step == _lastStep;
    final enabled = _canContinue && !_saving;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          key: const Key('onboarding_continue_button'),
          onPressed: enabled ? _next : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            disabledBackgroundColor: AppColors.surfaceHigh,
            disabledForegroundColor: AppColors.textSecondary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: _saving
              ? SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppColors.onPrimary,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isLast ? 'Start My Budget Journey' : 'Continue',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      isLast
                          ? Icons.rocket_launch_rounded
                          : Icons.arrow_forward_rounded,
                      size: 20,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

/// Scrollable page body with a subtle fade + slide-in when first built.
class _StepPage extends StatelessWidget {
  const _StepPage({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(offset: Offset(0, (1 - t) * 18), child: child),
      ),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        child: child,
      ),
    );
  }
}
