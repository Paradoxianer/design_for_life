import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/feedback_question.dart';

class FeedbackQuestionsRepository {
  FeedbackQuestionnaire? _cached;
  String? _cachedLocale;

  Future<FeedbackQuestionnaire> loadQuestionnaire(String locale, {bool forceReload = false}) async {
    if (!forceReload && _cached != null && _cachedLocale == locale) return _cached!;

    try {
      String response;
      final assetPath = 'assets/data/feedback_questions_$locale.json';
      try {
        response = await rootBundle.loadString(assetPath);
        _cachedLocale = locale;
      } catch (e) {
        // Fallback to German if locale is not found
        response = await rootBundle.loadString('assets/data/feedback_questions_de.json');
        _cachedLocale = 'de';
      }

      _cached = FeedbackQuestionnaire.fromJson(json.decode(response) as Map<String, dynamic>);
      return _cached!;
    } catch (e) {
      return FeedbackQuestionnaire.empty;
    }
  }

  void clearCache() {
    _cached = null;
  }
}
