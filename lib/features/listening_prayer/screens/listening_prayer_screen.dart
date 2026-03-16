import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../bloc/listening_prayer_bloc.dart';
import '../bloc/listening_prayer_event.dart';
import '../bloc/listening_prayer_state.dart';
import '../widgets/listening_prayer_editor.dart';
import '../widgets/listening_prayer_result.dart';
import '../../../core/widgets/dfl_module_scaffold.dart';

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
  late TextEditingController _takeawayController;

  @override
  void initState() {
    super.initState();
    _takeawayController = TextEditingController();
  }

  @override
  void dispose() {
    _takeawayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ListeningPrayerBloc, ListeningPrayerState>(
      listener: (context, state) {
        final highlights = state.highlights[widget.sessionId];
        if (highlights != null) {
          final newContent = highlights.join('\n');
          if (_takeawayController.text != newContent) {
            _takeawayController.text = newContent;
          }
        }
      },
      builder: (context, state) {
        final impressions = state.impressions[widget.sessionId] ?? [];
        final highlights = state.highlights[widget.sessionId] ?? [];

        return DflModuleScaffold(
          title: widget.title,
          editor: ListeningPrayerEditor(
            impressions: { 'Impressions': impressions },
            takeaways: highlights,
            takeawayController: _takeawayController,
            onImpressionsUpdate: (newMap) {
              // Logic for mapping back to individual UpdateImpression events
            },
            onTakeawaysUpdate: (newList) {
              for (int i = 0; i < newList.length; i++) {
                context.read<ListeningPrayerBloc>().add(
                  UpdateHighlight(
                    sessionId: widget.sessionId,
                    index: i,
                    text: newList[i],
                  ),
                );
              }
            },
          ),
          result: ListeningPrayerResult(
            impressions: { 'Impressions': impressions },
          ),
          onSave: () {},
        );
      },
    );
  }
}
