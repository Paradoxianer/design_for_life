/// ENTWURF – Impressum und Datenschutzerklärung der App.
///
/// Stellen in eckigen Klammern „[…]“ müssen von der Zentrale der Heilsarmee
/// bzw. der Datenschutzbeauftragten ergänzt und die Texte freigegeben werden.
/// Solange [kLegalTextsAreDraft] true ist, zeigt die App einen deutlichen
/// Entwurfs-Hinweis. Erst nach Freigabe auf false setzen.
const bool kLegalTextsAreDraft = true;

class LegalDocument {
  final String title;
  final List<(String, String)> sections;
  const LegalDocument(this.title, this.sections);
}

class LegalTexts {
  final String draftBanner;
  final LegalDocument imprint;
  final LegalDocument privacyPolicy;
  final String welcomeTitle;
  final String welcomeIntro;
  final List<String> welcomePoints;
  final String welcomeAck;
  final String readPrivacy;
  final String readImprint;
  final String back;

  const LegalTexts({
    required this.draftBanner,
    required this.imprint,
    required this.privacyPolicy,
    required this.welcomeTitle,
    required this.welcomeIntro,
    required this.welcomePoints,
    required this.welcomeAck,
    required this.readPrivacy,
    required this.readImprint,
    required this.back,
  });

  static LegalTexts forLanguage(String code) => code == 'de' ? de : en;

  static const de = LegalTexts(
    draftBanner:
        'ENTWURF – noch nicht freigegeben. Angaben in [eckigen Klammern] fehlen noch.',
    welcomeTitle: 'Willkommen bei Design for Life',
    welcomeIntro: 'Kurz vorab, was du wissen solltest:',
    welcomePoints: [
      'Alles, was du einträgst, bleibt nur auf diesem Gerät – es gibt kein Benutzerkonto und keinen Server, der deine Inhalte erhält.',
      'Die Einträge sind nicht verschlüsselt. Auf einem gemeinsam genutzten Gerät bitte nach der Nutzung unter „Sicherung“ alle Daten löschen.',
      'Die App enthält keine Werbung und kein Tracking und lädt nichts von Drittanbietern wie Google nach.',
      'Der Webserver speichert wie üblich technische Zugriffsdaten (z. B. IP-Adresse).',
    ],
    welcomeAck: 'Verstanden',
    readPrivacy: 'Datenschutzerklärung',
    readImprint: 'Impressum',
    back: 'Zurück',
    imprint: LegalDocument('Impressum', [
      (
        'Anbieter',
        'Die Heilsarmee in Deutschland\n[vollständiger Rechtsname und Rechtsform laut Zentrale]\n[Straße, PLZ Ort]\n\nVertreten durch: [vertretungsberechtigte Person(en)]\nKontakt: [E-Mail, Telefon]\nRegisternummer / Steuer-ID: [falls erforderlich]',
      ),
      (
        'Verantwortlich für die App',
        'Inhaltlich und technisch verantwortlich:\nMatthias Lindner, Heilsarmee Chemnitz\n[Anschrift, E-Mail]\n\nDie App wird im Auftrag der Heilsarmee in Deutschland betrieben und ist über die Ausbildungsseiten von heilsarmee.de verlinkt.',
      ),
      (
        'Datenschutzbeauftragte',
        '[Name und Kontakt der Datenschutzbeauftragten der Heilsarmee in Deutschland]',
      ),
      (
        'Hosting',
        'Die App wird bereitgestellt über: [Hoster, Anschrift, Standort – Auftragsverarbeitungsvertrag liegt vor].',
      ),
    ]),
    privacyPolicy: LegalDocument('Datenschutzerklärung', [
      (
        '1. Verantwortliche Stelle',
        'Verantwortlich für die Verarbeitung ist die Heilsarmee in Deutschland ([Anschrift siehe Impressum]). Datenschutzbeauftragte: [Kontakt].',
      ),
      (
        '2. Zugriffsdaten auf dem Server',
        'Beim Aufruf der App speichert der Webserver technische Daten in einem Protokoll: IP-Adresse, Datum und Uhrzeit, aufgerufene Datei, Browser-Angaben. Zweck ist der sichere und stabile Betrieb (Art. 6 Abs. 1 lit. f DSGVO). Die Protokolle werden nach [7] Tagen gelöscht. Parameter, die du in Links mitschickst, stehen hinter dem „#“ und erreichen den Server nicht.',
      ),
      (
        '3. Deine Eingaben bleiben auf deinem Gerät',
        'Notizen, Werte, Gaben, Gebetseindrücke, Ziele, Fotos und alle weiteren Eingaben werden ausschließlich im lokalen Speicher deines Browsers bzw. Geräts abgelegt. Sie werden nicht an die Heilsarmee oder Dritte übertragen. Diese Speicherung ist für die gewünschte Funktion unbedingt erforderlich (§ 25 Abs. 2 Nr. 2 TDDDG); es werden keine Cookies zu Werbe- oder Analysezwecken gesetzt. Die Ablage ist nicht verschlüsselt. Du kannst alles jederzeit über „Sicherung → Alle Daten löschen“ entfernen.',
      ),
      (
        '4. Keine Drittanbieter',
        'Die App lädt keine Schriften, Skripte oder Programmteile von Drittanbietern (z. B. Google). Alle Bestandteile kommen von unserem eigenen Server.',
      ),
      (
        '5. Gaben-Referenz',
        'Wenn du jemanden bittest, dich im Gaben-Test einzuschätzen, erzeugt die App einen Link. Die einschätzende Person kann dir darüber ihren Namen (freiwillig) und ihre Antworten zurücksenden. Die Angaben stehen hinter dem „#“ im Link und werden nicht an den Webserver übertragen. Sie gelangen nur über den Weg (z. B. Messenger), den ihr selbst wählt, zu der Person, die eingeladen hat. Für diesen Weg gelten die Datenschutzregeln des jeweiligen Dienstes.',
      ),
      (
        '6. Bibelstellen',
        'Beim Tippen auf eine Bibelstelle öffnet sich bibleserver.com bzw. bible.com in deinem Browser. Ab dann gelten deren Datenschutzbestimmungen.',
      ),
      (
        '7. Sicherung, Teilen und PDF',
        'Die Sicherungsdatei und exportierte PDFs enthalten deine Einträge unverschlüsselt. Wohin du sie weitergibst (E-Mail, Cloud, Messenger), entscheidest du. Bewahre sie sicher auf.',
      ),
      (
        '8. Leitermodus',
        'Der Leitermodus schaltet zusätzliche Hinweise für Gruppenleitende frei. Er verarbeitet keine personenbezogenen Daten von Teilnehmenden.',
      ),
      (
        '9. Deine Rechte',
        'Du hast das Recht auf Auskunft, Berichtigung, Löschung, Einschränkung der Verarbeitung und Widerspruch, soweit Daten über dich beim Server gespeichert sind (siehe Punkt 2). Zudem kannst du dich bei einer Datenschutz-Aufsichtsbehörde beschweren: [zuständige Behörde].',
      ),
    ]),
  );

