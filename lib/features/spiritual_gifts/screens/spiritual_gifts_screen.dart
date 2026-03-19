import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/dfl_module_scaffold.dart';
import '../bloc/spiritual_gifts_bloc.dart';
import '../widgets/spiritual_gifts_editor.dart';
import '../widgets/spiritual_gifts_result.dart';

class SpiritualGiftsScreen extends StatelessWidget {
  final String sessionId;
  final String title;
  final bool initialEditMode;

  const SpiritualGiftsScreen({
    super.key,
    required this.sessionId,
    required this.title,
    this.initialEditMode = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpiritualGiftsBloc, SpiritualGiftsState>(
      builder: (context, state) {
        return DflModuleScaffold(
          title: title,
          initialEditMode: initialEditMode,
          onWillToggleMode: () async {
            return await _validateCompletion(context, state);
          },
          editor: SpiritualGiftsEditor(sessionId: sessionId),
          result: const SpiritualGiftsResult(),
        );
      },
    );
  }

  Future<bool> _validateCompletion(BuildContext context, SpiritualGiftsState state) async {
    final totalQuestions = state.questionOrder.length;
    final answeredQuestions = state.answers.length;

    if (answeredQuestions < totalQuestions) {
      final bool? result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Test unvollständig'),
          content: Text(
            'Du hast erst $answeredQuestions von $totalQuestions Fragen beantwortet. '
            'Möchtest du den Test wirklich abschließen?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Weiter ausfüllen'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Trotzdem beenden'),
            ),
          ],
        ),
      );
      return result ?? false;
    }
    return true;
  }
}
