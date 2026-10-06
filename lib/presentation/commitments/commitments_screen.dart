import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/money.dart';
import '../../core/widgets/glass_card.dart';
import '../../data/local/app_database.dart';
import '../../data/providers/dashboard_provider.dart';
import '../../data/providers/database_providers.dart';
import 'widgets/add_commitment_sheet.dart';
import 'widgets/add_spaylater_sheet.dart';
import 'widgets/affordability_simulator_sheet.dart';
import 'widgets/debt_payoff_sheet.dart';

class CommitmentsScreen extends ConsumerWidget {
  const CommitmentsScreen({super.key});

  void _showAddChoice(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
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
            const Text(
              'Add Commitment',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Choose what type of commitment you want to record:',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 18),

            // SPayLater Option
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
                      child: const Text('🛍️', style: TextStyle(fontSize: 22)),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
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
                          SizedBox(height: 2),
                          Text(
                            'Track individual items, months left & allowance impact',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded,
                        size: 14, color: AppColors.accent),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Fixed Loan Option
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
                      child: const Text('🏦', style: TextStyle(fontSize: 22)),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
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
                          SizedBox(height: 2),
                          Text(
                            'PTPTN, MARA, Car Loan, SLoan, Personal Loan',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded,
                        size: 14, color: AppColors.textSecondary),
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
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(dashboardStateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Commitments & Loans',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          stateAsync.maybeWhen(
            data: (state) => IconButton(
              icon: const Icon(Icons.auto_graph_rounded, color: AppColors.primary),
              tooltip: 'Payoff Strategy (Snowball vs Avalanche)',
              onPressed: () => DebtPayoffSheet.show(context, state.activeCommitments),
            ),
            orElse: () => const SizedBox.shrink(),
          ),
          IconButton(
            icon: const Icon(Icons.psychology_alt_rounded, color: AppColors.accent),
            tooltip: 'Can I Afford It? Simulator',
            onPressed: () => AffordabilitySimulatorSheet.show(context),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary),
            tooltip: 'Add Commitment',
            onPressed: () => _showAddChoice(context),
          ),
        ],
      ),
      body: stateAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, _) => Center(
          child: Text('Error: $err', style: const TextStyle(color: AppColors.danger)),
        ),
        data: (state) {
          final commitments = state.activeCommitments;
          final totalCommitment = state.allocation.totalCommitments;
          final dsr = state.allocation.dsrRatio * 100;
          final netSalary = state.netSalary.netSalary;
          final isIntern = state.employmentType.isIntern;

          // Partition commitments
          final spayLaterItems = commitments
              .where((c) => c.type.toLowerCase() == 'spaylater')
              .toList();
          final otherCommitments = commitments
              .where((c) => c.type.toLowerCase() != 'spaylater')
              .toList();

          Color dsrColor;
          String dsrLabel;
          if (dsr <= 35) {
            dsrColor = AppColors.success;
            dsrLabel = 'Healthy (<35%)';
          } else if (dsr <= 50) {
            dsrColor = AppColors.warning;
            dsrLabel = 'Moderate (36-49%)';
          } else {
            dsrColor = AppColors.danger;
            dsrLabel = 'Critical (>50%)';
          }

          return CustomScrollView(
            slivers: [
              // 1. DSR Gauge Hero Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: GlassCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Debt Service Ratio (DSR)',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: dsrColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: dsrColor.withValues(alpha: 0.4)),
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
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '${dsr.toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                                color: dsrColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${totalCommitment.formatted} / month',
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Progress line towards 35% safe threshold
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: (dsr / 100).clamp(0.0, 1.0),
                            backgroundColor: AppColors.surfaceHigh,
                            valueColor: AlwaysStoppedAnimation<Color>(dsrColor),
                            minHeight: 8,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('0%',
                                style: TextStyle(
                                    fontSize: 10, color: AppColors.textSecondary)),
                            Text('35% Max Safe Limit',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold)),
                            Text('100%',
                                style: TextStyle(
                                    fontSize: 10, color: AppColors.textSecondary)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 2. Simulator Quick Banner
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                          color: AppColors.accent.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lightbulb_rounded,
                            color: AppColors.accent, size: 24),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Planning a new gadget purchase?',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Simulate your new DSR before using SPayLater.',
                                style: TextStyle(
                                    fontSize: 11, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              AffordabilitySimulatorSheet.show(context),
                          style: TextButton.styleFrom(
                            backgroundColor:
                                AppColors.accent.withValues(alpha: 0.2),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Simulate',
                              style: TextStyle(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              if (commitments.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.auto_graph_rounded,
                              color: AppColors.primary, size: 24),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Debt Payoff Roadmap',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Compare Snowball vs Avalanche strategies.',
                                  style: TextStyle(
                                      fontSize: 11, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                DebtPayoffSheet.show(context, commitments),
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  AppColors.primary.withValues(alpha: 0.2),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('View Plan',
                                style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // 3. SPayLater Hub Section Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
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
                          Text(
                            'SPayLater Purchases (${spayLaterItems.length})',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
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

              // SPayLater Hub: Financial Impact Overview Card
              if (spayLaterItems.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: _buildSpayLaterImpactCard(
                      spayLaterItems: spayLaterItems,
                      netSalary: netSalary,
                      isIntern: isIntern,
                    ),
                  ),
                ),

              // SPayLater Items List
              if (spayLaterItems.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    child: GlassCard(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceHigh,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.receipt_long_rounded,
                                    size: 18, color: AppColors.textSecondary),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'No SPayLater items tracked',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Track individual Shopee purchases here to see how many months are left, your monthly installment, and how it impacts your allowance.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: () => AddSpayLaterSheet.show(context),
                            icon: const Icon(Icons.add_shopping_cart_rounded, size: 16),
                            label: const Text('Add SPayLater Item'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.accent,
                              side: BorderSide(color: AppColors.accent.withValues(alpha: 0.5)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        final c = spayLaterItems[i];
                        return _buildSpayLaterItemCard(context, ref, c);
                      },
                      childCount: spayLaterItems.length,
                    ),
                  ),
                ),

              // 4. Other Commitments Section Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text('🏦', style: TextStyle(fontSize: 16)),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Fixed Loans & Subscriptions (${otherCommitments.length})',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
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

              // Other Commitments List
              if (otherCommitments.isEmpty && spayLaterItems.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.outline),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.check_circle_outline_rounded,
                              color: AppColors.primary, size: 20),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'No fixed loans (PTPTN, Car Loans, etc.) active.',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else if (commitments.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: GlassCard(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        children: [
                          const Text('🎉', style: TextStyle(fontSize: 44)),
                          const SizedBox(height: 12),
                          const Text(
                            'Zero Debt / Commitments!',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'You currently have no active loans or BNPL installments. Your take-home pay is fully flexible!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 13, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            alignment: WrapAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () => AddSpayLaterSheet.show(context),
                                icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                                label: const Text('Add SPayLater'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFEE4D2D),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14)),
                                ),
                              ),
                              OutlinedButton.icon(
                                onPressed: () => AddCommitmentSheet.show(context),
                                icon: const Icon(Icons.add_rounded, size: 18),
                                label: const Text('Add Other Loan'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.textPrimary,
                                  side: const BorderSide(color: AppColors.outline),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        final c = otherCommitments[i];
                        return _buildGeneralCommitmentCard(context, ref, c);
                      },
                      childCount: otherCommitments.length,
                    ),
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 90)),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddChoice(context),
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Commitment',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSpayLaterImpactCard({
    required List<CommitmentsTableData> spayLaterItems,
    required Money netSalary,
    required bool isIntern,
  }) {
    final totalMonthlySen = spayLaterItems.fold<int>(
        0, (sum, c) => sum + c.monthlyPaymentSen);
    final totalRemainingSen = spayLaterItems.fold<int>(
        0, (sum, c) => sum + c.remainingAmountSen);

    final ratio = netSalary.sen > 0
        ? (totalMonthlySen / netSalary.sen) * 100
        : 0.0;

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
        border: Border.all(
          color: impactColor.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.pie_chart_outline_rounded,
                      size: 16, color: AppColors.accent),
                  SizedBox(width: 8),
                  Text(
                    'SPayLater Financial Impact',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: impactColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: impactColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  impactBadge,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: impactColor,
                  ),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${Money(totalMonthlySen).formatted} / mo',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: impactColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${ratio.toStringAsFixed(1)}% of your ${netSalary.formatted} ${isIntern ? 'allowance' : 'salary'}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Total Outstanding',
                    style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
                  ),
                  Text(
                    Money(totalRemainingSen).formatted,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Mini progress bar for allowance consumed
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
            style: TextStyle(
              fontSize: 11,
              color: impactColor.withValues(alpha: 0.9),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpayLaterItemCard(
    BuildContext context,
    WidgetRef ref,
    CommitmentsTableData c,
  ) {
    final progress = c.totalTenureMonths > 0
        ? ((c.totalTenureMonths - c.remainingTenureMonths) / c.totalTenureMonths)
            .clamp(0.0, 1.0)
        : 0.0;

    final monthsPaid = (c.totalTenureMonths - c.remainingTenureMonths).clamp(0, 999);

    return Dismissible(
      key: Key('spaylater_${c.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.danger.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: AppColors.danger),
      ),
      onDismissed: (_) {
        ref.read(commitmentRepositoryProvider).deleteCommitment(c.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Deleted ${c.title}')),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFEE4D2D).withValues(alpha: 0.25),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title & Monthly installment
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEE4D2D).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('🛍️', style: TextStyle(fontSize: 20)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceHigh,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Due on ${c.dueDayOfMonth}th',
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${c.remainingTenureMonths} mo left',
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.accent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      Money(c.monthlyPaymentSen).formatted,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Text(
                      '/ month',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.textSecondary),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                  tooltip: 'Edit item',
                  onPressed: () => AddSpayLaterSheet.edit(context, c),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Tenure & Months left breakdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$monthsPaid of ${c.totalTenureMonths} months paid',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  'Remaining: ${Money(c.remainingAmountSen).formatted} of ${Money(c.totalAmountSen).formatted}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.surfaceHigh,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 12),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Settle early button
                TextButton(
                  onPressed: () => _confirmSettlement(context, ref, c),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Settle Early',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Record 1 month installment
                TextButton.icon(
                  onPressed: () => _confirmPayment(context, ref, c),
                  icon: const Icon(Icons.check_circle_outline_rounded,
                      size: 16, color: AppColors.primary),
                  label: Text(
                    'Pay 1 Mo (${Money(c.monthlyPaymentSen).formatted})',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralCommitmentCard(
    BuildContext context,
    WidgetRef ref,
    CommitmentsTableData c,
  ) {
    final progress = c.totalTenureMonths > 0
        ? ((c.totalTenureMonths - c.remainingTenureMonths) / c.totalTenureMonths)
            .clamp(0.0, 1.0)
        : 0.0;

    final monthsPaid = (c.totalTenureMonths - c.remainingTenureMonths).clamp(0, 999);

    return Dismissible(
      key: Key('commitment_${c.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.danger.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: AppColors.danger),
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
            color: AppColors.outline.withValues(alpha: 0.6),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHigh,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getCommitmentEmoji(c.type),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Due on ${c.dueDayOfMonth}th of month',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      Money(c.monthlyPaymentSen).formatted,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Text(
                      '/ month',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.textSecondary),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                  tooltip: 'Edit commitment',
                  onPressed: () => AddCommitmentSheet.edit(context, c),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Progress bar for tenure
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$monthsPaid of ${c.totalTenureMonths} months paid (${c.remainingTenureMonths} left)',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  'Remaining: ${Money(c.remainingAmountSen).formatted}',
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
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 12),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _confirmSettlement(context, ref, c),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Settle Early',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () => _confirmPayment(context, ref, c),
                  icon: const Icon(Icons.check_circle_outline_rounded,
                      size: 16, color: AppColors.primary),
                  label: const Text(
                    'Record Payment',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmPayment(
    BuildContext context,
    WidgetRef ref,
    CommitmentsTableData c,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Record Payment for ${c.title}?',
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 18)),
        content: Text(
          'This will deduct 1 installment of ${Money(c.monthlyPaymentSen).formatted} and log it under your expenses.',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textSecondary)),
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
                  SnackBar(
                    content: Text(
                        'Recorded payment of ${Money(c.monthlyPaymentSen).formatted} for ${c.title}!'),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: const Color(0xFF04291F),
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _confirmSettlement(
    BuildContext context,
    WidgetRef ref,
    CommitmentsTableData c,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Settle ${c.title} Early?',
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 18)),
        content: Text(
          'This will settle the entire remaining balance of ${Money(c.remainingAmountSen).formatted} in full and mark this commitment as completed.',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textSecondary)),
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
                  SnackBar(
                    content: Text(
                        'Settled ${c.title} in full (${Money(c.remainingAmountSen).formatted})! 🎉'),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
            ),
            child: const Text('Settle in Full'),
          ),
        ],
      ),
    );
  }

  String _getCommitmentEmoji(String type) {
    switch (type.toLowerCase()) {
      case 'spaylater':
        return '🛍️';
      case 'ptptn':
        return '🎓';
      case 'mara':
        return '📚';
      case 'car_loan':
        return '🚗';
      case 'sloan':
        return '💵';
      case 'credit_card':
        return '💳';
      case 'personal_loan':
        return '🏦';
      default:
        return '📋';
    }
  }
}
