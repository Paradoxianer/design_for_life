import 'dart:convert';
import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/feedback_question.dart';
import '../models/feedback_response.dart';

/// Teilt die Feedback-Antworten als CSV statt als Bild/Text (#7): eine Zeile
/// pro Frage (Kategorie, Frage, Antwort), damit ein Kursleiter die Exporte
/// aller Teilnehmenden einfach zu einer Tabelle zusammenführen kann.
class FeedbackCsvExporter {
  const FeedbackCsvExporter._();

  static String buildCsv(
    FeedbackQuestionnaire questionnaire,
    FeedbackResponse response, {
    required String categoryColumnLabel,
    required String questionColumnLabel,
    required String answerColumnLabel,
  }) {
    final buffer = StringBuffer();
    buffer.writeln(_row([categoryColumnLabel, questionColumnLabel, answerColumnLabel]));
    for (final category in questionnaire.categories) {
      for (final question in category.questions) {
        final answer = question.type == FeedbackQuestionType.scale
            ? (response.scaleAnswer(question.id)?.toString() ?? '')
            : response.textAnswer(question.id);
        buffer.writeln(_row([category.title, question.label, answer]));
      }
    }
    return buffer.toString();
  }

  static String _row(List<String> fields) => fields.map(_escapeCsvField).join(',');

  /// RFC4180-artiges Escaping: Felder mit Komma, Anführungszeichen oder
  /// Zeilenumbruch werden in Anführungszeichen gesetzt, enthaltene
  /// Anführungszeichen verdoppelt.
  static String _escapeCsvField(String field) {
    if (field.contains(',') || field.contains('"') || field.contains('\n') || field.contains('\r')) {
      return '"${field.replaceAll('"', '""')}"';
    }
    return field;
  }

  static Future<void> share({
    required FeedbackQuestionnaire questionnaire,
    required FeedbackResponse response,
    required String filename,
    required String subject,
    required String categoryColumnLabel,
    required String questionColumnLabel,
    required String answerColumnLabel,
  }) async {
    final csv = buildCsv(
      questionnaire,
      response,
      categoryColumnLabel: categoryColumnLabel,
      questionColumnLabel: questionColumnLabel,
      answerColumnLabel: answerColumnLabel,
    );
    // UTF-8-BOM voranstellen, damit Excel Umlaute beim Öffnen korrekt erkennt
    // statt sie als Ersatzzeichen darzustellen.
    final bytes = Uint8List.fromList([0xEF, 0xBB, 0xBF, ...utf8.encode(csv)]);

    final file = await _toXFile(bytes, filename);
    await Share.shareXFiles([file], subject: subject);
  }

  /// Siehe share_image_generator.dart::_toXFile für den Hintergrund: auf
  /// Mobile/Desktop ignoriert cross_file's XFile.fromData den name-Parameter,
  /// daher dort ein echter, eindeutig benannter Temp-Datei-Pfad.
  static Future<XFile> _toXFile(Uint8List bytes, String fileName) async {
    if (kIsWeb) {
      return XFile.fromData(bytes, name: fileName, mimeType: 'text/csv');
    }
    final directory = await getTemporaryDirectory();
    final uniqueName = '${DateTime.now().microsecondsSinceEpoch}_$fileName';
    final path = '${directory.path}/$uniqueName';
    await io.File(path).writeAsBytes(bytes);
    return XFile(path, mimeType: 'text/csv');
  }
}
