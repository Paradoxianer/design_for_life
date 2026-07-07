import 'package:flutter/material.dart';

/// Frage-Karte für eine Skala zwischen zwei gegensätzlichen Aussagen (#50):
/// [leftLabel] entspricht Wert 1, [rightLabel] entspricht Wert 6. Die Labels
/// stehen oben, die Auswahl darunter als eine Reihe von 6 Kreisen - bewusst
/// anders als RatingSelector (Label pro Zahl), da hier die Bedeutung an den
/// beiden Enden der Skala liegt, nicht bei jeder einzelnen Zahl.
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
                    child: Text(
                      '$value',
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
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
}
