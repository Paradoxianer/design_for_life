import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/dfl_module_scaffold.dart';
import '../bloc/values_bloc.dart';
import '../bloc/values_event.dart';
import '../bloc/values_state.dart';
import '../widgets/values_editor.dart';
import '../widgets/values_result.dart';

class ValuesAssessmentScreen extends StatelessWidget {
  final String title;
  final bool initialEditMode;

  const ValuesAssessmentScreen({
    super.key,
    required this.title,
    this.initialEditMode = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ValuesBloc()..add(const ValuesStarted()),
      child: BlocBuilder<ValuesBloc, ValuesState>(
        builder: (context, state) {
          return DflModuleScaffold(
            title: title,
            initialEditMode: initialEditMode,
            onWillToggleMode: () async {
              return await _validateCompletion(context, state);
            },
            editor: const ValuesEditor(),
            result: const ValuesResult(),
          );
        },
      ),
    );
  }

  Future<bool> _validateCompletion(BuildContext context, ValuesState state) async {
    if (state.topEightValues.length != 8) {
      final bool? result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Auswahl unvollständig'),
          content: Text(
            'Du hast aktuell ${state.topEightValues.length} von 8 Werten ausgewählt. '
            'Für ein optimales Ergebnis sollten es genau 8 sein. '
            'Möchtest du trotzdem fortfahren?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Zurück'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Trotzdem weiter'),
            ),
          ],
        ),
      );
      return result ?? false;
    }
    return true;
  }
}
