import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../data/local/app_database.dart';
import '../../../data/providers/database_providers.dart';

class ChecklistSection extends ConsumerWidget {
  const ChecklistSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final checklistAsync = ref.watch(checklistStreamProvider);

    return checklistAsync.when(
      loading: () => Center(child: CircularProgressIndicator(color: colors.primary)),
      error: (err, _) => Text('Error loading checklist: $err', style: TextStyle(color: colors.danger)),
      data: (items) {
        final completedCount = items.where((i) => i.isCompleted).length;
        final totalCount = items.length;
        final progress = totalCount > 0 ? completedCount / totalCount : 0.0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'First Salary Starter Pack',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () => _showAddDialog(context, ref),
                  icon: Icon(Icons.add_task_rounded, size: 14, color: colors.primary),
                  label: Text(
                    'Add Goal',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: const Size(0, 36),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    '$completedCount of $totalCount Done',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: colors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${(progress * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: colors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: colors.surfaceHigh,
                valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 12),
            ...items.map((item) => _buildChecklistItem(context, ref, colors, item)),
          ],
        );
      },
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String category = 'banking';
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final colors = AppColors.of(ctx);
          return AlertDialog(
            backgroundColor: colors.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(
              'Add Starter Pack Goal',
              style: TextStyle(color: colors.textPrimary, fontSize: 18),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: titleCtrl,
                    style: TextStyle(color: colors.textPrimary),
                    decoration: InputDecoration(
                      labelText: 'Goal Title',
                      labelStyle: TextStyle(color: colors.textSecondary),
                      hintText: 'e.g. Apply Touch \'n Go RFID',
                      hintStyle: TextStyle(color: colors.textSecondary.withValues(alpha: 0.5)),
                      filled: true,
                      fillColor: colors.surfaceHigh,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descCtrl,
                    maxLines: 2,
                    style: TextStyle(color: colors.textPrimary),
                    decoration: InputDecoration(
                      labelText: 'Description (Optional)',
                      labelStyle: TextStyle(color: colors.textSecondary),
                      hintText: 'Details or links for this milestone',
                      hintStyle: TextStyle(color: colors.textSecondary.withValues(alpha: 0.5)),
                      filled: true,
                      fillColor: colors.surfaceHigh,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: category,
                    isExpanded: true,
                    dropdownColor: colors.surfaceHigh,
                    style: TextStyle(color: colors.textPrimary),
                    decoration: InputDecoration(
                      labelText: 'Category',
                      labelStyle: TextStyle(color: colors.textSecondary),
                      filled: true,
                      fillColor: colors.surfaceHigh,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'statutory', child: Text('Statutory (KWSP / LHDN)')),
                      DropdownMenuItem(value: 'banking', child: Text('Banking & Cards')),
                      DropdownMenuItem(value: 'savings', child: Text('Savings & Emergency Fund')),
                      DropdownMenuItem(value: 'debt', child: Text('Loans & Debt Management')),
                      DropdownMenuItem(value: 'protection', child: Text('Protection & Takaful')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() => category = val);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(const Duration(days: 30)),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2035),
                        builder: (pickerCtx, child) {
                          final pickerColors = AppColors.of(pickerCtx);
                          return Theme(
                            data: Theme.of(pickerCtx).copyWith(
                              colorScheme: pickerColors.isDark
                                  ? ColorScheme.dark(
                                      primary: pickerColors.primary,
                                      onPrimary: pickerColors.onPrimary,
                                      surface: pickerColors.surface,
                                      onSurface: pickerColors.textPrimary,
                                    )
                                  : ColorScheme.light(
                                      primary: pickerColors.primary,
                                      onPrimary: pickerColors.onPrimary,
                                      surface: pickerColors.surface,
                                      onSurface: pickerColors.textPrimary,
                                    ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setDialogState(() => selectedDate = picked);
                      }
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: colors.surfaceHigh,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: colors.outline),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_rounded, size: 16, color: colors.primary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              selectedDate != null
                                  ? 'Target Date: ${_formatDate(selectedDate!)}'
                                  : 'Set Target / Due Date (Optional)',
                              style: TextStyle(
                                fontSize: 13,
                                color: selectedDate != null ? colors.textPrimary : colors.textSecondary,
                                fontWeight: selectedDate != null ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (selectedDate != null)
                            IconButton(
                              icon: Icon(Icons.close_rounded, size: 16, color: colors.textSecondary),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                              onPressed: () => setDialogState(() => selectedDate = null),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text('Cancel', style: TextStyle(color: colors.textSecondary)),
              ),
              ElevatedButton(
                onPressed: () async {
                  final title = titleCtrl.text.trim();
                  if (title.isEmpty) return;
                  Navigator.of(ctx).pop();
                  await ref.read(checklistRepositoryProvider).addItem(
                        title: title,
                        category: category,
                        description: descCtrl.text.trim().isEmpty
                            ? 'Personal milestone added by user.'
                            : descCtrl.text.trim(),
                        targetDate: selectedDate,
                      );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Add Goal'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    WidgetRef ref,
    ChecklistItemsTableData item,
  ) {
    final titleCtrl = TextEditingController(text: item.title);
    final descCtrl = TextEditingController(text: item.description);
    String category = item.category;
    DateTime? selectedDate = item.targetDate;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final colors = AppColors.of(ctx);
          return AlertDialog(
            backgroundColor: colors.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(
              'Edit Starter Pack Goal',
              style: TextStyle(color: colors.textPrimary, fontSize: 18),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: titleCtrl,
                    style: TextStyle(color: colors.textPrimary),
                    decoration: InputDecoration(
                      labelText: 'Goal Title',
                      labelStyle: TextStyle(color: colors.textSecondary),
                      filled: true,
                      fillColor: colors.surfaceHigh,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descCtrl,
                    maxLines: 2,
                    style: TextStyle(color: colors.textPrimary),
                    decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: TextStyle(color: colors.textSecondary),
                      filled: true,
                      fillColor: colors.surfaceHigh,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: ['statutory', 'banking', 'savings', 'debt', 'protection']
                            .contains(category.toLowerCase())
                        ? category.toLowerCase()
                        : 'banking',
                    isExpanded: true,
                    dropdownColor: colors.surfaceHigh,
                    style: TextStyle(color: colors.textPrimary),
                    decoration: InputDecoration(
                      labelText: 'Category',
                      labelStyle: TextStyle(color: colors.textSecondary),
                      filled: true,
                      fillColor: colors.surfaceHigh,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'statutory', child: Text('Statutory (KWSP / LHDN)')),
                      DropdownMenuItem(value: 'banking', child: Text('Banking & Cards')),
                      DropdownMenuItem(value: 'savings', child: Text('Savings & Emergency Fund')),
                      DropdownMenuItem(value: 'debt', child: Text('Loans & Debt Management')),
                      DropdownMenuItem(value: 'protection', child: Text('Protection & Takaful')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() => category = val);
                      }
                    },
                  ),
                  const SizedBox(height: 14),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2035),
                        builder: (pickerCtx, child) {
                          final pickerColors = AppColors.of(pickerCtx);
                          return Theme(
                            data: Theme.of(pickerCtx).copyWith(
                              colorScheme: pickerColors.isDark
                                  ? ColorScheme.dark(
                                      primary: pickerColors.primary,
                                      onPrimary: pickerColors.onPrimary,
                                      surface: pickerColors.surface,
                                      onSurface: pickerColors.textPrimary,
                                    )
                                  : ColorScheme.light(
                                      primary: pickerColors.primary,
                                      onPrimary: pickerColors.onPrimary,
                                      surface: pickerColors.surface,
                                      onSurface: pickerColors.textPrimary,
                                    ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setDialogState(() => selectedDate = picked);
                      }
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: colors.surfaceHigh,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: colors.outline),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_rounded, size: 16, color: colors.primary),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              selectedDate != null
                                  ? 'Target Due Date: ${_formatDate(selectedDate!)}'
                                  : 'Set Target Due Date (Optional)',
                              style: TextStyle(
                                fontSize: 13,
                                color: selectedDate != null ? colors.textPrimary : colors.textSecondary,
                                fontWeight: selectedDate != null ? FontWeight.w600 : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (selectedDate != null)
                            IconButton(
                              icon: Icon(Icons.close_rounded, size: 16, color: colors.textSecondary),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                              onPressed: () => setDialogState(() => selectedDate = null),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text('Cancel', style: TextStyle(color: colors.textSecondary)),
              ),
              ElevatedButton(
                onPressed: () async {
                  final title = titleCtrl.text.trim();
                  if (title.isEmpty) return;
                  Navigator.of(ctx).pop();
                  await ref.read(checklistRepositoryProvider).updateItem(
                        id: item.id,
                        title: title,
                        category: category,
                        description: descCtrl.text.trim().isEmpty ? item.description : descCtrl.text.trim(),
                        targetDate: selectedDate,
                      );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Updated goal "$title"!')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Save Changes'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    WidgetRef ref,
    ChecklistItemsTableData item,
  ) {
    showDialog(
      context: context,
      builder: (ctx) {
        final colors = AppColors.of(ctx);
        return AlertDialog(
          backgroundColor: colors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Delete Goal?', style: TextStyle(color: colors.textPrimary, fontSize: 18)),
          content: Text(
            'Remove "${item.title}" from your starter pack?',
            style: TextStyle(color: colors.textSecondary, fontSize: 13),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Cancel', style: TextStyle(color: colors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                await ref.read(checklistRepositoryProvider).deleteItem(item.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Deleted "${item.title}".')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.danger,
                foregroundColor: colors.onDanger,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildChecklistItem(
    BuildContext context,
    WidgetRef ref,
    AppPalette colors,
    ChecklistItemsTableData item,
  ) {
    return SurfaceCard(
      margin: const EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.zero,
      borderColor: item.isCompleted
          ? colors.primary.withValues(alpha: 0.3)
          : colors.cardBorder,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          leading: Checkbox(
            value: item.isCompleted,
            activeColor: colors.primary,
            checkColor: colors.onPrimary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            onChanged: (val) {
              ref
                  .read(checklistRepositoryProvider)
                  .toggleItem(item.id, val ?? false);
            },
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                  color: item.isCompleted
                      ? colors.textSecondary
                      : colors.textPrimary,
                ),
              ),
              if (item.targetDate != null) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: _targetDateColor(colors, item.targetDate!, item.isCompleted)
                        .withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: _targetDateColor(colors, item.targetDate!, item.isCompleted)
                          .withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.event_rounded,
                        size: 11,
                        color: _targetDateColor(colors, item.targetDate!, item.isCompleted),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          _formatTargetDateBadge(item.targetDate!, item.isCompleted),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: _targetDateColor(colors, item.targetDate!, item.isCompleted),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: colors.surfaceHigh,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _formatCategory(item.category),
                  style: TextStyle(
                    fontSize: 10,
                    color: colors.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 2),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert_rounded, size: 18, color: colors.textSecondary),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                color: colors.surfaceHigh,
                onSelected: (val) {
                  if (val == 'edit') {
                    _showEditDialog(context, ref, item);
                  } else if (val == 'delete') {
                    _showDeleteDialog(context, ref, item);
                  }
                },
                itemBuilder: (ctx) {
                  final menuColors = AppColors.of(ctx);
                  return [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 16, color: menuColors.textPrimary),
                          const SizedBox(width: 8),
                          Text('Edit Goal', style: TextStyle(fontSize: 12, color: menuColors.textPrimary)),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline_rounded, size: 16, color: menuColors.danger),
                          const SizedBox(width: 8),
                          Text('Delete Goal', style: TextStyle(fontSize: 12, color: menuColors.danger)),
                        ],
                      ),
                    ),
                  ];
                },
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () => _showEditDialog(context, ref, item),
                        icon: const Icon(Icons.edit_outlined, size: 14),
                        label: const Text('Edit', style: TextStyle(fontSize: 11)),
                        style: TextButton.styleFrom(
                          foregroundColor: colors.textSecondary,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(width: 4),
                      TextButton.icon(
                        onPressed: () => _showDeleteDialog(context, ref, item),
                        icon: Icon(Icons.delete_outline_rounded, size: 14, color: colors.danger),
                        label: Text('Delete', style: TextStyle(fontSize: 11, color: colors.danger)),
                        style: TextButton.styleFrom(
                          foregroundColor: colors.danger,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCategory(String cat) {
    switch (cat.toLowerCase()) {
      case 'statutory':
        return 'KWSP / LHDN';
      case 'banking':
        return 'BANKING';
      case 'savings':
        return 'SAVINGS';
      case 'debt':
        return 'LOANS';
      case 'protection':
        return 'TAKAFUL';
      default:
        return cat.toUpperCase();
    }
  }

  String _formatDate(DateTime dt) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  String _formatTargetDateBadge(DateTime targetDate, bool isCompleted) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(targetDate.year, targetDate.month, targetDate.day);
    final diff = target.difference(today).inDays;

    final dateStr = _formatDate(targetDate);
    if (isCompleted) {
      return 'Target: $dateStr';
    }
    if (diff < 0) {
      return 'Overdue ($dateStr)';
    } else if (diff == 0) {
      return 'Due Today!';
    } else if (diff == 1) {
      return 'Due Tomorrow';
    } else {
      return 'Target: $dateStr ($diff d)';
    }
  }

  Color _targetDateColor(AppPalette colors, DateTime targetDate, bool isCompleted) {
    if (isCompleted) return colors.textSecondary;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(targetDate.year, targetDate.month, targetDate.day);
    final diff = target.difference(today).inDays;
    if (diff < 0) return colors.danger;
    if (diff <= 7) return colors.accent;
    return colors.primary;
  }
}
