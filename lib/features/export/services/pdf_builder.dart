import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:design_for_life/core/models/export_document.dart';

/// Rendert ein [ExportDocument] als PDF (#27). Bilder werden proportional
/// eingebettet (BoxFit.contain) statt verzerrt oder abgeschnitten - wichtig
/// für größere Inhalte wie den Lebensbaum-Graphen (#30). Ein fehlerhafter
/// Abschnitt darf die restlichen Seiten nicht verhindern.
class PdfBuilder {
  const PdfBuilder._();

  static Future<Uint8List> build(ExportDocument document) async {
    // Die Standard-PDF-Schrift (Helvetica) kann keine Umlaute/ß darstellen.
    // PdfGoogleFonts lädt Noto Sans herunter und cached es lokal, damit
    // spätere Exports auch offline funktionieren.
    pw.Font? regularFont;
    pw.Font? boldFont;
    try {
      regularFont = await PdfGoogleFonts.notoSansRegular();
      boldFont = await PdfGoogleFonts.notoSansBold();
    } catch (e) {
      debugPrint('Could not load Unicode PDF font, falling back to default: $e');
    }

    final pdf = pw.Document(
      theme: regularFont != null
          ? pw.ThemeData.withFont(base: regularFont, bold: boldFont)
          : null,
    );

    pw.ImageProvider? logo;
    try {
      final logoBytes = (await rootBundle.load('assets/DFL_Logo.png')).buffer.asUint8List();
      logo = pw.MemoryImage(logoBytes);
    } catch (e) {
      debugPrint('Could not load DFL logo for PDF header: $e');
    }

    for (final section in document.sections) {
      try {
        pdf.addPage(
          pw.MultiPage(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(32),
            header: (context) => pw.Row(
              children: [
                if (logo != null) ...[
                  pw.Image(logo, height: 32),
                  pw.SizedBox(width: 12),
                ],
                pw.Text(
                  section.title,
                  style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
            build: (context) => [
              pw.SizedBox(height: 12),
              for (final text in section.textBlocks) ...[
                pw.Paragraph(text: text, style: const pw.TextStyle(fontSize: 12)),
              ],
              for (final imageBytes in section.images) ...[
                pw.SizedBox(height: 12),
                pw.Image(pw.MemoryImage(imageBytes), fit: pw.BoxFit.contain),
              ],
            ],
          ),
        );
      } catch (e) {
        debugPrint('Error adding export PDF section "${section.title}": $e');
      }
    }

    if (document.sections.isEmpty) {
      pdf.addPage(pw.Page(build: (context) => pw.Center(child: pw.Text('-'))));
    }

    return pdf.save();
  }
}
