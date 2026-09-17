import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/dfl_module_scaffold.dart';
import '../bloc/checklist_bloc.dart';
import '../widgets/checklist_view.dart';

class ChecklistScreen extends StatelessWidget {
  final String title;
  final bool initialEditMode;

  const ChecklistScreen({
    super.key,
    required this.title,
    this.initialEditMode = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChecklistBloc, ChecklistState>(
      builder: (context, state) {
        Widget buildView() => ChecklistView(
          items: state.items,
          onToggle: (id) =>
              context.read<ChecklistBloc>().add(ToggleChecklistItem(id)),
          onAdd: (text) =>
              context.read<ChecklistBloc>().add(AddCustomChecklistItem(text)),
          onRemove: (id) =>
              context.read<ChecklistBloc>().add(RemoveChecklistItem(id)),
        );

        return DflModuleScaffold(
          title: title,
          initialEditMode: initialEditMode,
          // Checklist has no dynamic sessionId of its own (single global
          // route), like Values/Feedback - session_checklist is the
          // leader_notes json key used for its Vorbereitungs-Zeitplan +
          // Materialliste content (#83).
          leaderNoteSessionId: 'session_checklist',
          editor: buildView(),
          result: buildView(),
        );
      },
    );
  }
}
