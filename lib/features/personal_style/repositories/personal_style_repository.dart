import 'dart:convert';
import '../../../core/i18n/localized_asset_loader.dart';
import '../models/personal_style_question.dart';

class PersonalStyleRepository {
  PersonalStyleQuestionnaire? _cached;
  String? _cachedLocale;
  String? _requestedLocale;

  Future<PersonalStyleQuestionnaire> loadQuestionnaire(String locale, {bool forceReload = false}) async {
    if (!forceReload && _cached != null && _requestedLocale == locale) return _cached!;

    try {
      final asset = await LocalizedAssetLoader.load('personal_style_questions', locale);
      _cachedLocale = asset.locale;
      _requestedLocale = locale;

      _cached = PersonalStyleQuestionnaire.fromJson(json.decode(asset.content) as Map<String, dynamic>);
      return _cached!;
    } catch (e) {
      return PersonalStyleQuestionnaire.empty;
    }
  }

  void clearCache() {
    _cached = null;
  }
}
