import 'package:flutter/material.dart';

/// Frage-Karte für eine Skala zwischen zwei gegensätzlichen Aussagen (#50):
/// [leftLabel] entspricht Wert 1, [rightLabel] entspricht Wert 6. Die
/// Auswahl-Kreise zeigen statt reiner Zahlen einen Daumen-Verlauf (voll
/// nach oben bis voll nach unten), damit auf einen Blick klar ist, in
/// welche Richtung jede Position zeigt - Zahlen allein ließen offen, welche
/// der beiden Aussagen mit "1" bzw. "6" gemeint war.
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

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: currentValue != null ? 1 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: currentValue != null ? theme.colorScheme.primary.withValues(alpha: 0.4) : theme.dividerColor,
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
                // "1"/"6"-Badge direkt neben der jeweiligen Aussage, statt sich
                // darauf zu verlassen, dass die Position (links=1, rechts=6)
                // gegenüber der Kreis-Reihe darunter implizit klar ist - sonst
                // ist unklar, welche Zahl zu welcher der beiden Aussagen gehört.
                const _PoleBadge('1'),
                const SizedBox(width: 8),
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
                const SizedBox(width: 8),
                const _PoleBadge('6'),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                final value = index + 1;
                final isSelected = currentValue == value;
                return InkWell(
                  onTap: () => onChanged(value),
                  borderRadius: BorderRadius.circular(20),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest,
                    ),
                    child: Icon(
                      _iconForValue(value),
                      size: 18,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  /// Daumen-Verlauf von voll zustimmend zu [leftLabel] (1) über neutral
  /// (3/4) zu voll zustimmend zu [rightLabel] (6).
  IconData _iconForValue(int value) {
    switch (value) {
      case 1:
        return Icons.thumb_up;
      case 2:
        return Icons.thumb_up_outlined;
      case 5:
        return Icons.thumb_down_outlined;
      case 6:
        return Icons.thumb_down;
      default:
        return Icons.thumbs_up_down_outlined;
    }
  }
}

/// Kleine, dezente Zahlen-Markierung ("1" bzw. "6") direkt neben einer der
/// beiden Aussagen, damit die Zuordnung zur Skala eindeutig ist.
class _PoleBadge extends StatelessWidget {
  final String value;

  const _PoleBadge(this.value);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 18,
      height: 18,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.surfaceContainerHighest,
        border: Border.all(color: theme.dividerColor),
      ),
      child: Text(
        value,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
