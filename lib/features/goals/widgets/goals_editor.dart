import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../../../core/widgets/dfl_module_editor.dart';
import '../bloc/goals_bloc.dart';
import '../models/goal.dart';
import 'smart_indicator.dart';

class GoalsEditor extends DflModuleEditor {
  final String sessionId;
  final List<Goal> goals;

  const GoalsEditor({
    super.key,
    required this.sessionId,
    required this.goals,
    required super.takeaways,
    required super.onUpdate,
  }) : super(showTakeaways: false);

  @override
  Widget buildContent(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.lightbulb_outline, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.goalsGuidance,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        ...List.generate(goals.length, (index) {
          final goal = goals[index];
          return _GoalEditCard(
            index: index,
            goal: goal,
            sessionId: sessionId,
          );
        }),
      ],
    );
  }
}

class _GoalEditCard extends StatelessWidget {
  final int index;
  final Goal goal;
  final String sessionId;

  const _GoalEditCard({
    required this.index,
    required this.goal,
    required this.sessionId,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

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
            TextField(
              controller: TextEditingController(text: goal.text)
                ..selection = TextSelection.fromPosition(TextPosition(offset: goal.text.length)),
              decoration: InputDecoration(
                hintText: l10n.goalHint,
                border: InputBorder.none,
              ),
              maxLines: null,
              onChanged: (val) {
                context.read<GoalsBloc>().add(
                      UpdateGoalText(sessionId: sessionId, index: index, text: val),
                    );
              },
            ),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              l10n.smartCheck,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SmartIndicator(
                  label: 'S',
                  tooltip: '${l10n.smartSpecific}: ${l10n.smartSpecificDesc}',
                  isActive: goal.isSpecific,
                  onTap: () => _toggle(context, 'S'),
                ),
                SmartIndicator(
                  label: 'M',
                  tooltip: '${l10n.smartMeasurable}: ${l10n.smartMeasurableDesc}',
                  isActive: goal.isMeasurable,
                  onTap: () => _toggle(context, 'M'),
                ),
                SmartIndicator(
                  label: 'A',
                  tooltip: '${l10n.smartAchievable}: ${l10n.smartAchievableDesc}',
                  isActive: goal.isAchievable,
                  onTap: () => _toggle(context, 'A'),
                ),
                SmartIndicator(
                  label: 'R',
                  tooltip: '${l10n.smartRelevant}: ${l10n.smartRelevantDesc}',
                  isActive: goal.isRelevant,
                  onTap: () => _toggle(context, 'R'),
                ),
                SmartIndicator(
                  label: 'T',
                  tooltip: '${l10n.smartTimeBound}: ${l10n.smartTimeBoundDesc}',
                  isActive: goal.isTimeBound,
                  onTap: () => _toggle(context, 'T'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _toggle(BuildContext context, String criterion) {
    context.read<GoalsBloc>().add(
          ToggleSmartCriterion(sessionId: sessionId, index: index, criterion: criterion),
        );
  }
}
