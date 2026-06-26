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
    if (line.isEmpty || line == ',,,,,,') continue;

    final parts = _splitCsvLine(line);
    if (parts.length < 7) continue;

    final giftName = parts[0].trim();
    
    if (giftName.isNotEmpty) {
      // Neue Gabe gefunden
      currentGift = {
        'id': _generateId(giftName, locale),
        'name': giftName,
        'originalWord': parts[1].trim(),
        'meaning': parts[2].trim(),
        'bibleReferences': parts[3].split(';').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
        'description': parts[4].trim(),
        'questions': [],
      };
      gifts.add(currentGift);
    }

    if (currentGift != null && parts[6].isNotEmpty) {
      final typeChar = parts[5].trim().toUpperCase();
      final type = typeChar == 'E' ? 'experience' : 
                   (typeChar == 'N' ? 'nature' : 
                   (typeChar == 'F' ? 'feedback' : 'reference'));
      
      currentGift['questions'].add({
        'id': '${currentGift['id']}_${currentGift['questions'].length + 1}',
        'type': type,
        'text': parts[6].trim(),
      });
    }
  }

  final output = File('assets/data/gifts_$locale.json');
  output.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(gifts));
  print('Erfolgreich ${gifts.length} Gaben für $locale konvertiert.');
}

String _generateId(String name, String locale) {
  // Wir mappen englische Namen auf die gleichen IDs wie deutsche, 
  // falls sie in einer Map definiert sind. Ansonsten generieren wir sie.
  // Für die Konsistenz zwischen den Sprachen wäre eine feste ID-Map ideal.
  final Map<String, String> translationMap = {
    'word of wisdom': 'wort_der_weisheit',
    'word of knowledge': 'wort_der_erkenntnis',
    'faith': 'glaube',
    'gifts of healings': 'gaben_der_heilungen',
    'working of miracles': 'wirkungen_von_wundern',
    'prophecy': 'prophetie',
    'discerning of spirits': 'unterscheidung_der_geister',
    'kinds of tongues': 'arten_von_zungen',
    'interpretation of tongues': 'auslegung_der_zungen',
    'service': 'dienst_diakonie',
    'teaching': 'lehren',
    'exhortation': 'ermahnung_zuspruch',
    'giving': 'geben',
    'leadership': 'leiten_verwalten',
    'mercy': 'barmherzigkeit',
    'apostleship': 'apostelamt',
    'evangelist': 'evangelist',
    'shepherd': 'hirte_pastor',
  };

  final lowerName = name.toLowerCase();
  if (translationMap.containsKey(lowerName)) {
    return translationMap[lowerName]!;
  }

  return lowerName
      .replaceAll(' / ', '_')
      .replaceAll(' ', '_')
      .replaceAll('ä', 'ae')
      .replaceAll('ö', 'oe')
      .replaceAll('ü', 'ue')
      .replaceAll('ß', 'ss');
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
