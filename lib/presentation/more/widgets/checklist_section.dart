import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/local/app_database.dart';
import '../../../data/providers/database_providers.dart';

class ChecklistSection extends ConsumerWidget {
  const ChecklistSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checklistAsync = ref.watch(checklistStreamProvider);

    return checklistAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Text('Error loading checklist: $err'),
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
                const Text(
                  'First Salary Starter Pack',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _showAddDialog(context, ref),
                  icon: const Icon(Icons.add_task_rounded, size: 14, color: AppColors.primary),
                  label: const Text(
                    'Add Goal',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$completedCount of $totalCount Done',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '${(progress * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.surfaceHigh,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 12),

            ...items.map((item) => _buildChecklistItem(context, ref, item)),
          ],
        );
      },
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String category = 'banking';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Add Starter Pack Goal',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 18),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleCtrl,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Goal Title',
                    labelStyle: const TextStyle(color: AppColors.textSecondary),
                    hintText: 'e.g. Apply Touch \'n Go RFID',
                    hintStyle: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.5)),
                    filled: true,
                    fillColor: AppColors.surfaceHigh,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descCtrl,
                  maxLines: 2,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Description (Optional)',
                    labelStyle: const TextStyle(color: AppColors.textSecondary),
                    hintText: 'Details or links for this milestone',
                    hintStyle: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.5)),
                    filled: true,
                    fillColor: AppColors.surfaceHigh,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: category,
                  dropdownColor: AppColors.surfaceHigh,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Category',
                    labelStyle: const TextStyle(color: AppColors.textSecondary),
                    filled: true,
                    fillColor: AppColors.surfaceHigh,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
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
                    );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: const Color(0xFF04291F),
              ),
              child: const Text('Add Goal'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistItem(
      BuildContext context, WidgetRef ref, ChecklistItemsTableData item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.isCompleted
              ? AppColors.primary.withValues(alpha: 0.3)
              : AppColors.outline.withValues(alpha: 0.5),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Checkbox(
            value: item.isCompleted,
            activeColor: AppColors.primary,
            checkColor: const Color(0xFF04291F),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            onChanged: (val) {
              ref
                  .read(checklistRepositoryProvider)
                  .toggleItem(item.id, val ?? false);
            },
          ),
          title: Text(
            item.title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              decoration: item.isCompleted ? TextDecoration.lineThrough : null,
              color: item.isCompleted
                  ? AppColors.textSecondary
                  : AppColors.textPrimary,
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.surfaceHigh,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _formatCategory(item.category),
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                item.description,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
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
}
