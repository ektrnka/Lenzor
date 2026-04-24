// models/lens_data.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme/app_colors.dart';

// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
// рџџў 1.1. LensType вЂ” РўРёРї РєРѕРЅС‚Р°РєС‚РЅС‹С… Р»РёРЅР· [file:15]
// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ

/// рџџў РўРёРї РєРѕРЅС‚Р°РєС‚РЅС‹С… Р»РёРЅР· [file:15] 1.1
/// 
/// Р—РЅР°С‡РµРЅРёРµ       | days | label           | Р•РґРёРЅРёС†Р° РїСЂРѕРіСЂРµСЃСЃР°
/// --------------|------|-----------------|------------------
/// daily          |   1  | РћРґРЅРѕРґРЅРµРІРЅС‹Рµ     | Р§Р°СЃС‹ (РјР°РєСЃ 14С‡)
/// weekly         |   7  | РќРµРґРµР»СЊРЅС‹Рµ       | Р”РЅРё (РєСЂСѓР¶РѕС‡РєРё)
/// biweekly       |  14  | Р”РІСѓС…РЅРµРґРµР»СЊРЅС‹Рµ   | Р”РЅРё (РєСЂСѓР¶РѕС‡РєРё)
/// monthly        |  30  | РњРµСЃСЏС‡РЅС‹Рµ        | Р”РЅРё (РєСЂСѓР¶РѕС‡РєРё)
/// quarterly      |  90  | РљРІР°СЂС‚Р°Р»СЊРЅС‹Рµ     | Р”РЅРё (Р»РёРЅРµР№РЅС‹Р№ Р±Р°СЂ)
/// halfYearly     | 180  | РџРѕР»СѓРіРѕРґРѕРІС‹Рµ     | Р”РЅРё (Р»РёРЅРµР№РЅС‹Р№ Р±Р°СЂ)
enum LensType {
  daily(days: 1, label: 'Daily'),
  weekly(days: 7, label: 'Weekly'),
  biweekly(days: 14, label: 'Bi-weekly'),
  monthly(days: 30, label: 'Monthly'),
  quarterly(days: 90, label: 'Quarterly'),
  halfYearly(days: 180, label: 'Semi-annual');

  final int days;
  final String label;

  const LensType({
    required this.days,
    required this.label,
  });

  /// рџџў РџРѕСЂРѕРі В«СЃРєРѕСЂРѕ Р·Р°РјРµРЅР°В» [file:15] 1.1
  /// в‰¤2 РґРЅСЏ РґР»СЏ daily/weekly/biweekly/monthly
  /// в‰¤7 РґРЅРµР№ РґР»СЏ quarterly/halfYearly
  int get nearEndThreshold => days > 30 ? 7 : 2;

  /// РўРёРї РІРёР·СѓР°Р»РёР·Р°С†РёРё РїСЂРѕРіСЂРµСЃСЃР°
  ProgressType get progressType {
    if (days == 1) return ProgressType.hourly;
    if (days <= 30) return ProgressType.dots;
    return ProgressType.linear;
  }
}

/// РўРёРї РІРёР·СѓР°Р»РёР·Р°С†РёРё РїСЂРѕРіСЂРµСЃСЃР°
enum ProgressType {
  hourly,  // Р§Р°СЃРѕРІРѕР№ (РґР»СЏ РѕРґРЅРѕРґРЅРµРІРЅС‹С…)
  dots,    // РљСЂСѓР¶РѕС‡РєРё (РґР»СЏ 7-30 РґРЅРµР№)
  linear,  // Р›РёРЅРµР№РЅС‹Р№ Р±Р°СЂ (РґР»СЏ 90, 180 РґРЅРµР№)
}

// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
// рџџў 1.2. Symptom вЂ” РЎРёРјРїС‚РѕРјС‹ [file:15]
// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ

