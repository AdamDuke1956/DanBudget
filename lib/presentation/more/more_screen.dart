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
import '../plan/widgets/salary_edit_sheet.dart';
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
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColors.cardBorder),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: AppColors.isDark ? 0.2 : 0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundColor: AppColors.primary.withValues(alpha: 0.18),
                              child: Text(
                                state.employmentType.emoji.isNotEmpty ? state.employmentType.emoji : '👤',
                                style: const TextStyle(fontSize: 24),
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
                                  const SizedBox(height: 3),
                                  Text(
                                    '${state.employmentType.label} • Gross: ${state.netSalary.grossSalary.formatted} • Payday: ${profile.paydayDayOfMonth}th',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
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
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: AppColors.outline.withValues(alpha: 0.6)),
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
                              'App Color Palette & Theme',
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
                                'Require fingerprint / Face ID on app launch',
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
                                'AI Financial Coaching',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                              ),
                              subtitle: Text(
                                'Display contextual cashflow and budget advice',
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
                            Divider(color: AppColors.outline.withValues(alpha: 0.5), height: 16),

                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(Icons.file_download_outlined, color: AppColors.primary, size: 20),
                              ),
                              title: Text(
                                'Export Financial Backup',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                              ),
                              subtitle: Text(
                                'Generate complete JSON backup of records',
                                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                              trailing: Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                              onTap: () => _exportDataAsJson(context, ref, state),
                            ),
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
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.outline.withValues(alpha: 0.6)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.shield_rounded, size: 22, color: AppColors.primary),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '100% Local-First Privacy',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'All transactions, payslips, and commitments are stored encrypted in on-device SQLite. Zero cloud tracking, zero telemetry, 100% private.',
                                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.4),
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
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              'DanBudget v1.5.0 • Malaysian Fresh Grad Edition',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary.withValues(alpha: 0.7)),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Built with Flutter & Drift SQLite • 100% Offline & Private',
                              style: TextStyle(fontSize: 10, color: AppColors.textSecondary.withValues(alpha: 0.5)),
                            ),
                          ],
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
                    color: AppColors.surface.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.outline.withValues(alpha: 0.8)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: AppColors.isDark ? 0.35 : 0.08),
                        blurRadius: 18,
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
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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

    final data = {
      'exportedAt': DateTime.now().toIso8601String(),
      'version': '1.5.0',
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
                const SizedBox(height: 12),
                Container(
                  height: 180,
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
                  const SnackBar(content: Text('Copied complete local JSON backup to clipboard!')),
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
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? activeColor.withValues(alpha: 0.12) : AppColors.surfaceHigh,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? activeColor : AppColors.outline.withValues(alpha: 0.7),
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
