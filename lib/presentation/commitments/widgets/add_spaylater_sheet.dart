import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_icons.dart';
import '../../../core/utils/money.dart';
import '../../../data/local/app_database.dart';
import '../../../data/providers/dashboard_provider.dart';
import '../../../data/providers/database_providers.dart';

class AddSpayLaterSheet extends ConsumerStatefulWidget {
  final CommitmentsTableData? existingItem;

  const AddSpayLaterSheet({super.key, this.existingItem});

  bool get isEditing => existingItem != null;

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddSpayLaterSheet(),
    );
  }

  static Future<void> edit(BuildContext context, CommitmentsTableData item) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddSpayLaterSheet(existingItem: item),
    );
  }

  @override
  ConsumerState<AddSpayLaterSheet> createState() => _AddSpayLaterSheetState();
}

class _AddSpayLaterSheetState extends ConsumerState<AddSpayLaterSheet> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _customMonthlyController = TextEditingController();

  int _selectedTenure = 3; // 1, 3, 6, 12
  int _monthsAlreadyPaid = 0;
  bool _includeShopeeFee = true;
  int _dueDay = 10; // Shopee default cycle 1
  int _shopeeCycle = 0; // 0: 1st->10th, 1: 11th->20th, 2: 21st->1st, 3: 25th->5th, 4: manual
  int _manualDueDay = 10;
  final _manualDueDayController = TextEditingController(text: '10');
  String _selectedCategoryTag = '🎧 Tech';

  static const _categoryTags = [
    '🎧 Tech',
    '👟 Fashion',
    '🧴 Self-Care',
    '🏠 Home',
    '🎒 Study',
    '📦 Other',
  ];

  static const _tenureOptions = [
    {'months': 1, 'label': '1 mo', 'sub': 'Next Month'},
    {'months': 3, 'label': '3 mo', 'sub': 'Quarterly'},
    {'months': 6, 'label': '6 mo', 'sub': 'Half Year'},
    {'months': 12, 'label': '12 mo', 'sub': '1 Year'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.existingItem != null) {
      final item = widget.existingItem!;
      String rawName = item.title;
      for (final tag in _categoryTags) {
        if (item.title.startsWith(tag)) {
          _selectedCategoryTag = tag;
          rawName = item.title.substring(tag.length).trim();
          break;
        }
      }
      _nameController.text = rawName;
      _priceController.text = (item.totalAmountSen / 100).toStringAsFixed(2);
      _customMonthlyController.text = (item.monthlyPaymentSen / 100).toStringAsFixed(2);
      _selectedTenure = item.totalTenureMonths;
      _monthsAlreadyPaid = (item.totalTenureMonths - item.remainingTenureMonths).clamp(0, 999);
      _includeShopeeFee = item.interestRateAnnual > 0;
      _dueDay = item.dueDayOfMonth;
      _manualDueDay = item.dueDayOfMonth;
      _manualDueDayController.text = item.dueDayOfMonth.toString();
      if (_dueDay == 10) {
        _shopeeCycle = 0;
      } else if (_dueDay == 20) {
        _shopeeCycle = 1;
      } else if (_dueDay == 1) {
        _shopeeCycle = 2;
      } else if (_dueDay == 5) {
        _shopeeCycle = 3;
      } else {
        _shopeeCycle = 4;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _customMonthlyController.dispose();
    _manualDueDayController.dispose();
    super.dispose();
  }

  double get _purchasePrice {
    return double.tryParse(_priceController.text.trim()) ?? 0.0;
  }

  double get _calculatedMonthly {
    if (_purchasePrice <= 0) return 0.0;
    if (_selectedTenure == 1) {
      return _purchasePrice;
    }
    // Shopee charges ~1.5% per month for installment plans
    final feeMultiplier = _includeShopeeFee ? (1 + (0.015 * _selectedTenure)) : 1.0;
    final totalWithFee = _purchasePrice * feeMultiplier;
    return totalWithFee / _selectedTenure;
  }

  double get _activeMonthly {
    final customText = _customMonthlyController.text.trim();
    if (customText.isNotEmpty) {
      final manual = double.tryParse(customText) ?? 0.0;
      if (manual > 0) return manual;
    }
    return _calculatedMonthly;
  }

  double get _totalCost {
    if (_selectedTenure == 1) return _purchasePrice;
    if (_includeShopeeFee) {
      return _purchasePrice * (1 + (0.015 * _selectedTenure));
    }
    return _purchasePrice;
  }

  int get _remainingTenure {
    final remaining = _selectedTenure - _monthsAlreadyPaid;
    return remaining > 0 ? remaining : 1;
  }

  double get _remainingCost {
    return _activeMonthly * _remainingTenure;
  }

  Future<void> _saveSpayLaterItem() async {
    final rawName = _nameController.text.trim();
    if (rawName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the item name')),
      );
      return;
    }

    if (_purchasePrice <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid purchase price')),
      );
      return;
    }

    final formattedTitle = '$_selectedCategoryTag $rawName';
    final totalSen = Money.fromRinggit(_totalCost).sen;
    final monthlySen = Money.fromRinggit(_activeMonthly).sen;
    final remainingSen = Money.fromRinggit(_remainingCost).sen;

    if (widget.isEditing) {
      await ref.read(commitmentRepositoryProvider).updateCommitment(
            id: widget.existingItem!.id,
            title: formattedTitle,
            type: 'spaylater',
            totalAmountSen: totalSen,
            monthlyPaymentSen: monthlySen,
            remainingAmountSen: remainingSen,
            interestRateAnnual: _includeShopeeFee ? 0.18 : 0.0,
            totalTenureMonths: _selectedTenure,
            remainingTenureMonths: _remainingTenure,
            dueDayOfMonth: _dueDay,
            isActive: remainingSen > 0 && _remainingTenure > 0,
          );
    } else {
      await ref.read(commitmentRepositoryProvider).addCommitment(
            title: formattedTitle,
            type: 'spaylater',
            totalAmountSen: totalSen,
            monthlyPaymentSen: monthlySen,
            remainingAmountSen: remainingSen,
            interestRateAnnual: _includeShopeeFee ? 0.18 : 0.0, // 1.5% x 12
            totalTenureMonths: _selectedTenure,
            remainingTenureMonths: _remainingTenure,
            dueDayOfMonth: _dueDay,
          );
    }

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.surfaceHigh,
          content: Text(
            widget.isEditing
                ? 'Updated $rawName (RM ${_activeMonthly.toStringAsFixed(2)}/mo, $_remainingTenure months left)'
                : 'Added $rawName (RM ${_activeMonthly.toStringAsFixed(2)}/mo, $_remainingTenure months left)',
            style: TextStyle(color: AppColors.textPrimary),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final dashboardAsync = ref.watch(dashboardStateProvider);

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: 24 + bottomInset,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
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
                  color: AppColors.outline,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEE4D2D).withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFFEE4D2D).withValues(alpha: 0.4),
                    ),
                  ),
                  child: const Icon(Icons.shopping_bag_rounded, size: 22, color: Color(0xFFEE4D2D)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.isEditing
                            ? 'Edit SPayLater Purchase'
                            : 'Add SPayLater Purchase',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Track item, months left & allowance impact',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              'Category Tag',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _categoryTags.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final tag = _categoryTags[i];
                  final isSelected = tag == _selectedCategoryTag;
                  return ChoiceChip(
                    avatar: Icon(
                      AppIcons.getSpayLaterTagIcon(tag),
                      size: 14,
                      color: isSelected ? AppColors.accent : AppColors.textSecondary,
                    ),
                    label: Text(tag, style: const TextStyle(fontSize: 12)),
                    selected: isSelected,
                    selectedColor: AppColors.accent.withValues(alpha: 0.25),
                    backgroundColor: AppColors.surfaceHigh,
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.accent : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    side: BorderSide(
                      color: isSelected ? AppColors.accent : AppColors.outline,
                    ),
                    onSelected: (_) {
                      setState(() => _selectedCategoryTag = tag);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _nameController,
              style: TextStyle(color: AppColors.textPrimary),
              decoration: _inputDecoration(
                hint: 'e.g. Mechanical Keyboard, Sneakers, Earbuds',
                label: 'Item Name / Description',
                icon: Icons.shopping_cart_outlined,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _priceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(color: AppColors.textPrimary),
              onChanged: (_) => setState(() {}),
              decoration: _inputDecoration(
                hint: 'e.g. 180.00',
                label: 'Total Purchase Price (RM)',
                icon: Icons.attach_money_rounded,
                prefixText: 'RM ',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Installment Plan (Tenure)',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: _tenureOptions.map((opt) {
                final months = opt['months'] as int;
                final isSelected = _selectedTenure == months;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedTenure = months;
                          if (_monthsAlreadyPaid >= _selectedTenure) {
                            _monthsAlreadyPaid = 0;
                          }
                          // Automatically turn off Shopee fee for 1 month
                          if (_selectedTenure == 1) {
                            _includeShopeeFee = false;
                          }
                        });
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.accent.withValues(alpha: 0.2)
                              : AppColors.surfaceHigh,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected ? AppColors.accent : AppColors.outline,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              opt['label'] as String,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? AppColors.accent
                                    : AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              opt['sub'] as String,
                              style: TextStyle(
                                fontSize: 10,
                                color: isSelected
                                    ? AppColors.accent.withValues(alpha: 0.8)
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            if (_selectedTenure > 1)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceHigh,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.outline),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Shopee 1.5%/mo processing fee',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Standard Shopee BNPL installment charge',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch.adaptive(
                      value: _includeShopeeFee,
                      activeColor: AppColors.accent,
                      onChanged: (val) {
                        setState(() => _includeShopeeFee = val);
                      },
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceHigh,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.outline),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment Progress',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$_monthsAlreadyPaid paid · $_remainingTenure months left',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, size: 20),
                    color: _monthsAlreadyPaid > 0
                        ? AppColors.textPrimary
                        : AppColors.textSecondary.withValues(alpha: 0.4),
                    onPressed: _monthsAlreadyPaid > 0
                        ? () => setState(() => _monthsAlreadyPaid--)
                        : null,
                  ),
                  Text(
                    '$_monthsAlreadyPaid',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, size: 20),
                    color: _monthsAlreadyPaid < (_selectedTenure - 1)
                        ? AppColors.textPrimary
                        : AppColors.textSecondary.withValues(alpha: 0.4),
                    onPressed: _monthsAlreadyPaid < (_selectedTenure - 1)
                        ? () => setState(() => _monthsAlreadyPaid++)
                        : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceHigh,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.outline),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_today_rounded, size: 16, color: Color(0xFFEE4D2D)),
                          SizedBox(width: 8),
                          Text(
                            'Shopee Due Date Cycle',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEE4D2D).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Due on ${_dueDay == 1 ? "1st" : _dueDay == 2 ? "2nd" : _dueDay == 3 ? "3rd" : "${_dueDay}th"}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFEE4D2D),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Select your Shopee bill cycle or set manually:',
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildShopeeCycleChip(0, 'Bill: 1st', 'Due: 10th', 10),
                      _buildShopeeCycleChip(1, 'Bill: 11th', 'Due: 20th', 20),
                      _buildShopeeCycleChip(2, 'Bill: 21st', 'Due: 1st', 1),
                      _buildShopeeCycleChip(3, 'Bill: 25th', 'Due: 5th', 5),
                      ChoiceChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.tune_rounded, size: 12, color: _shopeeCycle == 4 ? AppColors.accent : AppColors.textSecondary),
                            const SizedBox(width: 4),
                            const Text('Manual Set'),
                          ],
                        ),
                        selected: _shopeeCycle == 4,
                        selectedColor: AppColors.accent.withValues(alpha: 0.25),
                        backgroundColor: AppColors.surface,
                        labelStyle: TextStyle(
                          fontSize: 11,
                          color: _shopeeCycle == 4 ? AppColors.accent : AppColors.textSecondary,
                          fontWeight: _shopeeCycle == 4 ? FontWeight.bold : FontWeight.normal,
                        ),
                        side: BorderSide(
                          color: _shopeeCycle == 4 ? AppColors.accent : AppColors.outline,
                        ),
                        onSelected: (_) => setState(() {
                          _shopeeCycle = 4;
                          _dueDay = _manualDueDay;
                        }),
                      ),
                    ],
                  ),
                  if (_shopeeCycle == 4) ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: _manualDueDayController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        labelText: 'Manual Due Day of Month (1 - 31)',
                        labelStyle: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                        hintText: 'e.g. 15',
                        filled: true,
                        fillColor: AppColors.surface,
                        isDense: true,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onChanged: (val) {
                        final parsed = int.tryParse(val.trim());
                        if (parsed != null && parsed >= 1 && parsed <= 31) {
                          setState(() {
                            _manualDueDay = parsed;
                            _dueDay = parsed;
                          });
                        }
                      },
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _customMonthlyController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(color: AppColors.textPrimary),
              onChanged: (_) => setState(() {}),
              decoration: _inputDecoration(
                hint: _calculatedMonthly > 0 ? _calculatedMonthly.toStringAsFixed(2) : 'e.g. 52.25',
                label: 'Exact Monthly Amount (Optional override)',
                icon: Icons.edit_note_rounded,
                prefixText: 'RM ',
              ),
            ),
            const SizedBox(height: 16),
            dashboardAsync.maybeWhen(
              data: (dash) {
                final netIncome = dash.netSalary.netSalary;
                final incomeSen = netIncome.sen;
                final monthlyRinggit = _activeMonthly;
                final monthlySen = Money.fromRinggit(monthlyRinggit).sen;

                // Existing active SPayLater monthly commitments
                final currentSpayLaterMonthlySen = dash.activeCommitments
                    .where((c) => c.type.toLowerCase() == 'spaylater')
                    .fold<int>(0, (sum, c) => sum + c.monthlyPaymentSen);

                final newTotalSpayLaterSen =
                    currentSpayLaterMonthlySen + monthlySen;
                final itemImpactRatio = incomeSen > 0
                    ? (monthlySen / incomeSen) * 100
                    : 0.0;
                final totalImpactRatio = incomeSen > 0
                    ? (newTotalSpayLaterSen / incomeSen) * 100
                    : 0.0;

                Color impactColor;
                String impactStatus;
                if (totalImpactRatio <= 10) {
                  impactColor = AppColors.success;
                  impactStatus = 'Safe & Manageable';
                } else if (totalImpactRatio <= 20) {
                  impactColor = AppColors.warning;
                  impactStatus = 'Moderate Burden';
                } else {
                  impactColor = AppColors.danger;
                  impactStatus = 'High Burden on Allowance';
                }

                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: impactColor.withValues(alpha: 0.09),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: impactColor.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Icon(Icons.analytics_rounded,
                                    color: impactColor, size: 18),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Impact Summary',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: impactColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              impactStatus,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: impactColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Monthly Installment',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textSecondary)),
                              Text(
                                'RM ${monthlyRinggit.toStringAsFixed(2)} / mo',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Total with Fees',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textSecondary)),
                              Text(
                                'RM ${_totalCost.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Uses ${itemImpactRatio.toStringAsFixed(1)}% of income. Total SPayLater: ${totalImpactRatio.toStringAsFixed(1)}% (${Money(newTotalSpayLaterSen).formatted}/mo).',
                        style: TextStyle(
                          fontSize: 11,
                          height: 1.35,
                          color: impactColor,
                        ),
                      ),
                    ],
                  ),
                );
              },
              orElse: () => const SizedBox.shrink(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveSpayLaterItem,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 0,
              ),
              child: Text(
                widget.isEditing
                    ? 'Save Changes'
                    : 'Track SPayLater Purchase',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required String label,
    required IconData icon,
    String? prefixText,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: AppColors.textSecondary, fontSize: 13),
      hintText: hint,
      hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 13),
      prefixText: prefixText,
      prefixStyle: TextStyle(
          color: AppColors.textPrimary, fontWeight: FontWeight.bold),
      prefixIcon: Icon(icon, color: AppColors.accent, size: 20),
      filled: true,
      fillColor: AppColors.surfaceHigh,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.accent, width: 2),
      ),
    );
  }

  Widget _buildShopeeCycleChip(int cycleIndex, String billLabel, String dueLabel, int targetDueDay) {
    final isSelected = _shopeeCycle == cycleIndex;
    return ChoiceChip(
      label: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(billLabel, style: TextStyle(fontSize: 10, color: isSelected ? const Color(0xFFEE4D2D) : AppColors.textSecondary)),
          Text(dueLabel, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.w600, color: isSelected ? AppColors.textPrimary : AppColors.textPrimary)),
        ],
      ),
      selected: isSelected,
      selectedColor: const Color(0xFFEE4D2D).withValues(alpha: 0.25),
      backgroundColor: AppColors.surface,
      side: BorderSide(
        color: isSelected ? const Color(0xFFEE4D2D) : AppColors.outline,
        width: isSelected ? 1.5 : 1.0,
      ),
      onSelected: (_) {
        setState(() {
          _shopeeCycle = cycleIndex;
          _dueDay = targetDueDay;
        });
      },
    );
  }
}
