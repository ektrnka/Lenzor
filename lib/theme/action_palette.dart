import 'package:flutter/material.dart';

@immutable
class ActionPalette {
  const ActionPalette({
    required this.replacement,
    required this.attention,
    required this.symptom,
    required this.removal,
    required this.overdue,
  });

  final Color replacement;
  final Color attention;
  final Color symptom;
  final Color removal;
  final Color overdue;

  static const ActionPalette light = ActionPalette(
    replacement: Color(0xFF2DCE89),
    attention: Color(0xFFFFAD0D),
    symptom: Color(0xFFFF85A1),
    removal: Color(0xFF006494),
    overdue: Color(0xFFDC2626),
  );

  static const ActionPalette dark = ActionPalette(
    replacement: Color(0xFF2DCE89),
    attention: Color(0xFFFB923C),
    symptom: Color(0xFFFF85A1),
    removal: Color(0xFF006494),
    overdue: Color(0xFFDC2626),
  );
}

extension ActionPaletteContextX on BuildContext {
  ActionPalette get actionPalette {
    return Theme.of(this).brightness == Brightness.dark
        ? ActionPalette.dark
        : ActionPalette.light;
  }
}
