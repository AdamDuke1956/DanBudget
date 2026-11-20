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

  String _selectedType = 'bank';
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
      final colors = AppColors.of(context);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.existingAccount != null
                ? 'Updated "$name"'
                : 'Added "$name" to Money on Hand',
            style: TextStyle(color: colors.textPrimary),
          ),
          backgroundColor: colors.surfaceHigh,
        ),
      );
    }
  }

  Future<void> _deleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final colors = AppColors.of(ctx);
        return AlertDialog(
          backgroundColor: colors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Delete Account', style: TextStyle(color: colors.textPrimary)),
          content: Text(
            'Delete "${widget.existingAccount!.name}"? Past expenses linked to it will remain.',
            style: TextStyle(color: colors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.danger,
                foregroundColor: colors.onDanger,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
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
    final colors = AppColors.of(context);
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
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
                  color: colors.outline,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.existingAccount != null ? 'Edit Account' : 'Add Bank / E-Wallet',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
                if (widget.existingAccount != null)
                  IconButton(
                    icon: Icon(Icons.delete_outline_rounded, color: colors.danger),
                    onPressed: _deleteAccount,
                    tooltip: 'Delete Account',
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Track cash across Malaysian banks, e-wallets, or physical money.',
              style: TextStyle(fontSize: 12, color: colors.textSecondary),
            ),
            const SizedBox(height: 16),
            Text(
              'Select Bank or E-Wallet Preset',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
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
                              ? colors.primary.withValues(alpha: 0.2)
                              : colors.surfaceHigh,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: isSelected ? colors.primary : colors.outline,
                            width: isSelected ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.edit_note_rounded, size: 16, color: colors.primary),
                            const SizedBox(width: 6),
                            Text(
                              'Other / Custom',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected ? colors.primary : colors.textPrimary,
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
                            : colors.surfaceHigh,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isSelected ? Color(preset.colorHex) : colors.outline,
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
                              color: isSelected ? colors.textPrimary : colors.textSecondary,
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
              style: TextStyle(color: colors.textPrimary),
              decoration: InputDecoration(
                labelText: 'Account / Wallet Name',
                labelStyle: TextStyle(color: colors.textSecondary),
                hintText: 'e.g. Maybank M2U, CIMB Clicks, BIMB, TnG',
                hintStyle: TextStyle(color: colors.textSecondary.withValues(alpha: 0.5)),
                prefixIcon: Container(
                  width: 40,
                  alignment: Alignment.center,
                  child: Text(_selectedIcon, style: const TextStyle(fontSize: 18)),
                ),
                filled: true,
                fillColor: colors.surfaceHigh,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                  style: TextStyle(fontSize: 13, color: colors.textSecondary, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    children: [
                      _buildTypeChip(colors, 'bank', '🏦 Bank'),
                      _buildTypeChip(colors, 'ewallet', '📱 E-Wallet'),
                      _buildTypeChip(colors, 'cash', '💵 Cash'),
                      _buildTypeChip(colors, 'savings', '💰 Savings'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _balanceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(color: colors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                labelText: 'Current Balance',
                labelStyle: TextStyle(color: colors.textSecondary),
                hintText: '0.00',
                prefixText: 'RM ',
                prefixStyle: TextStyle(color: colors.primary, fontWeight: FontWeight.bold),
                filled: true,
                fillColor: colors.surfaceHigh,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Include in Total Money on Hand',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: colors.textPrimary),
              ),
              subtitle: Text(
                'Keep ON for liquid cash. Turn OFF for locked savings (ASB/FD).',
                style: TextStyle(fontSize: 11, color: colors.textSecondary),
              ),
              value: _isLiquidOnHand,
              activeColor: colors.primary,
              onChanged: (val) => setState(() => _isLiquidOnHand = val),
            ),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Set as Default Account',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: colors.textPrimary),
              ),
              subtitle: Text(
                'Default account selected when logging new expenses.',
                style: TextStyle(fontSize: 11, color: colors.textSecondary),
              ),
              value: _isDefault,
              activeColor: colors.primary,
              onChanged: (val) => setState(() => _isDefault = val),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveAccount,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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

  Widget _buildTypeChip(AppPalette colors, String type, String label) {
    final isSelected = _selectedType == type;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: colors.primary.withValues(alpha: 0.2),
      backgroundColor: colors.surfaceHigh,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      labelStyle: TextStyle(
        fontSize: 11,
        color: isSelected ? colors.primary : colors.textSecondary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(color: isSelected ? colors.primary : colors.outline),
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
