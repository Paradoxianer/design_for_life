// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'DFL Wochenende';

  @override
  String get notes => 'Notizen';

  @override
  String get notesGuidance =>
      'Schreibe auf, was dir in dieser Einheit wichtig geworden ist.';

  @override
  String get photosAndSlides => 'Fotos & Slides';

  @override
  String get notesHint => 'Deine Gedanken hier...';

  @override
  String get editMode => 'Bearbeiten';

  @override
  String get resultMode => 'Ergebnis';

  @override
  String get keyTakeaways => 'Wichtigste Erkenntnisse';

  @override
  String get takeawayHint => 'Gib hier deine Erkenntnis ein...';

  @override
  String get listeningPrayer => 'Hörendes Gebet';

  @override
  String get listeningPrayerGuidance =>
      'Halte deine Eindrücke während des hörenden Gebets fest. Neue Felder erscheinen automatisch beim Schreiben.';

  @override
  String get impressionHint => 'Schreibe deinen Eindruck hier...';

  @override
  String get assignedTo => 'Für:';

  @override
  String get receivedImpressions => 'Empfangene Eindrücke';

  @override
  String get ownImpressions => 'Eigene Eindrücke';

  @override
  String get threeHighlights => '3 Highlights aus dem hörenden Gebet';

  @override
  String get goalsTitle => 'SMART Ziele';

  @override
  String get goalsGuidance =>
      'Definiere genau 3 Ziele für deinen Weg. Nutze den SMART-Check, um sicherzustellen, dass sie umsetzbar sind.';

  @override
  String goalNumber(int number) {
    return 'Ziel $number';
  }

  @override
  String get goalHint => 'Was möchtest du erreichen?';

  @override
  String get smartCheck => 'Überprüfe, ob dein Ziel \"SMART\" ist:';

  @override
  String get smartSpecific => 'Spezifisch';

  @override
  String get smartSpecificDesc =>
      'Ist das Ziel präzise und eindeutig formuliert?';

  @override
  String get smartMeasurable => 'Messbar';

  @override
  String get smartMeasurableDesc =>
      'Gibt es klare Kriterien oder Zahlen, um den Erfolg zu prüfen?';

  @override
  String get smartAchievable => 'Attraktiv';

  @override
  String get smartAchievableDesc =>
      'Ist das Ziel für dich attraktiv und realistisch umsetzbar?';

  @override
  String get smartRelevant => 'Relevant';

  @override
  String get smartRelevantDesc =>
      'Bringt dich dieses Ziel auf deinem Weg wirklich weiter?';

  @override
  String get smartTimeBound => 'Terminiert';

  @override
  String get smartTimeBoundDesc =>
      'Gibt es einen klaren Termin oder Zeitrahmen?';
}
