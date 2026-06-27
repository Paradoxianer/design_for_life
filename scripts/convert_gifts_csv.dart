import 'dart:io';
import 'dart:convert';

void main() {
  _convert('de');
  _convert('en');
}

void _convert(String locale) {
  final inputFile = File('docs/data/gift_test.$locale.csv');
  if (!inputFile.existsSync()) {
    print('Warnung: Datei für $locale nicht gefunden: ${inputFile.path}');
    return;
  }

  final lines = inputFile.readAsLinesSync();
  if (lines.isEmpty) return;

  final List<Map<String, dynamic>> gifts = [];
  Map<String, dynamic>? currentGift;
  
  // Header überspringen
  for (var i = 1; i < lines.length; i++) {
    final line = lines[i].trim();
    if (line.isEmpty || line.split(',').every((p) => p.trim().isEmpty)) continue;

    final parts = _splitCsvLine(line);
    if (parts.length < 7) continue;

    final giftId = parts[0].trim(); // Gabe-ID (G01, G02...)
    final giftName = parts[1].trim();
    
    if (giftId.isNotEmpty && (currentGift == null || currentGift['id'] != giftId)) {
      // Neue Gabe gefunden
      currentGift = {
        'id': giftId,
        'name': giftName,
        'originalWord': parts[3].trim(),
        'meaning': parts[4].trim(),
        'bibleReferences': parts[5].split(';').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
        'description': parts.length > 6 ? parts[6].trim() : '', 
        'questions': [],
      };
      gifts.add(currentGift);
    }

    // Wenn die Beschreibung in Spalte 7 steht (Index 6)
    if (currentGift != null && parts[0].isEmpty && parts.length > 6 && parts[6].isNotEmpty && currentGift['description'].isEmpty) {
       currentGift['description'] = parts[6].trim();
    }

    if (currentGift != null && parts.length > 8 && parts[8].isNotEmpty) {
      final typeText = parts[7].trim().toUpperCase();
      String finalType = 'reference';
      if (typeText.contains('ERLEBNIS') || typeText.contains('EXPERIENCE')) finalType = 'experience';
      else if (typeText.contains('NEIGUNG') || typeText.contains('NATURE')) finalType = 'nature';
      else if (typeText.contains('FRUCHT') || typeText.contains('FRUIT')) finalType = 'feedback';
      
      currentGift['questions'].add({
        'id': parts[2].trim().isNotEmpty ? parts[2].trim() : '${currentGift['id']}_Q${currentGift['questions'].length + 1}',
        'type': finalType,
        'text': parts[8].trim(),
      });
    }
  }

  // Fallback für fehlende Beschreibungen (Wiederherstellung aus GiftData)
  _applyDescriptionFallback(gifts, locale);

  final output = File('assets/data/gifts_$locale.json');
  output.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(gifts));
  print('Erfolgreich ${gifts.length} Gaben für $locale konvertiert.');
}

