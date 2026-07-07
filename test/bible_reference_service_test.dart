import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:design_for_life/core/services/bible_reference_service.dart';

void main() {
  List<String> referencesFrom(String path) {
    final data = jsonDecode(File(path).readAsStringSync()) as List;
    return data
        .expand((gift) => (gift['bibleReferences'] as List).cast<String>())
        .toSet()
        .toList();
  }

  test('every DE gift bible reference resolves to a bibleserver.com URI', () {
    for (final ref in referencesFrom('assets/data/gifts_de.json')) {
      final uri = BibleReferenceService.buildUriForTest(ref, 'de');
      expect(uri, isNotNull, reason: 'Could not parse/map reference "$ref"');
      expect(uri!.host, 'www.bibleserver.com');
    }
  });

  test('every EN gift bible reference resolves to a bible.com URI', () {
    for (final ref in referencesFrom('assets/data/gifts_en.json')) {
      final uri = BibleReferenceService.buildUriForTest(ref, 'en');
      expect(uri, isNotNull, reason: 'Could not parse/map reference "$ref"');
      expect(uri!.host, 'www.bible.com');
    }
  });

  test('builds a verse-specific link when a verse is present', () {
    final uri = BibleReferenceService.buildUriForTest('1. Kor 12,8', 'de');
    expect(uri.toString(), 'https://www.bibleserver.com/LUT/1.Korinther12,8');
  });

  test('falls back to the whole chapter when no verse is given', () {
    final uri = BibleReferenceService.buildUriForTest('Hebr 11', 'de');
    expect(uri.toString(), 'https://www.bibleserver.com/LUT/Hebr%C3%A4er11');
  });

  test('unknown book returns null instead of a broken link', () {
    final uri = BibleReferenceService.buildUriForTest('Nichtsburg 3,1', 'de');
    expect(uri, isNull);
  });
}
