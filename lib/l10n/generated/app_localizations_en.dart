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

  @override
  String get valuesTitle => 'Discover Values';

  @override
  String get valuesPhase1Title => 'Rating';

  @override
  String get valuesPhase1Guidance =>
      'Go through the list and rate each value:\n1 = Very important to me\n2 = Important to me\n3 = Less important to me\n\nGoal: Select exactly 8 values with the rating \'1\'.';

  @override
  String valuesSelectionStatus(int count) {
    return 'Select exactly 8 values with \"1\". Current: $count / 8';
  }

  @override
  String get valuesPhase2Title => 'Personal Definition';

  @override
  String get valuesPhase2Guidance =>
      'Sort your top-8 values via drag & drop according to their priority for you. Then briefly define what each value means to you personally. The first 3 slots are your absolute key takeaways.';

  @override
  String get valuesDefinitionLabel => 'My Definition';

  @override
  String get valuesDefinitionHint => 'What does this value mean to me?';

  @override
  String get valuesPhase3Title => 'Reflection & Future';

  @override
  String get valuesPhase3Guidance =>
      'Take responsibility for your values and look ahead.';

  @override
  String get valuesReflectionLabel =>
      'What do you think about your selection? Any surprises?';

  @override
  String get valuesReflectionHint => 'Your thoughts here...';

  @override
  String get valuesNextPhaseLabel =>
      'Describe your next life stage (e.g., new job, retirement):';

  @override
  String get valuesNextPhaseHint => 'Future phase...';

  @override
  String get valuesNextPhaseValuesGuidance =>
      'Select up to 8 values from the list that will be especially important for this new stage (click in the desired order):';

  @override
  String get valuesResultTitle => 'My Top 8 Values';

  @override
  String get finish => 'Finish';

  @override
  String get next => 'Next';

  @override
  String get previous => 'Previous';

  @override
  String get share => 'Share';

  @override
  String get shareTitle => 'What do you want to share?';

  @override
  String get selectAll => 'Select All';

  @override
  String get deselectAll => 'Deselect All';

  @override
  String get cancel => 'Cancel';

  @override
  String get shareSubject => 'My results from DFL Weekend';

  @override
  String get shareFooter => 'Created during the DFL Weekend';

  @override
  String get shareIntro => 'Check out my results:';

  @override
  String get feedbackTitle => 'Feedback Form';

  @override
  String get feedbackGuidance =>
      'Please give us your feedback on the seminar so that we can make it even better next time.';

  @override
  String get feedbackRating1 => 'Excellent';

  @override
  String get feedbackRating2 => 'Good';

  @override
  String get feedbackRating3 => 'Satisfactory';

  @override
  String get feedbackRating4 => 'Sufficient';

  @override
  String get feedbackRating5 => 'Poor';

  @override
  String get feedbackRating6 => 'Very Poor';

  @override
  String get feedbackSectionContent => 'Seminar Content';

  @override
  String get feedbackContentExpectations => 'The content met my expectations';

  @override
  String get feedbackContentPracticalUtility =>
      'I gained useful suggestions for my daily practice';

  @override
  String get feedbackContentStructure =>
      'Structure & clarity of the topic complex';

  @override
  String get feedbackSectionSpeaker => 'Speaker & Execution';

  @override
  String get feedbackSpeakerGodWorking =>
      'I had the impression that God could work';

  @override
  String get feedbackSpeakerFaithProgress =>
      'The seminar helped me progress in my faith life';

  @override
  String get feedbackSpeakerDidactics => 'Didactic skills';

  @override
  String get feedbackSpeakerMethods => 'The methods used were effective';

  @override
  String get feedbackSpeakerInvolvement =>
      'The speaker actively involved the participants';

  @override
  String get feedbackSpeakerRespect => 'The speaker was polite and respectful';

  @override
  String get feedbackAtmosphere =>
      'General course atmosphere and group climate';

  @override
  String get feedbackSectionDocs => 'Seminar Documents';

  @override
  String get feedbackDocsStructure => 'Structure and clarity';

  @override
  String get feedbackDocsUnderstandability => 'Understandability';

  @override
  String get feedbackDocsDifficulty => 'Level of difficulty';

  @override
  String get feedbackSectionOrg => 'Organization & Infrastructure';

  @override
  String get feedbackRoomsAppropriateness => 'Appropriateness of the rooms';

  @override
  String get feedbackPrepQuality =>
      'Preparation of the seminar by the organizer';

  @override
  String get feedbackDuration => 'Duration of the event';

  @override
  String get feedbackTempo => 'Pace of the event';

  @override
  String get feedbackCatering => 'Catering';

  @override
  String get feedbackSectionComments => 'Comments';

  @override
  String get feedbackCommentsMissing => 'What was missing?';

  @override
  String get feedbackRecommendation => 'Would you recommend this seminar?';

  @override
  String get feedbackGeneralNotes => 'Additional notes';

  @override
  String feedbackLabel(int rating) {
    return 'Rating: $rating';
  }
}
