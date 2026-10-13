import 'package:flutter/material.dart';

enum AppThemeMode {
  darkGreen,
  whiteRed;

  bool get isDark => this == AppThemeMode.darkGreen;
  String get displayName =>
      this == AppThemeMode.darkGreen ? 'Dark / Emerald' : 'White / Crimson';
}

/// Palette tokens for a specific theme mode.
class AppPalette {
  final AppThemeMode mode;
  final Color background;
  final Color surface;
  final Color surfaceHigh;
  final Color outline;

  final Color primary;
  final Color primaryDark;
  final Color onPrimary;
  final Color accent;

  final Color textPrimary;
  final Color textSecondary;

  final Color success;
  final Color warning;
  final Color danger;

  final Color needs;
  final Color wants;
  final Color savings;
  final Color giving;

  final LinearGradient heroGradient;
  final BoxShadow? cardShadow;

  bool get isDark => mode.isDark;

  const AppPalette({
    required this.mode,
    required this.background,
    required this.surface,
    required this.surfaceHigh,
    required this.outline,
    required this.primary,
    required this.primaryDark,
    required this.onPrimary,
    required this.accent,
    required this.textPrimary,
    required this.textSecondary,
    required this.success,
    required this.warning,
    required this.danger,
    required this.needs,
    required this.wants,
    required this.savings,
    required this.giving,
    required this.heroGradient,
    this.cardShadow,
  });

  /// Obsidian Emerald: deep oceanic canvas, tiered blue-gray surfaces, emerald accent.
  static const dark = AppPalette(
    mode: AppThemeMode.darkGreen,
    background: Color(0xFF0A0F1D),
    surface: Color(0xFF131B2E),
    surfaceHigh: Color(0xFF1A253D),
    outline: Color(0xFF2A3A57),
    primary: Color(0xFF10B981), // emerald
    primaryDark: Color(0xFF059669),
    onPrimary: Color(0xFF03150F), // near-black on emerald (>7:1)
    accent: Color(0xFF818CF8), // soft indigo
    textPrimary: Color(0xFFF8FAFC),
    textSecondary: Color(0xFF94A3B8),
    success: Color(0xFF34D399),
    warning: Color(0xFFFBBF24),
    danger: Color(0xFFF87171),
    needs: Color(0xFF3B82F6),
    wants: Color(0xFFA855F7),
    savings: Color(0xFF10B981),
    giving: Color(0xFFF59E0B),
    heroGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF12302B), Color(0xFF131B2E)],
    ),
    cardShadow: null,
  );

  /// Malaysian ringgit crimson: Crisp white surfaces with bold crimson red accent.
  static const light = AppPalette(
    mode: AppThemeMode.whiteRed,
    background: Color(0xFFF8FAFC),
    surface: Color(0xFFFFFFFF),
    surfaceHigh: Color(0xFFF1F5F9),
    outline: Color(0xFFE2E8F0),
    primary: Color(0xFFE11D48), // crimson red
    primaryDark: Color(0xFFBE123C),
    onPrimary: Colors.white, // crisp white on crimson
    accent: Color(0xFF4F46E5), // deep indigo
    textPrimary: Color(0xFF0F172A), // WCAG AAA slate
    textSecondary: Color(0xFF64748B), // WCAG AA slate
    success: Color(0xFF059669),
    warning: Color(0xFFD97706),
    danger: Color(0xFFE11D48),
    needs: Color(0xFF2563EB),
    wants: Color(0xFF9333EA),
    savings: Color(0xFF059669),
    giving: Color(0xFFEA580C),
    heroGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFFF1F2), Color(0xFFFFE4E6)],
    ),
    cardShadow: BoxShadow(
      color: Color(0x0A0F172A),
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
  );
}

/// Central color facade for DanBudget.
/// Dispatches dynamically to active theme palette while retaining seamless compatibility.
abstract final class AppColors {
  /// The currently active palette across the app.
  static AppPalette current = AppPalette.dark;

  static bool get isDark => current.mode.isDark;

  // Surfaces
  static Color get background => current.background;
  static Color get surface => current.surface;
  static Color get surfaceHigh => current.surfaceHigh;
  static Color get outline => current.outline;

  // Brand
  static Color get primary => current.primary;
  static Color get primaryDark => current.primaryDark;
  static Color get onPrimary => current.onPrimary;
  static Color get accent => current.accent;

  // Text
  static Color get textPrimary => current.textPrimary;
  static Color get textSecondary => current.textSecondary;

  // Status
  static Color get success => current.success;
  static Color get warning => current.warning;
  static Color get danger => current.danger;

  // 40 / 30 / 20 / 10 buckets
  static Color get needs => current.needs;
  static Color get wants => current.wants;
  static Color get savings => current.savings;
  static Color get giving => current.giving;

  // Modern border and elevation tokens
  static Color get cardBorder => isDark
      ? current.outline.withValues(alpha: 0.45)
      : current.outline.withValues(alpha: 0.7);

  static Color get subtleBorder => isDark
      ? current.outline.withValues(alpha: 0.25)
      : current.outline.withValues(alpha: 0.4);

  static Color get surfaceElevated => current.surfaceHigh;

  static LinearGradient get heroGradient => current.heroGradient;
  static BoxShadow? get cardShadow => current.cardShadow;

  /// Retrieves the palette attached to [context] or falls back to [current].
  static AppPalette of(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>();
    return ext?.palette ?? current;
  }
}

/// ThemeExtension to pass palette through Flutter's Theme tree.
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final AppPalette palette;

  const AppThemeExtension({required this.palette});

  @override
  ThemeExtension<AppThemeExtension> copyWith({AppPalette? palette}) {
    return AppThemeExtension(palette: palette ?? this.palette);
  }

  @override
  ThemeExtension<AppThemeExtension> lerp(
    covariant ThemeExtension<AppThemeExtension>? other,
    double t,
  ) {
    if (other is! AppThemeExtension) return this;
    return t < 0.5 ? this : other;
  }
}
