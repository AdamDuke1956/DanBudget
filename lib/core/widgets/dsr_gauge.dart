import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Modern semicircular radial meter for Malaysian Debt Service Ratio (DSR).
///
/// Thresholds mirror the grading used on the Commitments screen:
/// healthy up to 35%, moderate up to 50%, critical above.
class DsrGauge extends StatelessWidget {
  const DsrGauge({
    super.key,
    required this.dsrRatio,
    this.size = 140,
    this.strokeWidth = 12,
    this.showStatusLabel = true,
  });

  /// Ratio from 0.0 to 1.0 (or greater if over-leveraged).
  final double dsrRatio;
  final double size;
  final double strokeWidth;

  /// Hide when the parent already renders its own status badge.
  final bool showStatusLabel;

  Color get statusColor {
    if (dsrRatio <= 0.35) return AppColors.success;
    if (dsrRatio <= 0.50) return AppColors.warning;
    return AppColors.danger;
  }

  String get statusLabel {
    if (dsrRatio <= 0.35) return 'Healthy';
    if (dsrRatio <= 0.50) return 'Moderate';
    return 'Critical';
  }

  @override
  Widget build(BuildContext context) {
    final clampedRatio = dsrRatio.clamp(0.0, 1.0);
    final pctText = '${(dsrRatio * 100).toStringAsFixed(1)}%';

    final double radius = (size - strokeWidth) / 2 - 2;
    final double centerY = radius + strokeWidth + 2;
    final double maxY = centerY + (radius * math.sin(math.pi * 0.15)) + (strokeWidth / 2);
    final double widgetHeight = (maxY + 4).ceilToDouble();

    return SizedBox(
      width: size,
      height: widgetHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, widgetHeight),
            painter: _DsrArcPainter(
              progress: clampedRatio,
              activeColor: statusColor,
              trackColor: AppColors.isDark
                  ? AppColors.surfaceHigh.withValues(alpha: 0.6)
                  : AppColors.outline.withValues(alpha: 0.8),
              strokeWidth: strokeWidth,
              centerY: centerY,
              radius: radius,
            ),
          ),
          Positioned(
            top: centerY - (showStatusLabel ? (size * 0.22) : (size * 0.14)),
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  pctText,
                  style: TextStyle(
                    fontSize: size * 0.17,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (showStatusLabel) ...[
                  const SizedBox(height: 1),
                  Text(
                    statusLabel,
                    style: TextStyle(
                      fontSize: size * 0.08,
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DsrArcPainter extends CustomPainter {
  final double progress;
  final Color activeColor;
  final Color trackColor;
  final double strokeWidth;
  final double centerY;
  final double radius;

  _DsrArcPainter({
    required this.progress,
    required this.activeColor,
    required this.trackColor,
    required this.strokeWidth,
    required this.centerY,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, centerY);

    const startAngle = math.pi * 0.85;
    const sweepAngle = math.pi * 1.3;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      trackPaint,
    );

    if (progress > 0) {
      final activePaint = Paint()
        ..color = activeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle * progress,
        false,
        activePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DsrArcPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.centerY != centerY ||
        oldDelegate.radius != radius;
  }
}
