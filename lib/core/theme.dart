import 'package:flutter/material.dart';

import '../domain/models.dart';

/// Shared visual language: warm parchment, deep violet ink and a liturgical
/// gold accent. Serif display type (Cormorant) meets a clean sans (Manrope).
abstract final class AppColors {
  static const ink = Color(0xFF241F35);
  static const violet = Color(0xFF4B3F72);
  static const violetDeep = Color(0xFF2F2750);
  static const gold = Color(0xFFB88A2E);
  static const goldSoft = Color(0xFFE7C77A);
  static const parchment = Color(0xFFFBF7EF);
  static const parchmentDeep = Color(0xFFF2EADC);
  static const night = Color(0xFF13111C);
  static const nightSoft = Color(0xFF1D1A28);
  static const teal = Color(0xFF2F6B5F);

  static LinearGradient heroGradient(Brightness brightness) => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: brightness == Brightness.dark
            ? const [Color(0xFF3A2F5E), Color(0xFF211C36)]
            : const [Color(0xFF4B3F72), Color(0xFF332A55)],
      );

  static LinearGradient eventGradient() => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF1C1730), Color(0xFF100E19)],
      );

  static Color tagColor(TagKind kind, ColorScheme scheme) => switch (kind) {
        TagKind.celebration => scheme.primary,
        TagKind.moment => scheme.tertiary,
        TagKind.theme => scheme.secondary,
      };
}

abstract final class AppTheme {
  static const _display = 'Cormorant';
  static const _body = 'Manrope';

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.violet,
      brightness: brightness,
    ).copyWith(
      primary: isDark ? const Color(0xFFCFC2F2) : AppColors.violet,
      onPrimary: isDark ? const Color(0xFF2A2244) : const Color(0xFFFFFBEF),
      primaryContainer:
          isDark ? const Color(0xFF3B3160) : const Color(0xFFE4DCF7),
      onPrimaryContainer:
          isDark ? const Color(0xFFE9E2FF) : const Color(0xFF2B2347),
      secondary: isDark ? AppColors.goldSoft : AppColors.gold,
      onSecondary: isDark ? const Color(0xFF34260A) : const Color(0xFFFFFBEF),
      secondaryContainer:
          isDark ? const Color(0xFF4A3A15) : const Color(0xFFF7E7BE),
      onSecondaryContainer:
          isDark ? const Color(0xFFF7E7BE) : const Color(0xFF3A2A06),
      tertiary: isDark ? const Color(0xFF9BD3C4) : AppColors.teal,
      onTertiary: isDark ? const Color(0xFF0D2E27) : const Color(0xFFFFFFFF),
      tertiaryContainer:
          isDark ? const Color(0xFF23463F) : const Color(0xFFD4EBE4),
      onTertiaryContainer:
          isDark ? const Color(0xFFD4EBE4) : const Color(0xFF10332B),
      surface: isDark ? AppColors.night : AppColors.parchment,
      onSurface: isDark ? const Color(0xFFF1EDE4) : AppColors.ink,
      onSurfaceVariant:
          isDark ? const Color(0xFFBCB5C7) : const Color(0xFF6A6279),
      surfaceContainerLowest:
          isDark ? const Color(0xFF0E0C15) : const Color(0xFFFFFFFF),
      surfaceContainerLow:
          isDark ? const Color(0xFF191623) : const Color(0xFFF7F1E6),
      surfaceContainer:
          isDark ? const Color(0xFF201C2D) : AppColors.parchmentDeep,
      surfaceContainerHigh:
          isDark ? const Color(0xFF282335) : const Color(0xFFEDE4D4),
      surfaceContainerHighest:
          isDark ? const Color(0xFF322C41) : const Color(0xFFE6DBC8),
      outline: isDark ? const Color(0xFF4C4559) : const Color(0xFFD5CBB8),
      outlineVariant:
          isDark ? const Color(0xFF38323F) : const Color(0xFFE7DECE),
      error: isDark ? const Color(0xFFFFB4AB) : const Color(0xFFB3261E),
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      fontFamily: _body,
    );

    final textTheme = base.textTheme
        .apply(fontFamily: _body)
        .copyWith(
          displayLarge: _serif(56, FontWeight.w600, 1.02, scheme.onSurface),
          displayMedium: _serif(42, FontWeight.w600, 1.05, scheme.onSurface),
          displaySmall: _serif(34, FontWeight.w600, 1.08, scheme.onSurface),
          headlineLarge: _serif(30, FontWeight.w600, 1.12, scheme.onSurface),
          headlineMedium: _serif(26, FontWeight.w600, 1.15, scheme.onSurface),
          headlineSmall: _serif(22, FontWeight.w600, 1.2, scheme.onSurface),
          titleLarge: TextStyle(
            fontFamily: _body,
            fontSize: 19,
            fontWeight: FontWeight.w700,
            height: 1.3,
            letterSpacing: -0.2,
            color: scheme.onSurface,
          ),
          titleMedium: TextStyle(
            fontFamily: _body,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 1.35,
            color: scheme.onSurface,
          ),
          titleSmall: TextStyle(
            fontFamily: _body,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.35,
            color: scheme.onSurface,
          ),
          bodyLarge: TextStyle(
            fontFamily: _body,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.55,
            color: scheme.onSurface,
          ),
          bodyMedium: TextStyle(
            fontFamily: _body,
            fontSize: 14.5,
            fontWeight: FontWeight.w400,
            height: 1.5,
            color: scheme.onSurface,
          ),
          bodySmall: TextStyle(
            fontFamily: _body,
            fontSize: 12.5,
            fontWeight: FontWeight.w400,
            height: 1.4,
            color: scheme.onSurfaceVariant,
          ),
          labelLarge: TextStyle(
            fontFamily: _body,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
            color: scheme.onSurface,
          ),
          labelMedium: TextStyle(
            fontFamily: _body,
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
            color: scheme.onSurfaceVariant,
          ),
        );

    return base.copyWith(
      textTheme: textTheme,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
        iconTheme: IconThemeData(color: scheme.onSurface),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.7)),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        selectedColor: scheme.primaryContainer,
        side: BorderSide(color: scheme.outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        labelStyle: textTheme.labelLarge,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLow,
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: scheme.primary, width: 1.6),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: textTheme.labelLarge?.copyWith(fontSize: 14.5),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 52),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          side: BorderSide(color: scheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: textTheme.labelLarge?.copyWith(fontSize: 14.5),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: textTheme.labelLarge?.copyWith(fontSize: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark
            ? scheme.surfaceContainerLow
            : scheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        indicatorColor: scheme.primaryContainer,
        height: 68,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStatePropertyAll(
          textTheme.labelMedium?.copyWith(letterSpacing: 0.1),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        indicatorColor: scheme.primaryContainer,
        selectedIconTheme: IconThemeData(color: scheme.onPrimaryContainer),
        unselectedIconTheme: IconThemeData(color: scheme.onSurfaceVariant),
        selectedLabelTextStyle: textTheme.labelLarge?.copyWith(
          color: scheme.primary,
        ),
        unselectedLabelTextStyle: textTheme.labelLarge?.copyWith(
          color: scheme.onSurfaceVariant,
          fontWeight: FontWeight.w500,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? scheme.surfaceContainerHighest : AppColors.ink,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      ),
    );
  }

  static TextStyle _serif(
    double size,
    FontWeight weight,
    double height,
    Color color,
  ) =>
      TextStyle(
        fontFamily: _display,
        fontSize: size,
        fontWeight: weight,
        height: height,
        letterSpacing: -0.4,
        color: color,
      );
}
