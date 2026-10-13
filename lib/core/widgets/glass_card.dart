import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Rounded surface card with refined elevation and border treatment.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.gradient,
    this.color,
    this.borderColor,
    this.borderRadius = 24.0,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Gradient? gradient;
  final Color? color;
  final Color? borderColor;
  final double borderRadius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final shadow = AppColors.cardShadow;
    final radius = BorderRadius.circular(borderRadius);

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          gradient: gradient,
          color: gradient == null ? (color ?? AppColors.surface) : null,
          borderRadius: radius,
          border: Border.all(
            color: borderColor ??
                (AppColors.isDark
                    ? AppColors.outline.withValues(alpha: 0.45)
                    : AppColors.outline.withValues(alpha: 0.8)),
            width: 1,
          ),
          boxShadow: gradient == null && shadow != null ? [shadow] : null,
        ),
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
