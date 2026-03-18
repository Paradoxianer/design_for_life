import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/dfl_module_scaffold.dart';
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

        return DflModuleScaffold(
          title: title,
          initialEditMode: initialEditMode,
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
