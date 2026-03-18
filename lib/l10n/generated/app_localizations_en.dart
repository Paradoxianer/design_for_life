// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'DFL Weekend';

  @override
  String get notes => 'Notes';

  @override
  String get notesGuidance =>
      'Write down what stands out to you from this session.';

  @override
  String get photosAndSlides => 'Photos & Slides';

  @override
  String get notesHint => 'Type your thoughts here...';

  @override
  String get editMode => 'Edit';

  @override
  String get resultMode => 'Result';

  @override
  String get keyTakeaways => 'Key Takeaways';

  @override
  String get takeawayHint => 'Enter your key takeaway here...';

  @override
  String get listeningPrayer => 'Listening Prayer';

  @override
  String get listeningPrayerGuidance =>
      'Record your impressions during the listening prayer. New fields appear as you write.';

  @override
  String get impressionHint => 'Write your impression here...';

  @override
  String get assignedTo => 'For:';

  @override
  String get receivedImpressions => 'Received Impressions';

  @override
  String get ownImpressions => 'Your Impressions';

  @override
  String get threeHighlights => '3 highlights from listening prayer';

  @override
  String get goalsTitle => 'SMART Goals';

  @override
  String get goalsGuidance =>
      'Define exactly 3 goals for your journey. Use the SMART check to ensure they are actionable.';

  @override
  String goalNumber(int number) {
    return 'Goal $number';
  }

  @override
  String get goalHint => 'What do you want to achieve?';

  @override
  String get smartCheck => 'Check if your goal is SMART:';

  @override
  String get smartSpecific => 'Specific';

  @override
  String get smartSpecificDesc => 'Is the goal precise and clearly defined?';

  @override
  String get smartMeasurable => 'Measurable';

  @override
  String get smartMeasurableDesc =>
      'Are there concrete numbers or criteria to measure success?';

  @override
  String get smartAchievable => 'Achievable';

  @override
  String get smartAchievableDesc =>
      'Is the goal attractive and realistically attainable for you?';

  @override
  String get smartRelevant => 'Relevant';

  @override
  String get smartRelevantDesc =>
      'Does this goal truly matter for your overall journey?';

  @override
  String get smartTimeBound => 'Time-bound';

  @override
  String get smartTimeBoundDesc => 'Is there a specific deadline or timeframe?';
}
