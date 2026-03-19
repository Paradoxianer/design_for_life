import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/spiritual_gift.dart';

class GiftsRepository {
  List<SpiritualGift>? _cachedGifts;

  Future<List<SpiritualGift>> loadGifts(String locale) async {
    if (_cachedGifts != null) return _cachedGifts!;

    try {
      String response;
      try {
        response = await rootBundle.loadString('assets/data/gifts_$locale.json');
      } catch (e) {
        // Fallback to German if locale is not found
        response = await rootBundle.loadString('assets/data/gifts_de.json');
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