/// рџџў РЎРёРјРїС‚РѕРјС‹ [file:15] 1.2
/// 
/// РџРѕР»СЊР·РѕРІР°С‚РµР»СЊ РјРѕР¶РµС‚ РІС‹Р±СЂР°С‚СЊ 1+ СЃРёРјРїС‚РѕРјРѕРІ РѕРґРЅРѕРІСЂРµРјРµРЅРЅРѕ
/// РљРЅРѕРїРєР° В«РЎРѕС…СЂР°РЅРёС‚СЊВ» РЅРµР°РєС‚РёРІРЅР° РїСЂРё РїСѓСЃС‚РѕРј РІС‹Р±РѕСЂРµ
enum Symptom {
  discomfort(label: 'Discomfort', icon: Icons.sentiment_dissatisfied_outlined),
  dryEyes(label: 'Dry eyes', icon: Icons.water_drop_outlined),
  redness(label: 'Redness', icon: Icons.circle_outlined),
  tearing(label: 'Tearing', icon: Icons.water_drop_outlined),
  blurryVision(label: 'Blurred vision', icon: Icons.blur_on_outlined),
  pain(label: 'Pain', icon: Icons.health_and_safety_outlined),
  lightSensitivity(label: 'Light sensitivity', icon: Icons.lightbulb_outline),
  eyeFatigue(label: 'Eye fatigue', icon: Icons.bedtime_outlined);

  final String label;
  final IconData icon;

  const Symptom({
    required this.label,
    required this.icon,
  });
}

// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
// рџџў 1.3. LensInfo вЂ” РРЅС„РѕСЂРјР°С†РёСЏ Рѕ Р»РёРЅР·Р°С… [file:15]
// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ

/// рџџў РРЅС„РѕСЂРјР°С†РёСЏ Рѕ Р»РёРЅР·Р°С… [file:15] 1.3
/// 
/// РџР РђР’РР›Рђ:
/// - РџСЂРё РїРµСЂРІРѕРј Р·Р°РїСѓСЃРєРµ firstUseDate = DateTime.now()
/// - РџСЂРё РєР°Р¶РґРѕР№ Р·Р°РјРµРЅРµ Р»РёРЅР· firstUseDate РѕР±РЅРѕРІР»СЏРµС‚СЃСЏ
/// - РР·РјРµРЅРµРЅРёРµ С‚РёРїР° Р»РёРЅР· РќР• РІР»РёСЏРµС‚ РЅР° С‚РµРєСѓС‰РёР№ Р°РєС‚РёРІРЅС‹Р№ С†РёРєР»
/// - BC Рё DIA вЂ” СЂР°Р·РґРµР»СЊРЅС‹Рµ РґР»СЏ РєР°Р¶РґРѕРіРѕ РіР»Р°Р·Р°
class LensInfo {
  String brand;
  LensType type;
  double bcLeft;
  double bcRight;
  double diaLeft;
  double diaRight;
  DateTime? firstUseDate;

  LensInfo({
    this.brand = 'Acuvue Oasys',
    this.type = LensType.monthly,
    this.bcLeft = 8.4,
    this.bcRight = 8.4,
    this.diaLeft = 14.0,
    this.diaRight = 14.0,
    this.firstUseDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'brand': brand,
      'type': type.name,
      'bcLeft': bcLeft,
      'bcRight': bcRight,
      'diaLeft': diaLeft,
      'diaRight': diaRight,
      'firstUseDate': firstUseDate?.toIso8601String(),
    };
  }

