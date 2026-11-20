import 'dart:convert';
import '../../../core/i18n/localized_asset_loader.dart';
import '../models/feedback_question.dart';

class FeedbackQuestionsRepository {
  FeedbackQuestionnaire? _cached;
  String? _cachedLocale;
  String? _requestedLocale;

  Future<FeedbackQuestionnaire> loadQuestionnaire(String locale, {bool forceReload = false}) async {
    if (!forceReload && _cached != null && _requestedLocale == locale) return _cached!;

    try {
      final asset = await LocalizedAssetLoader.load('feedback_questions', locale);
      _cachedLocale = asset.locale;
      _requestedLocale = locale;

      _cached = FeedbackQuestionnaire.fromJson(json.decode(asset.content) as Map<String, dynamic>);
      return _cached!;
    } catch (e) {
      return FeedbackQuestionnaire.empty;
    }
  }

  void clearCache() {
    _cached = null;
  }
}
