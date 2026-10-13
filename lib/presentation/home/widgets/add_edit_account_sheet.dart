import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/money.dart';
import '../../../data/local/app_database.dart';
import '../../../data/providers/database_providers.dart';

class MalaysianAccountPreset {
  final String name;
  final String type; // 'bank', 'ewallet', 'cash', 'savings'
  final String icon;
  final int colorHex;

  const MalaysianAccountPreset({
    required this.name,
    required this.type,
    required this.icon,
    required this.colorHex,
  });
}

const List<MalaysianAccountPreset> kMalaysianPresets = [
  MalaysianAccountPreset(name: 'Maybank', type: 'bank', icon: '🟡', colorHex: 0xFFFFC107),
  MalaysianAccountPreset(name: 'Bank Islam (BIMB)', type: 'bank', icon: '🕌', colorHex: 0xFFC00000),
  MalaysianAccountPreset(name: 'CIMB Bank', type: 'bank', icon: '🐙', colorHex: 0xFFED1C24),
  MalaysianAccountPreset(name: 'BSN (Bank Simpanan)', type: 'bank', icon: '🏦', colorHex: 0xFF0072CE),
  MalaysianAccountPreset(name: 'Public Bank', type: 'bank', icon: '🏛️', colorHex: 0xFFDC143C),
  MalaysianAccountPreset(name: 'RHB Bank', type: 'bank', icon: '🏦', colorHex: 0xFF005696),
  MalaysianAccountPreset(name: 'Hong Leong Bank', type: 'bank', icon: '🏦', colorHex: 0xFFB22222),
  MalaysianAccountPreset(name: 'AmBank', type: 'bank', icon: '🏦', colorHex: 0xFFED1B24),
  MalaysianAccountPreset(name: 'Bank Rakyat', type: 'bank', icon: '🏦', colorHex: 0xFFFF6600),
  MalaysianAccountPreset(name: 'Bank Muamalat', type: 'bank', icon: '🕌', colorHex: 0xFF008080),
  MalaysianAccountPreset(name: 'GXBank', type: 'bank', icon: '⚡', colorHex: 0xFF6C5CE7),
  MalaysianAccountPreset(name: 'Boost Bank', type: 'bank', icon: '🚀', colorHex: 0xFFFF4757),
  MalaysianAccountPreset(name: 'AEON Bank', type: 'bank', icon: '🏦', colorHex: 0xFF8E44AD),
  MalaysianAccountPreset(name: 'Touch \'n Go eWallet', type: 'ewallet', icon: '📱', colorHex: 0xFF0070BA),
  MalaysianAccountPreset(name: 'GrabPay', type: 'ewallet', icon: '🛵', colorHex: 0xFF00B14F),
  MalaysianAccountPreset(name: 'ShopeePay', type: 'ewallet', icon: '🛍️', colorHex: 0xFFEE4D2D),
  MalaysianAccountPreset(name: 'Boost eWallet', type: 'ewallet', icon: '⚡', colorHex: 0xFFEE2737),
  MalaysianAccountPreset(name: 'BigPay', type: 'ewallet', icon: '💳', colorHex: 0xFF00A3E0),
  MalaysianAccountPreset(name: 'MAE by Maybank', type: 'ewallet', icon: '🟡', colorHex: 0xFFFFBB00),
  MalaysianAccountPreset(name: 'Cash in Wallet', type: 'cash', icon: '💵', colorHex: 0xFF2ECC71),
  MalaysianAccountPreset(name: 'ASB / Tabung Haji', type: 'savings', icon: '💰', colorHex: 0xFF28C76F),
];

class AddEditAccountSheet extends ConsumerStatefulWidget {
  final AccountsTableData? existingAccount;

  const AddEditAccountSheet({super.key, this.existingAccount});

  static Future<void> show(BuildContext context, {AccountsTableData? account}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddEditAccountSheet(existingAccount: account),
    );
  }

  @override
  ConsumerState<AddEditAccountSheet> createState() => _AddEditAccountSheetState();
}

class _AddEditAccountSheetState extends ConsumerState<AddEditAccountSheet> {
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();

