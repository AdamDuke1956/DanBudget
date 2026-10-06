import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:local_auth/local_auth.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/glass_card.dart';
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
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: stateAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, _) => Center(
          child: Text('Error: $err', style: const TextStyle(color: AppColors.danger)),
        ),
        data: (state) {
          final profile = state.profile;

          return CustomScrollView(
            slivers: [
              // User Profile Info Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: GlassCard(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                          child: Text(state.employmentType.emoji,
                              style: const TextStyle(fontSize: 26)),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${state.employmentType.label} • ${state.employmentType.incomeLabel}: ${state.netSalary.grossSalary.formatted} • Payday: ${profile.paydayDayOfMonth}th',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.tune_rounded, color: AppColors.primary),
                          onPressed: () => SalaryEditSheet.show(context, profile),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Financial Health Score
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: HealthScoreCard(health: state.healthScore),
                ),
              ),

              // Starter Pack Checklist
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: const ChecklistSection(),
                ),
              ),

              // Preferences & Security
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: GlassCard(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Preferences & Security',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Biometrics toggle
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text(
                            'Biometric App Lock',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          subtitle: const Text(
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
                                    const SnackBar(
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
                                      const SnackBar(
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
                                        style: const TextStyle(color: AppColors.danger),
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
                        const Divider(color: AppColors.outline, height: 16),

                        // AI Coach toggle
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text(
                            'AI Financial Coaching',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          subtitle: const Text(
                            'Display dynamic cashflow and budget recommendations',
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
                        const Divider(color: AppColors.outline, height: 16),

                        // Export Data Tile
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.file_download_outlined,
                                color: AppColors.primary, size: 20),
                          ),
                          title: const Text(
                            'Export Financial Backup',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          subtitle: const Text(
                            'Generate complete JSON backup of records',
                            style: TextStyle(
                                fontSize: 12, color: AppColors.textSecondary),
                          ),
                          trailing: const Icon(Icons.chevron_right_rounded,
                              color: AppColors.textSecondary),
                          onTap: () => _exportDataAsJson(context, ref, state),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Local-only Privacy Assurance
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceHigh,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.outline),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('🛡️', style: TextStyle(fontSize: 22)),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '100% Local-First Privacy',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Your financial records, payslips, and loan details are stored strictly in an encrypted on-device SQLite database. Zero cloud accounts, zero telemetry, zero data retention.',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // App Version & Offline Guarantee
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          'DanBudget v1.0.0 • Malaysian Fresh Grad Edition',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Built with Flutter & Drift SQLite • 100% Offline & Private',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 90)),
            ],
          );
        },
      ),
    );
  }

  void _exportDataAsJson(
      BuildContext context, WidgetRef ref, DashboardState state) async {
    final expenses =
        await ref.read(expenseRepositoryProvider).getAllExpenses();
    final commitments = state.activeCommitments;
    final checklist = await ref
        .read(checklistRepositoryProvider)
        .watchChecklistItems()
        .first;

    final data = {
      'exportedAt': DateTime.now().toIso8601String(),
      'version': '1.0.0',
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.shield_outlined, color: AppColors.primary),
              SizedBox(width: 8),
              Text('100% Local Backup',
                  style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
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
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary),
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
                      style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 10,
                          color: AppColors.textPrimary),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Close',
                  style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: jsonStr));
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Copied complete local JSON backup to clipboard!'),
                  ),
                );
              },
              icon: const Icon(Icons.copy_rounded, size: 16),
              label: const Text('Copy JSON'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: const Color(0xFF04291F),
              ),
            ),
          ],
        ),
      );
    }
  }
}
