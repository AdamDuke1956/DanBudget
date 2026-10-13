import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_icons.dart';
import '../../../core/utils/money.dart';
import '../../../data/local/app_database.dart';
import '../../../data/providers/database_providers.dart';
import 'add_spaylater_sheet.dart';

class AddCommitmentSheet extends ConsumerStatefulWidget {
  final CommitmentsTableData? existingCommitment;

  const AddCommitmentSheet({super.key, this.existingCommitment});

  bool get isEditing => existingCommitment != null;

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddCommitmentSheet(),
    );
  }

  static Future<void> edit(BuildContext context, CommitmentsTableData commitment) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddCommitmentSheet(existingCommitment: commitment),
    );
  }

  @override
  ConsumerState<AddCommitmentSheet> createState() => _AddCommitmentSheetState();
}

class _AddCommitmentSheetState extends ConsumerState<AddCommitmentSheet> {
  final _titleController = TextEditingController();
  final _totalAmountController = TextEditingController();
  final _remainingAmountController = TextEditingController();
  final _monthlyPaymentController = TextEditingController();
  final _tenureMonthsController = TextEditingController(text: '12');
  final _remainingTenureMonthsController = TextEditingController(text: '12');
  final _dueDayController = TextEditingController(text: '10');

  String _selectedType = 'spaylater';

