import 'package:flutter/material.dart';

class ImagineResult extends StatelessWidget {
  final String? pastImageUrl;
  final String? futureImageUrl;

  const ImagineResult({
    super.key,
    this.pastImageUrl,
    this.futureImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final hasImages = pastImageUrl != null || futureImageUrl != null;

    if (!hasImages) {
      final theme = Theme.of(context);
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Text(
            'Noch keine Bilder ausgewählt.',
            style: theme.textTheme.bodyLarge
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (pastImageUrl != null)
                Expanded(
                  child: _OptionResultCard(
                    label: 'Vergangenheit',
                    optionId: pastImageUrl!,
                  ),
                ),
              if (pastImageUrl != null && futureImageUrl != null)
                const SizedBox(width: 12),
              if (futureImageUrl != null)
                Expanded(
                  child: _OptionResultCard(
                    label: 'Zukunft',
                    optionId: futureImageUrl!,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OptionResultCard extends StatelessWidget {
  final String label;
  final String optionId;

  const _OptionResultCard({required this.label, required this.optionId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final option = _optionById[optionId] ??
        const _ImagineResultOption(
          title: 'Auswahl',
          colors: [Color(0xFF455A64), Color(0xFF90A4AE)],
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge
              ?.copyWith(color: theme.colorScheme.primary),
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 3 / 4,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: option.colors,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    option.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      shadows: const [
                        Shadow(blurRadius: 4, color: Colors.black54),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ImagineResultOption {
  final String title;
  final List<Color> colors;

  const _ImagineResultOption({required this.title, required this.colors});
}

const Map<String, _ImagineResultOption> _optionById = {
  'past_roots': _ImagineResultOption(
    title: 'Wurzeln & Herkunft',
    colors: [Color(0xFF4E342E), Color(0xFF8D6E63), Color(0xFFBCAAA4)],
  ),
  'past_stones': _ImagineResultOption(
    title: 'Erfahrung & Beständigkeit',
    colors: [Color(0xFF37474F), Color(0xFF607D8B), Color(0xFF90A4AE)],
  ),
  'past_valley': _ImagineResultOption(
    title: 'Lernen in Tiefen',
    colors: [Color(0xFF1A237E), Color(0xFF3949AB), Color(0xFF7986CB)],
  ),
  'past_warm_memory': _ImagineResultOption(
    title: 'Warme Erinnerungen',
    colors: [Color(0xFF6D4C41), Color(0xFFA1887F), Color(0xFFD7CCC8)],
  ),
  'past_growth': _ImagineResultOption(
    title: 'Wachstum im Rückblick',
    colors: [Color(0xFF1B5E20), Color(0xFF43A047), Color(0xFF81C784)],
  ),
  'future_horizon': _ImagineResultOption(
    title: 'Neuer Horizont',
    colors: [Color(0xFF0D47A1), Color(0xFF1976D2), Color(0xFF64B5F6)],
  ),
  'future_light': _ImagineResultOption(
    title: 'Licht & Klarheit',
    colors: [Color(0xFFF9A825), Color(0xFFFFCA28), Color(0xFFFFF59D)],
  ),
  'future_path': _ImagineResultOption(
    title: 'Weg & Richtung',
    colors: [Color(0xFF4A148C), Color(0xFF7B1FA2), Color(0xFFBA68C8)],
  ),
  'future_peace': _ImagineResultOption(
    title: 'Frieden & Weite',
    colors: [Color(0xFF00695C), Color(0xFF26A69A), Color(0xFF80CBC4)],
  ),
  'future_bloom': _ImagineResultOption(
    title: 'Aufbruch & Entfaltung',
    colors: [Color(0xFFAD1457), Color(0xFFEC407A), Color(0xFFF48FB1)],
  ),
};
