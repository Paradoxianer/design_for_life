import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/dfl_module_scaffold.dart';
import '../bloc/listening_prayer_bloc.dart';
import '../bloc/listening_prayer_event.dart';
import '../bloc/listening_prayer_state.dart';
import '../widgets/listening_prayer_editor.dart';
import '../widgets/listening_prayer_result.dart';

class ListeningPrayerScreen extends StatefulWidget {
  final String sessionId;
  final String title;

  const ListeningPrayerScreen({
    super.key,
    required this.sessionId,
    required this.title,
  });

  @override
  State<ListeningPrayerScreen> createState() => _ListeningPrayerScreenState();
}

class _ListeningPrayerScreenState extends State<ListeningPrayerScreen> {
  bool _isEditMode = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListeningPrayerBloc, ListeningPrayerState>(
      builder: (context, state) {
        final impressions = state.impressions[widget.sessionId] ?? [];
        final highlights = state.highlights[widget.sessionId] ?? ['', '', ''];

        return DflModuleScaffold(
          title: widget.title,
          isEditMode: _isEditMode,
          onToggleMode: () => setState(() => _isEditMode = !_isEditMode),
          editor: ListeningPrayerEditor(
            sessionId: widget.sessionId,
            impressions: impressions,
            takeaways: highlights,
            onTakeawayUpdate: (index, val) {
              context.read<ListeningPrayerBloc>().add(
                    UpdateHighlight(
                      sessionId: widget.sessionId,
                      index: index,
                      text: val,
                    ),
                  );
            },
          ),
          result: ListeningPrayerResult(
            impressions: impressions,
            takeaways: highlights,
          ),
        );
      },
    );
  }
}