void _applyDescriptionFallback(List<Map<String, dynamic>> gifts, String locale) {
  // Vollständige Daten aus GiftData (Deutsch)
  final Map<String, Map<String, dynamic>> fallbackDataDe = {
    'G01': {
      'meaning': 'Übernatürliches Wort, das Gottes Plan oder Lösung offenbart',
      'desc': 'Die Gabe des Wortes der Weisheit beschreibt ein vom Heiligen Geist gegebenes Wort oder eine Einsicht, die Gottes Perspektive, Plan oder Lösung für eine konkrete Situation offenbart. Das griechische „logos sophias“ bezeichnet nicht allgemeine Weisheit, sondern ein spezifisches, situationsbezogenes Reden Gottes. In der Bibel zeigt sich diese Gabe z.B. bei Salomo (1. Kön 3), bei den Aposteln in schwierigen Entscheidungen (Apg 6; Apg 15) oder bei Jesus selbst, der göttliche Weisheit in Konfliktsituationen offenbarte. Diese Gabe bringt Klarheit, Orientierung und göttliche Strategie in komplexe Situationen und dient der Leitung und Erbauung der Gemeinde.',
      'refs': ['1. Kor 12,8', 'Jak 1,5', '1. Kön 3,5-12', 'Ex 31,3', 'Spr 2,6']
    },
    'G02': {
      'meaning': 'Übernatürliches Wissen oder Einblick in Geheimnisse Gottes',
      'desc': 'Das Wort der Erkenntnis beschreibt eine vom Heiligen Geist geschenkte Einsicht oder Information über eine Person, Situation oder geistliche Realität, die nicht durch natürliche Erkenntnis gewonnen wurde. Der Begriff „logos gnoseos“ meint eine konkrete Offenbarung von Wissen. In der Bibel zeigt sich diese Gabe etwa bei Petrus, der Ananias’ Täuschung erkennt (Apg 5), oder bei Jesus, der Gedanken und Lebenssituationen von Menschen kennt (Joh 4). Diese Gabe dient dazu, Wahrheit ans Licht zu bringen, Menschen zu helfen und Gottes Wirken sichtbar zu machen.',
      'refs': ['1. Kor 12,8', '1. Kor 13,2']
    },
    'G03': {
      'meaning': 'Besonderer, wundertätiger Glaube, der Berge versetzt',
      'desc': 'Die Gabe des Glaubens ist eine besondere, vom Heiligen Geist gewirkte Zuversicht, dass Gott in einer bestimmten Situation handeln wird. Sie geht über den allgemeinen rettenden Glauben hinaus und ist ein übernatürliches Vertrauen auf Gottes Macht und Verheißungen. Das griechische „pistis“ beschreibt hier ein starkes, festes Vertrauen auf Gottes Handeln. In der Bibel zeigt sich diese Gabe bei Personen wie Abraham (Röm 4) oder bei den Aposteln, die mutig Gottes Wirken erwarten. Diese Gabe stärkt andere im Glauben und öffnet Raum für Gottes übernatürliches Eingreifen.',
      'refs': ['1. Kor 12,9', '1. Kor 13,2', 'Mt 17,20', 'Hebr 11']
    },
    'G04': {
      'meaning': 'Fähigkeit, Kranke durch Gottes Kraft zu heilen',
      'desc': 'Die „Gaben der Heilungen“ beschreiben verschiedene Wirkungen göttlicher Heilung durch den Heiligen Geist. Das griechische „charismata iamaton“ steht im Plural und deutet darauf hin, dass Gott unterschiedliche Arten von Heilungen schenkt – körperlich, seelisch oder geistlich. In der Bibel werden Heilungen durch Jesus und die Apostel häufig beschrieben (z.B. Apg 3; Mk 16). Diese Gabe zeigt Gottes Mitgefühl für leidende Menschen und dient als Zeichen seines Reiches sowie zur Ermutigung des Glaubens.',
      'refs': ['1. Kor 12,9.28.30', 'Jak 5,14-15', 'Mt 10,8', 'Apg 3,1-10', 'Mk 16,18']
    },
    'G05': {
      'meaning': 'Vollbringen übernatürlicher Machttaten durch Gottes Kraft',
      'desc': 'Die „Wirkungen von Wundern“ beschreiben übernatürliche Machttaten Gottes, die über natürliche Möglichkeiten hinausgehen. Der Ausdruck „energemata dynameon“ bedeutet wörtlich „wirksame Taten von Macht“. In der Bibel zeigt sich diese Gabe z.B. bei Mose, Elia, Jesus und den Aposteln. Wunder können Befreiung, Versorgung, Naturwunder oder andere außergewöhnliche Eingriffe Gottes sein und bestätigen Gottes Macht und das Evangelium.',
      'refs': ['1. Kor 12,10.28.29', 'Apg 5,12', '2. Kor 12,12', 'Mk 16,17-18']
    },
    'G06': {
      'meaning': 'Reden im Auftrag Gottes zur Erbauung, Ermahnung und Tröstung',
      'desc': 'Prophetie ist das vom Heiligen Geist inspirierte Reden im Auftrag Gottes zur Erbauung, Ermahnung und Ermutigung der Gemeinde (1. Kor 14,3). Der Begriff „propheteia“ bedeutet wörtlich „für jemanden sprechen“. Prophetie kann sowohl Offenbarung als auch Anwendung von Gottes Wort auf eine konkrete Situation sein. In der Bibel sehen wir prophetisches Reden bei alttestamentlichen Propheten sowie im Neuen Testament z.B. bei Agabus (Apg 11). Diese Gabe stärkt den Glauben, korrigiert Fehlentwicklungen und richtet den Blick der Gemeinde auf Gottes Willen.',
      'refs': ['Röm 12,6', '1. Kor 12,10', '1. Kor 14,1-5', '1. Thess 5,20', 'Apg 11,27-28']
    },
    'G07': {
      'meaning': 'Unterscheiden zwischen göttlichen, dämonischen und menschlichen Geistern',
      'desc': 'Die Unterscheidung der Geister ist die Fähigkeit, geistliche Einflüsse zu erkennen und zu unterscheiden, ob sie von Gott, vom menschlichen Geist oder von dämonischen Mächten stammen. Der Begriff „diakrisis pneumaton“ bedeutet „Unterscheidung oder Prüfung von Geistern“. In der Bibel zeigt sich diese Gabe z.B. bei Petrus (Apg 5) oder Paulus (Apg 16). Sie schützt die Gemeinde vor Täuschung und hilft, Gottes Wirken klar zu erkennen.',
      'refs': ['1. Kor 12,10', '1. Joh 4,1', 'Apg 5,3', 'Apg 16,16-18', 'Hebr 5,14']
    },
    'G08': {
      'meaning': 'Reden in anderen Sprachen oder in der Gebetssprache des Geistes',
      'desc': 'Die Gabe der Zungenrede beschreibt das vom Heiligen Geist inspirierte Sprechen in einer Sprache, die der Sprecher nicht gelernt hat. Das griechische „gene glosson“ bedeutet „verschiedene Arten von Sprachen“. In der Bibel erscheint diese Gabe erstmals zu Pfingsten (Apg 2) und wird besonders in 1. Korinther 12–14 erklärt. Sie kann sowohl als persönliche Gebetssprache als auch als öffentliches Zeichen für Gottes Wirken dienen.',
      'refs': ['1. Kor 12,10.28.30', '1. Kor 14', 'Apg 2,4-11', 'Apg 19,6', 'Mk 16,17']
    },
    'G09': {
      'meaning': 'Deuten und Übersetzen der Zungenrede zur Erbauung der Gemeinde',
      'desc': 'Die Auslegung der Zungen ist die Fähigkeit, eine Zungenrede zu verstehen und für andere verständlich zu machen. Das griechische „hermeneia glosson“ bedeutet „Übersetzung oder Deutung von Sprachen“. Diese Gabe sorgt dafür, dass eine Zungenrede in der Gemeinde zur Erbauung dient, indem ihre Bedeutung verständlich wird (1. Kor 14).',
      'refs': ['1. Kor 12,10', '1. Kor 14,13.27-28']
    },
    'G10': {
      'meaning': 'Praktisches Dienen und Helfen in der Gemeinde',
      'desc': 'Die Gabe des Dienstes beschreibt eine besondere Befähigung, anderen praktisch zu helfen und Bedürfnisse zu erkennen. Das griechische „diakonia“ bedeutet „Dienst“ oder „praktische Hilfe“. In der Bibel zeigt sich diese Gabe besonders im Dienst der ersten Diakone (Apg 6). Menschen mit dieser Gabe tragen wesentlich dazu bei, dass die Gemeinde praktisch funktioniert und Menschen konkrete Hilfe erfahren.',
      'refs': ['Röm 12,7', '1. Kor 12,28', 'Apg 6,1-7', '1. Petr 4,10-11']
    },
    'G11': {
      'meaning': 'Unterweisen in der Wahrheit Gottes',
      'desc': 'Die Gabe des Lehrens ist die Fähigkeit, Gottes Wort klar, verständlich und treu zu erklären. Der Begriff „didaskalia“ bezeichnet sowohl den Inhalt als auch die Tätigkeit des Lehrens. In der Bibel wird diese Gabe besonders mit Leitungsaufgaben verbunden (Eph 4,11). Sie hilft der Gemeinde, Gottes Wahrheit zu verstehen und im Glauben zu wachsen.',
      'refs': ['Röm 12,7', 'Eph 4,11', '1. Tim 3,2', '2. Tim 2,2']
    },
    'G12': {
      'meaning': 'Ermutigen, Trösten und Ermahnen',
      'desc': 'Die Gabe der Ermutigung oder Ermahnung („paraklesis“) beschreibt die Fähigkeit, Menschen durch Worte zu stärken, zu trösten und zum Glauben zu ermutigen. Das Wort steht in Verbindung mit dem Begriff „Paraklet“, der für den Heiligen Geist als Tröster verwendet wird. Diese Gabe hilft Menschen, schwierige Zeiten zu überwinden und im Glauben weiterzugehen.',
      'refs': ['Röm 12,8', '1. Kor 14,3']
    },
    'G13': {
      'meaning': 'Großzügiges, freudiges Geben mit Einfalt',
      'desc': 'Die Gabe des Gebens beschreibt eine besondere Bereitschaft und Freude, materielle oder finanzielle Ressourcen großzügig weiterzugeben. Das griechische „metadidonai“ bedeutet „teilen“ oder „weitergeben“. In der Bibel sehen wir Beispiele dafür in der frühen Gemeinde (Apg 4). Diese Gabe macht Gottes Versorgung sichtbar und unterstützt die Arbeit des Reiches Gottes.',
      'refs': ['Röm 12,8', 'Apg 4,32-37', '2. Kor 8–9']
    },
    'G14': {
      'meaning': 'Führen und Organisieren der Gemeinde (wie ein Steuermann)',
      'desc': 'Die Gabe der Leitung beschreibt die Fähigkeit, Menschen zu führen, Vision zu vermitteln und Strukturen zu organisieren. Das griechische Wort „proistamenos“ bedeutet „vorstehen“ oder „leiten“. In der Bibel wird diese Gabe mit Verantwortung für die Gemeinde verbunden (1. Thess 5). Sie hilft, dass Dienste koordiniert werden und die Gemeinde gemeinsam vorankommt.',
      'refs': ['Röm 12,8', '1. Kor 12,28', '1. Thess 5,12', '1. Tim 5,17']
    },
    'G15': {
      'meaning': 'Mitgefühl und praktische Hilfe für Leidende',
      'desc': 'Die Gabe der Barmherzigkeit beschreibt ein besonderes Mitgefühl für Menschen in Not und die Bereitschaft, ihnen praktisch zu helfen. Das griechische „eleos“ bedeutet „Erbarmen“ oder „Mitgefühl“. In der Bibel wird Barmherzigkeit als Ausdruck von Gottes Charakter beschrieben (Mt 5,7). Menschen mit dieser Gabe bringen Gottes Liebe besonders zu leidenden Menschen.',
      'refs': ['Röm 12,8', 'Mt 5,7', 'Gal 6,2']
    },
    'G16': {
      'meaning': 'Gesandtsein mit Vollmacht zum Gründen von Gemeinden',
      'desc': 'Die Gabe des Apostels beschreibt eine besondere Berufung, neue Werke oder Gemeinden zu gründen und geistliche Bewegungen zu initiieren. Das Wort „apostolos“ bedeutet „Gesandter“. In der Bibel sehen wir diese Gabe bei den Aposteln, die das Evangelium verbreiteten und Gemeinden gründeten. Diese Gabe verbindet Vision, Leitung und missionarische Dynamik.',
      'refs': ['1. Kor 12,28', 'Eph 4,11', 'Apg 1,21-26', 'Apg 14,14']
    },
    'G17': {
      'meaning': 'Verkündigen der guten Botschaft (Evangelium)',
      'desc': 'Die Gabe des Evangelisten ist die besondere Fähigkeit, Menschen die gute Nachricht von Jesus verständlich und überzeugend zu vermitteln. Das Wort „euangelistes“ bedeutet „Verkündiger der guten Nachricht“. In der Bibel sehen wir diese Gabe z.B. bei Philippus (Apg 21). Evangelisten helfen Menschen, zum Glauben an Christus zu kommen.',
      'refs': ['Eph 4,11', 'Apg 21,8', '2. Tim 4,5']
    },
    'G18': {
      'meaning': 'Weiden, Hüten und Versorgen der Gemeinde als Herde',
      'desc': 'Die Gabe des Hirten beschreibt die Fähigkeit, Menschen geistlich zu begleiten, zu schützen und zu fördern. Das griechische „poimen“ bedeutet „Hirte“. Jesus selbst wird als der gute Hirte beschrieben (Joh 10). Menschen mit dieser Gabe kümmern sich langfristig um das geistliche Wachstum und das Wohl der Gemeinde.',
      'refs': ['Eph 4,11', 'Joh 10,1-18', '1. Petr 5,1-4']
    },
  };

  // Englisch Fallback (Übersetzt)
  final Map<String, Map<String, dynamic>> fallbackDataEn = {
    'G01': {
      'meaning': 'Supernatural word revealing God\'s plan or solution',
      'desc': 'The gift of the word of wisdom describes a word or insight given by the Holy Spirit that reveals God\'s perspective, plan, or solution for a concrete situation. The Greek „logos sophias“ does not mean general wisdom, but a specific, situation-related speaking of God. In the Bible, this gift is seen e.g. with Solomon (1 Kings 3), with the apostles in difficult decisions (Acts 6; Acts 15) or with Jesus himself, who revealed divine wisdom in conflict situations. This gift brings clarity, orientation and divine strategy to complex situations and serves the leadership and edification of the church.',
      'refs': ['1 Cor 12:8', 'Jas 1:5', '1 Kings 3:5-12', 'Ex 31:3', 'Prov 2:6']
    },
    'G02': {
      'meaning': 'Supernatural knowledge or insight into God\'s secrets',
      'desc': 'The word of knowledge describes an insight or information given by the Holy Spirit about a person, situation or spiritual reality that was not gained through natural knowledge. The term „logos gnoseos“ means a concrete revelation of knowledge. In the Bible, this gift is seen e.g. with Peter, who recognizes Ananias’ deception (Acts 5), or with Jesus, who knows the thoughts and life situations of people (John 4). This gift serves to bring truth to light, to help people and to make God\'s work visible.',
      'refs': ['1 Cor 12:8', '1 Cor 13:2']
    },
    'G03': {
      'meaning': 'Special, miracle-working faith that moves mountains',
      'desc': 'The gift of faith is a special confidence worked by the Holy Spirit that God will act in a certain situation. It goes beyond general saving faith and is a supernatural trust in God\'s power and promises. The Greek „pistis“ describes here a strong, firm trust in God\'s action. In the Bible, this gift is seen in people like Abraham (Rom 4) or with the apostles, who courageously expect God\'s work. This gift strengthens others in faith and opens space for God\'s supernatural intervention.',
      'refs': ['1 Cor 12:9', '1 Cor 13:2', 'Matt 17:20', 'Heb 11']
    },
    'G04': {
      'meaning': 'Ability to heal the sick through God\'s power',
      'desc': 'The „gifts of healings“ describe various effects of divine healing through the Holy Spirit. The Greek „charismata iamaton“ is plural and indicates that God grants different types of healings – physical, emotional or spiritual. In the Bible, healings through Jesus and the apostles are frequently described (e.g. Acts 3; Mark 16). This gift shows God\'s compassion for suffering people and serves as a sign of his kingdom and to encourage faith.',
      'refs': ['1 Cor 12:9,28,30', 'Jas 5:14-15', 'Matt 10:8', 'Acts 3:1-10', 'Mark 16:18']
    },
    'G05': {
      'meaning': 'Performing supernatural acts of power through God\'s power',
      'desc': 'The „workings of miracles“ describe supernatural acts of power by God that go beyond natural possibilities. The expression „energemata dynameon“ literally means „effective deeds of power“. In the Bible, this gift is seen e.g. with Moses, Elijah, Jesus and the apostles. Miracles can be deliverance, provision, nature miracles or other extraordinary interventions of God and confirm God\'s power and the Gospel.',
      'refs': ['1 Cor 12:10,28,29', 'Acts 5:12', '2 Cor 12:12', 'Mark 16:17-18']
    },
    'G06': {
      'meaning': 'Speaking on behalf of God for edification, exhortation and comfort',
      'desc': 'Prophecy is speaking inspired by the Holy Spirit on behalf of God for the edification, exhortation and encouragement of the church (1 Cor 14:3). The term „propheteia“ literally means „to speak for someone“. Prophecy can be both revelation and application of God\'s Word to a concrete situation. In the Bible we see prophetic speaking in Old Testament prophets as well as in the New Testament e.g. with Agabus (Acts 11). This gift strengthens faith, corrects wrong developments and directs the church\'s gaze to God\'s will.',
      'refs': ['Rom 12:6', '1 Cor 12:10', '1 Cor 14:1-5', '1 Thess 5:20', 'Acts 11:27-28']
    },
    'G07': {
      'meaning': 'Distinguishing between divine, demonic and human spirits',
      'desc': 'The discernment of spirits is the ability to recognize spiritual influences and to distinguish whether they come from God, from the human spirit or from demonic powers. The term „diakrisis pneumaton“ means „discernment or testing of spirits“. In the Bible, this gift is seen e.g. with Peter (Acts 5) or Paul (Acts 16). It protects the church from deception and helps to clearly recognize God\'s work.',
      'refs': ['1 Cor 12:10', '1 John 4:1', 'Acts 5:3', 'Acts 16:16-18', 'Heb 5:14']
    },
    'G08': {
      'meaning': 'Speaking in other languages or in the prayer language of the Spirit',
      'desc': 'The gift of speaking in tongues describes speaking inspired by the Holy Spirit in a language that the speaker has not learned. The Greek „gene glosson“ means „various kinds of languages“. In the Bible, this gift first appears at Pentecost (Acts 2) and is explained particularly in 1 Corinthians 12–14. It can serve both as a personal prayer language and as a public sign of God\'s work.',
      'refs': ['1 Cor 12:10,28,30', '1 Cor 14', 'Acts 2:4-11', 'Acts 19:6', 'Mark 16:17']
    },
    'G09': {
      'meaning': 'Interpreting and translating the speaking in tongues for the edification of the church',
      'desc': 'The interpretation of tongues is the ability to understand a speaking in tongues and make it understandable for others. The Greek „hermeneia glosson“ means „translation or interpretation of languages“. This gift ensures that a speaking in tongues in the church serves for edification by making its meaning understandable (1 Cor 14).',
      'refs': ['1 Cor 12:10', '1 Cor 14:13,27-28']
    },
    'G10': {
      'meaning': 'Practical serving and helping in the church',
      'desc': 'The gift of service describes a special qualification to help others practically and to recognize needs. The Greek „diakonia“ means „service“ or „practical help“. In the Bible, this gift is seen particularly in the service of the first deacons (Acts 6). People with this gift contribute significantly to the practical functioning of the church and to people experiencing concrete help.',
      'refs': ['Rom 12:7', '1 Cor 12:28', 'Acts 6:1-7', '1 Pet 4:10-11']
    },
    'G11': {
      'meaning': 'Instructing in the truth of God',
      'desc': 'The gift of teaching is the ability to explain God\'s Word clearly, understandably and faithfully. The term „didaskalia“ refers to both the content and the activity of teaching. In the Bible, this gift is particularly associated with leadership tasks (Eph 4:11). It helps the church to understand God\'s truth and to grow in faith.',
      'refs': ['Rom 12:7', 'Eph 4:11', '1 Tim 3:2', '2 Tim 2:2']
    },
    'G12': {
      'meaning': 'Encouraging, comforting and exhorting',
      'desc': 'The gift of encouragement or exhortation („paraklesis“) describes the ability to strengthen, comfort and encourage people in faith through words. The word is related to the term „Paraclete“, which is used for the Holy Spirit as Comforter. This gift helps people to overcome difficult times and to go further in faith.',
      'refs': ['Rom 12:8', '1 Cor 14:3']
    },
    'G13': {
      'meaning': 'Generous, joyful giving with simplicity',
      'desc': 'The gift of giving describes a special willingness and joy to share material or financial resources generously. The Greek „metadidonai“ means „to share“ or „to give“. In the Bible we see examples of this in the early church (Acts 4). This gift makes God\'s provision visible and supports the work of God\'s kingdom.',
      'refs': ['Rom 12:8', 'Acts 4:32-37', '2 Cor 8–9']
    },
    'G14': {
      'meaning': 'Leading and organizing the church (like a steersman)',
      'desc': 'The gift of leadership describes the ability to lead people, convey vision and organize structures. The Greek word „proistamenos“ means „to stand before“ or „to lead“. In the Bible, this gift is associated with responsibility for the church (1 Thess 5). It helps that services are coordinated and the church moves forward together.',
      'refs': ['Rom 12:8', '1 Cor 12:28', '1 Thess 5:12', '1 Tim 5:17']
    },
    'G15': {
      'meaning': 'Compassion and practical help for the suffering',
      'desc': 'The gift of mercy describes a special compassion for people in need and the willingness to help them practically. The Greek „eleos“ means „mercy“ or „compassion“. In the Bible, mercy is described as an expression of God\'s character (Matt 5:7). People with this gift bring God\'s love especially to suffering people.',
      'refs': ['Rom 12:8', 'Matt 5:7', 'Gal 6:2']
    },
    'G16': {
      'meaning': 'Being sent with authority to found churches',
      'desc': 'The gift of the apostle describes a special calling to found new works or churches and to initiate spiritual movements. The word „apostolos“ means „sent one“. In the Bible we see this gift in the apostles who spread the Gospel and founded churches. This gift combines vision, leadership and missionary dynamics.',
      'refs': ['1 Cor 12:28', 'Eph 4:11', 'Acts 1:21-26', 'Acts 14:14']
    },
    'G17': {
      'meaning': 'Proclaiming the good news (Gospel)',
      'desc': 'The gift of the evangelist is the special ability to communicate the good news of Jesus understandably and convincingly to people. The word „euangelistes“ means „proclaimer of the good news“. In the Bible we see this gift e.g. with Philip (Acts 21). Evangelists help people to come to faith in Christ.',
      'refs': ['Eph 4:11', 'Acts 21:8', '2 Tim 4:5']
    },
    'G18': {
      'meaning': 'Pasturing, tending and providing for the church as a flock',
      'desc': 'The gift of the shepherd describes the ability to accompany, protect and promote people spiritually. The Greek „poimen“ means „shepherd“. Jesus himself is described as the good shepherd (John 10). People with this gift take care of the spiritual growth and the welfare of the church in the long term.',
      'refs': ['Eph 4:11', 'John 10:1-18', '1 Pet 5:1-4']
    },
  };

  for (var gift in gifts) {
    final id = gift['id'];
    if (locale == 'de' && fallbackDataDe.containsKey(id)) {
      final data = fallbackDataDe[id]!;
      if ((gift['meaning'] as String).isEmpty) gift['meaning'] = data['meaning'];
      if ((gift['description'] as String).isEmpty) gift['description'] = data['desc'];
      if ((gift['bibleReferences'] as List).isEmpty) gift['bibleReferences'] = data['refs'];
    } else if (locale == 'en' && fallbackDataEn.containsKey(id)) {
      final data = fallbackDataEn[id]!;
      if ((gift['meaning'] as String).isEmpty) gift['meaning'] = data['meaning'];
      if ((gift['description'] as String).isEmpty) gift['description'] = data['desc'];
      if ((gift['bibleReferences'] as List).isEmpty) gift['bibleReferences'] = data['refs'];
    }
  }
}

List<String> _splitCsvLine(String line) {
  final List<String> result = [];
  bool inQuotes = false;
  StringBuffer current = StringBuffer();

  for (var i = 0; i < line.length; i++) {
    final char = line[i];
    if (char == '"') {
      inQuotes = !inQuotes;
    } else if (char == ',' && !inQuotes) {
      result.add(current.toString());
      current.clear();
    } else {
      current.write(char);
    }
  }
  result.add(current.toString());
  return result;
}