  String _selectedType = 'bank'; // 'bank', 'ewallet', 'cash', 'savings'
  String _selectedIcon = '🏦';
  int _selectedColorHex = 0xFFFFC107;
  bool _isLiquidOnHand = true;
  bool _isDefault = false;
  bool _isCustomInput = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingAccount != null) {
      final a = widget.existingAccount!;
      _nameController.text = a.name;
      _balanceController.text = (a.balanceSen / 100).toStringAsFixed(2);
      _selectedType = a.type;
      _selectedIcon = a.icon;
      _selectedColorHex = a.colorHex;
      _isLiquidOnHand = a.isLiquidOnHand;
      _isDefault = a.isDefault;
      _isCustomInput = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  void _selectPreset(MalaysianAccountPreset preset) {
    setState(() {
      _nameController.text = preset.name;
      _selectedType = preset.type;
      _selectedIcon = preset.icon;
      _selectedColorHex = preset.colorHex;
      _isCustomInput = false;
    });
  }

  Future<void> _saveAccount() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or enter an account name')),
      );
      return;
    }

    final ringgit = double.tryParse(_balanceController.text.trim()) ?? 0.0;
    final balanceSen = Money.fromRinggit(ringgit).sen;

    final repo = ref.read(accountRepositoryProvider);

    if (widget.existingAccount != null) {
      await repo.updateAccount(
        id: widget.existingAccount!.id,
        name: name,
        type: _selectedType,
        icon: _selectedIcon,
        colorHex: _selectedColorHex,
        isDefault: _isDefault,
        isLiquidOnHand: _isLiquidOnHand,
      );
      if (widget.existingAccount!.balanceSen != balanceSen) {
        await repo.setAccountBalance(widget.existingAccount!.id, balanceSen);
      }
    } else {
      await repo.addAccount(
        name: name,
        type: _selectedType,
        initialBalanceSen: balanceSen,
        icon: _selectedIcon,
        colorHex: _selectedColorHex,
        isDefault: _isDefault,
        isLiquidOnHand: _isLiquidOnHand,
      );
    }

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.existingAccount != null
                ? 'Updated "$name"'
                : 'Added "$name" to Money on Hand',
          ),
          backgroundColor: AppColors.surfaceHigh,
        ),
      );
    }
  }

  Future<void> _deleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Delete Account', style: TextStyle(color: AppColors.textPrimary)),
        content: Text(
          'Are you sure you want to delete "${widget.existingAccount!.name}"? This will not delete historical expenses associated with it.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await ref.read(accountRepositoryProvider).deleteAccount(widget.existingAccount!.id);
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Deleted "${widget.existingAccount!.name}"')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
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
                  widget.existingAccount != null
                      ? 'Edit Account'
                      : 'Add Bank / E-Wallet',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (widget.existingAccount != null)
                  IconButton(
                    icon: Icon(Icons.delete_outline_rounded, color: AppColors.danger),
                    onPressed: _deleteAccount,
                    tooltip: 'Delete Account',
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Track cash across Malaysian banks, e-wallets, or physical money.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),

            Text(
              'Select Bank or E-Wallet Preset',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),

            SizedBox(
              height: 48,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: kMalaysianPresets.length + 1,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  if (i == kMalaysianPresets.length) {
                    final isSelected = _isCustomInput;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _isCustomInput = true;
                          _nameController.clear();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.2)
                              : AppColors.surfaceHigh,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.outline,
                            width: isSelected ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.edit_note_rounded, size: 16, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Text(
                              'Other / Custom',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final preset = kMalaysianPresets[i];
                  final isSelected = !_isCustomInput && _nameController.text == preset.name;

                  return GestureDetector(
                    onTap: () => _selectPreset(preset),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Color(preset.colorHex).withValues(alpha: 0.2)
                            : AppColors.surfaceHigh,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? Color(preset.colorHex) : AppColors.outline,
                          width: isSelected ? 1.5 : 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(preset.icon, style: const TextStyle(fontSize: 14)),
                          const SizedBox(width: 6),
                          Text(
                            preset.name,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _nameController,
              style: TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                labelText: 'Account / Wallet Name',
                labelStyle: TextStyle(color: AppColors.textSecondary),
                hintText: 'e.g. Maybank M2U, CIMB Clicks, BIMB, TnG',
                hintStyle: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.5)),
                prefixIcon: Container(
                  width: 40,
                  alignment: Alignment.center,
                  child: Text(_selectedIcon, style: const TextStyle(fontSize: 18)),
                ),
                filled: true,
                fillColor: AppColors.surfaceHigh,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onChanged: (_) {
                if (!_isCustomInput) {
                  setState(() => _isCustomInput = true);
                }
              },
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Text(
                  'Type: ',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    children: [
                      _buildTypeChip('bank', '🏦 Bank'),
                      _buildTypeChip('ewallet', '📱 E-Wallet'),
                      _buildTypeChip('cash', '💵 Cash'),
                      _buildTypeChip('savings', '💰 Savings'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _balanceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                labelText: 'Current Balance',
                labelStyle: TextStyle(color: AppColors.textSecondary),
                hintText: '0.00',
                prefixText: 'RM ',
                prefixStyle: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                filled: true,
                fillColor: AppColors.surfaceHigh,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 16),

            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Include in Total Money on Hand',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              ),
              subtitle: Text(
                'Keep turned ON for liquid cash. Turn OFF for locked savings (e.g. ASB/FD).',
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
              value: _isLiquidOnHand,
              activeColor: AppColors.primary,
              onChanged: (val) => setState(() => _isLiquidOnHand = val),
            ),

            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Set as Default Account',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              ),
              subtitle: Text(
                'Default account selected when logging new expenses.',
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
              value: _isDefault,
              activeColor: AppColors.primary,
              onChanged: (val) => setState(() => _isDefault = val),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _saveAccount,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: const Color(0xFF04291F),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                widget.existingAccount != null ? 'Save Changes' : 'Add Account',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip(String type, String label) {
    final isSelected = _selectedType == type;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.primary.withValues(alpha: 0.2),
      backgroundColor: AppColors.surfaceHigh,
      labelStyle: TextStyle(
        fontSize: 11,
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(color: isSelected ? AppColors.primary : AppColors.outline),
      onSelected: (_) {
        setState(() {
          _selectedType = type;
          if (type == 'bank') _selectedIcon = '🏦';
          if (type == 'ewallet') _selectedIcon = '📱';
          if (type == 'cash') _selectedIcon = '💵';
          if (type == 'savings') _selectedIcon = '💰';
        });
      },
    );
  }
}
