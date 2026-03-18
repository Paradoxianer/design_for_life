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
