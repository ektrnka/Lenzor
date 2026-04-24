import 'dart:ui';

import 'package:flutter/material.dart';

import 'app_colors.dart';

@immutable
class NeonThemeTokens extends ThemeExtension<NeonThemeTokens> {
  const NeonThemeTokens({
    required this.background,
    required this.surface,
    required this.surfaceDim,
    required this.surfaceBright,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
    required this.primary,
    required this.primaryContainer,
    required this.secondary,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.onPrimary,
    required this.ghostBorder,
    required this.ghostBorderStrong,
    required this.glowColor,
    required this.headerGradient,
    required this.primaryGradient,
    required this.radiusSm,
    required this.radiusMd,
    required this.radiusLg,
    required this.radiusXl,
    required this.radiusPill,
    required this.spaceXs,
    required this.spaceSm,
    required this.spaceMd,
    required this.spaceLg,
    required this.spaceXl,
    required this.blurSm,
    required this.blurMd,
    required this.blurLg,
  });

  final Color background;
  final Color surface;
  final Color surfaceDim;
  final Color surfaceBright;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
  final Color primary;
  final Color primaryContainer;
  final Color secondary;
  final Color onSurface;
  final Color onSurfaceVariant;
  final Color onPrimary;
  final Color ghostBorder;
  final Color ghostBorderStrong;
  final Color glowColor;
  final Gradient headerGradient;
  final Gradient primaryGradient;
  final double radiusSm;
  final double radiusMd;
  final double radiusLg;
  final double radiusXl;
  final double radiusPill;
  final double spaceXs;
  final double spaceSm;
  final double spaceMd;
  final double spaceLg;
  final double spaceXl;
  final double blurSm;
  final double blurMd;
  final double blurLg;

