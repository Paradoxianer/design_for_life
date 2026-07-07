import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:design_for_life/core/models/dfl_entry.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../../../core/widgets/dfl_module_editor.dart';
import '../../../core/widgets/dfl_entry_widget.dart';
import '../bloc/group_photo_bloc.dart';
import 'package:design_for_life/core/blocs/entry_list_bloc.dart';

// ignore: avoid_positional_boolean_parameters
void _noOp(int i, String v) {}

class GroupPhotoEditor extends DflModuleEditor {
  final String sessionId;
  final List<DflEntry> entries;

  const GroupPhotoEditor({
    super.key,
    required this.sessionId,
    required this.entries,
  }) : super(takeaways: const [], onUpdate: _noOp, showTakeaways: false);

  @override
  Widget buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final bloc = context.read<GroupPhotoBloc>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.groupPhotoGuidance,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        ...List.generate(entries.length, (index) {
          final entry = entries[index];
          final isLast = index == entries.length - 1;

          return DflEntryWidget(
            key: ValueKey(entry.id),
            entry: entry,
            hintText: l10n.groupPhotoHint,
            onTextChanged: (text) {
              bloc.add(UpdateEntryText(sessionId, entry.id, text));
            },
            onImageChanged: (path) {
              bloc.add(UpdateEntryImage(sessionId, entry.id, path));
            },
            onDelete: isLast ? null : () {
              bloc.add(DeleteEntry(sessionId, entry.id));
            },
          );
        }),
      ],
    );
  }
}
