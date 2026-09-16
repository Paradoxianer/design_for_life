import 'package:flutter/material.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';

import '../models/gift_question.dart';

/// The 0-5 rating card used both for the main self-assessment (#5) and the
/// external "Referenz" mini-flow (#42) - shared so both flows stay visually
/// and behaviorally identical.
class GiftQuestionCard extends StatelessWidget {
  final GiftQuestion question;
  final int? currentScore;
  final bool isReadOnly;
  final ValueChanged<int> onAnswer;

  const GiftQuestionCard({
    super.key,
    required this.question,
    required this.currentScore,
    required this.isReadOnly,
    required this.onAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Fixed pixel sizes read noticeably smaller on desktop/web than on a
    // phone (higher-density displays, more physical viewing distance) - so
    // above a tablet-ish width, scale the question and answer text up.
    // Kept as a size step here rather than a smooth scale so it stays in
    // sync with spiritual_gifts_editor.dart's matching itemExtent step.
    final isWide = MediaQuery.sizeOf(context).width >= 700;
    final questionFontSize = isWide ? 17.0 : 13.0;
    final answerLabelFontSize = isWide ? 13.0 : 10.0;
    final answerNumberFontSize = isWide ? 12.0 : 9.0;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 2),
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: currentScore != null
              ? theme.colorScheme.primary.withValues(alpha: 0.5)
              : Colors.black12,
          width: 1.2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              question.text,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: questionFontSize,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              alignment: WrapAlignment.center,
              children: List.generate(6, (index) {
                final isSelected = currentScore == index;
                return InkWell(
                  onTap: isReadOnly ? null : () => onAnswer(index),
                  borderRadius: BorderRadius.circular(8),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _getLabel(context, index),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w600,
                            fontSize: answerLabelFontSize,
                          ),
                        ),
                        Text(
                          '$index',
                          style: TextStyle(
                            color: isSelected ? Colors.white70 : Colors.black87,
                            fontSize: answerNumberFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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

  String _getLabel(BuildContext context, int index) {
    final l10n = AppLocalizations.of(context);
    switch (index) {
      case 0:
        return l10n.giftsRating0;
      case 1:
        return l10n.giftsRating1;
      case 2:
        return l10n.giftsRating2;
      case 3:
        return l10n.giftsRating3;
      case 4:
        return l10n.giftsRating4;
      case 5:
        return l10n.giftsRating5;
      default:
        return '';
    }
  }
}