  static const _commitmentTypes = [
    {'type': 'spaylater', 'label': 'SPayLater'},
    {'type': 'ptptn', 'label': 'PTPTN'},
    {'type': 'mara', 'label': 'Pinjaman MARA'},
    {'type': 'car_loan', 'label': 'Car Loan'},
    {'type': 'sloan', 'label': 'Shopee SLoan'},
    {'type': 'credit_card', 'label': 'Credit Card'},
    {'type': 'personal_loan', 'label': 'Personal Loan'},
    {'type': 'other', 'label': 'Other'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.existingCommitment != null) {
      final c = widget.existingCommitment!;
      _titleController.text = c.title;
      _selectedType = c.type;
      _totalAmountController.text = (c.totalAmountSen / 100).toStringAsFixed(2);
      _remainingAmountController.text = (c.remainingAmountSen / 100).toStringAsFixed(2);
      _monthlyPaymentController.text = (c.monthlyPaymentSen / 100).toStringAsFixed(2);
      _tenureMonthsController.text = c.totalTenureMonths.toString();
      _remainingTenureMonthsController.text = c.remainingTenureMonths.toString();
      _dueDayController.text = c.dueDayOfMonth.toString();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _totalAmountController.dispose();
    _remainingAmountController.dispose();
    _monthlyPaymentController.dispose();
    _tenureMonthsController.dispose();
    _remainingTenureMonthsController.dispose();
    _dueDayController.dispose();
    super.dispose();
  }

  Future<void> _saveCommitment() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a commitment name')),
      );
      return;
    }

    final totalRinggit = double.tryParse(_totalAmountController.text.trim()) ?? 0;
    final monthlyRinggit = double.tryParse(_monthlyPaymentController.text.trim()) ?? 0;

    if (monthlyRinggit <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid monthly installment amount')),
      );
      return;
    }

    final totalSen = totalRinggit > 0
        ? Money.fromRinggit(totalRinggit).sen
        : Money.fromRinggit(monthlyRinggit * 12).sen;
    final monthlySen = Money.fromRinggit(monthlyRinggit).sen;
    final tenureMonths = int.tryParse(_tenureMonthsController.text.trim()) ?? 12;
    final remainingTenure = int.tryParse(_remainingTenureMonthsController.text.trim()) ?? tenureMonths;
    final dueDay = (int.tryParse(_dueDayController.text.trim()) ?? 10).clamp(1, 31);

    final remainingRinggit = double.tryParse(_remainingAmountController.text.trim());
    final remainingSen = (remainingRinggit != null && remainingRinggit >= 0)
        ? Money.fromRinggit(remainingRinggit).sen
        : (widget.isEditing
            ? widget.existingCommitment!.remainingAmountSen
            : totalSen);

    if (widget.isEditing) {
      await ref.read(commitmentRepositoryProvider).updateCommitment(
            id: widget.existingCommitment!.id,
            title: title,
            type: _selectedType,
            totalAmountSen: totalSen,
            monthlyPaymentSen: monthlySen,
            remainingAmountSen: remainingSen,
            totalTenureMonths: tenureMonths,
            remainingTenureMonths: remainingTenure,
            dueDayOfMonth: dueDay,
            isActive: remainingSen > 0 && remainingTenure > 0,
          );
    } else {
      await ref.read(commitmentRepositoryProvider).addCommitment(
            title: title,
            type: _selectedType,
            totalAmountSen: totalSen,
            monthlyPaymentSen: monthlySen,
            remainingAmountSen: totalSen,
            totalTenureMonths: tenureMonths,
            remainingTenureMonths: tenureMonths,
            dueDayOfMonth: dueDay,
          );
    }

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.surfaceHigh,
          content: Text(
            widget.isEditing
                ? 'Updated $title (RM ${monthlyRinggit.toStringAsFixed(2)}/mo)'
                : 'Added $title (RM ${monthlyRinggit.toStringAsFixed(2)}/mo)',
            style: TextStyle(color: AppColors.textPrimary),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

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

            Text(
              widget.isEditing
                  ? 'Edit Commitment'
                  : 'Add Commitment / Installment',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),

            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _commitmentTypes.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final t = _commitmentTypes[i];
                  final isSelected = t['type'] == _selectedType;
                  final typeIcon = AppIcons.getCommitmentIcon(t['type']!);
                  return ChoiceChip(
                    avatar: Icon(
                      typeIcon,
                      size: 15,
                      color: isSelected ? AppColors.accent : AppColors.textSecondary,
                    ),
                    label: Text(t['label']!),
                    selected: isSelected,
                    selectedColor: AppColors.accent.withValues(alpha: 0.22),
                    backgroundColor: AppColors.surfaceHigh,
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    side: BorderSide(
                      color: isSelected ? AppColors.accent : AppColors.outline,
                    ),
                    onSelected: (_) {
                      setState(() {
                        _selectedType = t['type']!;
                        if (_titleController.text.isEmpty) {
                          _titleController.text = t['label']!;
                        }
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 14),

            if (_selectedType == 'spaylater')
              Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEE4D2D).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFFEE4D2D).withValues(alpha: 0.35),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.tips_and_updates_outlined, size: 20, color: Color(0xFFEE4D2D)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tracking individual Shopee items?',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Use the SPayLater tracker to calculate months left, Shopee fees & allowance impact.',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        AddSpayLaterSheet.show(context);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFEE4D2D).withValues(alpha: 0.25),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Open',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            TextField(
              controller: _titleController,
              style: TextStyle(color: AppColors.textPrimary),
              decoration: _inputDecoration(
                hint: 'e.g. iPhone 15 SPayLater, Myvi Hire Purchase',
                label: 'Commitment Name',
                icon: Icons.label_rounded,
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _monthlyPaymentController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(color: AppColors.textPrimary),
              decoration: _inputDecoration(
                hint: 'e.g. 250.00',
                label: 'Monthly Installment (RM)',
                icon: Icons.payments_rounded,
                prefixText: 'RM ',
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _totalAmountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(color: AppColors.textPrimary),
              decoration: _inputDecoration(
                hint: 'e.g. 3000.00',
                label: 'Total Loan / Original Principal (RM)',
                icon: Icons.account_balance_rounded,
                prefixText: 'RM ',
              ),
            ),
            const SizedBox(height: 12),

            if (widget.isEditing) ...[
              TextField(
                controller: _remainingAmountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(color: AppColors.textPrimary),
                decoration: _inputDecoration(
                  hint: 'e.g. 1500.00',
                  label: 'Current Remaining Balance (RM)',
                  icon: Icons.price_change_rounded,
                  prefixText: 'RM ',
                ),
              ),
              const SizedBox(height: 12),
            ],

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tenureMonthsController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: AppColors.textPrimary),
                    decoration: _inputDecoration(
                      hint: '12',
                      label: 'Total Tenure (Mo)',
                      icon: Icons.timelapse_rounded,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                if (widget.isEditing)
                  Expanded(
                    child: TextField(
                      controller: _remainingTenureMonthsController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: AppColors.textPrimary),
                      decoration: _inputDecoration(
                        hint: '6',
                        label: 'Months Left',
                        icon: Icons.hourglass_bottom_rounded,
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: TextField(
                      controller: _dueDayController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: AppColors.textPrimary),
                      decoration: _inputDecoration(
                        hint: '10',
                        label: 'Due Day (1-28)',
                        icon: Icons.event_rounded,
                      ),
                    ),
                  ),
              ],
            ),
            if (widget.isEditing) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _dueDayController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: AppColors.textPrimary),
                decoration: _inputDecoration(
                  hint: '10',
                  label: 'Due Day of Month (1-31)',
                  icon: Icons.event_rounded,
                ),
              ),
            ],
            if (_selectedType == 'spaylater') ...[
              const SizedBox(height: 10),
              Text('Shopee Bill Cycles:', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              const SizedBox(height: 4),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  ActionChip(
                    label: const Text('Bill: 1st ➜ Due: 10th', style: TextStyle(fontSize: 11)),
                    backgroundColor: AppColors.surfaceHigh,
                    onPressed: () => setState(() => _dueDayController.text = '10'),
                  ),
                  ActionChip(
                    label: const Text('Bill: 11th ➜ Due: 20th', style: TextStyle(fontSize: 11)),
                    backgroundColor: AppColors.surfaceHigh,
                    onPressed: () => setState(() => _dueDayController.text = '20'),
                  ),
                  ActionChip(
                    label: const Text('Bill: 21st ➜ Due: 1st', style: TextStyle(fontSize: 11)),
                    backgroundColor: AppColors.surfaceHigh,
                    onPressed: () => setState(() => _dueDayController.text = '1'),
                  ),
                  ActionChip(
                    label: const Text('Bill: 25th ➜ Due: 5th', style: TextStyle(fontSize: 11)),
                    backgroundColor: AppColors.surfaceHigh,
                    onPressed: () => setState(() => _dueDayController.text = '5'),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _saveCommitment,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                elevation: 0,
              ),
              child: Text(
                widget.isEditing ? 'Save Changes' : 'Save Commitment',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
      prefixStyle: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
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
}
