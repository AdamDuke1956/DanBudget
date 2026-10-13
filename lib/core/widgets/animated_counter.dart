import 'package:flutter/material.dart';

import '../utils/money.dart';

/// Smoothly animates a currency figure in sen from 0 or previous to [sen].
class AnimatedMoneyCounter extends StatelessWidget {
  const AnimatedMoneyCounter({
    super.key,
    required this.sen,
    this.style,
    this.duration = const Duration(milliseconds: 150),
    this.curve = Curves.easeOutCubic,
  });

  final int sen;
  final TextStyle? style;
  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: sen),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Text(
          Money(value).formatted,
          style: style,
        );
      },
    );
  }
}

/// Smoothly animates a progress bar value from 0.0 to [value].
class AnimatedProgressBar extends StatelessWidget {
  const AnimatedProgressBar({
    super.key,
    required this.value,
    required this.color,
    this.backgroundColor,
    this.height = 8,
    this.borderRadius = 8,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeOutCubic,
  });

  final double value;
  final Color color;
  final Color? backgroundColor;
  final double height;
  final double borderRadius;
  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0.0, 1.0);
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: clamped),
            duration: duration,
            curve: curve,
            builder: (context, animatedValue, child) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: constraints.maxWidth * animatedValue,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
