import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../../../core/widgets/dfl_module_scaffold.dart';
import '../../../core/models/shareable_content.dart';
import '../../../core/services/share_service.dart';
import '../bloc/goals_bloc.dart';
import '../widgets/goals_editor.dart';
import '../widgets/goals_result.dart';
import '../models/goal.dart';

class GoalsScreen extends StatelessWidget {
  final String sessionId;
  final String title;
  final bool initialEditMode;

  const GoalsScreen({
    super.key,
    required this.sessionId,
    required this.title,
    this.initialEditMode = true,
  });

  ShareableContent _getShareableContent(BuildContext context, List<Goal> goals) {
    final l10n = AppLocalizations.of(context);
    final filledGoals = goals.where((g) => g.text.isNotEmpty).toList();

    List<Map<String, Object>> smartChips(Goal goal) => [
          {'label': 'S', 'title': l10n.smartSpecific, 'isActive': goal.isSpecific},
          {'label': 'M', 'title': l10n.smartMeasurable, 'isActive': goal.isMeasurable},
          {'label': 'A', 'title': l10n.smartAchievable, 'isActive': goal.isAchievable},
          {'label': 'R', 'title': l10n.smartRelevant, 'isActive': goal.isRelevant},
          {'label': 'T', 'title': l10n.smartTimeBound, 'isActive': goal.isTimeBound},
        ];

    return ShareableContent(
      title: l10n.goalsTitle,
      items: [
        // Ziele als eine gebrandete Bild-Karte statt einzelner Text-Zeilen (#24),
        // inklusive der SMART-Chips wie im Editor/Ergebnis der App.
        if (filledGoals.isNotEmpty)
          ShareableItem(
            id: 'goals_card',
            label: l10n.goalsShareCardLabel,
            textValue: [
              for (int i = 0; i < filledGoals.length; i++)
                '${l10n.shareGoalItem(i + 1)}: ${filledGoals[i].text}',
            ].join('\n'),
            data: {
              'type': 'text_card',
              'entries': [
                for (int i = 0; i < filledGoals.length; i++)
                  {
                    'title': l10n.shareGoalItem(i + 1),
                    'body': filledGoals[i].text,
                    'chips': smartChips(filledGoals[i]),
                  },
              ],
            },
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoalsBloc, GoalsState>(
      builder: (context, state) {
        final goals = state.goals[sessionId] ??
            const [Goal(), Goal(), Goal()];

        final shareContent = _getShareableContent(context, goals);

        return DflModuleScaffold(
          title: title,
          initialEditMode: initialEditMode,
          shareableContent: shareContent.items.isNotEmpty ? shareContent : null,
          onShare: (selectedItems) {
            ShareService.shareContent(
              context: context,
              content: shareContent,
              selectedItems: selectedItems,
            );
          },
          editor: GoalsEditor(
            sessionId: sessionId,
            goals: goals,
          ),
          result: GoalsResult(
            goals: goals,
          ),
        );
      },
    );
  }
}