  factory LensInfo.fromJson(Map<String, dynamic> json) {
    try {
      return LensInfo(
        brand: json['brand'] as String? ?? 'Acuvue Oasys',
        type: LensType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => LensType.monthly,
        ),
        bcLeft: (json['bcLeft'] as num?)?.toDouble() ?? 8.4,
        bcRight: (json['bcRight'] as num?)?.toDouble() ?? 8.4,
        diaLeft: (json['diaLeft'] as num?)?.toDouble() ?? 14.0,
        diaRight: (json['diaRight'] as num?)?.toDouble() ?? 14.0,
        firstUseDate: json['firstUseDate'] != null
            ? DateTime.parse(json['firstUseDate'] as String)
            : null,
      );
    } catch (e) {
      debugPrint('LensInfo parse error: $e');
      return LensInfo(); // Р—РЅР°С‡РµРЅРёСЏ РїРѕ СѓРјРѕР»С‡Р°РЅРёСЋ [file:15] EDGE-006
    }
  }

  LensInfo copyWith({
    String? brand,
    LensType? type,
    double? bcLeft,
    double? bcRight,
    double? diaLeft,
    double? diaRight,
    DateTime? firstUseDate,
  }) {
    return LensInfo(
      brand: brand ?? this.brand,
      type: type ?? this.type,
      bcLeft: bcLeft ?? this.bcLeft,
      bcRight: bcRight ?? this.bcRight,
      diaLeft: diaLeft ?? this.diaLeft,
      diaRight: diaRight ?? this.diaRight,
      firstUseDate: firstUseDate ?? this.firstUseDate,
    );
  }
}

// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
// рџџў 1.4. VisionCheck вЂ” РџСЂРѕРІРµСЂРєР° Р·СЂРµРЅРёСЏ [file:15]
// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ

/// рџџў РџСЂРѕРІРµСЂРєР° Р·СЂРµРЅРёСЏ [file:15] 1.4
/// 
/// РџР РђР’РР›Рђ Р’РђР›РР”РђР¦РР:
/// - SPH РѕР±СЏР·Р°С‚РµР»РµРЅ РґР»СЏ РѕР±РѕРёС… РіР»Р°Р·
/// - CYL РѕРїС†РёРѕРЅР°Р»РµРЅ. Р•СЃР»Рё СѓРєР°Р·Р°РЅ CYL, AXIS РѕР±СЏР·Р°С‚РµР»РµРЅ (0-180В°)
/// - РџСЂРё РґРѕР±Р°РІР»РµРЅРёРё РїСЂРµРґР·Р°РїРѕР»РЅСЏСЋС‚СЃСЏ Р·РЅР°С‡РµРЅРёСЏРјРё РёР· РїРѕСЃР»РµРґРЅРµР№ РїСЂРѕРІРµСЂРєРё
class VisionCheck {
  DateTime date;
  double leftSph;
  double rightSph;
  double? leftCyl;
  double? rightCyl;
  int? leftAxis;
  int? rightAxis;

  VisionCheck({
    required this.date,
    required this.leftSph,
    required this.rightSph,
    this.leftCyl,
    this.rightCyl,
    this.leftAxis,
    this.rightAxis,
  });

  /// Р•СЃС‚СЊ Р»Рё РґР°РЅРЅС‹Рµ РїРѕ Р°СЃС‚РёРіРјР°С‚РёР·РјСѓ
  bool get hasAstigmatism =>
      (leftCyl != null && leftCyl != 0) || (rightCyl != null && rightCyl != 0);

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'leftSph': leftSph,
      'rightSph': rightSph,
      'leftCyl': leftCyl,
      'rightCyl': rightCyl,
      'leftAxis': leftAxis,
      'rightAxis': rightAxis,
    };
  }

  factory VisionCheck.fromJson(Map<String, dynamic> json) {
    try {
      return VisionCheck(
        date: DateTime.parse(json['date'] as String),
        leftSph: (json['leftSph'] as num).toDouble(),
        rightSph: (json['rightSph'] as num).toDouble(),
        leftCyl: json['leftCyl'] != null ? (json['leftCyl'] as num).toDouble() : null,
        rightCyl: json['rightCyl'] != null ? (json['rightCyl'] as num).toDouble() : null,
        leftAxis: json['leftAxis'] as int?,
        rightAxis: json['rightAxis'] as int?,
      );
    } catch (e) {
      debugPrint('VisionCheck parse error: $e');
      // [file:15] EDGE-006: РќРµ РјРѕР¶РµРј РІРµСЂРЅСѓС‚СЊ Р·РЅР°С‡РµРЅРёРµ РїРѕ СѓРјРѕР»С‡Р°РЅРёСЋ, С‚.Рє. SPH РѕР±СЏР·Р°С‚РµР»РµРЅ
      rethrow;
    }
  }
}

// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
// рџџў 1.5. SymptomEntry вЂ” Р—Р°РїРёСЃСЊ СЃРёРјРїС‚РѕРјРѕРІ [file:15]
// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ

/// рџџў Р—Р°РїРёСЃСЊ СЃРёРјРїС‚РѕРјРѕРІ [file:15] 1.5
/// 
/// РџР РђР’РР›Рђ:
/// - РћРґРЅР° Р·Р°РїРёСЃСЊ РЅР° РґРµРЅСЊ (РїСЂРё РїРѕРІС‚РѕСЂРЅРѕРј СЃРѕС…СЂР°РЅРµРЅРёРё Р·Р°РјРµРЅСЏРµС‚СЃСЏ)
/// - РџСѓСЃС‚РѕР№ СЃРїРёСЃРѕРє symptoms РґРѕРїСѓСЃРєР°РµС‚СЃСЏ (РїСЂРё СЂСѓС‡РЅРѕРј СЃРЅСЏС‚РёРё)
/// - notes РјРѕР¶РµС‚ Р±С‹С‚СЊ null РёР»Рё РїСѓСЃС‚РѕР№ СЃС‚СЂРѕРєРѕР№
class SymptomEntry {
  DateTime date;
  List<Symptom> symptoms;
  String? notes;

  SymptomEntry({
    required this.date,
    required this.symptoms,
    this.notes,
  });

  /// РџСЂРѕРІРµСЂРєР°: СЌС‚Рѕ Р·Р°РїРёСЃСЊ Рѕ СЂСѓС‡РЅРѕРј СЃРЅСЏС‚РёРё Р»РёРЅР·
  bool get isManualRemoval =>
      symptoms.isEmpty &&
      notes == 'Lenses removed manually';

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'symptoms': symptoms.map((s) => s.name).toList(),
      'notes': notes,
    };
  }

  factory SymptomEntry.fromJson(Map<String, dynamic> json) {
    try {
      return SymptomEntry(
        date: DateTime.parse(json['date'] as String),
        symptoms: (json['symptoms'] as List?)
                ?.map((s) => Symptom.values.firstWhere(
                      (e) => e.name == s,
                      orElse: () => Symptom.discomfort,
                    ))
                .toList() ??
            [],
        notes: json['notes'] as String?,
      );
    } catch (e) {
      debugPrint('SymptomEntry parse error: $e');
      return SymptomEntry(date: DateTime.now(), symptoms: []); // [file:15] EDGE-006
    }
  }
}

// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
// рџџў 1.6. LensReplacement вЂ” Р—Р°РјРµРЅР° Р»РёРЅР· [file:15]
// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ

/// рџџў Р—Р°РјРµРЅР° Р»РёРЅР· [file:15] 1.6
/// 
/// РџР РђР’РР›Рђ:
/// - РЎРѕР·РґР°С‘С‚СЃСЏ Р°РІС‚РѕРјР°С‚РёС‡РµСЃРєРё РїСЂРё РІС‹Р·РѕРІРµ startNewCycle()
/// - РџСЂРё СЃРѕС…СЂР°РЅРµРЅРёРё РѕР±РЅРѕРІР»СЏРµС‚ LensInfo.firstUseDate
/// - Р—Р°РјРµРЅС‹ РЅРёРєРѕРіРґР° РЅРµ СѓРґР°Р»СЏСЋС‚СЃСЏ (С‚РѕР»СЊРєРѕ РїСЂРё РїРѕР»РЅРѕР№ РѕС‡РёСЃС‚РєРµ)
class LensReplacement {
  DateTime date;
  String? notes;

