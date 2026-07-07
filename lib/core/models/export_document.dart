import 'dart:typed_data';

/// Ein Abschnitt des Abschluss-Exports - ein Modul (Werte, Geistesgaben, ...).
/// Bewusst einfach gehalten: Bilder (bereits fertig gerendert, inkl. Branding)
/// und optionale Textblöcke, kein eigenes Rendering-Modell (#28).
class ExportSection {
  final String title;
  final List<Uint8List> images;
  final List<String> textBlocks;

  const ExportSection({
    required this.title,
    this.images = const [],
    this.textBlocks = const [],
  });

  bool get isEmpty => images.isEmpty && textBlocks.isEmpty;
}

/// Das gesamte Abschlussdokument: eine Liste ausgewählter, nicht-leerer
/// Abschnitte. Wird direkt zu PDF gerendert (#27).
class ExportDocument {
  final List<ExportSection> sections;

  const ExportDocument({required this.sections});
}
