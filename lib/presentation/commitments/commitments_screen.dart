import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/app_icons.dart';
import '../../core/utils/money.dart';
import '../../core/widgets/dsr_gauge.dart';
import '../../data/local/app_database.dart';
import '../../data/providers/dashboard_provider.dart';
import '../../data/providers/database_providers.dart';
import 'widgets/add_commitment_sheet.dart';
import 'widgets/add_spaylater_sheet.dart';
import 'widgets/affordability_simulator_sheet.dart';
import 'widgets/debt_payoff_sheet.dart';

class CommitmentsScreen extends ConsumerStatefulWidget {
  const CommitmentsScreen({super.key});

  @override
  ConsumerState<CommitmentsScreen> createState() => _CommitmentsScreenState();
}

class _CommitmentsScreenState extends ConsumerState<CommitmentsScreen> {
  String _filterTab = 'all'; // 'all', 'spaylater', 'loans'
  bool _isCompactView = false;

  void _showAddChoice(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border.all(color: AppColors.outline),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            const SizedBox(height: 18),
            Text(
              'Add Commitment',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Choose what type of commitment to record:',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 18),
            InkWell(
              onTap: () {
                Navigator.of(ctx).pop();
                AddSpayLaterSheet.show(context);
              },
              borderRadius: BorderRadius.circular(18),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEE4D2D).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFFEE4D2D).withValues(alpha: 0.35),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEE4D2D).withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.shopping_bag_rounded, size: 22, color: Color(0xFFEE4D2D)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Shopee SPayLater Purchase',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Track individual items, months left & monthly payments',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.accent),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () {
                Navigator.of(ctx).pop();
                AddCommitmentSheet.show(context);
              },
              borderRadius: BorderRadius.circular(18),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceHigh,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.outline),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(Icons.account_balance_rounded, size: 22, color: AppColors.primary),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fixed Loan or Subscription',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'PTPTN, MARA, Car Loan, SLoan, Personal Loan, etc.',
                            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textSecondary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stateAsync = ref.watch(dashboardStateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Commitments & Loans',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: -0.3),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline_rounded, color: AppColors.primary, size: 24),
            tooltip: 'Add Commitment',
            onPressed: () => _showAddChoice(context),
          ),
        ],
      ),
      body: stateAsync.when(
        loading: () => Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, _) => Center(
          child: Text('Error: $err', style: TextStyle(color: AppColors.danger)),
        ),
        data: (state) {
          final commitments = state.activeCommitments;
          final totalCommitment = state.allocation.totalCommitments;
          final dsr = state.allocation.dsrRatio * 100;
          final netSalary = state.netSalary.netSalary;
          final isIntern = state.employmentType.isIntern;

          final spayLaterItems = commitments.where((c) => c.type.toLowerCase() == 'spaylater').toList();
          final otherCommitments = commitments.where((c) => c.type.toLowerCase() != 'spaylater').toList();

          final int totalDebtOutstandingSen = commitments.fold<int>(0, (s, c) => s + c.remainingAmountSen);

          Color dsrColor;
          String dsrLabel;
          if (dsr <= 35) {
            dsrColor = AppColors.success;
            dsrLabel = 'Healthy (<35%)';
          } else if (dsr <= 50) {
            dsrColor = AppColors.warning;
            dsrLabel = 'Moderate (35-50%)';
          } else {
            dsrColor = AppColors.danger;
            dsrLabel = 'Critical (>50%)';
          }

          return Stack(
            children: [
              CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                slivers: [
                  // 1. Executive Debt Radar & DSR Gauge Card
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColors.cardBorder),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: AppColors.isDark ? 0.25 : 0.04),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Debt Service Ratio (DSR)',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: dsrColor.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: dsrColor.withValues(alpha: 0.4)),
                                  ),
                                  child: Text(
                                    dsrLabel,
                                    style: TextStyle(
                                      color: dsrColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Semantics(
                                  label: 'Debt service ratio ${dsr.toStringAsFixed(1)} percent, $dsrLabel',
                                  child: ExcludeSemantics(
                                    child: DsrGauge(
                                      dsrRatio: state.allocation.dsrRatio,
                                      size: 126,
                                      strokeWidth: 10,
                                      showStatusLabel: false,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Monthly commitments',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          totalCommitment.formatted,
                                          style: AppTypography.moneyAmount(fontSize: 22),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Healthy under 35%  •  Critical over 50%',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: AppColors.textSecondary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Divider(color: AppColors.outline.withValues(alpha: 0.5), height: 1),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Total Outstanding Debt',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  Money(totalDebtOutstandingSen).formatted,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 2. Action Hub Ribbon (Simulator & Strategy Tools)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      child: Row(
                        children: [
                          _buildQuickAction(
                            icon: Icons.psychology_alt_rounded,
                            label: 'Simulator',
                            color: AppColors.accent,
                            onTap: () => AffordabilitySimulatorSheet.show(context),
                          ),
                          const SizedBox(width: 10),
                          _buildQuickAction(
                            icon: Icons.auto_graph_rounded,
                            label: 'Strategy',
                            color: AppColors.primary,
                            onTap: () => DebtPayoffSheet.show(context, commitments),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 3. Segmented Filter & Density Switcher
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
                                  _buildFilterPill(
                                    label: 'All (${commitments.length})',
                                    isSelected: _filterTab == 'all',
                                    onTap: () => setState(() => _filterTab = 'all'),
                                  ),
                                  const SizedBox(width: 8),
                                  _buildFilterPill(
                                    label: 'SPayLater (${spayLaterItems.length})',
                                    isSelected: _filterTab == 'spaylater',
                                    onTap: () => setState(() => _filterTab = 'spaylater'),
                                  ),
                                  const SizedBox(width: 8),
                                  _buildFilterPill(
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
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: _isCompactView ? AppColors.primary.withValues(alpha: 0.15) : AppColors.surface,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: _isCompactView ? AppColors.primary : AppColors.outline.withValues(alpha: 0.6),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _isCompactView ? Icons.view_agenda_rounded : Icons.table_rows_rounded,
                                    size: 14,
                                    color: _isCompactView ? AppColors.primary : AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _isCompactView ? 'Compact' : 'Detailed',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: _isCompactView ? AppColors.primary : AppColors.textSecondary,
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

                  // 4. SPayLater Purchases Section
                  if (_filterTab == 'all' || _filterTab == 'spaylater') ...[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEE4D2D).withValues(alpha: 0.18),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Text('🛍️', style: TextStyle(fontSize: 16)),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'SPayLater Purchases (${spayLaterItems.length})',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            TextButton.icon(
                              onPressed: () => AddSpayLaterSheet.show(context),
                              icon: const Icon(Icons.add_rounded, size: 16),
                              label: const Text('Add Item', style: TextStyle(fontSize: 12)),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.accent,
                                backgroundColor: AppColors.accent.withValues(alpha: 0.15),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (spayLaterItems.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                          child: _buildSpayLaterImpactBanner(
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
                                  ? _buildCompactCard(context, ref, c, isSpay: true)
                                  : _buildDetailedCard(context, ref, c, isSpay: true);
                            },
                            childCount: spayLaterItems.length,
                          ),
                        ),
                      ),
                    ],
                  ],

                  // 5. Fixed Loans & Other Commitments Section
                  if (_filterTab == 'all' || _filterTab == 'loans') ...[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.18),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(Icons.account_balance_rounded, size: 16, color: AppColors.primary),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Other Commitments & Fixed Loans (${otherCommitments.length})',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            TextButton.icon(
                              onPressed: () => AddCommitmentSheet.show(context),
                              icon: const Icon(Icons.add_rounded, size: 16),
                              label: const Text('Add Loan', style: TextStyle(fontSize: 12)),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
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
                                  ? _buildCompactCard(context, ref, c, isSpay: false)
                                  : _buildDetailedCard(context, ref, c, isSpay: false);
                            },
                            childCount: otherCommitments.length,
                          ),
                        ),
                      ),
                  ],

                  // 6. Zero Commitments Celebration (when empty)
                  if (commitments.isEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                        child: Container(
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: AppColors.outline.withValues(alpha: 0.6)),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.celebration_rounded, size: 32, color: AppColors.primary),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                'Zero Commitments!',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Your take-home pay has zero loan deductions. Full cash flexibility!',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () => _showAddChoice(context),
                                icon: const Icon(Icons.add_rounded, size: 18),
                                label: const Text('Add Commitment'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: AppColors.onPrimary,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
                          onPressed: () => _showAddChoice(context),
                          icon: const Icon(Icons.add_rounded, size: 20),
                          label: const Text(
                            'Add Commitment',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 8),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterPill({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.16) : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outline.withValues(alpha: 0.6),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildSpayLaterImpactBanner({
    required List<CommitmentsTableData> spayLaterItems,
    required Money netSalary,
    required bool isIntern,
  }) {
    final totalMonthlySen = spayLaterItems.fold<int>(0, (sum, c) => sum + c.monthlyPaymentSen);
    final totalRemainingSen = spayLaterItems.fold<int>(0, (sum, c) => sum + c.remainingAmountSen);
    final ratio = netSalary.sen > 0 ? (totalMonthlySen / netSalary.sen) * 100 : 0.0;

    Color impactColor;
    String impactBadge;
    String adviceText;
    if (ratio <= 10) {
      impactColor = AppColors.success;
      impactBadge = 'Manageable (<10%)';
      adviceText = 'Your SPayLater installments are well-controlled.';
    } else if (ratio <= 20) {
      impactColor = AppColors.warning;
      impactBadge = 'Moderate (10-20%)';
      adviceText = isIntern
          ? 'SPayLater takes a noticeable bite out of your RM 900 allowance.'
          : 'Hold off on new BNPL installments until existing ones clear.';
    } else {
      impactColor = AppColors.danger;
      impactBadge = 'High Burden (>20%)';
      adviceText = isIntern
          ? 'Critical: over 20% of your allowance is pre-committed to SPayLater!'
          : 'High BNPL load. Settle items early to free up cash flow.';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: impactColor.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.pie_chart_outline_rounded, size: 16, color: AppColors.accent),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'SPayLater Financial Impact',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: impactColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: impactColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  impactBadge,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: impactColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${Money(totalMonthlySen).formatted} / mo',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: impactColor),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${ratio.toStringAsFixed(1)}% of your ${netSalary.formatted} ${isIntern ? 'allowance' : 'salary'}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Total Outstanding', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                  Text(
                    Money(totalRemainingSen).formatted,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (ratio / 100).clamp(0.0, 1.0),
              backgroundColor: AppColors.surfaceHigh,
              valueColor: AlwaysStoppedAnimation<Color>(impactColor),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            adviceText,
            style: TextStyle(fontSize: 11, color: impactColor.withValues(alpha: 0.9), fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedCard(
    BuildContext context,
    WidgetRef ref,
    CommitmentsTableData c, {
    required bool isSpay,
  }) {
    final progress = c.totalTenureMonths > 0
        ? ((c.totalTenureMonths - c.remainingTenureMonths) / c.totalTenureMonths).clamp(0.0, 1.0)
        : 0.0;
    final monthsPaid = (c.totalTenureMonths - c.remainingTenureMonths).clamp(0, 999);
    final brandColor = isSpay ? const Color(0xFFEE4D2D) : AppColors.primary;

    return Dismissible(
      key: Key(isSpay ? 'spaylater_${c.id}' : 'commitment_${c.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.danger.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(Icons.delete_outline_rounded, color: AppColors.danger),
      ),
      onDismissed: (_) {
        ref.read(commitmentRepositoryProvider).deleteCommitment(c.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Deleted commitment ${c.title}')),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSpay ? const Color(0xFFEE4D2D).withValues(alpha: 0.25) : AppColors.outline.withValues(alpha: 0.6),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: brandColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: isSpay
                      ? const Text('🛍️', style: TextStyle(fontSize: 20))
                      : Icon(AppIcons.getCommitmentIcon(c.type), size: 20, color: brandColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    c.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: Icon(Icons.edit_outlined, size: 18, color: AppColors.textSecondary),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                  tooltip: 'Edit item',
                  onPressed: () => isSpay ? AddSpayLaterSheet.edit(context, c) : AddCommitmentSheet.edit(context, c),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceHigh,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Due on ${c.dueDayOfMonth}th',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${c.remainingTenureMonths} mo left',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.accent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          Money(c.monthlyPaymentSen).formatted,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
                        ),
                      ),
                      Text('/ month', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    '$monthsPaid of ${c.totalTenureMonths} months paid',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'Remaining: ${Money(c.remainingAmountSen).formatted} of ${Money(c.totalAmountSen).formatted}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
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
                valueColor: AlwaysStoppedAnimation<Color>(brandColor),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              alignment: WrapAlignment.end,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 6,
              children: [
                TextButton(
                  onPressed: () => _confirmSettlement(context, ref, c),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('Settle Early', style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
                ),
                TextButton.icon(
                  onPressed: () => _confirmPayment(context, ref, c),
                  icon: Icon(Icons.check_circle_outline_rounded, size: 16, color: AppColors.primary),
                  label: Text(
                    isSpay ? 'Pay 1 Mo (${Money(c.monthlyPaymentSen).formatted})' : 'Record Payment',
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactCard(
    BuildContext context,
    WidgetRef ref,
    CommitmentsTableData c, {
    required bool isSpay,
  }) {
    final brandColor = isSpay ? const Color(0xFFEE4D2D) : AppColors.primary;

    return Dismissible(
      key: Key('compact_${c.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.danger.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(Icons.delete_outline_rounded, color: AppColors.danger),
      ),
      onDismissed: (_) {
        ref.read(commitmentRepositoryProvider).deleteCommitment(c.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Deleted ${c.title}')),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.outline.withValues(alpha: 0.6)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: brandColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(isSpay ? Icons.shopping_bag_rounded : AppIcons.getCommitmentIcon(c.type), size: 16, color: brandColor),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary)),
                  Text('Due ${c.dueDayOfMonth}th • ${c.remainingTenureMonths} mo left', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(Money(c.monthlyPaymentSen).formatted, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary)),
                  ),
                  Text('Rem: ${Money(c.remainingAmountSen).formatted}', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert_rounded, size: 16, color: AppColors.textSecondary),
              color: AppColors.surfaceHigh,
              onSelected: (val) {
                if (val == 'pay') _confirmPayment(context, ref, c);
                if (val == 'settle') _confirmSettlement(context, ref, c);
                if (val == 'edit') {
                  isSpay ? AddSpayLaterSheet.edit(context, c) : AddCommitmentSheet.edit(context, c);
                }
              },
              itemBuilder: (ctx) => [
                PopupMenuItem(value: 'pay', child: Text('Pay 1 Mo (${Money(c.monthlyPaymentSen).formatted})')),
                const PopupMenuItem(value: 'settle', child: Text('Settle Early')),
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmPayment(BuildContext context, WidgetRef ref, CommitmentsTableData c) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Record Payment for ${c.title}?', style: TextStyle(color: AppColors.textPrimary, fontSize: 18)),
        content: Text(
          'This will record 1 installment of ${Money(c.monthlyPaymentSen).formatted} and log it as an expense.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await ref.read(commitmentRepositoryProvider).recordPayment(
                    commitmentId: c.id,
                    paymentAmountSen: c.monthlyPaymentSen,
                    date: DateTime.now(),
                  );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Recorded payment of ${Money(c.monthlyPaymentSen).formatted}!')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: AppColors.onPrimary),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _confirmSettlement(BuildContext context, WidgetRef ref, CommitmentsTableData c) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Settle ${c.title} Early?', style: TextStyle(color: AppColors.textPrimary, fontSize: 18)),
        content: Text(
          'This will settle the entire remaining balance of ${Money(c.remainingAmountSen).formatted} in full and mark this commitment as completed.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await ref.read(commitmentRepositoryProvider).settleCommitment(
                    commitmentId: c.id,
                    date: DateTime.now(),
                  );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Settled ${c.title} in full (${Money(c.remainingAmountSen).formatted})!')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, foregroundColor: Colors.white),
            child: const Text('Settle in Full'),
          ),
        ],
      ),
    );
  }
}