  LensReplacement({
    required this.date,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }

  factory LensReplacement.fromJson(Map<String, dynamic> json) {
    try {
      return LensReplacement(
        date: DateTime.parse(json['date'] as String),
        notes: json['notes'] as String?,
      );
    } catch (e) {
      debugPrint('LensReplacement parse error: $e');
      return LensReplacement(date: DateTime.now()); // [file:15] EDGE-006
    }
  }
}

// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
// рџџў 1.7. StockUpdate вЂ” РћР±РЅРѕРІР»РµРЅРёРµ Р·Р°РїР°СЃР° [file:15]
// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ

/// рџџў РћР±РЅРѕРІР»РµРЅРёРµ Р·Р°РїР°СЃР° [file:15] 1.7
/// 
/// РџР РђР’РР›Рћ: pairsCount С…СЂР°РЅРёС‚ РђР‘РЎРћР›Р®РўРќРћР• Р·РЅР°С‡РµРЅРёРµ (РЅРµ РґРµР»СЊС‚Сѓ)
/// РџСЂРёРјРµСЂ: Р±С‹Р»Рѕ 3, РґРѕР±Р°РІРёР»Рё 5 в†’ pairsCount = 8
class StockUpdate {
  DateTime date;
  int pairsCount; // РРўРћР“РћР’РћР• РєРѕР»РёС‡РµСЃС‚РІРѕ РїР°СЂ

  StockUpdate({
    required this.date,
    required this.pairsCount,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'pairsCount': pairsCount,
    };
  }

  factory StockUpdate.fromJson(Map<String, dynamic> json) {
    try {
      return StockUpdate(
        date: DateTime.parse(json['date'] as String),
        pairsCount: json['pairsCount'] as int? ?? 0,
      );
    } catch (e) {
      debugPrint('StockUpdate parse error: $e');
      return StockUpdate(date: DateTime.now(), pairsCount: 0); // [file:15] EDGE-006
    }
  }
}

// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
// рџџў 1.8. LensCycle вЂ” Р¦РёРєР» РЅРѕС€РµРЅРёСЏ Р»РёРЅР· [file:15]
// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ

/// рџџў Р¦РёРєР» РЅРѕС€РµРЅРёСЏ Р»РёРЅР· [file:15] 1.8
/// 
/// Р’Р«Р§РРЎР›РЇР•РњР«Р• РџРћР›РЇ:
/// - isActive: endDate == null
/// - daysWorn: Р°РєС‚РёРІРЅС‹Р№ в†’ DateTime.now() - startDate; Р·Р°РІРµСЂС€С‘РЅРЅС‹Р№ в†’ actualDaysWorn
/// - isOverdue: daysWorn > lensType.days
/// - status: "Р’ РёСЃРїРѕР»СЊР·РѕРІР°РЅРёРё" / "РЎРєРѕСЂРѕ Р·Р°РјРµРЅР°" / "РџСЂРѕСЃСЂРѕС‡РµРЅРѕ" / "Р—Р°РІРµСЂС€РµРЅ" / "РџСЂРѕСЃСЂРѕС‡РµРЅ"
/// - statusColor: СЃРёРЅРёР№/РѕСЂР°РЅР¶РµРІС‹Р№/РєСЂР°СЃРЅС‹Р№/Р·РµР»С‘РЅС‹Р№
class LensCycle {
  final DateTime startDate;
  final DateTime? endDate; // null = Р°РєС‚РёРІРЅС‹Р№
  final LensType lensType;
  final int? actualDaysWorn; // null = Р°РєС‚РёРІРЅС‹Р№
  final bool completedManually; // true = СЃРЅСЏС‚ РІСЂСѓС‡РЅСѓСЋ, false = Р·Р°РјРµРЅС‘РЅ
  final String? replacementId;
  final String? symptomEntryId;

  LensCycle({
    required this.startDate,
    this.endDate,
    required this.lensType,
    this.actualDaysWorn,
    required this.completedManually,
    this.replacementId,
    this.symptomEntryId,
  });

