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
  String get lifeTreeTitle => 'My Life Tree';

  @override
  String get lifeTreeDigital => 'Digital Life Tree';

  @override
  String get lifeTreeAnalog => 'Notes & Drawings';

  @override
  String get lifeTreeStart => 'Start Life Tree (Birth)';

  @override
  String get lifeTreeBirth => 'Birth';

  @override
  String get lifeTreeNodeHint => 'Event...';

  @override
  String get lifeTreeAddChild => '+ Child';

  @override
  String get lifeTreeAddSibling => '+ Sibling';

  @override
  String get lifeTreeEditNote => 'Edit Note';

  @override
  String get lifeTreeShowNotes => 'Show Notes';

  @override
  String get lifeTreeNoteHint => 'Your thoughts...';

  @override
  String get lifeTreeSaveNote => 'Save';

  @override
  String get lifeTreeDeleteNote => 'Close / Delete';

  @override
  String get lifeTreeShareGraph => 'Digital Life Tree (Graph)';

  @override
  String get lifeTreeFullscreen => 'Fullscreen Mode';

  @override
  String get lifeTreeExitFullscreen => 'Exit Fullscreen';

  @override
  String lifeTreeShareEvent(String text) {
    return 'Event: $text';
  }

  @override
  String lifeTreeShareNote(String text) {
    return 'Note: $text';
  }

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

  @override
  String get session1Title => 'Session One: Hello, Good Evening and Welcome';

  @override
  String get session1Desc => 'Welcome and introduction to the DFL weekend.';

  @override
  String get session2Title => 'Session Two: Back to the Future';

  @override
  String get session2Desc => 'Reflection on one\'s own history.';

  @override
  String get session3Title => 'Group Work – Drawing the Life Tree + Evaluation';

  @override
  String get session3Desc =>
      'Creating your personal life tree in a group setting.';

  @override
  String get session4Title => 'Session Three: The Here and Now';

  @override
  String get session4Desc => 'Present and Identity.';

  @override
  String get session5Title => 'Spiritual Gifts (Evaluation, Exchange)';

  @override
  String get session5Desc => 'Discovery and classification of spiritual gifts.';

  @override
  String get session6Title => 'Values (Complete all workbook tasks + Exchange)';

  @override
  String get session6Desc => 'Connections to spiritual gifts + life tree.';

  @override
  String get session7Title =>
      'Session Four: Pray, Dream, Listen! (Listening Prayer)';

  @override
  String get session7Desc =>
      'Practical introduction and time for listening prayer.';

  @override
  String get session8Title => 'Developing a Vision for the Future';

  @override
  String get session8Desc =>
      'The Big Picture I (Collage) from life tree, gifts, values, and listening prayer.';

  @override
  String get session9Title => 'Session Five: Do you know the way to San Jose';

  @override
  String get session9Desc => 'Outlook and next steps.';

  @override
  String get session10Title => 'Setting 3 Goals';

  @override
  String get session10Desc => 'Personal goal setting in individual sessions.';

  @override
  String get session11Title => 'Group Photo';

  @override
  String get session12Title => 'Feedback Form';

  @override
  String get valueGenauigkeit => 'Accuracy';

  @override
  String get valueFamilie => 'Family';

  @override
  String get valuePersEntwicklung => 'Personal Development';

  @override
  String get valueAusfuehrung => 'Execution';

  @override
  String get valueFinanzielleSicherheit => 'Financial Security';

  @override
  String get valueBeitragMitarbeit => 'Contribution';

  @override
  String get valueAufstieg => 'Advancement';

  @override
  String get valueFlexibilitaet => 'Flexibility';

  @override
  String get valueLeistungEnergie => 'Achievement (Energy)';

  @override
  String get valueAbenteuer => 'Adventure';

  @override
  String get valueFreundschaft => 'Friendship';

  @override
  String get valuePrestige => 'Prestige';

  @override
  String get valueAesthetik => 'Aesthetics';

  @override
  String get valueGrosszuegigkeit => 'Generosity';

  @override
  String get valueAnerkennung => 'Recognition';

  @override
  String get valueKuenstlerischerAusdruck => 'Artistic Expression';

  @override
  String get valueGlueck => 'Happiness';

  @override
  String get valuePersGlaube => 'Personal Faith';

  @override
  String get valueEchtheit => 'Authenticity';

  @override
  String get valueHumor => 'Humor';

  @override
  String get valueVerantwortung => 'Responsibility';

  @override
  String get valueGleichgewicht => 'Balance';

  @override
  String get valueUnabhaengigkeit => 'Independence';

  @override
  String get valueSicherheit => 'Security';

  @override
  String get valueHerausforderung => 'Challenge';

  @override
  String get valueIntegritaet => 'Integrity';

  @override
  String get valueSelbstachtung => 'Self-respect';

  @override
  String get valueBefaehigung => 'Empowerment';

  @override
  String get valueLernen => 'Learning';

  @override
  String get valueDienst => 'Service';

  @override
  String get valueWettbewerb => 'Competition';

  @override
  String get valueFreizeit => 'Leisure';

  @override
  String get valueBestaendigkeit => 'Consistency';

  @override
  String get valueAnpassung => 'Adaptation';

  @override
  String get valueWohnort => 'Residence';

  @override
  String get valueToleranz => 'Tolerance';

  @override
  String get valueKoerperlicheFitnessGesundheit => 'Physical Fitness & Health';

  @override
  String get valueLiebe => 'Love';

  @override
  String get valueTradition => 'Tradition';

  @override
  String get valueKontrolle => 'Control';

  @override
  String get valueAusdauerBeharrlichkeit => 'Endurance - Perseverance';

  @override
  String get valueVielfaeltigkeit => 'Diversity';

  @override
  String get valueKooperation => 'Cooperation';

  @override
  String get valueNatur => 'Nature';

  @override
  String get valueEinfluss => 'Influence';

  @override
  String get valueKreativitaet => 'Creativity';

  @override
  String get valueOrganisation => 'Organization';

  @override
  String get valueEffektivitaet => 'Effectiveness';

  @override
  String get valueFriede => 'Peace';

  @override
  String get valueFairness => 'Fairness';

  @override
  String get valueLoyalitaet => 'Loyalty';
}
