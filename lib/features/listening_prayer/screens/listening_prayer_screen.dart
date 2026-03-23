import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:design_for_life/core/blocs/entry_list_bloc.dart';
import 'package:design_for_life/core/models/dfl_entry.dart';
import 'package:design_for_life/core/models/shareable_content.dart';
import 'package:design_for_life/core/services/share_service.dart';
import '../bloc/listening_prayer_bloc.dart';
import '../widgets/listening_prayer_editor.dart';
import '../widgets/listening_prayer_result.dart';
import '../../../core/widgets/dfl_module_scaffold.dart';

class ListeningPrayerScreen extends StatelessWidget {
  final String sessionId;
  final String title;
  final bool initialEditMode;

  const ListeningPrayerScreen({
    super.key,
    required this.sessionId,
    required this.title,
    this.initialEditMode = true,
  });

  ShareableContent _getShareableContent(List<DflEntry> impressions, List<String> highlights) {
    final List<ShareableItem> items = [];

    // Add Highlights first as they are most important
    for (int i = 0; i < highlights.length; i++) {
      if (highlights[i].trim().isNotEmpty) {
        items.add(ShareableItem(
          id: 'lp_highlight_$i',
          label: 'Highlight ${i + 1}',
          textValue: highlights[i],
        ));
      }
    }

    // Add Impressions
    for (int i = 0; i < impressions.length; i++) {
      final entry = impressions[i];
      if (entry.text.trim().isNotEmpty) {
        items.add(ShareableItem(
          id: 'lp_impression_${entry.id}',
          label: 'Eindruck ${i + 1}',
          textValue: entry.text,
        ));
      }
    }

    return ShareableContent(
      title: 'Hörendes Gebet',
      items: items,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListeningPrayerBloc, EntryListState>(
      builder: (context, state) {
        final impressions = state.entries[sessionId] ?? [];
        final highlights = state.takeaways[sessionId] ?? const ['', '', ''];

        final displayImpressions = impressions.isEmpty 
            ? [DflEntry(id: 'initial_$sessionId')] 
            : impressions;

        final shareContent = _getShareableContent(impressions, highlights);

        return DflModuleScaffold(
          title: title,
          initialEditMode: initialEditMode,
          shareableContent: shareContent.items.isNotEmpty ? shareContent : null,
          onShare: (selectedItems) {
            ShareService.shareContent(
              content: shareContent,
              selectedItems: selectedItems,
            );
          },
          editor: ListeningPrayerEditor(
            sessionId: sessionId,
            impressions: displayImpressions,
            takeaways: highlights,
            onTakeawaysUpdate: (newList) {
              for (int i = 0; i < newList.length; i++) {
                context.read<ListeningPrayerBloc>().add(
                  UpdateTakeaway(sessionId, i, newList[i]),
                );
              }
            },
          ),
          result: ListeningPrayerResult(
            impressions: { 'Eindrücke': impressions },
            takeaways: highlights,
            onUpdate: (index, value) {
              context.read<ListeningPrayerBloc>().add(
                UpdateTakeaway(sessionId, index, value),
              );
            },
          ),
        );
      },
    );
  }
}
