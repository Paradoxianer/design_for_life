import 'package:flutter/material.dart';

/// Frage-Karte für eine Skala zwischen zwei gegensätzlichen Aussagen (#50):
/// [leftLabel] entspricht Wert 1, [rightLabel] entspricht Wert 6.
///
/// Bewusst ein Schieberegler statt einzelner Symbole/Zahlen: man zieht ihn
/// einfach in die Richtung, zu der man mehr tendiert - das ist unmissver-
/// ständlich, weil die Richtung selbst die Bedeutung trägt. Frühere Versuche
/// (reine Zahlen 1-6, Daumen-Symbole) waren beide verwirrend: Zahlen allein
/// ließen offen, welche Aussage mit "1"/"6" gemeint war, und Daumen tragen
/// eine "gut/schlecht"-Wertung in sich, die bei einer neutralen
/// Persönlichkeits-Skala (keine Seite ist "besser") in die Irre führt.
class BipolarQuestionCard extends StatelessWidget {
  final String leftLabel;
  final String rightLabel;
  final int? currentValue;
  final ValueChanged<int> onChanged;

  const BipolarQuestionCard({
    super.key,
    required this.leftLabel,
    required this.rightLabel,
    required this.currentValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasAnswered = currentValue != null;
    // Ohne Antwort steht der Regler sichtbar neutral in der Mitte (3.5,
    // zwischen den Stufen 3 und 4) statt auf einem der beiden Enden zu
    // starten - das würde fälschlich wie eine bereits getroffene Auswahl
    // aussehen.
    final sliderValue = (currentValue ?? 3.5).toDouble();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: hasAnswered ? 1 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: hasAnswered ? theme.colorScheme.primary.withValues(alpha: 0.4) : theme.dividerColor,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    leftLabel,
                    textAlign: TextAlign.left,
                    style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    rightLabel,
                    textAlign: TextAlign.right,
                    style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            SliderTheme(
              data: theme.sliderTheme.copyWith(
                trackHeight: 3,
                thumbColor: hasAnswered ? theme.colorScheme.primary : theme.colorScheme.outline,
                activeTrackColor: hasAnswered ? theme.colorScheme.primary : theme.colorScheme.outline,
                inactiveTrackColor: theme.colorScheme.surfaceContainerHighest,
                overlayColor: theme.colorScheme.primary.withValues(alpha: 0.15),
              ),
              child: Slider(
                value: sliderValue,
                min: 1,
                max: 6,
                divisions: 5,
                onChanged: (value) => onChanged(value.round()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
