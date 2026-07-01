import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../bloc/synthesis_bloc.dart';

typedef _SectionDef = ({String key, Color color});

class SynthesisResult extends StatelessWidget {
  final SynthesisState state;

  const SynthesisResult({super.key, required this.state});

  static const _sections = <_SectionDef>[
    (key: 'lifeTree', color: Color(0xFF2E7D32)),
    (key: 'values', color: Color(0xFF2D5A27)),
    (key: 'gifts', color: Color(0xFF6B4C9A)),
    (key: 'prayer', color: Color(0xFF1565C0)),
    (key: 'goals', color: Color(0xFF8B5E3C)),
  ];

  static const _tagColors = {
    'red': Color(0xFFD32F2F),
    'blue': Color(0xFF1976D2),
    'green': Color(0xFF2E7D32),
    'gold': Color(0xFFF9A825),
  };

  String _sectionLabel(BuildContext context, String key) {
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
    final allCards = state.columns.values.expand((x) => x).toList();
    final grouped = <String, List<SynthesisCard>>{};
    for (final card in allCards) {
      if (card.tag == 'none') continue;
      grouped.putIfAbsent(card.tag, () => []).add(card);
    }

    // Only show sections that have cards
    final activeSections = _sections
        .where((s) => (state.columns[s.key] ?? const []).isNotEmpty)
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (grouped.isNotEmpty) ...[
            Text(l10n.connectionsGroupedByColor, style: theme.textTheme.titleMedium),
            const SizedBox(height: 10),
            for (final entry in grouped.entries) ...[
              _ColorGroupCard(
                color: _tagColors[entry.key] ?? Colors.grey,
                cards: entry.value,
                label: l10n.connectionsColorGroup(entry.value.length),
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 16),
          ],
          if (activeSections.isNotEmpty) ...[
            Text(l10n.connectionsMatrixView, style: theme.textTheme.titleMedium),
            const SizedBox(height: 10),
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
                    for (final section in activeSections) ...[
                      _ResultColumn(
                        label: _sectionLabel(context, section.key),
                        color: section.color,
                        cards: state.columns[section.key] ?? const <SynthesisCard>[],
                      ),
                      const SizedBox(width: 12),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
          if (state.takeaways.any((t) => t.trim().isNotEmpty)) ...[
            Text(l10n.keyTakeaways, style: theme.textTheme.titleMedium),
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

class _ColorGroupCard extends StatelessWidget {
  final Color color;
  final List<SynthesisCard> cards;
  final String label;

  const _ColorGroupCard({
    required this.color,
    required this.cards,
    required this.label,
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
              Text(
                label,
                style: theme.textTheme.titleSmall,
              ),
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
        mainAxisSize: MainAxisSize.min,
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