  static const en = LegalTexts(
    draftBanner:
        'DRAFT – not yet approved. Details in [square brackets] are still missing.',
    welcomeTitle: 'Welcome to Design for Life',
    welcomeIntro: 'A few things you should know first:',
    welcomePoints: [
      'Everything you enter stays on this device only – there is no user account and no server that receives your content.',
      'Entries are not encrypted. On a shared device, please delete all data under "Backup" after use.',
      'The app has no advertising and no tracking and loads nothing from third parties such as Google.',
      'As usual, the web server stores technical access data (e.g. IP address).',
    ],
    welcomeAck: 'Understood',
    readPrivacy: 'Privacy policy',
    readImprint: 'Imprint',
    back: 'Back',
    imprint: LegalDocument('Imprint', [
      (
        'Provider',
        'The Salvation Army in Germany\n[full legal name and form]\n[street, postcode, city]\n\nRepresented by: [authorised persons]\nContact: [email, phone]',
      ),
      (
        'Responsible for the app',
        'Content and technical responsibility:\nMatthias Lindner, Salvation Army Chemnitz\n[address, email]',
      ),
      ('Data protection officer', '[name and contact]'),
      ('Hosting', '[hosting provider, address, location]'),
    ]),
    privacyPolicy: LegalDocument('Privacy policy', [
      (
        '1. Controller',
        'The Salvation Army in Germany ([address see imprint]). Data protection officer: [contact].',
      ),
      (
        '2. Server access data',
        'When the app is opened, the web server logs technical data: IP address, date and time, requested file, browser details, to run the service securely (Art. 6(1)(f) GDPR). Logs are deleted after [7] days. Parameters in links sit behind the "#" and never reach the server.',
      ),
      (
        '3. Your entries stay on your device',
        'Notes, values, gifts, prayer impressions, goals, photos and all other entries are stored only in the local storage of your browser or device. They are not transmitted to the Salvation Army or third parties. This storage is strictly necessary for the requested function (section 25(2) no. 2 TDDDG); no cookies for advertising or analytics are set. Storage is not encrypted. You can remove everything at any time via "Backup → Delete all data".',
      ),
      (
        '4. No third parties',
        'The app loads no fonts, scripts or code from third parties (e.g. Google). Everything comes from our own server.',
      ),
      (
        '5. Gift reference',
        'If you ask someone to assess you in the gifts test, the app creates a link. The reviewer can send back their name (optional) and answers through it. These sit behind the "#" and are not sent to the web server. They reach the inviting person only via the channel you choose (e.g. a messenger), whose own privacy rules apply.',
      ),
      (
        '6. Bible references',
        'Tapping a Bible reference opens bibleserver.com or bible.com in your browser, where their privacy rules apply.',
      ),
      (
        '7. Backup, sharing and PDF',
        'Backup files and exported PDFs contain your entries unencrypted. You decide where you pass them on. Keep them safe.',
      ),
      (
        '8. Leader mode',
        'Leader mode unlocks additional notes for group leaders. It processes no personal data of participants.',
      ),
      (
        '9. Your rights',
        'You have the right of access, rectification, erasure, restriction and objection where data about you is stored on the server (see section 2), and may complain to a data protection authority: [competent authority].',
      ),
    ]),
  );
}
