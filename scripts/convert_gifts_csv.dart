import 'dart:io';
import 'dart:convert';

void main() {
  final input = File('docs/data/gift_test.de.csv');
  final lines = input.readAsLinesSync();
  
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
        'id': _generateId(giftName),
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
      final type = typeChar == 'E' ? 'experience' : (typeChar == 'N' ? 'nature' : 'feedback');
      
      currentGift['questions'].add({
        'id': '${currentGift['id']}_${currentGift['questions'].length + 1}',
        'type': type,
        'text': parts[6].trim(),
      });
    }
  }

  final output = File('assets/data/gifts_de.json');
  output.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(gifts));
  print('Erfolgreich ${gifts.length} Gaben konvertiert.');
}

String _generateId(String name) {
  return name.toLowerCase()
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
