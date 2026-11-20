import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/surface_card.dart';
import '../../../data/providers/dashboard_provider.dart';
import 'salary_edit_sheet.dart';

class PayslipBreakdownCard extends StatelessWidget {
  const PayslipBreakdownCard({super.key, required this.state});

  final DashboardState state;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final net = state.netSalary;
    final isIntern = state.employmentType.isIntern;
    final epfPercent = (state.profile.epfRate * 100).round();

    return SurfaceCard(
      padding: const EdgeInsets.all(20),
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
                        color: colors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.receipt_rounded, size: 18, color: colors.primary),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isIntern ? 'Monthly Allowance Voucher' : 'Monthly Payslip Breakdown',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
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
                onPressed: () => SalaryEditSheet.show(context, state.profile),
                icon: Icon(Icons.edit_rounded, size: 14, color: colors.primary),
                label: Text(
                  'Edit',
                  style: TextStyle(
                    color: colors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _PayslipRow(
            label: isIntern ? 'Monthly Allowance' : 'Gross Basic Salary',
            value: net.grossSalary.formatted,
            isBold: true,
          ),
          if (net.allowances.sen > 0)
            _PayslipRow(
              label: 'Fixed Allowances',
              value: '+${net.allowances.formatted}',
              color: colors.primary,
            ),
          Divider(color: colors.outline.withValues(alpha: 0.5), height: 18),
          if (isIntern)
            _PayslipRow(
              label: 'Statutory deductions (EPF / SOCSO / EIS)',
              value: 'None (Exempted)',
              color: colors.primary,
            )
          else ...[
            _PayslipRow(
              label: 'KWSP Employee ($epfPercent%)',
              value: '-${net.epfEmployee.formatted}',
              color: colors.textSecondary,
            ),
            _PayslipRow(
              label: 'SOCSO / PERKESO',
              value: '-${net.socsoEmployee.formatted}',
              color: colors.textSecondary,
            ),
            _PayslipRow(
              label: 'EIS / SIP',
              value: '-${net.eisEmployee.formatted}',
              color: colors.textSecondary,
            ),
            if (net.pcbTax.sen > 0)
              _PayslipRow(
                label: 'PCB Tax (MTD)',
                value: '-${net.pcbTax.formatted}',
                color: colors.textSecondary,
              ),
          ],
          Divider(color: colors.outline.withValues(alpha: 0.5), height: 18),
          _PayslipRow(
            label: 'Net Take-home Pay',
            value: net.netSalary.formatted,
            isHighlight: true,
          ),
        ],
      ),
    );
  }
}

class _PayslipRow extends StatelessWidget {
  const _PayslipRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.isHighlight = false,
    this.color,
  });

  final String label;
  final String value;
  final bool isBold;
  final bool isHighlight;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: isHighlight ? 14 : 13,
                fontWeight: (isBold || isHighlight) ? FontWeight.bold : FontWeight.normal,
                color: isHighlight ? colors.textPrimary : colors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: isHighlight ? 18 : 13,
              fontWeight: (isBold || isHighlight) ? FontWeight.bold : FontWeight.w600,
              color: isHighlight ? colors.primary : (color ?? colors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
