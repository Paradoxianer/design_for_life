import 'package:flutter/material.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../models/goal.dart';

class GoalsResult extends StatelessWidget {
  final List<Goal> goals;

  const GoalsResult({
    super.key,
    required this.goals,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(goals.length, (index) {
          final goal = goals[index];
          if (goal.text.isEmpty) return const SizedBox.shrink();
          
          return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: theme.dividerColor),
            ),
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.goalNumber(index + 1),
                    style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.secondary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    goal.text,
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildSmartChip(context, 'S', l10n.smartSpecific, goal.isSpecific),
                      _buildSmartChip(context, 'M', l10n.smartMeasurable, goal.isMeasurable),
                      _buildSmartChip(context, 'A', l10n.smartAchievable, goal.isAchievable),
                      _buildSmartChip(context, 'R', l10n.smartRelevant, goal.isRelevant),
                      _buildSmartChip(context, 'T', l10n.smartTimeBound, goal.isTimeBound),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSmartChip(BuildContext context, String letter, String label, bool isChecked) {
    final theme = Theme.of(context);
    final color = isChecked ? theme.colorScheme.primary : theme.colorScheme.surfaceVariant;
    final textColor = isChecked ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: isChecked ? null : Border.all(color: theme.dividerColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            letter,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
              fontSize: 12,
            ),
          ),
          if (isChecked) ...[
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.check, size: 12, color: textColor),
          ],
        ],
      ),
    );
  }
}
