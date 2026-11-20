import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../data/providers/dashboard_provider.dart';
import '../../plan/widgets/salary_edit_sheet.dart';

class ProfileBannerCard extends StatelessWidget {
  const ProfileBannerCard({super.key, required this.state});

  final DashboardState state;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final profile = state.profile;

    return SurfaceCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: colors.primary.withValues(alpha: 0.15),
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: colors.textPrimary,
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
            icon: Icon(Icons.tune_rounded, color: colors.primary),
            tooltip: 'Edit Profile & Salary',
            onPressed: () => SalaryEditSheet.show(context, profile),
          ),
        ],
      ),
    );
  }
}

class _ProfilePill extends StatelessWidget {
  const _ProfilePill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colors.surfaceHigh,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: colors.cardBorder),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: colors.textSecondary,
        ),
      ),
    );
  }
}
