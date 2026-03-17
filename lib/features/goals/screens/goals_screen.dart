import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../../../core/widgets/dfl_module_scaffold.dart';
import '../bloc/goals_bloc.dart';
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
            takeaways: const [],
            takeawayController: TextEditingController(),
            onUpdate: (index, value) {
              // Goals logic doesn't use standard takeaways, 
              // but we fulfill the interface requirements.
            },
          ),
          result: GoalsResult(
            goals: goals,
            smartChecks: const {}, 
          ),
          onSave: () {
            // Manual save if needed
          },
        );
      },
    );
  }
}