  // в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
  // Р’Р«Р§РРЎР›РЇР•РњР«Р• РџРћР›РЇ [file:15] 1.8
  // в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ

  /// РђРєС‚РёРІРµРЅ Р»Рё С†РёРєР»
  bool get isActive => endDate == null;

  /// рџџў РљРѕР»РёС‡РµСЃС‚РІРѕ РґРЅРµР№ РЅРѕС€РµРЅРёСЏ [file:15] 1.8
  /// РђРєС‚РёРІРЅС‹Р№ в†’ DateTime.now() - startDate
  /// Р—Р°РІРµСЂС€С‘РЅРЅС‹Р№ в†’ actualDaysWorn
  int get daysWorn {
    if (isActive) {
      return calculateInclusiveCalendarDays(startDate, DateTime.now());
    }
    if (endDate != null) {
      return calculateInclusiveCalendarDays(startDate, endDate!);
    }
    return actualDaysWorn ?? 0;
  }

  static int calculateInclusiveCalendarDays(DateTime start, DateTime end) {
    final startOnly = DateTime(start.year, start.month, start.day);
    final endOnly = DateTime(end.year, end.month, end.day);
    final diff = endOnly.difference(startOnly).inDays;
    return diff >= 0 ? diff + 1 : 0;
  }

  /// РџСЂРѕСЃСЂРѕС‡РµРЅ Р»Рё С†РёРєР»
  bool get isOverdue => daysWorn > lensType.days;

  /// Р‘Р»РёР·РєРѕ Р»Рё Рє РєРѕРЅС†Сѓ СЃСЂРѕРєР° (РїРѕСЂРѕРі Р·Р°РІРёСЃРёС‚ РѕС‚ С‚РёРїР° Р»РёРЅР·)
  bool get isNearEnd {
    final threshold = lensType.nearEndThreshold;
    return daysWorn >= lensType.days - threshold && daysWorn <= lensType.days;
  }

  /// рџџў РЎРўРђРўРЈРЎ [file:15] 1.8
  /// 
  /// РђРєС‚РёРІРЅС‹Р№ С†РёРєР»:
  ///   - daysWorn > totalDays в†’ В«РџСЂРѕСЃСЂРѕС‡РµРЅРѕ РЅР° X РґРЅ.В» (РєСЂР°СЃРЅС‹Р№)
  ///   - daysWorn >= totalDays-threshold в†’ В«РЎРєРѕСЂРѕ Р·Р°РјРµРЅР°В» (РѕСЂР°РЅР¶)
  ///   - РћСЃС‚Р°Р»СЊРЅС‹Рµ в†’ В«Р’ РёСЃРїРѕР»СЊР·РѕРІР°РЅРёРёВ» (СЃРёРЅРёР№)
  /// Р—Р°РІРµСЂС€С‘РЅРЅС‹Р№ С†РёРєР»:
  ///   - actualDaysWorn > totalDays в†’ В«РџСЂРѕСЃСЂРѕС‡РµРЅВ» (РєСЂР°СЃРЅС‹Р№)
  ///   - РћСЃС‚Р°Р»СЊРЅС‹Рµ в†’ В«Р—Р°РІРµСЂС€РµРЅВ» (Р·РµР»С‘РЅС‹Р№)
  String get status {
    if (isActive) {
      if (isOverdue) {
        return 'Overdue by ${daysWorn - lensType.days} ${_getDayWord(daysWorn - lensType.days)}';
      } else if (isNearEnd) {
        return 'Replace soon';
      } else {
        return 'Active';
      }
    } else {
      if (isOverdue) {
        return 'Overdue';
      } else {
        return 'Completed';
      }
    }
  }

