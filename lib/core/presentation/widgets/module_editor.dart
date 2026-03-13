import 'package:flutter/material.dart';
import 'key_takeaway_component.dart';

/// Die Basis-Klasse für alle Editoren im System.
/// Jedes Modul (Gaben, Werte, Notizen) leitet hiervon ab.
abstract class ModuleEditor extends StatelessWidget {
  final List<String> takeaways;
  final Function(int, String) onTakeawayUpdate;

  const ModuleEditor({
    super.key,
    required this.takeaways,
    required this.onTakeawayUpdate,
  });

  /// Hier implementiert das jeweilige Modul seine spezifischen Eingabefelder.
  Widget buildEditorContent(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildEditorContent(context),
        const SizedBox(height: 32),
        // Jedes Modul im Edit-Modus hat automatisch die Takeaway-Eingabe
        KeyTakeawayComponent(
          takeaways: takeaways,
          onUpdate: onTakeawayUpdate,
          isReadOnly: false,
        ),
      ],
    );
  }
}
