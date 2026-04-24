import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'neon_theme.dart';

abstract final class AppTheme {
  AppTheme._();

  static ThemeData light() =>
      _buildTheme(palette: AppColors.light, brightness: Brightness.light);

  static ThemeData dark() =>
      _buildTheme(palette: AppColors.dark, brightness: Brightness.dark);

  static ThemeData _buildTheme({
    required AppColorPalette palette,
    required Brightness brightness,
  }) {
    final isDark = brightness == Brightness.dark;
    final tokens = isDark ? NeonThemeTokens.dark() : NeonThemeTokens.light();

    final baseScheme = ColorScheme.fromSeed(
      seedColor: palette.primary,
      brightness: brightness,
    );

    final colorScheme = baseScheme.copyWith(
      primary: palette.primary,
      onPrimary: tokens.onPrimary,
      primaryContainer: palette.primaryContainer,
      onPrimaryContainer: tokens.onPrimary,
      secondary: palette.secondary,
      onSecondary: tokens.onPrimary,
      secondaryContainer: palette.secondaryContainer,
      onSecondaryContainer: palette.onSurface,
      tertiary: palette.tertiary,
      onTertiary: tokens.onPrimary,
      tertiaryContainer: palette.tertiaryContainer,
      onTertiaryContainer: tokens.onSurface,
      surface: tokens.surface,
      onSurface: tokens.onSurface,
      surfaceContainerLowest: tokens.surfaceContainerLowest,
      surfaceContainerLow: tokens.surfaceContainerLow,
      surfaceContainer: tokens.surfaceContainer,
      surfaceContainerHigh: tokens.surfaceContainerHigh,
      surfaceContainerHighest: tokens.surfaceContainerHighest,
      onSurfaceVariant: tokens.onSurfaceVariant,
      outline: tokens.ghostBorderStrong,
      outlineVariant: tokens.ghostBorder,
      error: palette.tertiaryContainer,
      onError: tokens.onPrimary,
      shadow: tokens.glowColor,
    );

    final baseTextTheme = GoogleFonts.manropeTextTheme();
    final textTheme = baseTextTheme.copyWith(
      displayLarge: GoogleFonts.manrope(
        textStyle: baseTextTheme.displayLarge,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
        color: tokens.onSurface,
      ),
      displayMedium: GoogleFonts.manrope(
        textStyle: baseTextTheme.displayMedium,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.6,
        color: tokens.onSurface,
      ),
      displaySmall: GoogleFonts.manrope(
        textStyle: baseTextTheme.displaySmall,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        color: tokens.onSurface,
      ),
      headlineLarge: GoogleFonts.manrope(
        textStyle: baseTextTheme.headlineLarge,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        color: tokens.onSurface,
      ),
      headlineMedium: GoogleFonts.manrope(
        textStyle: baseTextTheme.headlineMedium,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        color: tokens.onSurface,
      ),
      headlineSmall: GoogleFonts.manrope(
        textStyle: baseTextTheme.headlineSmall,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        color: tokens.onSurface,
      ),
      titleLarge: GoogleFonts.manrope(
        textStyle: baseTextTheme.titleLarge,
        fontWeight: FontWeight.w700,
        color: tokens.onSurface,
      ),
      titleMedium: GoogleFonts.manrope(
        textStyle: baseTextTheme.titleMedium,
        fontWeight: FontWeight.w600,
        color: tokens.onSurface,
      ),
      titleSmall: GoogleFonts.manrope(
        textStyle: baseTextTheme.titleSmall,
        fontWeight: FontWeight.w600,
        color: tokens.onSurface,
      ),
      bodyLarge: GoogleFonts.manrope(
        textStyle: baseTextTheme.bodyLarge,
        color: tokens.onSurface,
      ),
      bodyMedium: GoogleFonts.manrope(
        textStyle: baseTextTheme.bodyMedium,
        color: tokens.onSurface,
      ),
      bodySmall: GoogleFonts.manrope(
        textStyle: baseTextTheme.bodySmall,
        color: tokens.onSurfaceVariant,
      ),
      labelLarge: GoogleFonts.manrope(
        textStyle: baseTextTheme.labelLarge,
        fontWeight: FontWeight.w700,
        color: tokens.primary,
      ),
      labelMedium: GoogleFonts.manrope(
        textStyle: baseTextTheme.labelMedium,
        color: tokens.onSurfaceVariant,
      ),
      labelSmall: GoogleFonts.manrope(
        textStyle: baseTextTheme.labelSmall,
        color: tokens.onSurfaceVariant,
      ),
    );

    final manropeFamily = GoogleFonts.manrope().fontFamily;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: manropeFamily,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: tokens.background,
      canvasColor: tokens.background,
      textTheme: textTheme,
      dividerColor: Colors.transparent,
      extensions: <ThemeExtension<dynamic>>[tokens],
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: tokens.surface,
        foregroundColor: tokens.onSurface,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: tokens.surfaceContainer,
        shadowColor: tokens.glowColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tokens.radiusLg),
          side: BorderSide(color: tokens.ghostBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      listTileTheme: ListTileThemeData(
        textColor: tokens.onSurface,
        iconColor: tokens.primary,
        tileColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tokens.radiusMd),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: tokens.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shadowColor: tokens.glowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tokens.radiusXl),
          side: BorderSide(color: tokens.ghostBorder, width: 1),
        ),
        titleTextStyle: textTheme.headlineSmall,
        contentTextStyle: textTheme.bodyMedium,
        iconColor: tokens.primary,
        actionsPadding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: tokens.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        modalBackgroundColor: tokens.surfaceContainerHigh,
        shadowColor: tokens.glowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(tokens.radiusXl),
          ),
          side: BorderSide(color: tokens.ghostBorder, width: 1),
        ),
        dragHandleColor: Colors.transparent,
        showDragHandle: false,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: tokens.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shadowColor: tokens.glowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tokens.radiusMd),
          side: BorderSide(color: tokens.ghostBorder, width: 1),
        ),
        textStyle: textTheme.bodyMedium,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: tokens.surfaceBright,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: tokens.onSurface,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tokens.radiusPill),
          side: BorderSide(color: tokens.ghostBorderStrong, width: 1),
        ),
        elevation: 0,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: tokens.surfaceBright,
          borderRadius: BorderRadius.circular(tokens.radiusMd),
          border: Border.all(color: tokens.secondary.withValues(alpha: 0.65)),
        ),
        textStyle: textTheme.bodySmall?.copyWith(color: tokens.onSurface),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.transparent,
        thickness: 0,
        space: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? tokens.surfaceContainerLow.withValues(alpha: 0.60)
            : tokens.surfaceContainerHighest,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(tokens.radiusMd),
          borderSide: BorderSide(color: tokens.ghostBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(tokens.radiusMd),
          borderSide: BorderSide(color: tokens.ghostBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(tokens.radiusMd),
          borderSide: BorderSide(
            color: tokens.secondary,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(tokens.radiusMd),
          borderSide: BorderSide(
            color: palette.tertiaryContainer,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(tokens.radiusMd),
          borderSide: BorderSide(
            color: palette.tertiaryContainer,
            width: 1.5,
          ),
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: tokens.onSurfaceVariant,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: tokens.onSurfaceVariant,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          foregroundColor: tokens.onPrimary,
          backgroundColor: tokens.primary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 26),
          shape: const StadiumBorder(),
          shadowColor: tokens.glowColor,
          alignment: Alignment.center,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: tokens.onPrimary,
          backgroundColor: tokens.primary,
          elevation: 0,
          shadowColor: tokens.glowColor,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 26),
          shape: const StadiumBorder(),
          alignment: Alignment.center,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: tokens.primary,
          side: BorderSide(color: tokens.ghostBorderStrong, width: 1),
          backgroundColor: isDark
              ? tokens.surfaceContainerHigh.withValues(alpha: 0.72)
              : tokens.surfaceContainerHighest,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 22),
          shape: const StadiumBorder(),
          alignment: Alignment.center,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: tokens.primary,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: const StadiumBorder(),
          alignment: Alignment.center,
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return tokens.onPrimary;
            }
            return tokens.onSurface;
          }),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return tokens.primary;
            }
            return tokens.surfaceContainer;
          }),
          side: WidgetStatePropertyAll(
            BorderSide(color: tokens.ghostBorderStrong, width: 1),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: tokens.surfaceContainerHigh,
        selectedColor: tokens.primary.withValues(alpha: 0.22),
        disabledColor: tokens.surfaceContainerLow,
        side: BorderSide(color: tokens.ghostBorder, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(tokens.radiusPill),
        ),
        labelStyle: textTheme.labelMedium,
        secondaryLabelStyle: textTheme.labelMedium?.copyWith(
          color: tokens.primary,
        ),
        checkmarkColor: tokens.primary,
      ),
      switchTheme: SwitchThemeData(
        trackOutlineColor: WidgetStatePropertyAll(tokens.ghostBorderStrong),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return tokens.primary.withValues(alpha: 0.45);
          }
          return tokens.surfaceContainerHigh;
        }),
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return tokens.secondary;
          }
          return tokens.onSurfaceVariant;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        side: BorderSide(color: tokens.ghostBorderStrong, width: 1),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return tokens.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStatePropertyAll(tokens.onPrimary),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return tokens.secondary;
          }
          return tokens.onSurfaceVariant;
        }),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: tokens.primary,
        foregroundColor: tokens.onPrimary,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: const StadiumBorder(),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: tokens.primary,
        linearTrackColor: tokens.surfaceContainerHigh,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: tokens.primary,
        unselectedLabelColor: tokens.onSurfaceVariant,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: tokens.primary, width: 2),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: tokens.surfaceContainerLowest,
        selectedItemColor: tokens.primary,
        unselectedItemColor: tokens.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.manrope(
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: GoogleFonts.manrope(fontSize: 11),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: tokens.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        indicatorColor: tokens.primary.withValues(alpha: 0.16),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final color = states.contains(WidgetState.selected)
              ? tokens.primary
              : tokens.onSurfaceVariant;
          return IconThemeData(color: color);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final color = states.contains(WidgetState.selected)
              ? tokens.primary
              : tokens.onSurfaceVariant;
          return GoogleFonts.manrope(
            color: color,
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
          );
        }),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: tokens.surfaceContainer,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(tokens.radiusMd),
            borderSide: BorderSide(color: tokens.ghostBorder),
          ),
        ),
        menuStyle: MenuStyle(
          backgroundColor:
              WidgetStatePropertyAll(tokens.surfaceContainerHigh),
          surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
          side: WidgetStatePropertyAll(BorderSide(color: tokens.ghostBorder)),
        ),
      ),
    );
  }
}

