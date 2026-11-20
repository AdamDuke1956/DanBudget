import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../data/providers/database_providers.dart';
import '../../../data/services/backup_file_service.dart';
import '../../../data/services/backup_service.dart';

class LocalBackupCard extends ConsumerWidget {
  const LocalBackupCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);

    return SurfaceCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.shield_rounded, size: 20, color: colors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Local Data & Backup',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: colors.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  'Stored locally on your device. Save .json backups to Downloads/DanBudget so they survive uninstalls.',
                  style: TextStyle(fontSize: 11, color: colors.textSecondary, height: 1.35),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => BackupActions.exportDataAsJson(context, ref),
                      icon: const Icon(Icons.file_download_outlined, size: 15),
                      label: const Text('Export JSON'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colors.primary,
                        side: BorderSide(color: colors.primary.withValues(alpha: 0.5)),
                        minimumSize: const Size(0, 44),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => BackupActions.showRestoreDialog(context, ref),
                      icon: const Icon(Icons.restore_page_outlined, size: 15),
                      label: const Text('Restore JSON'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colors.textPrimary,
                        side: BorderSide(color: colors.cardBorder),
                        minimumSize: const Size(0, 44),
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
    );
  }
}

abstract final class BackupActions {
  static Future<void> exportDataAsJson(BuildContext context, WidgetRef ref) async {
    final db = ref.read(databaseProvider);
    final taxRepo = ref.read(taxRepositoryProvider);
    final payload = await BackupService.exportToBackupPayload(db, taxRepo: taxRepo);
    final jsonStr = payload.jsonString;
    final fileName = BackupFileService.buildFileName();
    final previewStr = jsonStr.length > 3000
        ? '${jsonStr.substring(0, 3000)}\n...\n[Full ${jsonStr.length} chars will be saved to $fileName]'
        : jsonStr;

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (ctx) {
        final colors = AppColors.of(ctx);
        return AlertDialog(
          backgroundColor: colors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.shield_outlined, color: colors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '100% Local Backup',
                  style: TextStyle(color: colors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Backup ready: ${payload.accountCount} accounts, ${payload.expenseCount} expenses, ${payload.commitmentCount} commitments, and ${payload.dailyPlanCount} daily plans.',
                    style: TextStyle(fontSize: 12, color: colors.textSecondary),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: colors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: colors.warning.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.folder_outlined, size: 16, color: colors.warning),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Saved to Downloads/DanBudget/$fileName so it stays safe even if you uninstall the app.',
                            style: TextStyle(fontSize: 11, color: colors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 120,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colors.surfaceHigh,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        previewStr,
                        style: TextStyle(fontFamily: 'monospace', fontSize: 10, color: colors.textPrimary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Wrap(
              alignment: WrapAlignment.end,
              spacing: 8,
              runSpacing: 8,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text('Close', style: TextStyle(color: colors.textSecondary)),
                ),
                TextButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: jsonStr));
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Copied backup to clipboard. Prefer saving the .json file for long backups.'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.copy_rounded, size: 15),
                  label: const Text('Copy'),
                ),
                OutlinedButton.icon(
                  onPressed: () async {
                    Navigator.of(ctx).pop();
                    await _saveBackupFile(
                      context,
                      jsonStr: jsonStr,
                      fileName: fileName,
                      usePicker: true,
                    );
                  },
                  icon: const Icon(Icons.folder_open_rounded, size: 15),
                  label: const Text('Save As...'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.textPrimary,
                    side: BorderSide(color: colors.cardBorder),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    Navigator.of(ctx).pop();
                    await _saveBackupFile(
                      context,
                      jsonStr: jsonStr,
                      fileName: fileName,
                      usePicker: false,
                    );
                  },
                  icon: const Icon(Icons.save_alt_rounded, size: 16),
                  label: const Text('Save .json File'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  static Future<void> _saveBackupFile(
    BuildContext context, {
    required String jsonStr,
    required String fileName,
    required bool usePicker,
  }) async {
    try {
      final result = usePicker
          ? await BackupFileService.saveWithPicker(
              jsonContent: jsonStr,
              fileName: fileName,
            )
          : await BackupFileService.saveToDownloadsFolder(
              jsonContent: jsonStr,
              fileName: fileName,
            );

      if (!context.mounted || result.cancelled) return;

      if (result.saved) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF10B981),
            content: Text('Backup saved to ${result.location ?? fileName}'),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFFEF4444),
            content: Text('Failed to save backup file: $e'),
          ),
        );
      }
    }
  }

  static void showRestoreDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        final colors = AppColors.of(ctx);
        return AlertDialog(
          backgroundColor: colors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.restore_page_outlined, color: colors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Restore Backup',
                  style: TextStyle(color: colors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Choose a saved .json backup file from Downloads/DanBudget (or any folder) to restore.',
                    style: TextStyle(fontSize: 12, color: colors.textSecondary),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        final picked = await BackupFileService.pickJsonFile();
                        if (picked.cancelled || !picked.picked) return;
                        final content = picked.content?.trim() ?? '';
                        if (content.isEmpty) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Color(0xFFEF4444),
                                content: Text('Selected backup file is empty.'),
                              ),
                            );
                          }
                          return;
                        }
                        if (ctx.mounted) Navigator.of(ctx).pop();
                        if (context.mounted) {
                          await _restoreDataFromJson(
                            context,
                            ref,
                            content,
                            sourceLabel: picked.fileName,
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: const Color(0xFFEF4444),
                              content: Text('Could not open backup file: $e'),
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.upload_file_rounded, size: 18),
                    label: const Text('Choose .json File'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: colors.onPrimary,
                      minimumSize: const Size(0, 44),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Or paste JSON text below:',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: colors.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller,
                    maxLines: 5,
                    style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: colors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Paste JSON backup here...',
                      hintStyle: TextStyle(color: colors.textSecondary.withValues(alpha: 0.5)),
                      filled: true,
                      fillColor: colors.surfaceHigh,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () async {
                        final clip = await Clipboard.getData('text/plain');
                        if (clip?.text != null) {
                          controller.text = clip!.text!;
                        }
                      },
                      icon: const Icon(Icons.paste_rounded, size: 16),
                      label: const Text('Paste from Clipboard', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Cancel', style: TextStyle(color: colors.textSecondary)),
            ),
            OutlinedButton(
              onPressed: () async {
                final text = controller.text.trim();
                if (text.isEmpty) return;
                Navigator.of(ctx).pop();
                await _restoreDataFromJson(context, ref, text);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: colors.primary,
                side: BorderSide(color: colors.primary.withValues(alpha: 0.5)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Restore Now'),
            ),
          ],
        );
      },
    );
  }

  static Future<void> _restoreDataFromJson(
    BuildContext context,
    WidgetRef ref,
    String jsonText, {
    String? sourceLabel,
  }) async {
    try {
      final db = ref.read(databaseProvider);
      final taxRepo = ref.read(taxRepositoryProvider);
      await BackupService.restoreFromJson(db, jsonText, taxRepo: taxRepo);

      if (context.mounted) {
        final msg = sourceLabel != null
            ? 'Backup restored from $sourceLabel!'
            : 'Backup restored successfully! All data has been loaded.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF10B981),
            content: Text(msg),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFFEF4444),
            content: Text('Failed to restore backup: $e'),
          ),
        );
      }
    }
  }
}
