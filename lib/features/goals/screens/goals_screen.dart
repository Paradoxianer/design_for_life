import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/dfl_module_scaffold.dart';
import '../bloc/goals_bloc.dart';
import '../bloc/goals_state.dart';
import '../widgets/goals_editor.dart';
import '../widgets/goals_result.dart';
import '../models/goal.dart';

class GoalsScreen extends StatefulWidget {
  final String sessionId;
  final String title;

  const GoalsScreen({
    super.key,
    required this.sessionId,
    required this.title,
  });

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  bool _isEditMode = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoalsBloc, GoalsState>(
      builder: (context, state) {
        final goals = state.goals[widget.sessionId] ??
            const [
              Goal(),
              Goal(),
              Goal(),
            ];

        return DflModuleScaffold(
          title: widget.title,
          isEditMode: _isEditMode,
          onToggleMode: () => setState(() => _isEditMode = !_isEditMode),
          editor: GoalsEditor(
            sessionId: widget.sessionId,
            goals: goals,
            takeaways: const [], // Goals module doesn't use standard takeaways
            onTakeawayUpdate: (_, __) {},
          ),
          result: GoalsResult(
            goals: goals,
          ),
        );
      },
    );
  }
}
