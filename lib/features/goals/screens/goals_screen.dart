import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  ShareableContent _getShareableContent(List<Goal> goals) {
    return ShareableContent(
      title: 'Meine SMARTen Ziele',
      items: goals.asMap().entries.where((e) => e.value.text.isNotEmpty).map((entry) {
        final index = entry.key;
        final goal = entry.value;
        return ShareableItem(
          id: 'goal_$index',
          label: 'Ziel ${index + 1}',
          textValue: goal.text,
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoalsBloc, GoalsState>(
      builder: (context, state) {
        final goals = state.goals[sessionId] ??
            const [
              Goal(),
              Goal(),
              Goal(),
            ];

        final shareContent = _getShareableContent(goals);

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
            takeaways: const [],
            onUpdate: (index, value) {},
          ),
          result: GoalsResult(
            goals: goals,
          ),
        );
      },
    );
  }
}
