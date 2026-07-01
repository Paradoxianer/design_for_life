import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../../../core/widgets/dfl_module_editor.dart';
import '../bloc/synthesis_bloc.dart';

class SynthesisEditor extends StatelessWidget {
  const SynthesisEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SynthesisBloc, SynthesisState>(
      builder: (context, state) {
        return _ConnectionsEditorLayout(
          takeaways: state.takeaways,
          onUpdate: (index, value) {
            context.read<SynthesisBloc>().add(UpdateSynthesisTakeaway(index, value));
          },
          showTakeaways: true,
          isReadOnly: false,
        );
      },
    );
  }
}

class _ConnectionsEditorLayout extends DflModuleEditor {
  const _ConnectionsEditorLayout({
    required super.takeaways,
    required super.onUpdate,
    required super.showTakeaways,
    required super.isReadOnly,
  });

  @override
  Widget buildContent(BuildContext context) => const _ConnectionsBoard();
}

typedef _ColumnDef = ({String key, Color color, IconData icon});

class _ConnectionsBoard extends StatelessWidget {
  const _ConnectionsBoard();

  static const _columnDefs = <_ColumnDef>[
    (key: 'lifeTree', color: Color(0xFF2E7D32), icon: Icons.account_tree_rounded),
    (key: 'values', color: Color(0xFF2D5A27), icon: Icons.diamond_outlined),
    (key: 'gifts', color: Color(0xFF6B4C9A), icon: Icons.volunteer_activism_rounded),
    (key: 'prayer', color: Color(0xFF1565C0), icon: Icons.hearing_rounded),
    (key: 'goals', color: Color(0xFF8B5E3C), icon: Icons.flag_rounded),
  ];

  String _columnLabel(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context);
    switch (key) {
      case 'lifeTree': return l10n.connectionsColLifeTree;
      case 'values': return l10n.connectionsColValues;
      case 'gifts': return l10n.connectionsColGifts;
      case 'prayer': return l10n.connectionsColPrayer;
      case 'goals': return l10n.connectionsColGoals;
      default: return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return BlocBuilder<SynthesisBloc, SynthesisState>(
      builder: (context, state) {
        // Only show columns that have cards
        final activeColumns = _columnDefs
            .where((col) => (state.columns[col.key] ?? const []).isNotEmpty)
            .toList();

        if (activeColumns.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              l10n.connectionsNoContent,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.connectionsGuidance,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                },
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final col in activeColumns) ...[
                      _ConnectionsColumn(
                        columnKey: col.key,
                        label: _columnLabel(context, col.key),
                        color: col.color,
                        icon: col.icon,
                        cards: state.columns[col.key] ?? const <SynthesisCard>[],
                      ),
                      const SizedBox(width: 12),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ConnectionsColumn extends StatelessWidget {
  final String columnKey;
  final String label;
  final Color color;
  final IconData icon;
  final List<SynthesisCard> cards;

  const _ConnectionsColumn({
    required this.columnKey,
    required this.label,
    required this.color,
    required this.icon,
    required this.cards,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 260,
      constraints: const BoxConstraints(minHeight: 120),
      decoration: BoxDecoration(
        border: Border.all(color: color.withValues(alpha: 0.25)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.titleSmall?.copyWith(color: color),
                  ),
                ),
              ],
            ),
          ),
          ReorderableListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            onReorder: (oldIndex, newIndex) {
              context.read<SynthesisBloc>().add(
                    MoveSynthesisCard(
                      fromColumn: columnKey,
                      fromIndex: oldIndex,
                      toColumn: columnKey,
                      toIndex: newIndex,
                    ),
                  );
            },
            children: [
              for (final card in cards)
                _ConnectionCard(
                  key: ValueKey(card.id),
                  columnKey: columnKey,
                  card: card,
                  color: color,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ConnectionCard extends StatelessWidget {
  final String columnKey;
  final SynthesisCard card;
  final Color color;

  const _ConnectionCard({
    super.key,
    required this.columnKey,
    required this.card,
    required this.color,
  });

  static const _tagColors = {
    'none': Color(0xFFBDBDBD),
    'red': Color(0xFFD32F2F),
    'blue': Color(0xFF1976D2),
    'green': Color(0xFF2E7D32),
    'gold': Color(0xFFF9A825),
  };

  String _tagLabel(BuildContext context, String tag) {
    final l10n = AppLocalizations.of(context);
    switch (tag) {
      case 'none': return l10n.connectionsColorNone;
      case 'red': return l10n.connectionsColorRed;
      case 'blue': return l10n.connectionsColorBlue;
      case 'green': return l10n.connectionsColorGreen;
      case 'gold': return l10n.connectionsColorGold;
      default: return tag;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final tagColor = _tagColors[card.tag] ?? _tagColors['none']!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(Icons.drag_indicator, color: theme.colorScheme.outline),
        title: Text(card.text, style: theme.textTheme.bodyMedium),
        subtitle: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: tagColor, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(_tagLabel(context, card.tag)),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.palette_outlined),
          tooltip: l10n.connectionsAssignColor,
          onSelected: (value) {
            context.read<SynthesisBloc>().add(SetSynthesisCardTag(card.id, value));
          },
          itemBuilder: (_) => [
            for (final tag in ['none', 'red', 'blue', 'green', 'gold'])
              PopupMenuItem<String>(
                value: tag,
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: _tagColors[tag],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(_tagLabel(context, tag)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

