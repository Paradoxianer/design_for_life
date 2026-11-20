import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/leader_note_block.dart';
import '../models/leader_note_session.dart';

/// Baut aus den Leiter-Infos (#83) ein Leiterheft als PDF: erst die Checkliste
/// samt Mitarbeiterschulung, danach die Einheiten in ihrer Reihenfolge. Die
/// Inhalte kommen aus denselben JSON-Dateien wie die Leiter-Info in der App,
/// das PDF ist also immer so aktuell wie die App.
class LeaderBookletPdf {
  const LeaderBookletPdf._();

  /// Reihenfolge: Checkliste zuerst, dann session_1, session_2, ...
  /// (numerisch, nicht alphabetisch - sonst käme session_10 vor session_2).
  static List<MapEntry<String, LeaderNoteSession>> orderedSessions(
    Map<String, LeaderNoteSession> sessions,
  ) {
    int rank(String id) {
      if (id == 'session_checklist') return -1;
      final number = int.tryParse(id.replaceFirst('session_', ''));
      return number ?? 1000;
    }

    final entries = sessions.entries.toList()
      ..sort((a, b) => rank(a.key).compareTo(rank(b.key)));
    return entries;
  }

  static Future<Uint8List> build(
    Map<String, LeaderNoteSession> sessions, {
    required String title,
  }) async {
    pw.ThemeData? theme;
    try {
      // Gebündelte Unicode-Schrift (Umlaute/ß), funktioniert offline.
      final regular = pw.Font.ttf(
        await rootBundle.load('assets/fonts/NotoSans-Regular.ttf'),
      );
      final bold = pw.Font.ttf(
        await rootBundle.load('assets/fonts/NotoSans-Bold.ttf'),
      );
      theme = pw.ThemeData.withFont(base: regular, bold: bold);
    } catch (_) {
      theme = null;
    }

    final pdf = pw.Document(theme: theme, title: title);
    final ordered = orderedSessions(sessions);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        footer: (context) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            '$title – ${context.pageNumber}/${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
          ),
        ),
        build: (context) => [
          pw.Text(
            title,
            style: pw.TextStyle(fontSize: 26, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 16),
          for (final entry in ordered) ..._sessionWidgets(entry.value),
        ],
      ),
    );

    return pdf.save();
  }

  static List<pw.Widget> _sessionWidgets(LeaderNoteSession session) {
    return [
      pw.SizedBox(height: 18),
      pw.Header(
        level: 0,
        text: session.sessionTitle,
        textStyle: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
      ),
      for (final section in session.sections) ...[
        pw.SizedBox(height: 8),
        pw.Text(
          section.heading,
          style: pw.TextStyle(
            fontSize: 13,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blueGrey800,
          ),
        ),
        pw.SizedBox(height: 4),
        for (final block in section.blocks) ..._blockWidgets(block),
      ],
    ];
  }

  static List<pw.Widget> _blockWidgets(LeaderNoteBlock block) {
    const body = pw.TextStyle(fontSize: 10.5, lineSpacing: 2);
    switch (block) {
      case LeaderNoteSubheading(:final text):
        return [
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 4, bottom: 2),
            child: pw.Text(
              text,
              style: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
        ];
      case LeaderNoteParagraph(:final text):
        if (text.isEmpty) return const [];
        return [
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 6),
            child: pw.Text(text, style: body),
          ),
        ];
      case LeaderNoteBulletList(:final items):
        return [
          for (final item in items)
            pw.Padding(
              padding: const pw.EdgeInsets.only(left: 8, bottom: 2),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(width: 12, child: pw.Text('•', style: body)),
                  pw.Expanded(child: pw.Text(item, style: body)),
                ],
              ),
            ),
          pw.SizedBox(height: 4),
        ];
      case LeaderNoteChecklist(:final items):
        return [
          for (final item in items)
            pw.Padding(
              padding: const pw.EdgeInsets.only(left: 8, bottom: 2),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    width: 8,
                    height: 8,
                    margin: const pw.EdgeInsets.only(top: 2, right: 6),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey700),
                    ),
                  ),
                  pw.Expanded(child: pw.Text(item, style: body)),
                ],
              ),
            ),
          pw.SizedBox(height: 4),
        ];
      case LeaderNoteNumberedList(:final items):
        return [
          for (final (index, item) in items.indexed)
            pw.Padding(
              padding: const pw.EdgeInsets.only(left: 8, bottom: 2),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(
                    width: 16,
                    child: pw.Text('${index + 1}.', style: body),
                  ),
                  pw.Expanded(child: pw.Text(item, style: body)),
                ],
              ),
            ),
          pw.SizedBox(height: 4),
        ];
      case LeaderNoteQuote(:final text, :final reference):
        return [
          pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 6, left: 6),
            padding: const pw.EdgeInsets.only(left: 8),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                left: pw.BorderSide(color: PdfColors.blueGrey400, width: 2),
              ),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(text, style: body),
                if (reference.isNotEmpty)
                  pw.Text(
                    reference,
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        ];
      case LeaderNoteQuestion(:final text):
        return [
          pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 6),
            padding: const pw.EdgeInsets.all(6),
            color: PdfColors.grey200,
            child: pw.Text(
              '? $text',
              style: pw.TextStyle(fontSize: 10.5, fontWeight: pw.FontWeight.bold),
            ),
          ),
        ];
      case LeaderNoteVideo(:final label, :final url):
        return [
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 6),
            child: pw.Text(
              url == null ? '▶ $label' : '▶ $label ($url)',
              style: body,
            ),
          ),
        ];
    }
  }
}
