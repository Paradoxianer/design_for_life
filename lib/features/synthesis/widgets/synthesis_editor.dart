import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

class _ConnectionsBoard extends StatelessWidget {
  const _ConnectionsBoard();

  static const _columns = [
    ('lifeTree', 'Lebensbaum', Color(0xFF2E7D32), Icons.account_tree_rounded),
    ('values', 'Werte', Color(0xFF2D5A27), Icons.diamond_outlined),
    ('gifts', 'Gaben', Color(0xFF6B4C9A), Icons.volunteer_activism_rounded),
    ('prayer', 'Hörendes Gebet', Color(0xFF1565C0), Icons.hearing_rounded),
    ('goals', 'Ziele', Color(0xFF8B5E3C), Icons.flag_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<SynthesisBloc, SynthesisState>(
      builder: (context, state) {
        final hasAny = state.columns.values.any((c) => c.isNotEmpty);
        if (!hasAny) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Noch keine Key-Takeaways vorhanden. '
              'Bearbeite zuerst mindestens ein Modul (Lebensbaum, Werte, Gaben oder Hörendes Gebet).',
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
              'Ziehe Karten zwischen den Spalten, um Verbindungen festzuhalten.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final (key, label, color, icon) in _columns) ...[
                    _ConnectionsColumn(
                      columnKey: key,
                      label: label,
                      color: color,
                      icon: icon,
                      cards: state.columns[key] ?? const <SynthesisCard>[],
                    ),
                    const SizedBox(width: 12),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DragData {
  final String fromColumn;
  final int fromIndex;
  final SynthesisCard card;

  const _DragData({
    required this.fromColumn,
    required this.fromIndex,
    required this.card,
  });
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

  void _moveCard(BuildContext context, _DragData data, int toIndex) {
    context.read<SynthesisBloc>().add(
          MoveSynthesisCard(
            fromColumn: data.fromColumn,
            fromIndex: data.fromIndex,
            toColumn: columnKey,
            toIndex: toIndex,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 260,
      constraints: const BoxConstraints(minHeight: 380),
      decoration: BoxDecoration(
        border: Border.all(color: color.withValues(alpha: 0.25)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          for (int i = 0; i <= cards.length; i++) ...[
            _DropZone(
              onAccept: (data) => _moveCard(context, data, i),
            ),
            if (i < cards.length)
              _ConnectionCard(
                columnKey: columnKey,
                index: i,
                card: cards[i],
                color: color,
              ),
          ],
        ],
      ),
    );
  }
}

class _DropZone extends StatefulWidget {
  final ValueChanged<_DragData> onAccept;

  const _DropZone({required this.onAccept});

  @override
  State<_DropZone> createState() => _DropZoneState();
}

class _DropZoneState extends State<_DropZone> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DragTarget<_DragData>(
      onWillAcceptWithDetails: (_) {
        setState(() => _hover = true);
        return true;
      },
      onLeave: (_) => setState(() => _hover = false),
      onAcceptWithDetails: (details) {
        setState(() => _hover = false);
        widget.onAccept(details.data);
      },
      builder: (_, __, ___) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          height: 12,
          decoration: BoxDecoration(
            color: _hover
                ? theme.colorScheme.primary.withValues(alpha: 0.25)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
        );
      },
    );
  }
}

class _ConnectionCard extends StatelessWidget {
  final String columnKey;
  final int index;
  final SynthesisCard card;
  final Color color;

  const _ConnectionCard({
    required this.columnKey,
    required this.index,
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

  static const _tagLabels = {
    'none': 'Kein Cluster',
    'red': 'Rot',
    'blue': 'Blau',
    'green': 'Grün',
    'gold': 'Gelb',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tagColor = _tagColors[card.tag] ?? _tagColors['none']!;

    return LongPressDraggable<_DragData>(
      data: _DragData(fromColumn: columnKey, fromIndex: index, card: card),
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          width: 220,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black26)],
          ),
          child: Text(
            card.text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _buildCard(context, theme, tagColor),
      ),
      child: _buildCard(context, theme, tagColor),
    );
  }

  Widget _buildCard(BuildContext context, ThemeData theme, Color tagColor) {
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
            Text(_tagLabels[card.tag] ?? 'Kein Cluster'),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.palette_outlined),
          onSelected: (value) {
            context.read<SynthesisBloc>().add(SetSynthesisCardTag(card.id, value));
          },
          itemBuilder: (_) => [
            for (final entry in _tagLabels.entries)
              PopupMenuItem<String>(
                value: entry.key,
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: _tagColors[entry.key],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(entry.value),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
