import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Opaque card surface with a 1px outline. No blur, no gradient.
///
/// Radius defaults to 14 so cards read as tighter than the 20+ pill shapes
/// used elsewhere. Set [raised] for the one card on a screen that should sit
/// a level above its neighbours (it swaps to the higher surface tone).
class SurfaceCard extends StatelessWidget {
  const SurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color,
    this.borderColor,
    this.borderRadius = 14.0,
    this.raised = false,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Color? borderColor;
  final double borderRadius;
  final bool raised;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final shadow = AppColors.cardShadow;
    final radius = BorderRadius.circular(borderRadius);

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: color ?? (raised ? AppColors.surfaceHigh : AppColors.surface),
          borderRadius: radius,
          border: Border.all(color: borderColor ?? AppColors.cardBorder),
          boxShadow: shadow != null ? [shadow] : null,
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
