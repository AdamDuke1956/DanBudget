import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, AppThemeMode>(() {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends Notifier<AppThemeMode> {
  static const _storageKey = 'danbudget_theme_mode';
  final _storage = const FlutterSecureStorage();

  @override
  AppThemeMode build() {
    _loadPersistedTheme();
    return AppThemeMode.darkGreen;
  }

  Future<void> _loadPersistedTheme() async {
    try {
      final saved = await _storage.read(key: _storageKey);
      if (saved == 'whiteRed') {
        state = AppThemeMode.whiteRed;
        AppColors.current = AppPalette.light;
      } else {
        state = AppThemeMode.darkGreen;
        AppColors.current = AppPalette.dark;
      }
    } catch (_) {
      // Default to darkGreen
    }
  }

  Future<void> setTheme(AppThemeMode mode) async {
    state = mode;
    AppColors.current = mode.isDark ? AppPalette.dark : AppPalette.light;
    try {
      await _storage.write(
        key: _storageKey,
        value: mode == AppThemeMode.whiteRed ? 'whiteRed' : 'darkGreen',
      );
    } catch (_) {}
  }

  Future<void> toggle() async {
    final next =
        state == AppThemeMode.darkGreen ? AppThemeMode.whiteRed : AppThemeMode.darkGreen;
    await setTheme(next);
  }
}

abstract final class AppTheme {
  static ThemeData dark() => _buildTheme(AppPalette.dark);
  static ThemeData light() => _buildTheme(AppPalette.light);

  static ThemeData _buildTheme(AppPalette palette) {
    final isDark = palette.mode.isDark;
    final base = ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      colorScheme: isDark
          ? ColorScheme.dark(
              primary: palette.primary,
              onPrimary: palette.onPrimary,
              secondary: palette.accent,
              surface: palette.surface,
              onSurface: palette.textPrimary,
              error: palette.danger,
              outline: palette.outline,
            )
          : ColorScheme.light(
              primary: palette.primary,
              onPrimary: palette.onPrimary,
              secondary: palette.accent,
              surface: palette.surface,
              onSurface: palette.textPrimary,
              error: palette.danger,
              outline: palette.outline,
            ),
      scaffoldBackgroundColor: palette.background,
      cardColor: palette.surface,
      dividerColor: palette.outline,
      extensions: [AppThemeExtension(palette: palette)],
    );

    final textTheme = GoogleFonts.plusJakartaSansTextTheme(base.textTheme)
        .apply(
          bodyColor: palette.textPrimary,
          displayColor: palette.textPrimary,
        );

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: palette.textPrimary),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: palette.textPrimary,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        height: 68,
        indicatorColor: palette.primary.withValues(alpha: isDark ? 0.16 : 0.12),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 24,
            color: isSelected ? palette.primary : palette.textSecondary,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return textTheme.labelSmall?.copyWith(
            fontSize: 11,
            letterSpacing: -0.1,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? palette.primary : palette.textSecondary,
          );
        }),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: palette.primary,
        foregroundColor: palette.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      cardTheme: CardTheme(
        color: palette.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: isDark
                ? palette.outline.withValues(alpha: 0.6)
                : palette.outline,
          ),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: palette.surface,
        modalBackgroundColor: palette.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: palette.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.surfaceHigh,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: isDark
                ? palette.outline.withValues(alpha: 0.6)
                : palette.outline,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: isDark
                ? palette.outline.withValues(alpha: 0.6)
                : palette.outline,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: palette.primary,
            width: 1.5,
          ),
        ),
        labelStyle: TextStyle(color: palette.textSecondary),
        hintStyle: TextStyle(
          color: palette.textSecondary.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}
