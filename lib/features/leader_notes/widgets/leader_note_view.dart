import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
    final theme = Theme.of(context);
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
          for (final block in section.blocks) ...[
            _LeaderNoteBlockView(block: block),
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

  const _LeaderNoteBlockView({required this.block});

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
