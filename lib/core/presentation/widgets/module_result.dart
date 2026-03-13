import 'package:flutter/material.dart';
import 'key_takeaway_component.dart';

/// Die Basis-Klasse für alle Result-Views im System.
abstract class ModuleResult extends StatelessWidget {
  final List<String> takeaways;

  const ModuleResult({
    super.key,
    required this.takeaways,
  });

  /// Hier implementiert das jeweilige Modul seine spezifische Anzeige (Graphen, Texte, etc.).
  Widget buildResultContent(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildResultContent(context),
        const SizedBox(height: 32),
        // Jedes Modul im Result-Modus zeigt automatisch die Takeaways schreibgeschützt an
        KeyTakeawayComponent(
          takeaways: takeaways,
          onUpdate: (_, __) {}, // Keine Funktion im Read-Only Modus
          isReadOnly: true,
        ),
      ],
    );
  }
}