  static NeonThemeTokens light() {
    final palette = AppColors.light;
    return NeonThemeTokens(
      background: palette.background,
      surface: palette.surface,
      surfaceDim: palette.surfaceDim,
      surfaceBright: palette.surfaceBright,
      surfaceContainerLowest: palette.surfaceContainerLowest,
      surfaceContainerLow: palette.surfaceContainerLow,
      surfaceContainer: palette.surfaceContainer,
      surfaceContainerHigh: palette.surfaceContainerHigh,
      surfaceContainerHighest: palette.surfaceContainerHighest,
      primary: palette.primary,
      primaryContainer: palette.primaryContainer,
      secondary: palette.secondary,
      onSurface: palette.onSurface,
      onSurfaceVariant: palette.onSurfaceVariant,
      onPrimary: Colors.white,
      ghostBorder: palette.outlineVariant.withValues(alpha: 0.12),
      ghostBorderStrong: palette.outlineVariant.withValues(alpha: 0.18),
      glowColor: palette.primary.withValues(alpha: 0.10),
      headerGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          palette.primary,
          palette.primaryContainer,
        ],
      ),
      primaryGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          palette.primary,
          palette.primaryContainer,
        ],
      ),
      radiusSm: 8,
      radiusMd: 12,
      radiusLg: 16,
      radiusXl: 24,
      radiusPill: 9999,
      spaceXs: 4,
      spaceSm: 8,
      spaceMd: 16,
      spaceLg: 24,
      spaceXl: 32,
      blurSm: 8,
      blurMd: 16,
      blurLg: 24,
    );
  }

  static NeonThemeTokens dark() {
    final palette = AppColors.dark;
    return NeonThemeTokens(
      background: palette.background,
      surface: palette.surface,
      surfaceDim: palette.surfaceDim,
      surfaceBright: palette.surfaceBright,
      surfaceContainerLowest: palette.surfaceContainerLowest,
      surfaceContainerLow: palette.surfaceContainerLow,
      surfaceContainer: palette.surfaceContainer,
      surfaceContainerHigh: palette.surfaceContainerHigh,
      surfaceContainerHighest: palette.surfaceContainerHighest,
      primary: palette.primary,
      primaryContainer: palette.primaryContainer,
      secondary: palette.secondary,
      onSurface: palette.onSurface,
      onSurfaceVariant: palette.onSurfaceVariant,
      onPrimary: const Color(0xFF003354),
      ghostBorder: palette.outlineVariant.withValues(alpha: 0.12),
      ghostBorderStrong: palette.outlineVariant.withValues(alpha: 0.16),
      glowColor: palette.primaryContainer.withValues(alpha: 0.30),
      headerGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[palette.primary, palette.primaryContainer],
      ),
      primaryGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[palette.primary, palette.primaryContainer],
      ),
      radiusSm: 8,
      radiusMd: 12,
      radiusLg: 16,
      radiusXl: 24,
      radiusPill: 9999,
      spaceXs: 4,
      spaceSm: 8,
      spaceMd: 16,
      spaceLg: 24,
      spaceXl: 32,
      blurSm: 8,
      blurMd: 16,
      blurLg: 24,
    );
  }

  @override
  ThemeExtension<NeonThemeTokens> copyWith({
    Color? background,
    Color? surface,
    Color? surfaceDim,
    Color? surfaceBright,
    Color? surfaceContainerLowest,
    Color? surfaceContainerLow,
    Color? surfaceContainer,
    Color? surfaceContainerHigh,
    Color? surfaceContainerHighest,
    Color? primary,
    Color? primaryContainer,
    Color? secondary,
    Color? onSurface,
    Color? onSurfaceVariant,
    Color? onPrimary,
    Color? ghostBorder,
    Color? ghostBorderStrong,
    Color? glowColor,
    Gradient? headerGradient,
    Gradient? primaryGradient,
    double? radiusSm,
    double? radiusMd,
    double? radiusLg,
    double? radiusXl,
    double? radiusPill,
    double? spaceXs,
    double? spaceSm,
    double? spaceMd,
    double? spaceLg,
    double? spaceXl,
    double? blurSm,
    double? blurMd,
    double? blurLg,
  }) {
    return NeonThemeTokens(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceDim: surfaceDim ?? this.surfaceDim,
      surfaceBright: surfaceBright ?? this.surfaceBright,
      surfaceContainerLowest:
          surfaceContainerLowest ?? this.surfaceContainerLowest,
      surfaceContainerLow: surfaceContainerLow ?? this.surfaceContainerLow,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      surfaceContainerHigh: surfaceContainerHigh ?? this.surfaceContainerHigh,
      surfaceContainerHighest:
          surfaceContainerHighest ?? this.surfaceContainerHighest,
      primary: primary ?? this.primary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      secondary: secondary ?? this.secondary,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
      onPrimary: onPrimary ?? this.onPrimary,
      ghostBorder: ghostBorder ?? this.ghostBorder,
      ghostBorderStrong: ghostBorderStrong ?? this.ghostBorderStrong,
      glowColor: glowColor ?? this.glowColor,
      headerGradient: headerGradient ?? this.headerGradient,
      primaryGradient: primaryGradient ?? this.primaryGradient,
      radiusSm: radiusSm ?? this.radiusSm,
      radiusMd: radiusMd ?? this.radiusMd,
      radiusLg: radiusLg ?? this.radiusLg,
      radiusXl: radiusXl ?? this.radiusXl,
      radiusPill: radiusPill ?? this.radiusPill,
      spaceXs: spaceXs ?? this.spaceXs,
      spaceSm: spaceSm ?? this.spaceSm,
      spaceMd: spaceMd ?? this.spaceMd,
      spaceLg: spaceLg ?? this.spaceLg,
      spaceXl: spaceXl ?? this.spaceXl,
      blurSm: blurSm ?? this.blurSm,
      blurMd: blurMd ?? this.blurMd,
      blurLg: blurLg ?? this.blurLg,
    );
  }

  @override
  ThemeExtension<NeonThemeTokens> lerp(
    covariant ThemeExtension<NeonThemeTokens>? other,
    double t,
  ) {
    if (other is! NeonThemeTokens) return this;
    return NeonThemeTokens(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceDim: Color.lerp(surfaceDim, other.surfaceDim, t)!,
      surfaceBright: Color.lerp(surfaceBright, other.surfaceBright, t)!,
      surfaceContainerLowest:
          Color.lerp(surfaceContainerLowest, other.surfaceContainerLowest, t)!,
      surfaceContainerLow:
          Color.lerp(surfaceContainerLow, other.surfaceContainerLow, t)!,
      surfaceContainer:
          Color.lerp(surfaceContainer, other.surfaceContainer, t)!,
      surfaceContainerHigh:
          Color.lerp(surfaceContainerHigh, other.surfaceContainerHigh, t)!,
      surfaceContainerHighest:
          Color.lerp(surfaceContainerHighest, other.surfaceContainerHighest, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryContainer: Color.lerp(primaryContainer, other.primaryContainer, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      onSurfaceVariant: Color.lerp(onSurfaceVariant, other.onSurfaceVariant, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      ghostBorder: Color.lerp(ghostBorder, other.ghostBorder, t)!,
      ghostBorderStrong:
          Color.lerp(ghostBorderStrong, other.ghostBorderStrong, t)!,
      glowColor: Color.lerp(glowColor, other.glowColor, t)!,
      headerGradient: t < 0.5 ? headerGradient : other.headerGradient,
      primaryGradient: t < 0.5 ? primaryGradient : other.primaryGradient,
      radiusSm: lerpDouble(radiusSm, other.radiusSm, t)!,
      radiusMd: lerpDouble(radiusMd, other.radiusMd, t)!,
      radiusLg: lerpDouble(radiusLg, other.radiusLg, t)!,
      radiusXl: lerpDouble(radiusXl, other.radiusXl, t)!,
      radiusPill: lerpDouble(radiusPill, other.radiusPill, t)!,
      spaceXs: lerpDouble(spaceXs, other.spaceXs, t)!,
      spaceSm: lerpDouble(spaceSm, other.spaceSm, t)!,
      spaceMd: lerpDouble(spaceMd, other.spaceMd, t)!,
      spaceLg: lerpDouble(spaceLg, other.spaceLg, t)!,
      spaceXl: lerpDouble(spaceXl, other.spaceXl, t)!,
      blurSm: lerpDouble(blurSm, other.blurSm, t)!,
      blurMd: lerpDouble(blurMd, other.blurMd, t)!,
      blurLg: lerpDouble(blurLg, other.blurLg, t)!,
    );
  }
}

extension NeonContextX on BuildContext {
  NeonThemeTokens get neon {
    final extension = Theme.of(this).extension<NeonThemeTokens>();
    assert(extension != null, 'NeonThemeTokens are not configured in ThemeData');
    return extension!;
  }
}

