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

  @override
  String get valuesTitle => 'Werte herausfinden';

  @override
  String get valuesPhase1Title => 'Bewertung';

  @override
  String get valuesPhase1Guidance =>
      'Gehe die Liste durch und bewerte jeden Wert:\n1 = Sehr wichtig für mich\n2 = Wichtig für mich\n3 = Weniger wichtig für mich\n\nZiel: Wähle genau 8 Werte mit der Bewertung \'1\' aus.';

  @override
  String valuesSelectionStatus(int count) {
    return 'Wähle genau 8 Werte mit \"1\". Aktuell: $count / 8';
  }

  @override
  String valuesSelectionMissing(int count) {
    return 'Du hast aktuell $count von 8 Werten ausgewählt. Für ein optimales Ergebnis sollten es genau 8 sein. Möchtest du trotzdem fortfahren?';
  }

  @override
  String get valuesPhase2Title => 'Persönliche Definition';

  @override
  String get valuesPhase2Guidance =>
      'Sortiere deine Top-8 Werte per Drag & Drop nach ihrer Priorität für dich. Definiere dann kurz, was dieser Wert für dich ganz persönlich bedeutet. Die ersten 3 Plätze sind deine absoluten Key Takeaways.';

  @override
  String get valuesDefinitionLabel => 'Meine Definition';

  @override
  String get valuesDefinitionHint => 'Was bedeutet dieser Wert für mich?';

  @override
  String get valuesPhase3Title => 'Reflektion & Zukunft';

  @override
  String get valuesPhase3Guidance =>
      'Übernimm Verantwortung für deine Werte und blicke nach vorne.';

  @override
  String get valuesReflectionLabel =>
      'Was denkst du über deine Auswahl? Gab es Überraschungen?';

  @override
  String get valuesReflectionHint => 'Deine Gedanken hier...';

  @override
  String get valuesNextPhaseLabel =>
      'Beschreibe deinen nächsten Lebensabschnitt (z.B. neuer Job, Rente):';

  @override
  String get valuesNextPhaseHint => 'Zukünftige Phase...';

  @override
  String get valuesNextPhaseValuesGuidance =>
      'Wähle bis zu 8 Werte aus der Liste, die für diesen neuen Abschnitt besonders wichtig sein werden (klicke in der gewünschten Reihenfolge):';

  @override
  String get valuesResultTitle => 'Meine Top 8 Werte';

  @override
  String get lifeTreeTitle => 'Mein Lebensbaum';

  @override
  String get lifeTreeDigital => 'Digitaler Lebensbaum';

  @override
  String get lifeTreeAnalog => 'Notizen & Zeichnungen';

  @override
  String get lifeTreeStart => 'Lebensbaum starten (Geburt)';

  @override
  String get lifeTreeBirth => 'Geburt';

  @override
  String get lifeTreeNodeHint => 'Ereignis...';

  @override
  String get lifeTreeAddChild => '+ Kind';

  @override
  String get lifeTreeAddSibling => '+ Geschwister';

  @override
  String get lifeTreeEditNote => 'Notiz bearbeiten';

  @override
  String get lifeTreeShowNotes => 'Notizen anzeigen';

  @override
  String get lifeTreeNoteHint => 'Deine Gedanken...';

  @override
  String get lifeTreeSaveNote => 'Speichern';

  @override
  String get lifeTreeDeleteNote => 'Schließen / Löschen';

  @override
  String get giftsLoading => 'Lade Fragen...';

  @override
  String giftsQuestionCounter(int current, int total) {
    return 'Frage $current von $total';
  }

  @override
  String get giftsRating0 => 'Gar nicht';

  @override
  String get giftsRating1 => 'Kaum';

  @override
  String get giftsRating2 => 'Wenig';

  @override
  String get giftsRating3 => 'Teilweise';

  @override
  String get giftsRating4 => 'Viel';

  @override
  String get giftsRating5 => 'Sehr stark';

  @override
  String get giftsRankingTitle => 'Deine Gaben-Rangliste';

  @override
  String get giftsRankingGuidance =>
      'Tippe auf eine Gabe, um Details und Bibelstellen zu sehen. Deine Top 3 werden automatisch übernommen.';

  @override
  String giftsScorePoints(int score) {
    return '$score Pkt.';
  }

  @override
  String get giftsMeaning => 'Bedeutung';

  @override
  String get giftsDescription => 'Beschreibung';

  @override
  String get giftsBibleReferences => 'Bibelstellen';

  @override
  String get giftsIncompleteTitle => 'Test unvollständig';

  @override
  String giftsIncompleteMessage(int answered, int total) {
    return 'Du hast erst $answered von $total Fragen beantwortet. Möchtest du den Test wirklich abschließen?';
  }

  @override
  String get giftsContinue => 'Weiter ausfüllen';

  @override
  String get giftsFinishAnyway => 'Trotzdem beenden';

  @override
  String get lifeTreeShareGraph => 'Digitaler Lebensbaum (Grafik)';

  @override
  String get lifeTreeFullscreen => 'Vollbildmodus';

  @override
  String get lifeTreeExitFullscreen => 'Vollbild beenden';

  @override
  String lifeTreeShareEvent(String text) {
    return 'Ereignis: $text';
  }

  @override
  String lifeTreeShareNote(String text) {
    return 'Notiz: $text';
  }

  @override
  String get finish => 'Abschließen';

  @override
  String get next => 'Weiter';

  @override
  String get previous => 'Zurück';

  @override
  String get share => 'Teilen';

  @override
  String get shareTitle => 'Was möchtest du teilen?';

  @override
  String get selectAll => 'Alle auswählen';

  @override
  String get deselectAll => 'Nichts auswählen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get shareSubject => 'Meine Ergebnisse vom DFL-Wochenende';

  @override
  String get shareFooter => 'Erstellt während des DFL-Wochenendes';

  @override
  String get shareIntro => 'Schau dir meine Ergebnisse an:';

  @override
  String get feedbackTitle => 'Feedbackbogen';

  @override
  String get feedbackGuidance =>
      'Bitte gib uns deine Rückmeldung zum Seminar, damit wir beim nächsten Mal es noch besser gestalten können.';

  @override
  String get feedbackRating1 => 'Sehr gut';

  @override
  String get feedbackRating2 => 'Gut';

  @override
  String get feedbackRating3 => 'Befriedigend';

  @override
  String get feedbackRating4 => 'Ausreichend';

  @override
  String get feedbackRating5 => 'Mangelhaft';

  @override
  String get feedbackRating6 => 'Ungenügend';

  @override
  String get feedbackSectionContent => 'Inhalt des Seminars';

  @override
  String get feedbackContentExpectations =>
      'Die Inhalte entsprachen meinen Erwartungen';

  @override
  String get feedbackContentPracticalUtility =>
      'Ich habe nützliche Anregungen für meine täglich Praxis gewonnen';

  @override
  String get feedbackContentStructure =>
      'Gliederung & Verständlichkeit des Themenkomplexes';

  @override
  String get feedbackSectionSpeaker => 'Referent & Durchführung';

  @override
  String get feedbackSpeakerGodWorking =>
      'Ich hatte den Eindruck, dass Gott wirken konnte';

  @override
  String get feedbackSpeakerFaithProgress =>
      'Das Seminar hat mich in meinem Glaubensleben weitergebracht';

  @override
  String get feedbackSpeakerDidactics => 'Didaktische Fähigkeiten';

  @override
  String get feedbackSpeakerMethods =>
      'Die eingesetzten Methoden waren zielführend';

  @override
  String get feedbackSpeakerInvolvement =>
      'Der Referent hat die Teilnehmer aktiv eingebunden';

  @override
  String get feedbackSpeakerRespect =>
      'Der Referent hat sich höflich und respektvoll verhalten';

  @override
  String get feedbackAtmosphere => 'Allgemeine Kursatmosphäre und Gruppenklima';

  @override
  String get feedbackSectionDocs => 'Seminarunterlagen';

  @override
  String get feedbackDocsStructure => 'Struktur und Übersichtlichkeit';

  @override
  String get feedbackDocsUnderstandability => 'Verständlichkeit';

  @override
  String get feedbackDocsDifficulty => 'Schwierigkeitsgrad';

  @override
  String get feedbackSectionOrg => 'Organisation & Infrastruktur';

  @override
  String get feedbackRoomsAppropriateness =>
      'Angemessenheit der Räumlichkeiten';

  @override
  String get feedbackPrepQuality =>
      'Vorbereitung des Seminars durch den Veranstalter';

  @override
  String get feedbackDuration => 'Dauer der Veranstaltung';

  @override
  String get feedbackTempo => 'Tempo der Veranstaltung';

  @override
  String get feedbackCatering => 'Verpflegung';

  @override
  String get feedbackSectionComments => 'Kommentare';

  @override
  String get feedbackCommentsMissing => 'Was kam zu kurz?';

  @override
  String get feedbackRecommendation =>
      'Würden Sie dieses Seminar weiterempfehlen?';

  @override
  String get feedbackGeneralNotes => 'Anmerkungen';

  @override
  String feedbackLabel(int rating) {
    return 'Bewertung: $rating';
  }

  @override
  String get session1Title => 'Einheit Eins: Hallo, Guten Abend und Willkommen';

  @override
  String get session1Desc => 'Begrüßung und Einführung in das DFL Wochenende.';

  @override
  String get session2Title => 'Einheit Zwei: Zurück in die Zukunft';

  @override
  String get session2Desc => 'Reflektion über die eigene Geschichte.';

  @override
  String get session3Title => 'Gruppenarbeit – Lebensbaum zeichnen + Auswerten';

  @override
  String get session3Desc =>
      'Erstellung des persönlichen Lebensbaums in der Gruppe.';

  @override
  String get session4Title => 'Einheit Drei: Das Hier und Jetzt';

  @override
  String get session4Desc => 'Gegenwart und Identität.';

  @override
  String get session5Title => 'Gaben';

  @override
  String get session5Desc => 'Entdeckung und Einordnung der geistlichen Gaben.';

  @override
  String get session6Title => 'Werte';

  @override
  String get session6Desc => 'Zusammenhänge zu den Gaben + Lebensbaum.';

  @override
  String get session7Title => 'Einheit Vier: Bete, Träume, Höre!';

  @override
  String get session7Desc =>
      'Praktische Einführung und Zeit des hörenden Gebets.';

  @override
  String get session8Title => 'Entwicklung einer Zukunftidee';

  @override
  String get session8Desc =>
      'The Big Picture I (Collage) aus Lebensbaum, Gaben, Werten und hörendem Gebet.';

  @override
  String get session9Title => 'Einheit Fünf: Weißt Du den Weg nach San Jose';

  @override
  String get session9Desc => 'Ausblick und nächste Schritte.';

  @override
  String get session10Title => '3 Ziele festlegen';

  @override
  String get session10Desc => 'Persönliche Zielsetzung in Einzelgesprächen.';

  @override
  String get session11Title => 'Gruppenfoto';

  @override
  String get timelineSynthesisTitle => 'Verknüpfungen';

  @override
  String get timelineSynthesisDesc =>
      'Verdichte die wichtigsten Erkenntnisse aus Lebensbaum, Gaben, Werten und hörendem Gebet.';

  @override
  String get timelineImagineTitle => 'Imagine';

  @override
  String get timelineImagineDesc =>
      'Gestalte Zukunftsbilder und halte deine Gedanken zur nächsten Lebensphase fest.';

  @override
  String get timelineUnavailable =>
      'Timeline konnte nicht geladen werden. Bitte starte die App neu.';

  @override
  String get session12Title => 'Feedbackbogen';

  @override
  String get valueGenauigkeit => 'Genauigkeit';

  @override
  String get valueFamilie => 'Familie';

  @override
  String get valuePersEntwicklung => 'pers. Entwicklung';

  @override
  String get valueAusfuehrung => 'Ausführung';

  @override
  String get valueFinanzielleSicherheit => 'finanzielle Sicherheit';

  @override
  String get valueBeitragMitarbeit => 'Beitrag/Mitarbeit';

  @override
  String get valueAufstieg => 'Aufstieg';

  @override
  String get valueFlexibilitaet => 'Flexibilität';

  @override
  String get valueLeistungEnergie => 'Leistung (Energie)';

  @override
  String get valueAbenteuer => 'Abenteuer';

  @override
  String get valueFreundschaft => 'Freundschaft';

  @override
  String get valuePrestige => 'Prestige';

  @override
  String get valueAesthetik => 'Ästhetik';

  @override
  String get valueGrosszuegigkeit => 'Großzügigkeit';

  @override
  String get valueAnerkennung => 'Anerkennung';

  @override
  String get valueKuenstlerischerAusdruck => 'künstlerischer Ausdruck';

  @override
  String get valueGlueck => 'Glück';

  @override
  String get valuePersGlaube => 'pers. Glaube';

  @override
  String get valueEchtheit => 'Echtheit';

  @override
  String get valueHumor => 'Humor';

  @override
  String get valueVerantwortung => 'Verantwortung';

  @override
  String get valueGleichgewicht => 'Gleichgewicht';

  @override
  String get valueUnabhaengigkeit => 'Unabhängigkeit';

  @override
  String get valueSicherheit => 'Sicherheit';

  @override
  String get valueHerausforderung => 'Herausforderung';

  @override
  String get valueIntegritaet => 'Integrität';

  @override
  String get valueSelbstachtung => 'Selbstachtung';

  @override
  String get valueBefaehigung => 'Befähigung';

  @override
  String get valueLernen => 'Lernen';

  @override
  String get valueDienst => 'Dienst';

  @override
  String get valueWettbewerb => 'Wettbewerb';

  @override
  String get valueFreizeit => 'Freizeit';

  @override
  String get valueBestaendigkeit => 'Beständigkeit';

  @override
  String get valueAnpassung => 'Anpassung';

  @override
  String get valueWohnort => 'Wohnort';

  @override
  String get valueToleranz => 'Toleranz';

  @override
  String get valueKoerperlicheFitnessGesundheit =>
      'körperliche Fitness + Gesundheit';

  @override
  String get valueLiebe => 'Liebe';

  @override
  String get valueTradition => 'Tradition';

  @override
  String get valueKontrolle => 'Kontrolle';

  @override
  String get valueAusdauerBeharrlichkeit => 'Ausdauer - Beharrlichkeit';

  @override
  String get valueVielfaeltigkeit => 'Vielfältigkeit';

  @override
  String get valueKooperation => 'Kooperation';

  @override
  String get valueNatur => 'Natur';

  @override
  String get valueEinfluss => 'Einfluss';

  @override
  String get valueKreativitaet => 'Kreativität';

  @override
  String get valueOrganisation => 'Organisation';

  @override
  String get valueEffektivitaet => 'Effektivität';

  @override
  String get valueFriede => 'Friede';

  @override
  String get valueFairness => 'Fairness';

  @override
  String get valueLoyalitaet => 'Loyalität';

  @override
  String get valuesNoValuesSelected => 'Noch keine Werte ausgewählt.';

  @override
  String get valuesSelectEightFirst =>
      'Bitte wähle zuerst 8 Werte in Phase 1 (Bewertung) aus.';

  @override
  String get connectionsColLifeTree => 'Lebensbaum';

  @override
  String get connectionsColValues => 'Werte';

  @override
  String get connectionsColGifts => 'Gaben';

  @override
  String get connectionsColPrayer => 'Hörendes Gebet';

  @override
  String get connectionsColGoals => 'Ziele';

  @override
  String get connectionsGroupedByColor => 'Nach Farben gruppiert';

  @override
  String get connectionsMatrixView => 'Matrix-Ansicht';

  @override
  String connectionsColorGroup(int count) {
    return 'Farbgruppe ($count)';
  }

  @override
  String get connectionsNoContent =>
      'Noch keine Key-Takeaways vorhanden. Bearbeite zuerst mindestens ein Modul (Lebensbaum, Werte, Gaben oder Hörendes Gebet).';

  @override
  String get connectionsGuidance =>
      'Ordne Karten innerhalb einer Spalte per Drag & Drop. Weise jeder Karte eine Farbe zu, um Gemeinsamkeiten zu markieren.';

  @override
  String get connectionsAssignColor => 'Farbe zuweisen';

  @override
  String get connectionsColorNone => 'Keine Farbe';

  @override
  String get connectionsColorRed => 'Rot';

  @override
  String get connectionsColorBlue => 'Blau';

  @override
  String get connectionsColorGreen => 'Grün';

  @override
  String get connectionsColorGold => 'Gelb';
}
