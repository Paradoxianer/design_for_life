import 'package:flutter/material.dart';
import '../models/imagine_visual_option.dart';

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
    final option = _resolveOption(optionId);

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
                    option.label,
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

ImagineVisualOption _resolveOption(String optionId) {
  final option = imagineOptionsById[optionId];
  if (option != null) {
    return option;
  }
  debugPrint(
    'ImagineResult: unknown optionId "$optionId". Valid ids: ${imagineOptionsById.keys.join(', ')}',
  );
  return const ImagineVisualOption(
    id: 'fallback',
    label: 'Auswahl',
    colors: [Color(0xFF455A64), Color(0xFF90A4AE)],
  );
}
