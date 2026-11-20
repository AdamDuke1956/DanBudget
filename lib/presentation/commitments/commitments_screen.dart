import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/surface_card.dart';
import '../../data/providers/dashboard_provider.dart';
import 'widgets/add_commitment_choice_sheet.dart';
import 'widgets/add_commitment_sheet.dart';
import 'widgets/add_spaylater_sheet.dart';
import 'widgets/commitment_cards.dart';
import 'widgets/dsr_radar_card.dart';
import 'widgets/spaylater_impact_banner.dart';

class CommitmentsScreen extends ConsumerStatefulWidget {
  const CommitmentsScreen({super.key});

  @override
  ConsumerState<CommitmentsScreen> createState() => _CommitmentsScreenState();
}

class _CommitmentsScreenState extends ConsumerState<CommitmentsScreen> {
  String _filterTab = 'all'; // 'all', 'spaylater', 'loans'
  bool _isCompactView = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final stateAsync = ref.watch(dashboardStateProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text(
          'Commitments & Loans',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: -0.3),
        ),
        backgroundColor: colors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline_rounded, color: colors.primary, size: 24),
            tooltip: 'Add Commitment',
            onPressed: () => AddCommitmentChoiceSheet.show(context),
          ),
        ],
      ),
      body: stateAsync.when(
        loading: () => Center(
          child: CircularProgressIndicator(color: colors.primary),
        ),
        error: (err, _) => Center(
          child: Text('Error: $err', style: TextStyle(color: colors.danger)),
        ),
        data: (state) {
          final commitments = state.activeCommitments;
          final totalCommitment = state.allocation.totalCommitments;
          final netSalary = state.netSalary.netSalary;
          final isIntern = state.employmentType.isIntern;

          final spayLaterItems =
              commitments.where((c) => c.type.toLowerCase() == 'spaylater').toList();
          final otherCommitments =
              commitments.where((c) => c.type.toLowerCase() != 'spaylater').toList();
          final totalDebtOutstandingSen =
              commitments.fold<int>(0, (s, c) => s + c.remainingAmountSen);

          return Stack(
            children: [
              CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
                      child: DsrRadarCard(
                        dsrRatio: state.allocation.dsrRatio,
                        totalMonthlyCommitment: totalCommitment,
                        totalDebtOutstandingSen: totalDebtOutstandingSen,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      child: CommitmentsActionHubRibbon(commitments: commitments),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _FilterPill(
                                    label: 'All (${commitments.length})',
                                    isSelected: _filterTab == 'all',
                                    onTap: () => setState(() => _filterTab = 'all'),
                                  ),
                                  const SizedBox(width: 8),
                                  _FilterPill(
                                    label: 'SPayLater (${spayLaterItems.length})',
                                    isSelected: _filterTab == 'spaylater',
                                    onTap: () => setState(() => _filterTab = 'spaylater'),
                                  ),
                                  const SizedBox(width: 8),
                                  _FilterPill(
                                    label: 'Loans (${otherCommitments.length})',
                                    isSelected: _filterTab == 'loans',
                                    onTap: () => setState(() => _filterTab = 'loans'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () => setState(() => _isCompactView = !_isCompactView),
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: _isCompactView
                                    ? colors.primary.withValues(alpha: 0.15)
                                    : colors.surface,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: _isCompactView ? colors.primary : colors.cardBorder,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _isCompactView
                                        ? Icons.view_agenda_rounded
                                        : Icons.table_rows_rounded,
                                    size: 14,
                                    color: _isCompactView ? colors.primary : colors.textSecondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _isCompactView ? 'Compact' : 'Detailed',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: _isCompactView ? colors.primary : colors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_filterTab == 'all' || _filterTab == 'spaylater') ...[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
                        child: _SectionHeader(
                          leading: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEE4D2D).withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text('🛍️', style: TextStyle(fontSize: 16)),
                          ),
                          title: 'SPayLater Purchases (${spayLaterItems.length})',
                          actionLabel: 'Add Item',
                          actionColor: colors.accent,
                          onAction: () => AddSpayLaterSheet.show(context),
                        ),
                      ),
                    ),
                    if (spayLaterItems.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                          child: SpayLaterImpactBanner(
                            spayLaterItems: spayLaterItems,
                            netSalary: netSalary,
                            isIntern: isIntern,
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, i) {
                              final c = spayLaterItems[i];
                              return _isCompactView
                                  ? CompactCommitmentCard(commitment: c, isSpay: true)
                                  : DetailedCommitmentCard(commitment: c, isSpay: true);
                            },
                            childCount: spayLaterItems.length,
                          ),
                        ),
                      ),
                    ],
                  ],
                  if (_filterTab == 'all' || _filterTab == 'loans') ...[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                        child: _SectionHeader(
                          leading: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: colors.primary.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.account_balance_rounded, size: 16, color: colors.primary),
                          ),
                          title: 'Fixed Loans (${otherCommitments.length})',
                          actionLabel: 'Add Loan',
                          actionColor: colors.primary,
                          onAction: () => AddCommitmentSheet.show(context),
                        ),
                      ),
                    ),
                    if (otherCommitments.isNotEmpty)
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, i) {
                              final c = otherCommitments[i];
                              return _isCompactView
                                  ? CompactCommitmentCard(commitment: c, isSpay: false)
                                  : DetailedCommitmentCard(commitment: c, isSpay: false);
                            },
                            childCount: otherCommitments.length,
                          ),
                        ),
                      ),
                  ],
                  if (commitments.isEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                        child: SurfaceCard(
                          padding: const EdgeInsets.all(28),
                          child: Column(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: colors.primary.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check_circle_outline_rounded,
                                  size: 32,
                                  color: colors.primary,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                'No commitments yet',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: colors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () => AddCommitmentChoiceSheet.show(context),
                                icon: const Icon(Icons.add_rounded, size: 18),
                                label: const Text('Add Commitment'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colors.primary,
                                  foregroundColor: colors.onPrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 16,
                child: SurfaceCard(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => AddCommitmentChoiceSheet.show(context),
                          icon: const Icon(Icons.add_rounded, size: 20),
                          label: const Text(
                            'Add Commitment',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.primary,
                            foregroundColor: colors.onPrimary,
                            elevation: 0,
                            minimumSize: const Size(0, 48),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary.withValues(alpha: 0.16) : colors.surface,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? colors.primary : colors.cardBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? colors.primary : colors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.leading,
    required this.title,
    required this.actionLabel,
    required this.actionColor,
    required this.onAction,
  });

  final Widget leading;
  final String title;
  final String actionLabel;
  final Color actionColor;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              leading,
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        TextButton.icon(
          onPressed: onAction,
          icon: const Icon(Icons.add_rounded, size: 16),
          label: Text(actionLabel, style: const TextStyle(fontSize: 12)),
          style: TextButton.styleFrom(
            foregroundColor: actionColor,
            backgroundColor: actionColor.withValues(alpha: 0.15),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }
}
