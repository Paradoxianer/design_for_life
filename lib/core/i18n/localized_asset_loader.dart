import 'package:flutter/services.dart';

/// Ergebnis von [LocalizedAssetLoader.load]: der Dateiinhalt und die Sprache,
/// aus der er tatsächlich stammt (kann wegen des Fallbacks von der
/// gewünschten abweichen).
class LocalizedAsset {
  final String content;
  final String locale;
  const LocalizedAsset(this.content, this.locale);
}

/// Lädt sprachabhängige Inhalts-Dateien `assets/data/<name>_<sprache>.json`
/// (Gaben, Fragebögen, Leiter-Texte ...).
///
/// Eine neue Sprache besteht damit nur aus zusätzlichen Dateien nach diesem
/// Namensschema - am Code ändert sich nichts. Fehlt eine einzelne Datei
/// (z. B. sind die Leiter-Texte noch nicht übersetzt), wird pro Datei auf die
/// nächste Sprache der [fallbackChain] ausgewichen: gewünschte Sprache ->
/// Englisch -> Deutsch.
class LocalizedAssetLoader {
  const LocalizedAssetLoader._();

  static const List<String> fallbackChain = ['en', 'de'];

  static List<String> candidates(String locale) => [
    locale,
    ...fallbackChain.where((l) => l != locale),
  ];

  static Future<LocalizedAsset> load(
    String baseName,
    String locale, {
    AssetBundle? bundle,
  }) async {
    final assets = bundle ?? rootBundle;
    Object? lastError;
    for (final candidate in candidates(locale)) {
      try {
        final content = await assets.loadString(
          'assets/data/${baseName}_$candidate.json',
        );
        return LocalizedAsset(content, candidate);
      } catch (e) {
        lastError = e;
      }
    }
    throw lastError ?? StateError('No asset found for $baseName');
  }
}
