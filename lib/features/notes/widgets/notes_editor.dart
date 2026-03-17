import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:design_for_life/core/models/dfl_entry.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../../../core/widgets/dfl_module_editor.dart';
import '../../../core/widgets/dfl_entry_widget.dart';
import '../bloc/notes_bloc.dart';
import 'package:design_for_life/core/blocs/entry_list_bloc.dart';

class NotesEditor extends DflModuleEditor {
  final String sessionId;
  final List<DflEntry> entries;

  const NotesEditor({
    super.key,
    required this.sessionId,
    required this.entries,
    required super.takeaways,
    required super.onUpdate,
  });

  @override
  Widget buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final bloc = context.read<NotesBloc>();

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
                  l10n.notesGuidance,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        ...entries.map((entry) => DflEntryWidget(
          entry: entry,
          hintText: l10n.notesHint,
          onTextChanged: (text) {
            bloc.add(UpdateEntryText(sessionId, entry.id, text));
          },
          onImageChanged: (path) {
            bloc.add(UpdateEntryImage(sessionId, entry.id, path));
          },
          onToggleCompleted: () {
            bloc.add(ToggleEntryCompletion(sessionId, entry.id));
          },
        )),
      ],
    );
  }
}
