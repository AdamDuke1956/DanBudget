import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/money.dart';
import '../../../data/local/app_database.dart';
import '../../../data/providers/dashboard_provider.dart';
import '../../../data/providers/database_providers.dart';

class DailySpendingCalendarSheet extends ConsumerStatefulWidget {
  const DailySpendingCalendarSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const DailySpendingCalendarSheet(),
    );
  }

  @override
  ConsumerState<DailySpendingCalendarSheet> createState() =>
      _DailySpendingCalendarSheetState();
}

class _DailySpendingCalendarSheetState
    extends ConsumerState<DailySpendingCalendarSheet> {
  @override
  Widget build(BuildContext context) {
    final dashAsync = ref.watch(dashboardStateProvider);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return dashAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (dash) {
        final profile = dash.profile;
        final safe = dash.safeToSpend;
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final payday = safe.nextPaydayDate ?? DateTime(now.year, now.month, profile.paydayDayOfMonth);

        final daysUntil = safe.daysUntilPayday;
        final workdays = safe.workdaysUntilPayday;
        final weekends = safe.weekendDaysUntilPayday;

        final daysList = <DateTime>[];
        var cur = today;
        while (!cur.isAfter(payday)) {
          daysList.add(cur);
          cur = cur.add(const Duration(days: 1));
        }

        final plansStream = ref.watch(dailyPlanRepositoryProvider).watchPlansForRange(today, payday);

        return StreamBuilder<List<DailySpendingPlansTableData>>(
          stream: plansStream,
          builder: (context, snapshot) {
            final plans = snapshot.data ?? [];
            final planMap = {
              for (final p in plans)
                DateTime(p.date.year, p.date.month, p.date.day): p
            };

            int totalPlannedSen = 0;
            for (final d in daysList) {
              final p = planMap[d];
              if (p != null) {
                totalPlannedSen += p.targetAmountSen;
              }
            }

            final remainingUnallocatedSen =
                (safe.effectiveDisposable.sen - totalPlannedSen)
                    .clamp(0, double.infinity)
                    .toInt();

            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.9,
              ),
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: 20 + bottomInset,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
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
                      Row(
                        children: [
                          Icon(Icons.calendar_month_rounded, color: AppColors.primary),
                          SizedBox(width: 8),
                          Text(
                            'Daily Spending Calendar',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.info_outline_rounded, size: 20, color: AppColors.textSecondary),
                        onPressed: () => _showCycleExplanation(context, profile.paydayDayOfMonth, daysUntil, workdays, weekends),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Set how much to spend each day, what to buy, and why.',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 14),

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
                            Text(
                              'Cycle: Until ${DateFormat('dd MMM').format(payday)} (Payday)',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '$daysUntil days ($workdays workdays)',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Remaining Budget', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                                Text(
                                  safe.effectiveDisposable.formatted,
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Total Planned', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                                Text(
                                  Money(totalPlannedSen).formatted,
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.accent),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Unplanned Pool', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                                Text(
                                  Money(remainingUnallocatedSen).formatted,
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.success),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _bulkSetWorkdayLunch(context, today, payday),
                          icon: const Icon(Icons.lunch_dining_rounded, size: 14),
                          label: const Text(
                            'Set Mon–Fri Lunch (RM 10)',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: BorderSide(color: AppColors.primary),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () => _toggleWorkdaysOnlyPreference(profile),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: profile.workdaysOnlySafeToSpend ? AppColors.accent : AppColors.textSecondary,
                          side: BorderSide(
                            color: profile.workdaysOnlySafeToSpend ? AppColors.accent : AppColors.outline,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          profile.workdaysOnlySafeToSpend ? 'Workdays Mode: ON' : 'Workdays: OFF',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Expanded(
                    child: ListView.separated(
                      itemCount: daysList.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, i) {
                        final date = daysList[i];
                        final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
                        final isPayday = date.day == payday.day && date.month == payday.month;
                        final isWorkday = date.weekday >= DateTime.monday && date.weekday <= DateTime.friday;

                        final plan = planMap[date];
                        final targetSen = plan?.targetAmountSen ?? (isWorkday ? profile.defaultWorkdayTargetSen : profile.defaultWeekendTargetSen);
                        final whatToSpend = plan?.whatToSpendOn ?? (isWorkday ? 'Lunch' : 'Personal / Weekend');
                        final reason = plan?.reason ?? (isWorkday ? 'Workday meal budget' : 'Free spending');

                        return InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () => _showEditDayDialog(context, date, plan, isWorkday, targetSen, whatToSpend, reason),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: isToday
                                  ? AppColors.primary.withValues(alpha: 0.12)
                                  : AppColors.surfaceHigh,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isToday
                                    ? AppColors.primary
                                    : (isPayday ? AppColors.accent : AppColors.outline.withValues(alpha: 0.5)),
                                width: isToday ? 1.5 : 1.0,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  decoration: BoxDecoration(
                                    color: (isToday ? AppColors.primary : AppColors.surface).withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        DateFormat('E').format(date).toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: isWorkday ? AppColors.textPrimary : AppColors.accent,
                                        ),
                                      ),
                                      Text(
                                        '${date.day}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                          color: isToday ? AppColors.primary : AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            whatToSpend,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          if (isToday) ...[
                                            const SizedBox(width: 6),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                              decoration: BoxDecoration(
                                                color: AppColors.primary,
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: const Text(
                                                'TODAY',
                                                style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF04291F)),
                                              ),
                                            ),
                                          ],
                                          if (isPayday) ...[
                                            const SizedBox(width: 6),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                              decoration: BoxDecoration(
                                                color: AppColors.accent,
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: const Text(
                                                'PAYDAY 🎉',
                                                style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        reason,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                      ),
                                    ],
                                  ),
                                ),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      Money(targetSen).formatted,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: plan != null ? AppColors.primary : AppColors.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      plan != null ? 'Custom' : 'Default',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: plan != null ? AppColors.primary : AppColors.textSecondary,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 6),
                                Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.textSecondary),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showCycleExplanation(
    BuildContext context,
    int paydayDayOfMonth,
    int totalDays,
    int workdays,
    int weekends,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
              'Cycle Breakdown',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '• $totalDays days until your next payday (${paydayDayOfMonth}th).\n'
              '• $workdays workdays (Mon–Fri) and $weekends weekend days.\n'
              '• Tap "Set Mon–Fri Lunch" to batch-fill your workday meal targets.',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.45),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: const Color(0xFF04291F),
                minimumSize: const Size.fromHeight(46),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Understood', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleWorkdaysOnlyPreference(UserProfileTableData profile) async {
    final newValue = !profile.workdaysOnlySafeToSpend;
    await ref.read(profileRepositoryProvider).updateProfile(
          UserProfileTableCompanion(
            workdaysOnlySafeToSpend: Value(newValue),
          ),
        );
  }

  Future<void> _bulkSetWorkdayLunch(
    BuildContext context,
    DateTime start,
    DateTime end,
  ) async {
    final targetController = TextEditingController(text: '10.00');

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Quick Set Workday Lunch', style: TextStyle(color: AppColors.textPrimary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Apply a targeted lunch allowance for every working day (Monday – Friday) until payday:',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: targetController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                labelText: 'Daily Target Amount',
                labelStyle: TextStyle(color: AppColors.textSecondary),
                prefixText: 'RM ',
                filled: true,
                fillColor: AppColors.surfaceHigh,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: const Color(0xFF04291F),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Apply Target'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final ringgit = double.tryParse(targetController.text.trim()) ?? 10.0;
      final sen = Money.fromRinggit(ringgit).sen;
      await ref.read(dailyPlanRepositoryProvider).bulkSetWorkdays(
            startDate: start,
            endDate: end,
            targetSen: sen,
            whatToSpendOn: 'Lunch',
            reason: 'Workday lunch allowance',
          );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Applied RM ${ringgit.toStringAsFixed(2)} lunch target across all workdays!'),
            backgroundColor: AppColors.surfaceHigh,
          ),
        );
      }
    }
  }

  void _showEditDayDialog(
    BuildContext context,
    DateTime date,
    DailySpendingPlansTableData? plan,
    bool isWorkdayDefault,
    int currentTargetSen,
    String currentWhatToSpend,
    String currentReason,
  ) {
    final amountCtrl = TextEditingController(
      text: (currentTargetSen / 100).toStringAsFixed(2),
    );
    final whatCtrl = TextEditingController(text: currentWhatToSpend);
    final reasonCtrl = TextEditingController(text: currentReason);
    bool isWorkday = plan?.isWorkday ?? isWorkdayDefault;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Plan ${DateFormat('EEEE, dd MMM').format(date)}',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 18),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: amountCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    labelText: 'Targeted Spend Amount',
                    labelStyle: TextStyle(color: AppColors.textSecondary),
                    prefixText: 'RM ',
                    filled: true,
                    fillColor: AppColors.surfaceHigh,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                const SizedBox(height: 12),

                Wrap(
                  spacing: 6,
                  children: [
                    'Lunch',
                    'Coffee',
                    'Petrol',
                    'Groceries',
                    'Hangout',
                  ].map((preset) {
                    return ActionChip(
                      label: Text(preset, style: const TextStyle(fontSize: 11)),
                      backgroundColor: AppColors.surfaceHigh,
                      onPressed: () {
                        setDialogState(() {
                          whatCtrl.text = preset;
                          if (preset == 'Lunch') {
                            reasonCtrl.text = 'Workday office meal';
                          } else if (preset == 'Coffee') {
                            reasonCtrl.text = 'Cafe / treat';
                          } else if (preset == 'Petrol') {
                            reasonCtrl.text = 'Fuel refill';
                          } else if (preset == 'Groceries') {
                            reasonCtrl.text = 'Weekly household staples';
                          } else if (preset == 'Hangout') {
                            reasonCtrl.text = 'Weekend gathering with friends';
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: whatCtrl,
                  style: TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'What to spend on',
                    labelStyle: TextStyle(color: AppColors.textSecondary),
                    hintText: 'e.g. Lunch at office, Mixed rice',
                    filled: true,
                    fillColor: AppColors.surfaceHigh,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: reasonCtrl,
                  style: TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Why / Reason note',
                    labelStyle: TextStyle(color: AppColors.textSecondary),
                    hintText: 'e.g. Workday meal, Dinner with team',
                    filled: true,
                    fillColor: AppColors.surfaceHigh,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                const SizedBox(height: 12),

                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Mark as Workday', style: TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                  value: isWorkday,
                  activeColor: AppColors.primary,
                  onChanged: (val) => setDialogState(() => isWorkday = val),
                ),
              ],
            ),
          ),
          actions: [
            if (plan != null)
              TextButton(
                onPressed: () async {
                  Navigator.of(ctx).pop();
                  await ref.read(dailyPlanRepositoryProvider).deletePlanForDate(date);
                },
                child: Text('Reset', style: TextStyle(color: AppColors.danger)),
              ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: const Color(0xFF04291F),
              ),
              onPressed: () async {
                final ringgit = double.tryParse(amountCtrl.text.trim()) ?? 0.0;
                final sen = Money.fromRinggit(ringgit).sen;
                Navigator.of(ctx).pop();
                await ref.read(dailyPlanRepositoryProvider).setPlanForDate(
                      date: date,
                      targetAmountSen: sen,
                      whatToSpendOn: whatCtrl.text.trim().isEmpty ? null : whatCtrl.text.trim(),
                      reason: reasonCtrl.text.trim().isEmpty ? null : reasonCtrl.text.trim(),
                      isWorkday: isWorkday,
                    );
              },
              child: const Text('Save Plan'),
            ),
          ],
        ),
      ),
    );
  }
}
