import 'package:flutter/material.dart';

import '../bloc/synthesis_bloc.dart';

class SynthesisResult extends StatelessWidget {
  final SynthesisState state;

  const SynthesisResult({super.key, required this.state});

  static const _sections = [
    ('lifeTree', 'Lebensbaum', Color(0xFF2E7D32)),
    ('values', 'Werte', Color(0xFF2D5A27)),
    ('gifts', 'Gaben', Color(0xFF6B4C9A)),
    ('prayer', 'Hörendes Gebet', Color(0xFF1565C0)),
    ('goals', 'Ziele', Color(0xFF8B5E3C)),
  ];

  static const _tagColors = {
    'red': Color(0xFFD32F2F),
    'blue': Color(0xFF1976D2),
    'green': Color(0xFF2E7D32),
    'gold': Color(0xFFF9A825),
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final allCards = state.columns.values.expand((x) => x).toList();
    final grouped = <String, List<SynthesisCard>>{};
    for (final card in allCards) {
      if (card.tag == 'none') continue;
      grouped.putIfAbsent(card.tag, () => []).add(card);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (grouped.isNotEmpty) ...[
            Text('Cluster / rote Linien', style: theme.textTheme.titleMedium),
            const SizedBox(height: 10),
            for (final entry in grouped.entries) ...[
              _ClusterCard(
                color: _tagColors[entry.key] ?? Colors.grey,
                cards: entry.value,
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 16),
          ],
          Text('Matrix-Ansicht', style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final (key, label, color) in _sections) ...[
                  _ResultColumn(
                    label: label,
                    color: color,
                    cards: state.columns[key] ?? const <SynthesisCard>[],
                  ),
                  const SizedBox(width: 12),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (state.takeaways.any((t) => t.trim().isNotEmpty)) ...[
            Text('Key Takeaways', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            for (final takeaway in state.takeaways)
              if (takeaway.trim().isNotEmpty)
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.check_circle_outline),
                  title: Text(takeaway),
                ),
          ],
        ],
      ),
    );
  }
}

class _ClusterCard extends StatelessWidget {
  final Color color;
  final List<SynthesisCard> cards;

  const _ClusterCard({
    required this.color,
    required this.cards,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: color.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text('Cluster (${cards.length})', style: theme.textTheme.titleSmall),
            ],
          ),
          const SizedBox(height: 8),
          for (final card in cards)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text('• ${card.text}', style: theme.textTheme.bodyMedium),
            ),
        ],
      ),
    );
  }
}

class _ResultColumn extends StatelessWidget {
  final String label;
  final Color color;
  final List<SynthesisCard> cards;

  const _ResultColumn({
    required this.label,
    required this.color,
    required this.cards,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 240,
      decoration: BoxDecoration(
        border: Border.all(color: color.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: Text(
              label,
              style: theme.textTheme.titleSmall?.copyWith(color: color),
            ),
          ),
          if (cards.isEmpty)
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'Keine Einträge',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            )
          else
            for (final card in cards)
              ListTile(
                dense: true,
                title: Text(card.text, style: theme.textTheme.bodyMedium),
              ),
        ],
      ),
    );
  }
}
