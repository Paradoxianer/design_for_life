import 'package:flutter/material.dart';

class SynthesisResult extends StatelessWidget {
  final Map<String, List<String>> orderedLists;

  const SynthesisResult({super.key, required this.orderedLists});

  static const _sections = [
    {'key': 'gifts',  'label': 'Geistliche Gaben', 'icon': Icons.volunteer_activism_rounded, 'color': Color(0xFF6B4C9A)},
    {'key': 'values', 'label': 'Werte',             'icon': Icons.diamond_outlined,           'color': Color(0xFF2D5A27)},
    {'key': 'prayer', 'label': 'Hörendes Gebet',    'icon': Icons.hearing_rounded,            'color': Color(0xFF1565C0)},
    {'key': 'goals',  'label': 'Ziele',             'icon': Icons.flag_rounded,               'color': Color(0xFF8B5E3C)},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final section in _sections) ...[
            _ResultSection(
              icon: section['icon'] as IconData,
              label: section['label'] as String,
              color: section['color'] as Color,
              items: orderedLists[section['key'] as String] ?? [],
            ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}

class _ResultSection extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final List<String> items;

  const _ResultSection({
    required this.icon,
    required this.label,
    required this.color,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (items.isEmpty) return const SizedBox.shrink();
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.25)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.07),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: Row(children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Text(label, style: theme.textTheme.titleSmall?.copyWith(color: color)),
            ]),
          ),
          for (int i = 0; i < items.length; i++)
            ListTile(
              dense: true,
              leading: CircleAvatar(
                radius: 11,
                backgroundColor: color.withOpacity(0.12),
                child: Text('${i + 1}',
                    style: TextStyle(
                        fontSize: 11, color: color, fontWeight: FontWeight.w600)),
              ),
              title: Text(items[i], style: theme.textTheme.bodyMedium),
            ),
        ],
      ),
    );
  }
}