  /// рџџў Р¦Р’Р•Рў РЎРўРђРўРЈРЎРђ [file:15] 1.8
  Color get statusColor {
    if (isActive) {
      if (isOverdue) {
        return AppColors.tertiary;
      } else if (isNearEnd) {
        return AppColors.tertiaryContainer;
      } else {
        return AppColors.primary;
      }
    } else {
      if (isOverdue) {
        return AppColors.tertiary;
      } else {
        return AppColors.primaryContainer;
      }
    }
  }

  /// РћРїРёСЃР°РЅРёРµ СЃРїРѕСЃРѕР±Р° Р·Р°РІРµСЂС€РµРЅРёСЏ
  String get completionDescription {
    if (isActive) return 'Active cycle';
    return completedManually
        ? 'Completed by manual removal'
        : 'Completed by replacement';
  }

  /// РўРµРєСЃС‚ РїСЂРѕРґРѕР»Р¶РёС‚РµР»СЊРЅРѕСЃС‚Рё
  String get durationText {
    if (isActive) {
      return '$daysWorn of ${lensType.days} ${_getDayWord(lensType.days)}';
    } else {
      return 'Used $daysWorn of ${lensType.days} ${_getDayWord(lensType.days)}';
    }
  }

  /// РўРµРєСЃС‚ РґРёР°РїР°Р·РѕРЅР° РґР°С‚
  String get dateRangeText {
    final start = DateFormat('d MMM yyyy', 'en').format(startDate);
    if (isActive) {
      return '$start - today';
    } else {
      final end = DateFormat('d MMM yyyy', 'en').format(endDate!);
      return '$start - $end';
    }
  }

  // в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
  // РњР•РўРћР”Р« РР—РњР•РќР•РќРРЇ РЎРћРЎРўРћРЇРќРРЇ
  // в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ

  /// Р—Р°РІРµСЂС€Р°РµС‚ С†РёРєР»
  LensCycle completeCycle(
    DateTime endDate, {
    bool manually = false,
    String? replacementId,
    String? symptomEntryId,
  }) {
    final daysWorn = calculateInclusiveCalendarDays(startDate, endDate);
    return LensCycle(
      startDate: startDate,
      endDate: endDate,
      lensType: lensType,
      actualDaysWorn: daysWorn,
      completedManually: manually,
      replacementId: replacementId,
      symptomEntryId: symptomEntryId,
    );
  }

  /// РЎРѕР·РґР°С‘С‚ РєРѕРїРёСЋ СЃ РЅРѕРІС‹РјРё Р·РЅР°С‡РµРЅРёСЏРјРё
  LensCycle copyWith({
    DateTime? startDate,
    DateTime? endDate,
    LensType? lensType,
    int? actualDaysWorn,
    bool? completedManually,
    String? replacementId,
    String? symptomEntryId,
  }) {
    return LensCycle(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      lensType: lensType ?? this.lensType,
      actualDaysWorn: actualDaysWorn ?? this.actualDaysWorn,
      completedManually: completedManually ?? this.completedManually,
      replacementId: replacementId ?? this.replacementId,
      symptomEntryId: symptomEntryId ?? this.symptomEntryId,
    );
  }

  // в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
  // РЎР•Р РРђР›РР—РђР¦РРЇ
  // в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ

  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'lensType': lensType.name,
      'actualDaysWorn': actualDaysWorn,
      'completedManually': completedManually,
      'replacementId': replacementId,
      'symptomEntryId': symptomEntryId,
    };
  }

  factory LensCycle.fromJson(Map<String, dynamic> json) {
    try {
      return LensCycle(
        startDate: DateTime.parse(json['startDate'] as String),
        endDate: json['endDate'] != null
            ? DateTime.parse(json['endDate'] as String)
            : null,
        lensType: LensType.values.firstWhere(
          (e) => e.name == json['lensType'],
          orElse: () => LensType.monthly,
        ),
        actualDaysWorn: json['actualDaysWorn'] as int?,
        completedManually: json['completedManually'] as bool? ?? false,
        replacementId: json['replacementId'] as String?,
        symptomEntryId: json['symptomEntryId'] as String?,
      );
    } catch (e) {
      debugPrint('LensCycle parse error: $e');
      // [file:15] EDGE-006: Р’РѕР·РІСЂР°С‰Р°РµРј РІРёСЂС‚СѓР°Р»СЊРЅС‹Р№ С†РёРєР»
      return LensCycle(
        startDate: DateTime.now(),
        lensType: LensType.monthly,
        completedManually: false,
      );
    }
  }

  // в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
  // Р’РЎРџРћРњРћР“РђРўР•Р›Р¬РќР«Р• Р¤РЈРќРљР¦РР
  // в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ

  /// РЎРєР»РѕРЅРµРЅРёРµ СЃР»РѕРІР° "РґРµРЅСЊ"
  static String _getDayWord(int days) {
    return days == 1 ? 'day' : 'days';
  }
}

// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
// рџџў 1.9. TimelineEvent вЂ” РЎРѕР±С‹С‚РёРµ РІСЂРµРјРµРЅРЅРѕР№ С€РєР°Р»С‹ [file:15]
// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ

/// рџџў РЎРѕР±С‹С‚РёСЏ РІСЂРµРјРµРЅРЅРѕР№ С€РєР°Р»С‹ [file:15] 1.9
/// 
/// РўРёРї            | РСЃС‚РѕС‡РЅРёРєРё РґР°РЅРЅС‹С…
/// ---------------|------------------------------------------
/// replacement    | LensReplacement + Р·Р°РІРµСЂС€С‘РЅРЅС‹Рµ LensCycle
/// symptoms       | SymptomEntry
/// stock          | StockUpdate
/// vision         | VisionCheck
enum TimelineEventType {
  replacement,
  symptoms,
  stock,
  vision,
}

/// РЎРѕР±С‹С‚РёРµ РІСЂРµРјРµРЅРЅРѕР№ С€РєР°Р»С‹
class TimelineEvent {
  final TimelineEventType type;
  final DateTime date;
  final String title;
  final String description;
  final dynamic data; // РҐСЂР°РЅРёС‚ РёСЃС…РѕРґРЅС‹Р№ РѕР±СЉРµРєС‚ (LensReplacement, SymptomEntry, Рё С‚.Рґ.)

  TimelineEvent({
    required this.type,
    required this.date,
    required this.title,
    required this.description,
    this.data,
  });

  /// РРєРѕРЅРєР° СЃРѕР±С‹С‚РёСЏ
  IconData get iconData {
    switch (type) {
      case TimelineEventType.replacement:
        return Icons.autorenew;
      case TimelineEventType.symptoms:
        return Icons.medical_services_outlined;
      case TimelineEventType.stock:
        return Icons.inventory_2_outlined;
      case TimelineEventType.vision:
        return Icons.visibility_outlined;
    }
  }

  /// Р¦РІРµС‚ СЃРѕР±С‹С‚РёСЏ
  Color get color {
    switch (type) {
      case TimelineEventType.replacement:
        return AppColors.primary;
      case TimelineEventType.symptoms:
        return AppColors.tertiary;
      case TimelineEventType.stock:
        return AppColors.tertiaryContainer;
      case TimelineEventType.vision:
        return AppColors.primary;
    }
  }
}

// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
// Р”РћРџРћР›РќРРўР•Р›Р¬РќР«Р• РЈРўРР›РРўР«
// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ

/// РЎРєР»РѕРЅРµРЅРёРµ СЃР»РѕРІР° "РїР°СЂР°"
String getPairWord(int count) {
  return count == 1 ? 'pair' : 'pairs';
}

/// РЎРєР»РѕРЅРµРЅРёРµ СЃР»РѕРІР° "РґРµРЅСЊ"
String getDayWord(int days) {
  return days == 1 ? 'day' : 'days';
}

/// РЎРєР»РѕРЅРµРЅРёРµ СЃР»РѕРІР° "С‡Р°СЃ"
String getHourWord(int hours) {
  return hours == 1 ? 'hour' : 'hours';
}

