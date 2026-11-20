import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:design_for_life/l10n/generated/app_localizations.dart';

/// Vorlagen für Leiter (Urkunde, Zeitpläne), die direkt aus den Sprachtexten
/// der App als PDF erzeugt werden - so sind sie in jeder App-Sprache
/// verfügbar, ohne pro Sprache eine Datei pflegen zu müssen.
class LeaderTemplatesPdf {
  const LeaderTemplatesPdf._();

  static Future<pw.ThemeData?> _theme() async {
    try {
      final regular = pw.Font.ttf(
        await rootBundle.load('assets/fonts/NotoSans-Regular.ttf'),
      );
      final bold = pw.Font.ttf(
        await rootBundle.load('assets/fonts/NotoSans-Bold.ttf'),
      );
      return pw.ThemeData.withFont(base: regular, bold: bold);
    } catch (_) {
      return null;
    }
  }

  /// Eine Urkunde pro Name; ohne Namen eine Urkunde mit Linie zum
  /// Handausfüllen.
  static Future<Uint8List> certificates(
    AppLocalizations l10n, {
    List<String> names = const [],
    String place = '',
    String date = '',
  }) async {
    final pdf = pw.Document(
      theme: await _theme(),
      title: l10n.certificateTitle,
    );

    pw.ImageProvider? logo;
    try {
      logo = pw.MemoryImage(
        (await rootBundle.load('assets/DFL_Logo.png')).buffer.asUint8List(),
      );
    } catch (_) {
      logo = null;
    }

    final cleaned = names
        .map((n) => n.trim())
        .where((n) => n.isNotEmpty)
        .toList();
    final recipients = cleaned.isEmpty ? <String?>[null] : cleaned;
    final placeDate = [place.trim(), date.trim()]
        .where((s) => s.isNotEmpty)
        .join(', ');

    for (final name in recipients) {
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(48),
          build: (context) => pw.Container(
            padding: const pw.EdgeInsets.all(32),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.blueGrey700, width: 2),
            ),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Column(
                  children: [
                    if (logo != null) pw.SizedBox(height: 90, child: pw.Image(logo)),
                    pw.SizedBox(height: 24),
                    pw.Text(
                      l10n.certificateTitle,
                      style: pw.TextStyle(
                        fontSize: 34,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 36),
                    if (name != null)
                      pw.Text(
                        name,
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      )
                    else
                      pw.Container(
                        width: 280,
                        height: 28,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            bottom: pw.BorderSide(color: PdfColors.black),
                          ),
                        ),
                      ),
                    pw.SizedBox(height: 24),
                    pw.Text(
                      l10n.certificateParticipated,
                      style: const pw.TextStyle(fontSize: 14),
                    ),
                    pw.SizedBox(height: 12),
                    pw.Text(
                      l10n.certificateCourse,
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 28),
                    pw.Text(
                      l10n.certificateDescription,
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 12, lineSpacing: 3),
                    ),
                    pw.SizedBox(height: 28),
                    pw.Text(
                      l10n.certificateVerse,
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 11, lineSpacing: 3),
                    ),
                    pw.SizedBox(height: 6),
                    pw.Text(
                      l10n.certificateVerseRef,
                      style: pw.TextStyle(
                        fontSize: 11,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    _signatureLine(l10n.certificateSignature, ''),
                    _signatureLine(l10n.certificatePlaceDate, placeDate),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
    return pdf.save();
  }

  static pw.Widget _signatureLine(String label, String value) {
    return pw.SizedBox(
      width: 200,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            height: 24,
            alignment: pw.Alignment.bottomLeft,
            decoration: const pw.BoxDecoration(
              border: pw.Border(bottom: pw.BorderSide(color: PdfColors.black)),
            ),
            child: pw.Text(value, style: const pw.TextStyle(fontSize: 12)),
          ),
          pw.SizedBox(height: 3),
          pw.Text(label, style: const pw.TextStyle(fontSize: 9)),
        ],
      ),
    );
  }

  /// Zwei leere Zeitpläne (Hörendes Gebet, Persönliches Gespräch) zum
  /// Ausdrucken und Ausfüllen.
  static Future<Uint8List> schedules(
    AppLocalizations l10n, {
    int rows = 14,
  }) async {
    final pdf = pw.Document(
      theme: await _theme(),
      title: l10n.leaderTemplateSchedulesTitle,
    );

    pw.Widget table(List<String> headers) {
      return pw.Table(
        border: pw.TableBorder.all(color: PdfColors.grey700),
        columnWidths: {
          0: const pw.FlexColumnWidth(1),
          for (var i = 1; i < headers.length; i++) i: const pw.FlexColumnWidth(2),
        },
        children: [
          pw.TableRow(
            decoration: const pw.BoxDecoration(color: PdfColors.grey200),
            children: [
              for (final h in headers)
                pw.Padding(
                  padding: const pw.EdgeInsets.all(6),
                  child: pw.Text(
                    h,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
            ],
          ),
          for (var r = 0; r < rows; r++)
            pw.TableRow(
              children: [
                for (final _ in headers) pw.SizedBox(height: 28),
              ],
            ),
        ],
      );
    }

    void page(String title, List<String> headers) {
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                title,
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 16),
              table(headers),
            ],
          ),
        ),
      );
    }

    page(l10n.scheduleListeningPrayerTitle, [
      l10n.scheduleTime,
      l10n.scheduleWho,
    ]);
    page(l10n.scheduleConversationTitle, [
      l10n.scheduleTime,
      l10n.scheduleWho,
      l10n.scheduleConversationLeader,
    ]);
    return pdf.save();
  }
}
