import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../domain/engine/allocation_engine.dart';

class AllocationBucketsSection extends StatelessWidget {
  const AllocationBucketsSection({super.key, required this.allocation});

  final AllocationResult allocation;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final alloc = allocation;
    String pct(double v) => (v * 100).toStringAsFixed(0);

    return Column(
      children: [
        // Needs Card
        SurfaceCard(
          padding: const EdgeInsets.all(18),
          borderColor: colors.needs.withValues(alpha: 0.4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colors.needs.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.home_rounded, color: colors.needs, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '${pct(alloc.needs.percentage)}% Needs & Fixed Living',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: colors.needs,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    alloc.needs.targetAmount.formatted,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Groceries, bills, rent, fuel, loans.',
                style: TextStyle(fontSize: 12, color: colors.textSecondary, height: 1.4),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: colors.surfaceHigh,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fixed Loans / SPayLater',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 10, color: colors.textSecondary),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            alloc.needs.fixedCommitmentPortion.formatted,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: colors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: colors.surfaceHigh,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Flexible Needs Buffer',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 10, color: colors.textSecondary),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            alloc.needs.flexibleAmount.formatted,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: colors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Wants & Savings Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _CompactBucketCard(
                icon: Icons.coffee_rounded,
                title: '${pct(alloc.wants.percentage)}% Wants',
                subtitle: 'Dining, hobbies, coffee.',
                amount: alloc.wants.targetAmount.formatted,
                color: colors.wants,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _CompactBucketCard(
                icon: Icons.savings_rounded,
                title: '${pct(alloc.savings.percentage)}% Savings',
                subtitle: 'Emergency fund, ASB, deposits.',
                amount: alloc.savings.targetAmount.formatted,
                color: colors.savings,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Giving Strip
        SurfaceCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          borderColor: colors.giving.withValues(alpha: 0.35),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: colors.giving.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(Icons.volunteer_activism_rounded, color: colors.giving, size: 16),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${pct(alloc.giving.percentage)}% Charity & Giving',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: colors.giving,
                      ),
                    ),
                    Text(
                      'Sedekah, zakat, donations.',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 10, color: colors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                alloc.giving.targetAmount.formatted,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CompactBucketCard extends StatelessWidget {
  const _CompactBucketCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return SurfaceCard(
      padding: const EdgeInsets.all(16),
      borderColor: color.withValues(alpha: 0.35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  amount,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 11, color: colors.textSecondary, height: 1.3),
          ),
        ],
      ),
    );
  }
}
