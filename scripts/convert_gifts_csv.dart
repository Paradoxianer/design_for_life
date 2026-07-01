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

  final rawHeader = _splitCsvLine(lines[0]);
  print('Header ($locale): $rawHeader');
  final colMap = {for (var i = 0; i < rawHeader.length; i++) rawHeader[i].trim().toLowerCase(): i};

  int getCol(List<String> keys) {
    for (final key in keys) {
      if (colMap.containsKey(key.toLowerCase())) return colMap[key.toLowerCase()]!;
    }
    return -1;
  }

  final idxGiftId = getCol(['gabe-id', 'id']);
  final idxGiftName = getCol(['geistesgabe', 'gift', 'name']);
  final idxOriginalWord = getCol(['originalwort (sprache)', 'original word']);
  final idxMeaning = getCol(['wortbedeutung', 'meaning']);
  final idxRefs = getCol(['bibelstellen', 'bible references', 'references']);
  final idxDesc = getCol(['beschreibung', 'description']);
  final idxType = getCol(['fragetyp', 'kategorie', 'type', 'category']);
  final idxQuestion = getCol(['frage', 'test-frage (biblischer bezug)', 'question', 'text']);
  final idxQuestionId = getCol(['frage-id', 'question id']);

  print('Indices ($locale): ID:$idxGiftId, Name:$idxGiftName, Orig:$idxOriginalWord, Meaning:$idxMeaning, Refs:$idxRefs, Desc:$idxDesc, Type:$idxType, Q:$idxQuestion');

  final List<Map<String, dynamic>> gifts = [];
  Map<String, dynamic>? currentGift;

  final nameToIdMap = {
    'Wort der Weisheit': 'G01',
    'Word of Wisdom': 'G01',
    'Wort der Erkenntnis': 'G02',
    'Word of Knowledge': 'G02',
    'Glaube': 'G03',
    'Faith': 'G03',
    'Gaben der Heilungen': 'G04',
    'Healing': 'G04',
    'Wirkungen von Wundern': 'G05',
    'Working of Miracles': 'G05',
    'Prophetie': 'G06',
    'Prophecy': 'G06',
    'Unterscheidung der Geister': 'G07',
    'Discernment of Spirits': 'G07',
    'Zungenrede': 'G08',
    'Praying in Tongues': 'G08',
    'Auslegung der Zungenrede': 'G09',
    'Auslegung der Zungen': 'G09',
    'Interpretation of Tongues': 'G09',
    'Dienst / Diakonie': 'G10',
    'Service / Diakonie': 'G10',
    'Lehren': 'G11',
    'Teaching': 'G11',
    'Ermahnung': 'G12',
    'Exhortation / Encouragement': 'G12',
    'Geben': 'G13',
    'Giving': 'G13',
    'Leiten': 'G14',
    'Leadership / Administration': 'G14',
    'Barmherzigkeit': 'G15',
    'Mercy': 'G15',
    'Apostelamt': 'G16',
    'Apostleship': 'G16',
    'Apostel': 'G16',
    'Evangelist': 'G17',
    'Hirte': 'G18',
    'Shepherd / Pastor': 'G18',
  };

  for (var i = 1; i < lines.length; i++) {
    final line = lines[i].trim();
    if (line.isEmpty) continue;

    final parts = _splitCsvLine(line);
    
    String? rowGiftName;
    if (idxGiftName != -1 && idxGiftName < parts.length) {
      rowGiftName = parts[idxGiftName].trim();
    }

    if (rowGiftName != null && rowGiftName.isNotEmpty) {
      String? giftId;
      if (idxGiftId != -1 && idxGiftId < parts.length && parts[idxGiftId].trim().isNotEmpty) {
        giftId = parts[idxGiftId].trim();
      } else {
        giftId = nameToIdMap[rowGiftName] ?? nameToIdMap[rowGiftName.replaceAll(' / ', '/')] ?? 'GXX';
      }

      if (currentGift == null || currentGift['id'] != giftId) {
        currentGift = {
          'id': giftId,
          'name': rowGiftName,
          'originalWord': idxOriginalWord != -1 && idxOriginalWord < parts.length ? parts[idxOriginalWord].trim() : '',
          'meaning': idxMeaning != -1 && idxMeaning < parts.length ? parts[idxMeaning].trim() : '',
          'bibleReferences': idxRefs != -1 && idxRefs < parts.length 
              ? parts[idxRefs].split(';').map((e) => e.trim()).where((e) => e.isNotEmpty).toList() 
              : [],
          'description': idxDesc != -1 && idxDesc < parts.length ? parts[idxDesc].trim() : '',
          'questions': [],
        };
        gifts.add(currentGift);
      }
    }

    if (currentGift != null) {
      final qText = idxQuestion != -1 && idxQuestion < parts.length ? parts[idxQuestion].trim() : '';
      if (qText.isNotEmpty) {
        final qTypeRaw = idxType != -1 && idxType < parts.length ? parts[idxType].trim().toUpperCase() : '';
        String finalType = 'reference';
        if (qTypeRaw == 'E' || qTypeRaw == 'EXPERIENCE') finalType = 'experience';
        else if (qTypeRaw == 'N' || qTypeRaw == 'NATURE') finalType = 'nature';
        else if (qTypeRaw == 'F' || qTypeRaw == 'FRUIT' || qTypeRaw == 'FEEDBACK') finalType = 'feedback';
        else if (qTypeRaw == 'R' || qTypeRaw == 'REFERENCE') finalType = 'reference';

        final qId = idxQuestionId != -1 && idxQuestionId < parts.length && parts[idxQuestionId].trim().isNotEmpty
            ? parts[idxQuestionId].trim()
            : '${currentGift['id']}_Q${currentGift['questions'].length + 1}';

        currentGift['questions'].add({
          'id': qId,
          'type': finalType,
          'text': qText,
        });
      }
    }
  }

  // Fallback for missing data
  for (var gift in gifts) {
    if (gift['originalWord'].isEmpty || gift['meaning'].isEmpty || gift['description'].isEmpty) {
       _applySpecificFallback(gift, locale);
    }
  }

  final output = File('assets/data/gifts_$locale.json');
  output.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(gifts));
  print('Erfolgreich ${gifts.length} Gaben für $locale konvertiert.');
}

void _applySpecificFallback(Map<String, dynamic> gift, String locale) {
  // Simple fallback logic if needed, but CSV should be primary
}

List<String> _splitCsvLine(String line) {
  final List<String> result = [];
  bool inQuotes = false;
  StringBuffer current = StringBuffer();

  for (var i = 0; i < line.length; i++) {
    final char = line[i];
    if (char == '"') {
      if (inQuotes && i + 1 < line.length && line[i + 1] == '"') {
        // Double quotes escaped
        current.write('"');
        i++;
      } else {
        inQuotes = !inQuotes;
      }
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
