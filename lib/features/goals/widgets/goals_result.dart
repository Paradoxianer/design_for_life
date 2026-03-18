import 'package:flutter/material.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
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
                      SmartIndicator(
                        label: 'S',
                        title: l10n.smartSpecific,
                        description: l10n.smartSpecificDesc,
                        isActive: goal.isSpecific,
                        compact: true,
                      ),
                      SmartIndicator(
                        label: 'M',
                        title: l10n.smartMeasurable,
                        description: l10n.smartMeasurableDesc,
                        isActive: goal.isMeasurable,
                        compact: true,
                      ),
                      SmartIndicator(
                        label: 'A',
                        title: l10n.smartAchievable,
                        description: l10n.smartAchievableDesc,
                        isActive: goal.isAchievable,
                        compact: true,
                      ),
                      SmartIndicator(
                        label: 'R',
                        title: l10n.smartRelevant,
                        description: l10n.smartRelevantDesc,
                        isActive: goal.isRelevant,
                        compact: true,
                      ),
                      SmartIndicator(
                        label: 'T',
                        title: l10n.smartTimeBound,
                        description: l10n.smartTimeBoundDesc,
                        isActive: goal.isTimeBound,
                        compact: true,
                      ),
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
