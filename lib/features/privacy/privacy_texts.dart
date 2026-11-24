/// Texte der Datenschutz-Hinweise (Stand: Datenschutz-Prüfung Nov. 2026).
///
/// Bewusst nicht in den ARB-Dateien: Rechtstexte sollen von der
/// Datenschutzbeauftragten freigegeben werden, bevor sie übersetzt werden.
/// Deshalb nur Deutsch und Englisch; jede andere Sprache zeigt Englisch.
class PrivacyTexts {
  final String title;
  final String intro;
  final List<(String, String)> sections;
  final String imprintLink;
  final String privacyLink;
  final String deleteTitle;
  final String deleteGuidance;
  final String deleteButton;
  final String deleteConfirmTitle;
  final String deleteConfirmMessage;
  final String deleteConfirmAction;
  final String cancel;
  final String unencryptedNote;

  const PrivacyTexts({
    required this.title,
    required this.intro,
    required this.sections,
    required this.imprintLink,
    required this.privacyLink,
    required this.deleteTitle,
    required this.deleteGuidance,
    required this.deleteButton,
    required this.deleteConfirmTitle,
    required this.deleteConfirmMessage,
    required this.deleteConfirmAction,
    required this.cancel,
    required this.unencryptedNote,
  });

  static PrivacyTexts forLanguage(String code) => code == 'de' ? de : en;

  static const de = PrivacyTexts(
    title: 'Datenschutz & Impressum',
    intro:
        'Design for Life ist eine Begleit-App zum DFL-Wochenende der Heilsarmee. '
        'Sie braucht kein Benutzerkonto, enthält keine Werbung und kein Tracking.',
    sections: [
      (
        'Deine Einträge bleiben auf deinem Gerät',
        'Alles, was du in der App eingibst (Notizen, Werte, Gaben, Gebetseindrücke, '
            'Ziele …), wird nur im Speicher deines Browsers bzw. Geräts abgelegt – '
            'nicht auf einem Server. Die Heilsarmee erhält diese Inhalte nicht. '
            'Die Ablage ist nicht verschlüsselt. Auf gemeinsam genutzten Geräten '
            'solltest du deshalb nach der Nutzung alle Daten löschen (siehe '
            '„Sicherung“).',
      ),
      (
        'Was der Server protokolliert',
        'Wie bei jeder Webseite verzeichnet der Webserver beim Aufruf technische '
            'Zugriffsdaten (z. B. IP-Adresse, Zeitpunkt, aufgerufene Datei). '
            'Die App lädt keine Schriften, Skripte oder Programmteile von '
            'Drittanbietern wie Google nach.',
      ),
      (
        'Gaben-Referenz',
        'Wenn du jemanden bittest, dich im Gaben-Test einzuschätzen, enthält der '
            'Rücksende-Link den Namen und die Antworten der einschätzenden '
            'Person. Diese Angaben stehen hinter dem „#“ des Links und werden '
            'daher nicht an den Webserver übertragen. Sie gehen nur an die Person, '
            'der du den Link schickst – und über den Messenger, den ihr dafür '
            'nutzt.',
      ),
      (
        'Bibelstellen',
        'Tippst du auf eine Bibelstelle, öffnet sich bibleserver.com bzw. '
            'bible.com in deinem Browser. Dort gelten deren Datenschutzregeln.',
      ),
      (
        'Sicherungsdatei',
        'Die Sicherungsdatei enthält alle deine Einträge unverschlüsselt. '
            'Bewahre sie sicher auf und gib sie nicht unbedacht weiter.',
      ),
    ],
    imprintLink: 'Impressum',
    privacyLink: 'Datenschutzerklärung',
    deleteTitle: 'Alle Daten löschen',
    deleteGuidance:
        'Löscht alle Einträge aus allen Modulen von diesem Gerät. Erstelle vorher '
        'bei Bedarf eine Sicherung. Besonders wichtig auf gemeinsam genutzten Geräten.',
    deleteButton: 'Alle Daten löschen',
    deleteConfirmTitle: 'Wirklich alles löschen?',
    deleteConfirmMessage:
        'Alle Einträge auf diesem Gerät werden endgültig gelöscht. Das lässt '
        'sich nicht rückgängig machen.',
    deleteConfirmAction: 'Endgültig löschen',
    cancel: 'Abbrechen',
    unencryptedNote:
        'Hinweis: Deine Einträge und die Sicherungsdatei sind nicht verschlüsselt. '
        'Auf gemeinsam genutzten Geräten nach der Nutzung alle Daten löschen.',
  );

  static const en = PrivacyTexts(
    title: 'Privacy & imprint',
    intro:
        'Design for Life is a companion app for the Salvation Army DFL weekend. '
        'It needs no user account and contains no advertising or tracking.',
    sections: [
      (
        'Your entries stay on your device',
        'Everything you enter (notes, values, gifts, prayer impressions, goals …) '
            'is stored only in your browser or device – not on a server. The '
            'Salvation Army does not receive this content. Storage is not '
            'encrypted, so on shared devices please delete all data after use '
            '(see "Backup").',
      ),
      (
        'What the server logs',
        'Like any website, the web server records technical access data when the '
            'app is opened (e.g. IP address, time, requested file). The app does '
            'not load fonts, scripts or code from third parties such as Google.',
      ),
      (
        'Gift reference',
        'If you ask someone to assess you in the gifts test, the return link '
            'contains the reviewer\'s name and answers. These sit behind the "#" '
            'of the link and are therefore not sent to the web server. They only '
            'reach the person you send the link to – and the messenger you use.',
      ),
      (
        'Bible references',
        'Tapping a Bible reference opens bibleserver.com or bible.com in your '
            'browser, where their privacy rules apply.',
      ),
      (
        'Backup file',
        'The backup file contains all your entries unencrypted. Keep it safe '
            'and do not pass it on carelessly.',
      ),
    ],
    imprintLink: 'Imprint',
    privacyLink: 'Privacy policy',
    deleteTitle: 'Delete all data',
    deleteGuidance:
        'Removes all entries of all modules from this device. Create a backup '
        'first if needed. Especially important on shared devices.',
    deleteButton: 'Delete all data',
    deleteConfirmTitle: 'Really delete everything?',
    deleteConfirmMessage:
        'All entries on this device will be permanently deleted. This cannot '
        'be undone.',
    deleteConfirmAction: 'Delete permanently',
    cancel: 'Cancel',
    unencryptedNote:
        'Note: your entries and the backup file are not encrypted. On shared '
        'devices, delete all data after use.',
  );
}
