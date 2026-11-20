import 'dart:convert';
import '../../../core/i18n/localized_asset_loader.dart';
import '../models/spiritual_gift.dart';

class GiftsRepository {
  List<SpiritualGift>? _cachedGifts;
  String? _cachedLocale;
  String? _requestedLocale;

  String? get cachedLocale => _cachedLocale;

  Future<List<SpiritualGift>> loadGifts(String locale, {bool forceReload = false}) async {
    if (!forceReload && _cachedGifts != null && _requestedLocale == locale) return _cachedGifts!;

    try {
      final asset = await LocalizedAssetLoader.load('gifts', locale);
      _cachedLocale = asset.locale;
      _requestedLocale = locale;

      final List<dynamic> data = json.decode(asset.content);
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
