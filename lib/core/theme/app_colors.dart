import 'package:flutter/material.dart';

/// Central colour tokens for DanBudget (dark-first, navy + emerald).
abstract final class AppColors {
  // Surfaces
  static const Color background = Color(0xFF0B1220);
  static const Color surface = Color(0xFF131C2E);
  static const Color surfaceHigh = Color(0xFF1B2740);
  static const Color outline = Color(0xFF2A3753);

  // Brand
  static const Color primary = Color(0xFF2EE6A6); // emerald
  static const Color primaryDark = Color(0xFF12B886);
  static const Color accent = Color(0xFF7C8CFF); // soft indigo

  // Text
  static const Color textPrimary = Color(0xFFF2F5FB);
  static const Color textSecondary = Color(0xFF9AA7C2);

  // Status
  static const Color success = Color(0xFF2EE6A6);
  static const Color warning = Color(0xFFFFC857);
  static const Color danger = Color(0xFFFF6B7A);

  // 40 / 30 / 20 / 10 buckets
  static const Color needs = Color(0xFF5B8DEF);
  static const Color wants = Color(0xFFB86BFF);
  static const Color savings = Color(0xFF2EE6A6);
  static const Color giving = Color(0xFFFFB86B);

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E3A5F), Color(0xFF0F5C4D)],
  );
}
