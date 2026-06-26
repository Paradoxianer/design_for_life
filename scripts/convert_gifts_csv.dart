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
    if (parts.length < 9) continue;

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
        'description': parts[6].trim(),
        'questions': [],
      };
      gifts.add(currentGift);
    }

    if (currentGift != null && parts[8].isNotEmpty) {
      final typeChar = parts[7].trim().toUpperCase();
      final type = typeChar == 'ERLEBNIS' || typeChar == 'EXPERIENCE' ? 'experience' : 
                   (typeChar == 'NEIGUNG' || typeChar == 'NATURE' ? 'nature' : 
                   (typeChar == 'FRUCHT' || typeChar == 'FRUIT' ? 'feedback' : 'reference'));
      
      currentGift['questions'].add({
        'id': parts[2].trim().isNotEmpty ? parts[2].trim() : '${currentGift['id']}_Q${currentGift['questions'].length + 1}',
        'type': type,
        'text': parts[8].trim(),
      });
    }
  }

  final output = File('assets/data/gifts_$locale.json');
  output.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(gifts));
  print('Erfolgreich ${gifts.length} Gaben für $locale konvertiert.');
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
