import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:local_auth/local_auth.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/local/app_database.dart';
import '../../data/providers/dashboard_provider.dart';
import '../../data/providers/database_providers.dart';
import '../../data/repositories/tax_repository.dart';
import '../plan/widgets/salary_edit_sheet.dart';
import '../tax/tax_optimizer_screen.dart';
import 'widgets/checklist_section.dart';
import 'widgets/health_score_card.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(dashboardStateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'More & Starter Pack',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: -0.3),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: stateAsync.when(
        loading: () => Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, _) => Center(
          child: Text('Error: $err', style: TextStyle(color: AppColors.danger)),
        ),
        data: (state) {
          final profile = state.profile;

          return Stack(
            children: [
              CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                slivers: [
                  // 1. Executive Profile Banner
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.cardBorder),
                          boxShadow: AppColors.cardShadow != null ? [AppColors.cardShadow!] : null,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                              child: Text(
                                state.employmentType.emoji.isNotEmpty ? state.employmentType.emoji : '👤',
                                style: const TextStyle(fontSize: 22),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    profile.name.isNotEmpty ? profile.name : 'DanBudget User',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 4,
                                    children: [
                                      _ProfilePill(label: state.employmentType.label),
                                      _ProfilePill(label: 'Gross ${state.netSalary.grossSalary.formatted}'),
                                      _ProfilePill(label: 'Payday ${profile.paydayDayOfMonth}th'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.tune_rounded, color: AppColors.primary),
                              tooltip: 'Edit Profile & Salary',
                              onPressed: () => SalaryEditSheet.show(context, profile),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 2. Financial Health Diagnostic Card
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      child: HealthScoreCard(health: state.healthScore),
                    ),
                  ),

                  // 3. Malaysian First Salary Starter Pack Checklist
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      child: ChecklistSection(),
                    ),
                  ),

                  // 4. Preferences & Security Hub
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Preferences & Security',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 14),

                            Text(
                              'Theme',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),

                            Row(
                              children: [
                                Expanded(
                                  child: _ThemeModeTile(
                                    mode: AppThemeMode.darkGreen,
                                    title: 'Dark / Emerald',
                                    subtitle: 'Obsidian Night',
                                    icon: Icons.dark_mode_rounded,
                                    activeColor: const Color(0xFF2EE6A6),
                                    isSelected: ref.watch(themeModeProvider) == AppThemeMode.darkGreen,
                                    onTap: () => ref.read(themeModeProvider.notifier).setTheme(AppThemeMode.darkGreen),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _ThemeModeTile(
                                    mode: AppThemeMode.whiteRed,
                                    title: 'White / Crimson',
                                    subtitle: 'Malaysian Ringgit',
                                    icon: Icons.light_mode_rounded,
                                    activeColor: const Color(0xFFE11D48),
                                    isSelected: ref.watch(themeModeProvider) == AppThemeMode.whiteRed,
                                    onTap: () => ref.read(themeModeProvider.notifier).setTheme(AppThemeMode.whiteRed),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Divider(color: AppColors.outline.withValues(alpha: 0.5), height: 1),
                            const SizedBox(height: 6),

                            SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                'Biometric App Lock',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                              ),
                              subtitle: Text(
                                'Require fingerprint or Face ID on launch',
                                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                              activeColor: AppColors.primary,
                              value: profile.biometricLockEnabled,
                              onChanged: (val) async {
                                if (val) {
                                  final auth = LocalAuthentication();
                                  final canCheck = await auth.canCheckBiometrics;
                                  final isSupported = await auth.isDeviceSupported();

                                  if (!canCheck && !isSupported) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          backgroundColor: AppColors.surfaceHigh,
                                          content: Text(
                                            'Biometrics not enrolled or unavailable on this device.',
                                            style: TextStyle(color: AppColors.warning),
                                          ),
                                        ),
                                      );
                                    }
                                    return;
                                  }

                                  try {
                                    final didAuth = await auth.authenticate(
                                      localizedReason: 'Scan fingerprint or Face ID to confirm biometric lock',
                                      options: const AuthenticationOptions(
                                        stickyAuth: true,
                                        biometricOnly: false,
                                      ),
                                    );
                                    if (!didAuth) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            backgroundColor: AppColors.surfaceHigh,
                                            content: Text(
                                              'Biometric confirmation cancelled.',
                                              style: TextStyle(color: AppColors.textSecondary),
                                            ),
                                          ),
                                        );
                                      }
                                      return;
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          backgroundColor: AppColors.surfaceHigh,
                                          content: Text(
                                            'Biometric check error: $e',
                                            style: TextStyle(color: AppColors.danger),
                                          ),
                                        ),
                                      );
                                    }
                                    return;
                                  }
                                }

                                ref.read(profileRepositoryProvider).updateProfile(
                                      UserProfileTableCompanion(
                                        biometricLockEnabled: drift.Value(val),
                                      ),
                                    );
                              },
                            ),
                            Divider(color: AppColors.outline.withValues(alpha: 0.5), height: 16),

                            SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                'Cashflow Advisor',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                              ),
                              subtitle: Text(
                                'Show budget advice on the Plan tab',
                                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                              activeColor: AppColors.primary,
                              value: profile.aiAdviceEnabled,
                              onChanged: (val) {
                                ref.read(profileRepositoryProvider).updateProfile(
                                      UserProfileTableCompanion(
                                        aiAdviceEnabled: drift.Value(val),
                                      ),
                                    );
                              },
                            ),
                            if (!state.employmentType.isIntern) ...[
                              Divider(color: AppColors.outline.withValues(alpha: 0.5), height: 16),

                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(Icons.account_balance_rounded, color: AppColors.primary, size: 20),
                                ),
                                title: Text(
                                  'Income Tax (Form BE)',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                                ),
                                subtitle: Text(
                                  'Reliefs, receipts & refund estimate',
                                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                ),
                                trailing: Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => const TaxOptimizerScreen()),
                                  );
                                },
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 5. Local-First Privacy Guarantee Card
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.shield_rounded, size: 20, color: AppColors.primary),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Local Data & Backup',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Stored locally on your device. No cloud sync or tracking.',
                                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.35),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: () => _exportDataAsJson(context, ref, state),
                                          icon: const Icon(Icons.file_download_outlined, size: 16),
                                          label: const Text('Export JSON', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: AppColors.primary,
                                            side: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                            padding: const EdgeInsets.symmetric(vertical: 8),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: () => _showRestoreDialog(context, ref),
                                          icon: const Icon(Icons.restore_page_outlined, size: 16),
                                          label: const Text('Restore JSON', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: AppColors.textPrimary,
                                            side: BorderSide(color: AppColors.cardBorder),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                            padding: const EdgeInsets.symmetric(vertical: 8),
                                          ),
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
                    ),
                  ),

                  // 6. Versioning footer
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                      child: Center(
                        child: Text(
                          'DanBudget v1.6.5 • 100% Offline',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textSecondary.withValues(alpha: 0.6)),
                        ),
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),

              // Sticky Lower-Zone Action Dock (Reachable within bottom 60%)
              Positioned(
                left: 20,
                right: 20,
                bottom: 16,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.96),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.cardBorder),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: AppColors.isDark ? 0.35 : 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _exportDataAsJson(context, ref, state),
                          icon: const Icon(Icons.file_download_outlined, size: 18),
                          label: const Text(
                            'Export Backup',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.onPrimary,
                            elevation: 0,
                            minimumSize: const Size(0, 48),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => SalaryEditSheet.show(context, profile),
                          icon: Icon(Icons.tune_rounded, size: 16, color: AppColors.textPrimary),
                          label: Text(
                            'Edit Profile',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.cardBorder),
                            minimumSize: const Size(0, 48),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _exportDataAsJson(BuildContext context, WidgetRef ref, DashboardState state) async {
    final expenses = await ref.read(expenseRepositoryProvider).getAllExpenses();
    final commitments = state.activeCommitments;
    final checklist = await ref.read(checklistRepositoryProvider).watchChecklistItems().first;
    final taxRepo = ref.read(taxRepositoryProvider);
    final taxProfiles = await taxRepo.getAllProfiles();
    final taxClaims = await taxRepo.getAllReceiptClaims();

    final data = {
      'exportedAt': DateTime.now().toIso8601String(),
      'version': '1.6.5',
      'appName': 'DanBudget',
      'profile': {
        'name': state.profile.name,
        'grossSalarySen': state.profile.grossSalarySen,
        'fixedAllowanceSen': state.profile.fixedAllowanceSen,
        'currentSavingsSen': state.profile.currentSavingsSen,
        'paydayDayOfMonth': state.profile.paydayDayOfMonth,
        'epfRate': state.profile.epfRate,
      },
      'expenses': expenses
          .map((e) => {
                'id': e.expense.id,
                'amountSen': e.expense.amountSen,
                'category': e.category.name,
                'date': e.expense.date.toIso8601String(),
                'note': e.expense.note,
                'isCommitment': e.expense.isCommitmentPayment,
              })
          .toList(),
      'commitments': commitments
          .map((c) => {
                'id': c.id,
                'title': c.title,
                'type': c.type,
                'monthlyPaymentSen': c.monthlyPaymentSen,
                'remainingTenureMonths': c.remainingTenureMonths,
                'remainingAmountSen': c.remainingAmountSen,
                'dueDayOfMonth': c.dueDayOfMonth,
              })
          .toList(),
      'checklist': checklist
          .map((i) => {
                'id': i.id,
                'title': i.title,
                'category': i.category,
                'isCompleted': i.isCompleted,
              })
          .toList(),
      'taxProfiles': taxProfiles.map((p) => p.toJson()).toList(),
      'taxReceiptClaims': taxClaims.map((c) => c.toJson()).toList(),
    };

    final jsonStr = const JsonEncoder.withIndent('  ').convert(data);

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.shield_outlined, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                '100% Local Backup',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Backup ready: ${expenses.length} expenses, ${commitments.length} commitments, and ${checklist.length} checklist items.',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.shield_outlined, size: 16, color: AppColors.warning),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Keep your exported JSON private. It contains personal income, debt, and expense records.',
                          style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 160,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHigh,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      jsonStr,
                      style: TextStyle(fontFamily: 'monospace', fontSize: 10, color: AppColors.textPrimary),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Close', style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: jsonStr));
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Copied backup to clipboard. Paste securely and avoid pasting in untrusted apps.'),
                  ),
                );
              },
              icon: const Icon(Icons.copy_rounded, size: 16),
              label: const Text('Copy JSON'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
              ),
            ),
          ],
        ),
      );
    }
  }

  void _showRestoreDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.restore_page_outlined, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              'Restore Backup',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Paste your exported JSON backup text below to restore your profile, expenses, commitments, and checklist.',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                maxLines: 6,
                style: TextStyle(fontFamily: 'monospace', fontSize: 11, color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Paste JSON backup here...',
                  hintStyle: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.5)),
                  filled: true,
                  fillColor: AppColors.surfaceHigh,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () async {
                  final clip = await Clipboard.getData('text/plain');
                  if (clip?.text != null) {
                    controller.text = clip!.text!;
                  }
                },
                icon: const Icon(Icons.paste_rounded, size: 16),
                label: const Text('Paste from Clipboard', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              final text = controller.text.trim();
              if (text.isEmpty) return;
              Navigator.of(ctx).pop();
              await _restoreDataFromJson(context, ref, text);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
            ),
            child: const Text('Restore Now'),
          ),
        ],
      ),
    );
  }

  Future<void> _restoreDataFromJson(BuildContext context, WidgetRef ref, String jsonText) async {
    try {
      final dynamic decoded = jsonDecode(jsonText);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Invalid backup format: root must be a JSON object.');
      }
      final db = ref.read(databaseProvider);

      await db.transaction(() async {
        // 1. Profile
        if (decoded['profile'] is Map<String, dynamic>) {
          final p = decoded['profile'] as Map<String, dynamic>;
          await (db.update(db.userProfileTable)..where((t) => t.id.equals(1))).write(
            UserProfileTableCompanion(
              name: drift.Value((p['name'] as String?) ?? ''),
              grossSalarySen: drift.Value((p['grossSalarySen'] as num?)?.toInt() ?? 300000),
              fixedAllowanceSen: drift.Value((p['fixedAllowanceSen'] as num?)?.toInt() ?? 0),
              currentSavingsSen: drift.Value((p['currentSavingsSen'] as num?)?.toInt() ?? 0),
              paydayDayOfMonth: drift.Value((p['paydayDayOfMonth'] as num?)?.toInt() ?? 25),
              epfRate: drift.Value((p['epfRate'] as num?)?.toDouble() ?? 0.11),
              isOnboarded: const drift.Value(true),
              updatedAt: drift.Value(DateTime.now()),
            ),
          );
        }

        // 2. Commitments
        if (decoded['commitments'] is List) {
          await db.delete(db.commitmentsTable).go();
          for (final item in decoded['commitments'] as List) {
            if (item is Map<String, dynamic>) {
              final remaining = (item['remainingAmountSen'] as num?)?.toInt() ?? 0;
              await db.into(db.commitmentsTable).insert(
                CommitmentsTableCompanion.insert(
                  title: item['title'] ?? 'Commitment',
                  type: item['type'] ?? 'other',
                  totalAmountSen: (item['totalAmountSen'] as num?)?.toInt() ?? remaining,
                  monthlyPaymentSen: (item['monthlyPaymentSen'] as num?)?.toInt() ?? 0,
                  remainingAmountSen: remaining,
                  remainingTenureMonths: drift.Value((item['remainingTenureMonths'] as num?)?.toInt() ?? 1),
                  dueDayOfMonth: drift.Value((item['dueDayOfMonth'] as num?)?.toInt() ?? 1),
                ),
              );
            }
          }
        }

        // 3. Expenses
        if (decoded['expenses'] is List) {
          await db.delete(db.expensesTable).go();
          final categories = await db.select(db.expenseCategoriesTable).get();
          final catMap = {for (var c in categories) c.name.toLowerCase(): c.id};
          final defaultCatId = categories.isNotEmpty ? categories.first.id : 'food';

          for (final item in decoded['expenses'] as List) {
            if (item is Map<String, dynamic>) {
              final catName = (item['category'] as String?)?.toLowerCase() ?? '';
              final categoryId = catMap[catName] ?? defaultCatId;
              final date = item['date'] != null
                  ? DateTime.tryParse(item['date']) ?? DateTime.now()
                  : DateTime.now();

              await db.into(db.expensesTable).insert(
                ExpensesTableCompanion.insert(
                  amountSen: (item['amountSen'] as num?)?.toInt() ?? 0,
                  categoryId: categoryId,
                  date: date,
                  note: drift.Value(item['note'] as String?),
                  isCommitmentPayment: drift.Value((item['isCommitment'] as bool?) ?? false),
                ),
              );
            }
          }
        }

        // 4. Checklist
        if (decoded['checklist'] is List) {
          for (final item in decoded['checklist'] as List) {
            if (item is Map<String, dynamic> && item['id'] != null) {
              final id = item['id'].toString();
              final isCompleted = (item['isCompleted'] as bool?) ?? false;
              await (db.update(db.checklistItemsTable)..where((t) => t.id.equals(id))).write(
                ChecklistItemsTableCompanion(
                  isCompleted: drift.Value(isCompleted),
                  completedAt: drift.Value(isCompleted ? DateTime.now() : null),
                ),
              );
            }
          }
        }
      });

      // 5. Tax Profiles & Receipt Claims (v1.6.0+)
      final taxRepo = ref.read(taxRepositoryProvider);
      if (decoded['taxProfiles'] is List || decoded['taxReceiptClaims'] is List) {
        await taxRepo.clearAllTaxData();
        if (decoded['taxProfiles'] is List) {
          for (final item in decoded['taxProfiles'] as List) {
            if (item is Map<String, dynamic>) {
              await taxRepo.saveTaxYearProfile(TaxYearProfileData.fromJson(item));
            }
          }
        }
        if (decoded['taxReceiptClaims'] is List) {
          for (final item in decoded['taxReceiptClaims'] as List) {
            if (item is Map<String, dynamic>) {
              final claim = TaxReceiptClaimData.fromJson(item);
              await taxRepo.addReceiptClaim(
                assessmentYear: claim.assessmentYear,
                expenseId: claim.expenseId,
                title: claim.title,
                amountSen: claim.amountSen,
                bucket: claim.bucket,
                subBucketId: claim.subBucketId,
                receiptRef: claim.receiptRef,
                claimedDate: claim.claimedDate,
                isAutoClassified: claim.isAutoClassified,
              );
            }
          }
        }
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color(0xFF10B981),
            content: Text('Backup restored successfully! All data has been loaded.'),
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

class _ProfilePill extends StatelessWidget {
  final String label;

  const _ProfilePill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _ThemeModeTile extends StatelessWidget {
  final AppThemeMode mode;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color activeColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeModeTile({
    required this.mode,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.activeColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? activeColor.withValues(alpha: 0.12) : AppColors.surfaceHigh,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? activeColor : AppColors.cardBorder,
              width: isSelected ? 1.8 : 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isSelected ? activeColor.withValues(alpha: 0.2) : AppColors.surface,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 16,
                      color: isSelected ? activeColor : AppColors.textSecondary,
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle_rounded,
                      size: 18,
                      color: activeColor,
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? activeColor : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
