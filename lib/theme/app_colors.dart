import 'package:flutter/material.dart';

/// App color tokens.
abstract final class AppColors {
  AppColors._();

  static const AppColorPalette light = AppColorPalette(
    primary: Color(0xFF004B71),
    primaryContainer: Color(0xFF006494),
    secondary: Color(0xFF008EC2),
    surfaceTint: Color(0xFF006494),
    background: Color(0xFFF6FAFE),
    surface: Color(0xFFF6FAFE),
    surfaceDim: Color(0xFFEEF3F7),
    surfaceBright: Color(0xFFFFFFFF),
    surfaceContainer: Color(0xFFEAEEF2),
    surfaceContainerLow: Color(0xFFF0F4F8),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerHigh: Color(0xFFE8ECF0),
    surfaceContainerHighest: Color(0xFFDFE3E7),
    onSurface: Color(0xFF171C1F),
    onSurfaceVariant: Color(0xFF40484F),
    secondaryContainer: Color(0xFFD6E4F5),
    tertiary: Color(0xFF930010),
    tertiaryContainer: Color(0xFFBA1A20),
    outlineVariant: Color(0xFFC0C7D0),
    ambientShadow: Color(0x14004B71),
  );

  // Dark palette based on DESIGN (4).md "Vision Flow Dark".
  static const AppColorPalette dark = AppColorPalette(
    primary: Color(0xFF55B1FF),
    primaryContainer: Color(0xFF55B1FF),
    secondary: Color(0xFFB7C8E1),
    surfaceTint: Color(0xFF55B1FF),
    background: Color(0xFF0F1419),
    surface: Color(0xFF0F1419),
    surfaceDim: Color(0xFF0F1419),
    surfaceBright: Color(0xFF353A40),
    surfaceContainer: Color(0xFF1B2026),
    surfaceContainerLow: Color(0xFF171C22),
    surfaceContainerLowest: Color(0xFF0A0F14),
    surfaceContainerHigh: Color(0xFF262A30),
    surfaceContainerHighest: Color(0xFF30353B),
    onSurface: Color(0xFFDFE3EA),
    onSurfaceVariant: Color(0xFFBEC7D4),
    secondaryContainer: Color(0xFF3A4A5F),
    tertiary: Color(0xFFFFB77D),
    tertiaryContainer: Color(0xFFEB8104),
    outlineVariant: Color(0xFF3F4852),
    ambientShadow: Color(0x2655B1FF),
  );

  // Backward-compatible light tokens used across existing screens.
  static const Color primary = Color(0xFF004B71);
  static const Color primaryContainer = Color(0xFF006494);
  static const Color secondary = Color(0xFF008EC2);
  static const Color surfaceTint = Color(0xFF006494);
  static const Color background = Color(0xFFF6FAFE);
  static const Color surface = Color(0xFFF6FAFE);
  static const Color surfaceDim = Color(0xFFEEF3F7);
  static const Color surfaceBright = Color(0xFFFFFFFF);
  static const Color surfaceContainer = Color(0xFFEAEEF2);
  static const Color surfaceContainerLow = Color(0xFFF0F4F8);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerHigh = Color(0xFFE8ECF0);
  static const Color surfaceContainerHighest = Color(0xFFDFE3E7);
  static const Color onSurface = Color(0xFF171C1F);
  static const Color onSurfaceVariant = Color(0xFF40484F);
  static const Color secondaryContainer = Color(0xFFD6E4F5);
  static const Color tertiary = Color(0xFF930010);
  static const Color tertiaryContainer = Color(0xFFBA1A20);
  static const Color outlineVariant = Color(0xFFC0C7D0);
  static const Color ambientShadow = Color(0x14004B71);

  static const LinearGradient primaryDiagonalGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryContainer],
  );
}

class AppColorPalette {
  final Color primary;
  final Color primaryContainer;
  final Color secondary;
  final Color surfaceTint;
  final Color background;
  final Color surface;
  final Color surfaceDim;
  final Color surfaceBright;
  final Color surfaceContainer;
  final Color surfaceContainerLow;
  final Color surfaceContainerLowest;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
  final Color onSurface;
  final Color onSurfaceVariant;
  final Color secondaryContainer;
  final Color tertiary;
  final Color tertiaryContainer;
  final Color outlineVariant;
  final Color ambientShadow;

  const AppColorPalette({
    required this.primary,
    required this.primaryContainer,
    required this.secondary,
    required this.surfaceTint,
    required this.background,
    required this.surface,
    required this.surfaceDim,
    required this.surfaceBright,
    required this.surfaceContainer,
    required this.surfaceContainerLow,
    required this.surfaceContainerLowest,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.secondaryContainer,
    required this.tertiary,
    required this.tertiaryContainer,
    required this.outlineVariant,
    required this.ambientShadow,
  });
}

