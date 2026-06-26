import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/spiritual_gift.dart';

class GiftsRepository {
  List<SpiritualGift>? _cachedGifts;
  String? _cachedLocale;

  String? get cachedLocale => _cachedLocale;

  Future<List<SpiritualGift>> loadGifts(String locale) async {
    if (_cachedGifts != null && _cachedLocale == locale) return _cachedGifts!;

    try {
      String response;
      final assetPath = 'assets/data/gifts_$locale.json';
      try {
        response = await rootBundle.loadString(assetPath);
        _cachedLocale = locale;
      } catch (e) {
        // Fallback to German if locale is not found
        response = await rootBundle.loadString('assets/data/gifts_de.json');
        _cachedLocale = 'de';
      }
      
      final List<dynamic> data = json.decode(response);
      _cachedGifts = data.map((json) => SpiritualGift.fromJson(json as Map<String, dynamic>)).toList();
      return _cachedGifts!;
    } catch (e) {
      return [];
    }
  }

  void clearCache() {
    _cachedGifts = null;
  }
}
