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
          editor: SpiritualGiftsEditor(sessionId: sessionId),
          result: SpiritualGiftsResult(
            takeaways: state.takeaways[sessionId] ?? const [],
            onTakeawaysUpdate: (takeaways) {
              context.read<SpiritualGiftsBloc>().add(
                    UpdateTakeaways(sessionId: sessionId, takeaways: takeaways),
                  );
            },
          ),
        );
      },
    );
  }
}
