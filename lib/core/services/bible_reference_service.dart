import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';

/// Öffnet Bibelstellen-Angaben (z.B. "1. Kor 12,8" / "1 Cor 12:8") direkt in
/// einer passenden externen Bibel-App/-Website statt nichts zu tun (#64).
/// Deutsch geht nach bibleserver.com (dort ist die Luther-Übersetzung mit
/// deutschen Buchnamen verlinkbar), Englisch nach bible.com/YouVersion
/// (universeller USFM-Buchcode). Zentral hier statt pro Modul, damit z.B.
/// auch andere Module (Predigt-Notizen, Andachten) dieselbe Logik nutzen
/// können.
class BibleReferenceService {
  const BibleReferenceService._();

  static Future<void> open(BuildContext context, String reference) async {
    final uri = buildUriForTest(reference, Localizations.localeOf(context).languageCode);
    final l10n = AppLocalizations.of(context);
    if (uri == null || !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.bibleReferenceOpenFailed(reference))),
        );
      }
    }
  }

  @visibleForTesting
  static Uri? buildUriForTest(String reference, String languageCode) {
    final match = RegExp(r'^((?:[123]\.?\s*)?[A-Za-zÀ-ÿ]+)\s+(\d+)(?:[,:–-]\s*(\d+))?')
        .firstMatch(reference.trim());
    if (match == null) return null;

    final bookKey = match.group(1)!.replaceAll('.', '').replaceAll(' ', '').toUpperCase();
    final chapter = match.group(2)!;
    final verse = match.group(3);

    if (languageCode == 'de') {
      final slug = _bibleserverBooks[bookKey];
      if (slug == null) return null;
      final path = verse != null ? '$slug$chapter,$verse' : '$slug$chapter';
      return Uri.https('www.bibleserver.com', '/LUT/$path');
    }

    final usfm = _bibleComBooks[bookKey];
    if (usfm == null) return null;
    final path = verse != null ? '/bible/111/$usfm.$chapter.$verse.NIV' : '/bible/111/$usfm.$chapter.NIV';
    return Uri.https('www.bible.com', path);
  }

  // Deutsch: Buch-Abkürzung (wie in den Gaben-Datensätzen verwendet) ->
  // bibleserver.com-Buchname. Nur die Bücher, die aktuell in den
  // .arb/Datenquellen tatsächlich vorkommen; bei Bedarf einfach ergänzen.
  static const Map<String, String> _bibleserverBooks = {
    '1KOR': '1.Korinther',
    '2KOR': '2.Korinther',
    'JAK': 'Jakobus',
    '1KÖN': '1.Könige',
    'EX': '2.Mose',
    'SPR': 'Sprüche',
    'MT': 'Matthäus',
    'HEBR': 'Hebräer',
    'APG': 'Apostelgeschichte',
    'MK': 'Markus',
    'RÖM': 'Römer',
    '1THESS': '1.Thessalonicher',
    '1JOH': '1.Johannes',
    '1PETR': '1.Petrus',
    'EPH': 'Epheser',
    '1TIM': '1.Timotheus',
    '2TIM': '2.Timotheus',
    'GAL': 'Galater',
    'JOH': 'Johannes',
  };

  // Englisch: Buch-Abkürzung -> universeller 3-Buchstaben-USFM-Code
  // (bible.com/YouVersion-URLs basieren darauf, unabhängig von der Übersetzung).
  static const Map<String, String> _bibleComBooks = {
    '1COR': '1CO',
    '2COR': '2CO',
    'JAS': 'JAS',
    '1KGS': '1KI',
    'EX': 'EXO',
    'PROV': 'PRO',
    'MATT': 'MAT',
    'HEB': 'HEB',
    'ACTS': 'ACT',
    'MARK': 'MRK',
    'ROM': 'ROM',
    '1THESS': '1TH',
    '1JOHN': '1JN',
    '1PET': '1PE',
    'EPH': 'EPH',
    '1TIM': '1TI',
    '2TIM': '2TI',
    'GAL': 'GAL',
    'JOHN': 'JHN',
  };
}
