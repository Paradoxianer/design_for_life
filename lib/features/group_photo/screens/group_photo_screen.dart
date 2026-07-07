import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:design_for_life/core/blocs/entry_list_bloc.dart';
import 'package:design_for_life/core/models/dfl_entry.dart';
import 'package:design_for_life/core/models/shareable_content.dart';
import 'package:design_for_life/core/services/share_service.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../../../core/widgets/dfl_module_scaffold.dart';
import '../bloc/group_photo_bloc.dart';
import '../widgets/group_photo_editor.dart';
import '../widgets/group_photo_result.dart';

/// Einzige, feste Session-ID: das Gruppenfoto ist kein Modul pro Zeitslot,
/// sondern ein einziger, geteilter Punkt für die gesamte DFL-Erfahrung.
const String groupPhotoSessionId = 'group_photo';

class GroupPhotoScreen extends StatelessWidget {
  final String title;
  final bool initialEditMode;

  const GroupPhotoScreen({
    super.key,
    required this.title,
    this.initialEditMode = true,
  });

  ShareableContent _getShareableContent(BuildContext context, List<DflEntry> entries) {
    final l10n = AppLocalizations.of(context);
    final items = <ShareableItem>[];

    for (int i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final hasText = entry.text.trim().isNotEmpty;
      final hasImage = entry.imagePath != null && entry.imagePath!.isNotEmpty;

      if (hasText || hasImage) {
        items.add(ShareableItem(
          id: 'group_photo_entry_${entry.id}',
          label: l10n.shareInsightItem(i + 1),
          textValue: hasText ? entry.text : null,
          imagePath: hasImage ? entry.imagePath : null,
        ));
      }
    }

    return ShareableContent(title: l10n.session11Title, items: items);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupPhotoBloc, EntryListState>(
      builder: (context, state) {
        final entries = state.entries[groupPhotoSessionId] ?? [];
        final displayEntries = entries.isEmpty
            ? [DflEntry(id: 'initial_$groupPhotoSessionId')]
            : entries;

        final shareContent = _getShareableContent(context, entries);

        return DflModuleScaffold(
          title: title,
          initialEditMode: initialEditMode,
          shareableContent: shareContent.items.isNotEmpty ? shareContent : null,
          onShare: (selectedItems) {
            ShareService.shareContent(
              context: context,
              content: shareContent,
              selectedItems: selectedItems,
            );
          },
          editor: GroupPhotoEditor(
            sessionId: groupPhotoSessionId,
            entries: displayEntries,
          ),
          result: GroupPhotoResult(entries: entries),
        );
      },
    );
  }
}
