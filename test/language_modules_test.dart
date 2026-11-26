import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:design_for_life/core/i18n/language_registry.dart';
import 'package:design_for_life/core/i18n/localized_asset_loader.dart';
import 'package:design_for_life/core/services/deep_link_service.dart';

class _FakeBundle extends CachingAssetBundle {
  final Map<String, String> files;
  _FakeBundle(this.files);

  @override
  Future<ByteData> load(String key) async {
    final content = files[key];
    if (content == null) throw FlutterError('missing $key');
    return ByteData.sublistView(Uint8List.fromList(content.codeUnits));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocalizedAssetLoader', () {
    test('uses the requested language when the file exists', () async {
      final bundle = _FakeBundle({
        'assets/data/gifts_pl.json': 'pl',
        'assets/data/gifts_en.json': 'en',
        'assets/data/gifts_de.json': 'de',
      });
      final asset = await LocalizedAssetLoader.load(
        'gifts',
        'pl',
        bundle: bundle,
      );
      expect(asset.locale, 'pl');
      expect(asset.content, 'pl');
    });

    test('falls back per file: language -> en -> de', () async {
      final bundle = _FakeBundle({
        'assets/data/gifts_en.json': 'en',
        'assets/data/gifts_de.json': 'de',
        'assets/data/leader_notes_de.json': 'de-only',
      });
      final gifts = await LocalizedAssetLoader.load('gifts', 'pl', bundle: bundle);
      expect(gifts.locale, 'en');
      final notes = await LocalizedAssetLoader.load(
        'leader_notes',
        'pl',
        bundle: bundle,
      );
      expect(notes.locale, 'de');
    });

    test('throws if no language has the file', () {
      expect(
        LocalizedAssetLoader.load('nope', 'pl', bundle: _FakeBundle({})),
        throwsA(anything),
      );
    });
  });

  group('LanguageRegistry', () {
    test('the bundled registry lists German and English', () async {
      final languages = await LanguageRegistry.load();
      final codes = languages.map((l) => l.code).toSet();
      expect(codes, containsAll(['de', 'en']));
    });

    test('parses status', () {
      final languages = LanguageRegistry.parse(
        '{"languages":[{"code":"pl","name":"Polski","status":"draft"}]}',
      );
      expect(languages.single.status, LanguageStatus.draft);
    });
  });

  group('lang deep link parameter', () {
    test('reads a valid code, independent of other parameters', () {
      expect(
        DeepLinkService.parseLanguage(
          Uri.parse('https://x.de/?modules=session_1&lang=PL'),
        ),
        'pl',
      );
    });

    test('ignores invalid values', () {
      expect(DeepLinkService.parseLanguage(Uri.parse('https://x.de/?lang=')), isNull);
      expect(DeepLinkService.parseLanguage(Uri.parse('https://x.de/?lang=../x')), isNull);
      expect(DeepLinkService.parseLanguage(Uri.parse('https://x.de/')), isNull);
    });
  });
}
