import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'DFL Weekend'**
  String get appTitle;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @notesGuidance.
  ///
  /// In en, this message translates to:
  /// **'Write down what stands out to you from this session.'**
  String get notesGuidance;

  /// No description provided for @photosAndSlides.
  ///
  /// In en, this message translates to:
  /// **'Photos & Slides'**
  String get photosAndSlides;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'Type your thoughts here...'**
  String get notesHint;

  /// No description provided for @editMode.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editMode;

  /// No description provided for @resultMode.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get resultMode;

  /// No description provided for @keyTakeaways.
  ///
  /// In en, this message translates to:
  /// **'Key Takeaways'**
  String get keyTakeaways;

  /// No description provided for @takeawayHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your key takeaway here...'**
  String get takeawayHint;

  /// No description provided for @listeningPrayer.
  ///
  /// In en, this message translates to:
  /// **'Listening Prayer'**
  String get listeningPrayer;

  /// No description provided for @listeningPrayerGuidance.
  ///
  /// In en, this message translates to:
  /// **'Record your impressions during the listening prayer. New fields appear as you write.'**
  String get listeningPrayerGuidance;

  /// No description provided for @impressionHint.
  ///
  /// In en, this message translates to:
  /// **'Write your impression here...'**
  String get impressionHint;

  /// No description provided for @assignedTo.
  ///
  /// In en, this message translates to:
  /// **'For:'**
  String get assignedTo;

  /// No description provided for @receivedImpressions.
  ///
  /// In en, this message translates to:
  /// **'Received Impressions'**
  String get receivedImpressions;

  /// No description provided for @ownImpressions.
  ///
  /// In en, this message translates to:
  /// **'Your Impressions'**
  String get ownImpressions;

  /// No description provided for @threeHighlights.
  ///
  /// In en, this message translates to:
  /// **'3 highlights from listening prayer'**
  String get threeHighlights;

  /// No description provided for @goalsTitle.
  ///
  /// In en, this message translates to:
  /// **'SMART Goals'**
  String get goalsTitle;

  /// No description provided for @goalsGuidance.
  ///
  /// In en, this message translates to:
  /// **'Define exactly 3 goals for your journey. Use the SMART check to ensure they are actionable.'**
  String get goalsGuidance;

  /// No description provided for @goalNumber.
  ///
  /// In en, this message translates to:
  /// **'Goal {number}'**
  String goalNumber(int number);

  /// No description provided for @goalHint.
  ///
  /// In en, this message translates to:
  /// **'What do you want to achieve?'**
  String get goalHint;

  /// No description provided for @smartCheck.
  ///
  /// In en, this message translates to:
  /// **'Check if your goal is SMART:'**
  String get smartCheck;

  /// No description provided for @smartSpecific.
  ///
  /// In en, this message translates to:
  /// **'Specific'**
  String get smartSpecific;

  /// No description provided for @smartSpecificDesc.
  ///
  /// In en, this message translates to:
  /// **'Is the goal precise and clearly defined?'**
  String get smartSpecificDesc;

  /// No description provided for @smartMeasurable.
  ///
  /// In en, this message translates to:
  /// **'Measurable'**
  String get smartMeasurable;

  /// No description provided for @smartMeasurableDesc.
  ///
  /// In en, this message translates to:
  /// **'Are there concrete numbers or criteria to measure success?'**
  String get smartMeasurableDesc;

  /// No description provided for @smartAchievable.
  ///
  /// In en, this message translates to:
  /// **'Achievable'**
  String get smartAchievable;

  /// No description provided for @smartAchievableDesc.
  ///
  /// In en, this message translates to:
  /// **'Is the goal attractive and realistically attainable for you?'**
  String get smartAchievableDesc;

  /// No description provided for @smartRelevant.
  ///
  /// In en, this message translates to:
  /// **'Relevant'**
  String get smartRelevant;

  /// No description provided for @smartRelevantDesc.
  ///
  /// In en, this message translates to:
  /// **'Does this goal truly matter for your overall journey?'**
  String get smartRelevantDesc;

  /// No description provided for @smartTimeBound.
  ///
  /// In en, this message translates to:
  /// **'Time-bound'**
  String get smartTimeBound;

  /// No description provided for @smartTimeBoundDesc.
  ///
  /// In en, this message translates to:
  /// **'Is there a specific deadline or timeframe?'**
  String get smartTimeBoundDesc;

  /// No description provided for @valuesTitle.
  ///
  /// In en, this message translates to:
  /// **'Discover Values'**
  String get valuesTitle;

  /// No description provided for @valuesPhase1Title.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get valuesPhase1Title;

  /// No description provided for @valuesPhase1Guidance.
  ///
  /// In en, this message translates to:
  /// **'Go through the list and rate each value:\n1 = Very important to me\n2 = Important to me\n3 = Less important to me\n\nGoal: Select exactly 8 values with the rating \'1\'.'**
  String get valuesPhase1Guidance;

  /// No description provided for @valuesSelectionStatus.
  ///
  /// In en, this message translates to:
  /// **'Select exactly 8 values with \"1\". Current: {count} / 8'**
  String valuesSelectionStatus(int count);

  /// No description provided for @valuesSelectionMissing.
  ///
  /// In en, this message translates to:
  /// **'You have currently selected {count} out of 8 values. For optimal results, there should be exactly 8. Do you want to continue anyway?'**
  String valuesSelectionMissing(int count);

  /// No description provided for @valuesPhase2Title.
  ///
  /// In en, this message translates to:
  /// **'Personal Definition'**
  String get valuesPhase2Title;

  /// No description provided for @valuesPhase2Guidance.
  ///
  /// In en, this message translates to:
  /// **'Sort your top-8 values via drag & drop according to their priority for you. Then briefly define what each value means to you personally. The first 3 slots are your absolute key takeaways.'**
  String get valuesPhase2Guidance;

  /// No description provided for @valuesDefinitionLabel.
  ///
  /// In en, this message translates to:
  /// **'My Definition'**
  String get valuesDefinitionLabel;

  /// No description provided for @valuesDefinitionHint.
  ///
  /// In en, this message translates to:
  /// **'What does this value mean to me?'**
  String get valuesDefinitionHint;

  /// No description provided for @valuesPhase3Title.
  ///
  /// In en, this message translates to:
  /// **'Reflection & Future'**
  String get valuesPhase3Title;

  /// No description provided for @valuesPhase3Guidance.
  ///
  /// In en, this message translates to:
  /// **'Take responsibility for your values and look ahead.'**
  String get valuesPhase3Guidance;

  /// No description provided for @valuesReflectionLabel.
  ///
  /// In en, this message translates to:
  /// **'What do you think about your selection? Any surprises?'**
  String get valuesReflectionLabel;

  /// No description provided for @valuesReflectionHint.
  ///
  /// In en, this message translates to:
  /// **'Your thoughts here...'**
  String get valuesReflectionHint;

  /// No description provided for @valuesNextPhaseLabel.
  ///
  /// In en, this message translates to:
  /// **'Describe your next life stage (e.g., new job, retirement):'**
  String get valuesNextPhaseLabel;

  /// No description provided for @valuesNextPhaseHint.
  ///
  /// In en, this message translates to:
  /// **'Future phase...'**
  String get valuesNextPhaseHint;

  /// No description provided for @valuesNextPhaseValuesGuidance.
  ///
  /// In en, this message translates to:
  /// **'Select up to 8 values from the list that will be especially important for this new stage (click in the desired order):'**
  String get valuesNextPhaseValuesGuidance;

  /// No description provided for @valuesResultTitle.
  ///
  /// In en, this message translates to:
  /// **'My Top 8 Values'**
  String get valuesResultTitle;

  /// No description provided for @lifeTreeTitle.
  ///
  /// In en, this message translates to:
  /// **'My Life Tree'**
  String get lifeTreeTitle;

  /// No description provided for @lifeTreeDigital.
  ///
  /// In en, this message translates to:
  /// **'Digital Life Tree'**
  String get lifeTreeDigital;

  /// No description provided for @lifeTreeAnalog.
  ///
  /// In en, this message translates to:
  /// **'Notes & Drawings'**
  String get lifeTreeAnalog;

  /// No description provided for @lifeTreeStart.
  ///
  /// In en, this message translates to:
  /// **'Start Life Tree (Birth)'**
  String get lifeTreeStart;

  /// No description provided for @lifeTreeBirth.
  ///
  /// In en, this message translates to:
  /// **'Birth'**
  String get lifeTreeBirth;

  /// No description provided for @lifeTreeNodeHint.
  ///
  /// In en, this message translates to:
  /// **'Event...'**
  String get lifeTreeNodeHint;

  /// No description provided for @lifeTreeAddChild.
  ///
  /// In en, this message translates to:
  /// **'+ Child'**
  String get lifeTreeAddChild;

  /// No description provided for @lifeTreeAddSibling.
  ///
  /// In en, this message translates to:
  /// **'+ Sibling'**
  String get lifeTreeAddSibling;

  /// No description provided for @lifeTreeEditNote.
  ///
  /// In en, this message translates to:
  /// **'Edit Note'**
  String get lifeTreeEditNote;

  /// No description provided for @lifeTreeShowNotes.
  ///
  /// In en, this message translates to:
  /// **'Show Notes'**
  String get lifeTreeShowNotes;

  /// No description provided for @lifeTreeNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Your thoughts...'**
  String get lifeTreeNoteHint;

  /// No description provided for @lifeTreeSaveNote.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get lifeTreeSaveNote;

  /// No description provided for @lifeTreeDeleteNote.
  ///
  /// In en, this message translates to:
  /// **'Close / Delete'**
  String get lifeTreeDeleteNote;

  /// No description provided for @giftsLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading questions...'**
  String get giftsLoading;

  /// No description provided for @giftsQuestionCounter.
  ///
  /// In en, this message translates to:
  /// **'Question {current} of {total}'**
  String giftsQuestionCounter(int current, int total);

  /// No description provided for @giftsRating0.
  ///
  /// In en, this message translates to:
  /// **'Not at all'**
  String get giftsRating0;

  /// No description provided for @giftsRating1.
  ///
  /// In en, this message translates to:
  /// **'Hardly'**
  String get giftsRating1;

  /// No description provided for @giftsRating2.
  ///
  /// In en, this message translates to:
  /// **'Little'**
  String get giftsRating2;

  /// No description provided for @giftsRating3.
  ///
  /// In en, this message translates to:
  /// **'Partially'**
  String get giftsRating3;

  /// No description provided for @giftsRating4.
  ///
  /// In en, this message translates to:
  /// **'Much'**
  String get giftsRating4;

  /// No description provided for @giftsRating5.
  ///
  /// In en, this message translates to:
  /// **'Very strongly'**
  String get giftsRating5;

  /// No description provided for @giftsRankingTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Spiritual Gifts Ranking'**
  String get giftsRankingTitle;

  /// No description provided for @giftsRankingGuidance.
  ///
  /// In en, this message translates to:
  /// **'Tap on a gift to see details and Bible references. Your Top 3 will be automatically included.'**
  String get giftsRankingGuidance;

  /// No description provided for @giftsScorePoints.
  ///
  /// In en, this message translates to:
  /// **'{score} pts.'**
  String giftsScorePoints(int score);

  /// No description provided for @giftsMeaning.
  ///
  /// In en, this message translates to:
  /// **'Meaning'**
  String get giftsMeaning;

  /// No description provided for @giftsDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get giftsDescription;

  /// No description provided for @giftsBibleReferences.
  ///
  /// In en, this message translates to:
  /// **'Bible References'**
  String get giftsBibleReferences;

  /// No description provided for @giftsIncompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Test Incomplete'**
  String get giftsIncompleteTitle;

  /// No description provided for @giftsIncompleteMessage.
  ///
  /// In en, this message translates to:
  /// **'You have only answered {answered} out of {total} questions. Do you really want to finish the test?'**
  String giftsIncompleteMessage(int answered, int total);

  /// No description provided for @giftsContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue filling out'**
  String get giftsContinue;

  /// No description provided for @giftsFinishAnyway.
  ///
  /// In en, this message translates to:
  /// **'Finish anyway'**
  String get giftsFinishAnyway;

  /// No description provided for @lifeTreeShareGraph.
  ///
  /// In en, this message translates to:
  /// **'Digital Life Tree (Graph)'**
  String get lifeTreeShareGraph;

  /// No description provided for @lifeTreeFullscreen.
  ///
  /// In en, this message translates to:
  /// **'Fullscreen Mode'**
  String get lifeTreeFullscreen;

  /// No description provided for @lifeTreeExitFullscreen.
  ///
  /// In en, this message translates to:
  /// **'Exit Fullscreen'**
  String get lifeTreeExitFullscreen;

  /// No description provided for @lifeTreeShareEvent.
  ///
  /// In en, this message translates to:
  /// **'Event: {text}'**
  String lifeTreeShareEvent(String text);

  /// No description provided for @lifeTreeShareNote.
  ///
  /// In en, this message translates to:
  /// **'Note: {text}'**
  String lifeTreeShareNote(String text);

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @shareTitle.
  ///
  /// In en, this message translates to:
  /// **'What do you want to share?'**
  String get shareTitle;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get selectAll;

  /// No description provided for @deselectAll.
  ///
  /// In en, this message translates to:
  /// **'Deselect All'**
  String get deselectAll;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @shareSubject.
  ///
  /// In en, this message translates to:
  /// **'My results from DFL Weekend'**
  String get shareSubject;

  /// No description provided for @shareFooter.
  ///
  /// In en, this message translates to:
  /// **'Created during the DFL Weekend'**
  String get shareFooter;

  /// No description provided for @shareIntro.
  ///
  /// In en, this message translates to:
  /// **'Check out my results:'**
  String get shareIntro;

  /// No description provided for @feedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Feedback Form'**
  String get feedbackTitle;

  /// No description provided for @feedbackGuidance.
  ///
  /// In en, this message translates to:
  /// **'Please give us your feedback on the seminar so that we can make it even better next time.'**
  String get feedbackGuidance;

  /// No description provided for @feedbackRating1.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get feedbackRating1;

  /// No description provided for @feedbackRating2.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get feedbackRating2;

  /// No description provided for @feedbackRating3.
  ///
  /// In en, this message translates to:
  /// **'Satisfactory'**
  String get feedbackRating3;

  /// No description provided for @feedbackRating4.
  ///
  /// In en, this message translates to:
  /// **'Sufficient'**
  String get feedbackRating4;

  /// No description provided for @feedbackRating5.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get feedbackRating5;

  /// No description provided for @feedbackRating6.
  ///
  /// In en, this message translates to:
  /// **'Very Poor'**
  String get feedbackRating6;

  /// No description provided for @feedbackSectionContent.
  ///
  /// In en, this message translates to:
  /// **'Seminar Content'**
  String get feedbackSectionContent;

  /// No description provided for @feedbackContentExpectations.
  ///
  /// In en, this message translates to:
  /// **'The content met my expectations'**
  String get feedbackContentExpectations;

  /// No description provided for @feedbackContentPracticalUtility.
  ///
  /// In en, this message translates to:
  /// **'I gained useful suggestions for my daily practice'**
  String get feedbackContentPracticalUtility;

  /// No description provided for @feedbackContentStructure.
  ///
  /// In en, this message translates to:
  /// **'Structure & clarity of the topic complex'**
  String get feedbackContentStructure;

  /// No description provided for @feedbackSectionSpeaker.
  ///
  /// In en, this message translates to:
  /// **'Speaker & Execution'**
  String get feedbackSectionSpeaker;

  /// No description provided for @feedbackSpeakerGodWorking.
  ///
  /// In en, this message translates to:
  /// **'I had the impression that God could work'**
  String get feedbackSpeakerGodWorking;

  /// No description provided for @feedbackSpeakerFaithProgress.
  ///
  /// In en, this message translates to:
  /// **'The seminar helped me progress in my faith life'**
  String get feedbackSpeakerFaithProgress;

  /// No description provided for @feedbackSpeakerDidactics.
  ///
  /// In en, this message translates to:
  /// **'Didactic skills'**
  String get feedbackSpeakerDidactics;

  /// No description provided for @feedbackSpeakerMethods.
  ///
  /// In en, this message translates to:
  /// **'The methods used were effective'**
  String get feedbackSpeakerMethods;

  /// No description provided for @feedbackSpeakerInvolvement.
  ///
  /// In en, this message translates to:
  /// **'The speaker actively involved the participants'**
  String get feedbackSpeakerInvolvement;

  /// No description provided for @feedbackSpeakerRespect.
  ///
  /// In en, this message translates to:
  /// **'The speaker was polite and respectful'**
  String get feedbackSpeakerRespect;

  /// No description provided for @feedbackAtmosphere.
  ///
  /// In en, this message translates to:
  /// **'General course atmosphere and group climate'**
  String get feedbackAtmosphere;

  /// No description provided for @feedbackSectionDocs.
  ///
  /// In en, this message translates to:
  /// **'Seminar Documents'**
  String get feedbackSectionDocs;

  /// No description provided for @feedbackDocsStructure.
  ///
  /// In en, this message translates to:
  /// **'Structure and clarity'**
  String get feedbackDocsStructure;

  /// No description provided for @feedbackDocsUnderstandability.
  ///
  /// In en, this message translates to:
  /// **'Understandability'**
  String get feedbackDocsUnderstandability;

  /// No description provided for @feedbackDocsDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Level of difficulty'**
  String get feedbackDocsDifficulty;

  /// No description provided for @feedbackSectionOrg.
  ///
  /// In en, this message translates to:
  /// **'Organization & Infrastructure'**
  String get feedbackSectionOrg;

  /// No description provided for @feedbackRoomsAppropriateness.
  ///
  /// In en, this message translates to:
  /// **'Appropriateness of the rooms'**
  String get feedbackRoomsAppropriateness;

  /// No description provided for @feedbackPrepQuality.
  ///
  /// In en, this message translates to:
  /// **'Preparation of the seminar by the organizer'**
  String get feedbackPrepQuality;

  /// No description provided for @feedbackDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration of the event'**
  String get feedbackDuration;

  /// No description provided for @feedbackTempo.
  ///
  /// In en, this message translates to:
  /// **'Pace of the event'**
  String get feedbackTempo;

  /// No description provided for @feedbackCatering.
  ///
  /// In en, this message translates to:
  /// **'Catering'**
  String get feedbackCatering;

  /// No description provided for @feedbackSectionComments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get feedbackSectionComments;

  /// No description provided for @feedbackCommentsMissing.
  ///
  /// In en, this message translates to:
  /// **'What was missing?'**
  String get feedbackCommentsMissing;

  /// No description provided for @feedbackRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Would you recommend this seminar?'**
  String get feedbackRecommendation;

  /// No description provided for @feedbackGeneralNotes.
  ///
  /// In en, this message translates to:
  /// **'Additional notes'**
  String get feedbackGeneralNotes;

  /// No description provided for @feedbackLabel.
  ///
  /// In en, this message translates to:
  /// **'Rating: {rating}'**
  String feedbackLabel(int rating);

  /// No description provided for @session1Title.
  ///
  /// In en, this message translates to:
  /// **'Session One: Hello, Good Evening and Welcome'**
  String get session1Title;

  /// No description provided for @session1Desc.
  ///
  /// In en, this message translates to:
  /// **'Welcome and introduction to the DFL weekend.'**
  String get session1Desc;

  /// No description provided for @session2Title.
  ///
  /// In en, this message translates to:
  /// **'Session Two: Back to the Future'**
  String get session2Title;

  /// No description provided for @session2Desc.
  ///
  /// In en, this message translates to:
  /// **'Reflection on one\'s own history.'**
  String get session2Desc;

  /// No description provided for @session3Title.
  ///
  /// In en, this message translates to:
  /// **'Group Work – Drawing the Life Tree + Evaluation'**
  String get session3Title;

  /// No description provided for @session3Desc.
  ///
  /// In en, this message translates to:
  /// **'Creating your personal life tree in a group setting.'**
  String get session3Desc;

  /// No description provided for @session4Title.
  ///
  /// In en, this message translates to:
  /// **'Session Three: The Here and Now'**
  String get session4Title;

  /// No description provided for @session4Desc.
  ///
  /// In en, this message translates to:
  /// **'Present and Identity.'**
  String get session4Desc;

  /// No description provided for @session5Title.
  ///
  /// In en, this message translates to:
  /// **'Spiritual Gifts'**
  String get session5Title;

  /// No description provided for @session5Desc.
  ///
  /// In en, this message translates to:
  /// **'Discovery and classification of spiritual gifts.'**
  String get session5Desc;

  /// No description provided for @session6Title.
  ///
  /// In en, this message translates to:
  /// **'Values'**
  String get session6Title;

  /// No description provided for @session6Desc.
  ///
  /// In en, this message translates to:
  /// **'Connections to spiritual gifts + life tree.'**
  String get session6Desc;

  /// No description provided for @session7Title.
  ///
  /// In en, this message translates to:
  /// **'Session Four: Pray, Dream, Listen!'**
  String get session7Title;

  /// No description provided for @session7Desc.
  ///
  /// In en, this message translates to:
  /// **'Practical introduction and time for listening prayer.'**
  String get session7Desc;

  /// No description provided for @session8Title.
  ///
  /// In en, this message translates to:
  /// **'Developing a Vision for the Future'**
  String get session8Title;

  /// No description provided for @session8Desc.
  ///
  /// In en, this message translates to:
  /// **'The Big Picture I (Collage) from life tree, gifts, values, and listening prayer.'**
  String get session8Desc;

  /// No description provided for @session9Title.
  ///
  /// In en, this message translates to:
  /// **'Session Five: Do you know the way to San Jose'**
  String get session9Title;

  /// No description provided for @session9Desc.
  ///
  /// In en, this message translates to:
  /// **'Outlook and next steps.'**
  String get session9Desc;

  /// No description provided for @session10Title.
  ///
  /// In en, this message translates to:
  /// **'Setting 3 Goals'**
  String get session10Title;

  /// No description provided for @session10Desc.
  ///
  /// In en, this message translates to:
  /// **'Personal goal setting in individual sessions.'**
  String get session10Desc;

  /// No description provided for @session11Title.
  ///
  /// In en, this message translates to:
  /// **'Group Photo'**
  String get session11Title;

  /// No description provided for @timelineSynthesisTitle.
  ///
  /// In en, this message translates to:
  /// **'Connections'**
  String get timelineSynthesisTitle;

  /// No description provided for @timelineSynthesisDesc.
  ///
  /// In en, this message translates to:
  /// **'Bring together the key insights from life tree, gifts, values, and listening prayer.'**
  String get timelineSynthesisDesc;

  /// No description provided for @timelineImagineTitle.
  ///
  /// In en, this message translates to:
  /// **'Imagine'**
  String get timelineImagineTitle;

  /// No description provided for @timelineImagineDesc.
  ///
  /// In en, this message translates to:
  /// **'Shape future images and capture your thoughts for the next life phase.'**
  String get timelineImagineDesc;

  /// No description provided for @timelineUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unable to load the timeline. Please restart the app.'**
  String get timelineUnavailable;

  /// No description provided for @session12Title.
  ///
  /// In en, this message translates to:
  /// **'Feedback Form'**
  String get session12Title;

  /// No description provided for @valueGenauigkeit.
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get valueGenauigkeit;

  /// No description provided for @valueFamilie.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get valueFamilie;

  /// No description provided for @valuePersEntwicklung.
  ///
  /// In en, this message translates to:
  /// **'Personal Development'**
  String get valuePersEntwicklung;

  /// No description provided for @valueAusfuehrung.
  ///
  /// In en, this message translates to:
  /// **'Execution'**
  String get valueAusfuehrung;

  /// No description provided for @valueFinanzielleSicherheit.
  ///
  /// In en, this message translates to:
  /// **'Financial Security'**
  String get valueFinanzielleSicherheit;

  /// No description provided for @valueBeitragMitarbeit.
  ///
  /// In en, this message translates to:
  /// **'Contribution'**
  String get valueBeitragMitarbeit;

  /// No description provided for @valueAufstieg.
  ///
  /// In en, this message translates to:
  /// **'Advancement'**
  String get valueAufstieg;

  /// No description provided for @valueFlexibilitaet.
  ///
  /// In en, this message translates to:
  /// **'Flexibility'**
  String get valueFlexibilitaet;

  /// No description provided for @valueLeistungEnergie.
  ///
  /// In en, this message translates to:
  /// **'Achievement (Energy)'**
  String get valueLeistungEnergie;

  /// No description provided for @valueAbenteuer.
  ///
  /// In en, this message translates to:
  /// **'Adventure'**
  String get valueAbenteuer;

  /// No description provided for @valueFreundschaft.
  ///
  /// In en, this message translates to:
  /// **'Friendship'**
  String get valueFreundschaft;

  /// No description provided for @valuePrestige.
  ///
  /// In en, this message translates to:
  /// **'Prestige'**
  String get valuePrestige;

  /// No description provided for @valueAesthetik.
  ///
  /// In en, this message translates to:
  /// **'Aesthetics'**
  String get valueAesthetik;

  /// No description provided for @valueGrosszuegigkeit.
  ///
  /// In en, this message translates to:
  /// **'Generosity'**
  String get valueGrosszuegigkeit;

  /// No description provided for @valueAnerkennung.
  ///
  /// In en, this message translates to:
  /// **'Recognition'**
  String get valueAnerkennung;

  /// No description provided for @valueKuenstlerischerAusdruck.
  ///
  /// In en, this message translates to:
  /// **'Artistic Expression'**
  String get valueKuenstlerischerAusdruck;

  /// No description provided for @valueGlueck.
  ///
  /// In en, this message translates to:
  /// **'Happiness'**
  String get valueGlueck;

  /// No description provided for @valuePersGlaube.
  ///
  /// In en, this message translates to:
  /// **'Personal Faith'**
  String get valuePersGlaube;

  /// No description provided for @valueEchtheit.
  ///
  /// In en, this message translates to:
  /// **'Authenticity'**
  String get valueEchtheit;

  /// No description provided for @valueHumor.
  ///
  /// In en, this message translates to:
  /// **'Humor'**
  String get valueHumor;

  /// No description provided for @valueVerantwortung.
  ///
  /// In en, this message translates to:
  /// **'Responsibility'**
  String get valueVerantwortung;

  /// No description provided for @valueGleichgewicht.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get valueGleichgewicht;

  /// No description provided for @valueUnabhaengigkeit.
  ///
  /// In en, this message translates to:
  /// **'Independence'**
  String get valueUnabhaengigkeit;

  /// No description provided for @valueSicherheit.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get valueSicherheit;

  /// No description provided for @valueHerausforderung.
  ///
  /// In en, this message translates to:
  /// **'Challenge'**
  String get valueHerausforderung;

  /// No description provided for @valueIntegritaet.
  ///
  /// In en, this message translates to:
  /// **'Integrity'**
  String get valueIntegritaet;

  /// No description provided for @valueSelbstachtung.
  ///
  /// In en, this message translates to:
  /// **'Self-respect'**
  String get valueSelbstachtung;

  /// No description provided for @valueBefaehigung.
  ///
  /// In en, this message translates to:
  /// **'Empowerment'**
  String get valueBefaehigung;

  /// No description provided for @valueLernen.
  ///
  /// In en, this message translates to:
  /// **'Learning'**
  String get valueLernen;

  /// No description provided for @valueDienst.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get valueDienst;

  /// No description provided for @valueWettbewerb.
  ///
  /// In en, this message translates to:
  /// **'Competition'**
  String get valueWettbewerb;

  /// No description provided for @valueFreizeit.
  ///
  /// In en, this message translates to:
  /// **'Leisure'**
  String get valueFreizeit;

  /// No description provided for @valueBestaendigkeit.
  ///
  /// In en, this message translates to:
  /// **'Consistency'**
  String get valueBestaendigkeit;

  /// No description provided for @valueAnpassung.
  ///
  /// In en, this message translates to:
  /// **'Adaptation'**
  String get valueAnpassung;

  /// No description provided for @valueWohnort.
  ///
  /// In en, this message translates to:
  /// **'Residence'**
  String get valueWohnort;

  /// No description provided for @valueToleranz.
  ///
  /// In en, this message translates to:
  /// **'Tolerance'**
  String get valueToleranz;

  /// No description provided for @valueKoerperlicheFitnessGesundheit.
  ///
  /// In en, this message translates to:
  /// **'Physical Fitness & Health'**
  String get valueKoerperlicheFitnessGesundheit;

  /// No description provided for @valueLiebe.
  ///
  /// In en, this message translates to:
  /// **'Love'**
  String get valueLiebe;

  /// No description provided for @valueTradition.
  ///
  /// In en, this message translates to:
  /// **'Tradition'**
  String get valueTradition;

  /// No description provided for @valueKontrolle.
  ///
  /// In en, this message translates to:
  /// **'Control'**
  String get valueKontrolle;

  /// No description provided for @valueAusdauerBeharrlichkeit.
  ///
  /// In en, this message translates to:
  /// **'Endurance - Perseverance'**
  String get valueAusdauerBeharrlichkeit;

  /// No description provided for @valueVielfaeltigkeit.
  ///
  /// In en, this message translates to:
  /// **'Diversity'**
  String get valueVielfaeltigkeit;

  /// No description provided for @valueKooperation.
  ///
  /// In en, this message translates to:
  /// **'Cooperation'**
  String get valueKooperation;

  /// No description provided for @valueNatur.
  ///
  /// In en, this message translates to:
  /// **'Nature'**
  String get valueNatur;

  /// No description provided for @valueEinfluss.
  ///
  /// In en, this message translates to:
  /// **'Influence'**
  String get valueEinfluss;

  /// No description provided for @valueKreativitaet.
  ///
  /// In en, this message translates to:
  /// **'Creativity'**
  String get valueKreativitaet;

  /// No description provided for @valueOrganisation.
  ///
  /// In en, this message translates to:
  /// **'Organization'**
  String get valueOrganisation;

  /// No description provided for @valueEffektivitaet.
  ///
  /// In en, this message translates to:
  /// **'Effectiveness'**
  String get valueEffektivitaet;

  /// No description provided for @valueFriede.
  ///
  /// In en, this message translates to:
  /// **'Peace'**
  String get valueFriede;

  /// No description provided for @valueFairness.
  ///
  /// In en, this message translates to:
  /// **'Fairness'**
  String get valueFairness;

  /// No description provided for @valueLoyalitaet.
  ///
  /// In en, this message translates to:
  /// **'Loyalty'**
  String get valueLoyalitaet;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
