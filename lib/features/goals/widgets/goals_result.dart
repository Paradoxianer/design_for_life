import 'package:flutter/material.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../models/goal.dart';
import 'smart_indicator.dart';

class GoalsResult extends StatelessWidget {
  final List<Goal> goals;

  const GoalsResult({
    super.key,
    required this.goals,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

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
                  const SizedBox(height: 8),
                  Text(
                    goal.text,
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SmartIndicator(label: 'S', isActive: goal.isSpecific),
                      const SizedBox(width: 8),
                      SmartIndicator(label: 'M', isActive: goal.isMeasurable),
                      const SizedBox(width: 8),
                      SmartIndicator(label: 'A', isActive: goal.isAchievable),
                      const SizedBox(width: 8),
                      SmartIndicator(label: 'R', isActive: goal.isRelevant),
                      const SizedBox(width: 8),
                      SmartIndicator(label: 'T', isActive: goal.isTimeBound),
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
}
