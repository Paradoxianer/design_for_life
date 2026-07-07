import 'package:flutter_test/flutter_test.dart';
import 'package:design_for_life/core/models/export_document.dart';
import 'package:design_for_life/features/export/services/pdf_builder.dart';

void main() {
  group('PdfBuilder', () {
    test('produces a valid, non-empty PDF for a text-only section', () async {
      const doc = ExportDocument(
        sections: [
          ExportSection(title: 'Werte', textBlocks: ['1. Ehrlichkeit\n2. Familie']),
        ],
      );

      final bytes = await PdfBuilder.build(doc);

      expect(bytes, isNotEmpty);
      expect(String.fromCharCodes(bytes.take(4)), '%PDF');
    });

    test('does not throw for an empty document', () async {
      final bytes = await PdfBuilder.build(const ExportDocument(sections: []));
      expect(bytes, isNotEmpty);
    });
  });
}
