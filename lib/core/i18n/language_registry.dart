import 'dart:convert';
import 'package:flutter/services.dart';

enum LanguageStatus { complete, draft }

class LanguageInfo {
  final String code;
  final String name;
  final LanguageStatus status;

  const LanguageInfo({
    required this.code,
    required this.name,
    this.status = LanguageStatus.complete,
  });

  factory LanguageInfo.fromJson(Map<String, dynamic> json) => LanguageInfo(
    code: json['code'] as String,
    name: json['name'] as String,
    status: json['status'] == 'draft'
        ? LanguageStatus.draft
        : LanguageStatus.complete,
  );
}

/// Liste der Sprachen für die Sprachauswahl, gepflegt in
/// `assets/config/languages.json` - eine neue Sprache braucht dort nur einen
/// Eintrag (plus die .arb-Datei und die Inhaltsdateien).
class LanguageRegistry {
  const LanguageRegistry._();

  static List<LanguageInfo> parse(String source) {
    final data = json.decode(source) as Map<String, dynamic>;
    return (data['languages'] as List)
        .map((e) => LanguageInfo.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<List<LanguageInfo>> load({AssetBundle? bundle}) async {
    try {
      return parse(
        await (bundle ?? rootBundle).loadString('assets/config/languages.json'),
      );
    } catch (_) {
      return const [
        LanguageInfo(code: 'de', name: 'Deutsch'),
        LanguageInfo(code: 'en', name: 'English'),
      ];
    }
  }
}
