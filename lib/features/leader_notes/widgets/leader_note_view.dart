import 'package:design_for_life/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/leader_checklist_cubit.dart';
import '../models/leader_note_block.dart';
import '../models/leader_note_session.dart';

/// Renders one [LeaderNoteSession]'s content (#83) - the leader-only
/// counterpart to a module's participant-facing content, gated behind the
/// Leiter-Key elsewhere. Each [LeaderNoteBlock] type gets its own visual
/// treatment so the Leiterheft's structure (talking points, Bible quotes,
/// discussion questions, ...) stays legible rather than reading as one
/// undifferentiated wall of text.
class LeaderNoteView extends StatelessWidget {
  final LeaderNoteSession session;

  const LeaderNoteView({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    // SelectionArea: Texte lassen sich markieren und kopieren (v. a. im
    // Browser gewünscht, z. B. um Passagen in eigene Unterlagen zu übernehmen).
    return SelectionArea(child: _buildContent(context));
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    if (session.collapsible) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final section in session.sections)
            Card(
              clipBehavior: Clip.antiAlias,
              child: ExpansionTile(
                // Eigener Key je Abschnitt, damit der Auf-/Zu-Zustand beim
                // Neuaufbau der Liste erhalten bleibt.
                key: PageStorageKey<String>('leader-note-${section.heading}'),
                shape: const Border(),
                collapsedShape: const Border(),
                title: Text(
                  section.heading,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final block in section.blocks) ...[
                    _LeaderNoteBlockView(block: block, sectionHeading: section.heading),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
        ],
      );
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final section in session.sections) ...[
          Text(
            section.heading,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          for (final (index, block) in section.blocks.indexed) ...[
            _LeaderNoteBlockView(
              block: block,
              sectionHeading: section.heading,
              blockIndex: index,
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _LeaderNoteBlockView extends StatelessWidget {
  final LeaderNoteBlock block;
  final String sectionHeading;
  final int blockIndex;

  const _LeaderNoteBlockView({
    required this.block,
    required this.sectionHeading,
    required this.blockIndex,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return switch (block) {
      LeaderNoteSubheading(:final text) => Text(
        text,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      LeaderNoteParagraph(:final text) => Text(
        text,
        style: theme.textTheme.bodyMedium,
      ),
      LeaderNoteBulletList(:final items) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('•  '),
                  Expanded(
                    child: Text(item, style: theme.textTheme.bodyMedium),
                  ),
                ],
              ),
            ),
        ],
      ),
      LeaderNoteChecklist(:final items) => _LeaderChecklistView(
        items: items,
        listKey: LeaderChecklistCubit.listKey(sectionHeading, blockIndex),
        legacyHeading: sectionHeading,
      ),
      LeaderNoteNumberedList(:final items) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (index, item) in items.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${index + 1}.  '),
                  Expanded(
                    child: Text(item, style: theme.textTheme.bodyMedium),
                  ),
                ],
              ),
            ),
        ],
      ),
      LeaderNoteQuote(:final text, :final reference) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: theme.colorScheme.primary, width: 3),
          ),
          color: theme.colorScheme.surfaceContainerHighest.withValues(
            alpha: 0.4,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
            if (reference.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                reference,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
      LeaderNoteQuestion(:final text) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.forum_outlined, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
      LeaderNoteVideo(:final label, :final url) => InkWell(
        onTap: url == null
            ? null
            : () => launchUrl(
                Uri.parse(url),
                mode: LaunchMode.externalApplication,
              ),
        child: Row(
          children: [
            Icon(
              Icons.play_circle_outline,
              color: url == null
                  ? theme.colorScheme.outline
                  : theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  decoration: url == null ? null : TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    };
  }
}

/// Abhakbare Liste mit den vorgegebenen Punkten plus eigenen Punkten, die
/// sich unten über ein Eingabefeld ergänzen und wieder entfernen lassen.
class _LeaderChecklistView extends StatefulWidget {
  final List<String> items;
  final String listKey;

  /// Abschnittsüberschrift: Haken der vorgegebenen Punkte werden weiter unter
  /// diesem Schlüssel gespeichert (Kompatibilität mit älteren Ständen).
  final String legacyHeading;

  const _LeaderChecklistView({
    required this.items,
    required this.listKey,
    required this.legacyHeading,
  });

  @override
  State<_LeaderChecklistView> createState() => _LeaderChecklistViewState();
}

class _LeaderChecklistViewState extends State<_LeaderChecklistView> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    context.read<LeaderChecklistCubit>().addItem(
      widget.listKey,
      _controller.text,
    );
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<LeaderChecklistCubit, LeaderChecklistState>(
      builder: (context, state) {
        final cubit = context.read<LeaderChecklistCubit>();
        Widget tile(String item, String key, {VoidCallback? onRemove}) {
          final done = state.checked.contains(key);
          return CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            value: done,
            onChanged: (_) => cubit.toggle(key),
            title: Text(
              item,
              style: theme.textTheme.bodyMedium?.copyWith(
                decoration: done ? TextDecoration.lineThrough : null,
              ),
            ),
            secondary: onRemove == null
                ? null
                : IconButton(
                    icon: const Icon(Icons.delete_outline),
                    tooltip: l10n.leaderChecklistRemoveItem,
                    onPressed: onRemove,
                  ),
          );
        }

        return Column(
          children: [
            for (final item in widget.items)
              tile(item, LeaderChecklistCubit.keyFor(widget.legacyHeading, item)),
            for (final item in state.custom[widget.listKey] ?? const <String>[])
              tile(
                item,
                LeaderChecklistCubit.keyFor(widget.listKey, item),
                onRemove: () => cubit.removeItem(widget.listKey, item),
              ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: l10n.leaderChecklistNewItemHint,
                    ),
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _submit(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  tooltip: l10n.leaderChecklistAddItem,
                  onPressed: _submit,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
