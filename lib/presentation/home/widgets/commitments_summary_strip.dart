import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../data/providers/dashboard_provider.dart';

class CommitmentsSummaryStrip extends StatelessWidget {
  const CommitmentsSummaryStrip({
    super.key,
    required this.state,
    this.onManage,
  });

  final DashboardState state;
  final VoidCallback? onManage;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isElevatedDsr = state.allocation.dsrRatio > 0.4;
    final badgeColor = isElevatedDsr ? colors.warning : colors.accent;

    return SurfaceCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.account_balance_wallet_rounded,
              color: badgeColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${state.activeCommitments.length} commitments',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${state.allocation.totalCommitments.formatted}/mo, DSR ${(state.allocation.dsrRatio * 100).toStringAsFixed(1)}%',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onManage,
            child: Text(
              'Manage',
              style: TextStyle(
                color: colors.accent,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
