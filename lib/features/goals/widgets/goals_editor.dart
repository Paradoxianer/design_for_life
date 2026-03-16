import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/dfl_module_editor.dart';
import '../bloc/goals_bloc.dart';
import '../bloc/goals_event.dart';
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
    required super.onTakeawayUpdate,
  });

  @override
  Widget buildContent(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Guidance
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            children: [
              Icon(Icons.lightbulb_outline, size: 20, color: Colors.blue),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Define exactly 3 goals for your journey. Use the SMART check to ensure they are actionable.',
                  style: TextStyle(fontStyle: FontStyle.italic),
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

  @override
  Widget build(BuildContext context) {
    return buildContent(context);
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
              'Goal ${index + 1}',
              style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.secondary),
            ),
            TextField(
              controller: TextEditingController(text: goal.text)
                ..selection = TextSelection.fromPosition(TextPosition(offset: goal.text.length)),
              decoration: const InputDecoration(
                hintText: 'What do you want to achieve?',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SmartIndicator(
                  label: 'S',
                  isActive: goal.isSpecific,
                  onTap: () => _toggle(context, 'S'),
                ),
                SmartIndicator(
                  label: 'M',
                  isActive: goal.isMeasurable,
                  onTap: () => _toggle(context, 'M'),
                ),
                SmartIndicator(
                  label: 'A',
                  isActive: goal.isAchievable,
                  onTap: () => _toggle(context, 'A'),
                ),
                SmartIndicator(
                  label: 'R',
                  isActive: goal.isRelevant,
                  onTap: () => _toggle(context, 'R'),
                ),
                SmartIndicator(
                  label: 'T',
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
