import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/spiritual_gift.dart';

class GiftsRepository {
  List<SpiritualGift>? _cachedGifts;

  Future<List<SpiritualGift>> loadGifts(String locale) async {
    if (_cachedGifts != null) return _cachedGifts!;

    try {
      final String response = await rootBundle.loadString('assets/data/gifts_$locale.json');
      final List<dynamic> data = json.decode(response);
      _cachedGifts = data.map((json) => SpiritualGift.fromJson(json)).toList();
      return _cachedGifts!;
    } catch (e) {
      // Fallback oder Error Handling
      return [];
    }
  }

  void clearCache() {
    _cachedGifts = null;
  }
}
