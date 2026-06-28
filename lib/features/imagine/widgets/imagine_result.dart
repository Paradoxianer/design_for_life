import 'package:flutter/material.dart';

class ImagineResult extends StatelessWidget {
  final String? pastImageUrl;
  final String? futureImageUrl;
  final String takeaway;

  const ImagineResult({
    super.key,
    this.pastImageUrl,
    this.futureImageUrl,
    this.takeaway = '',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasImages = pastImageUrl != null || futureImageUrl != null;

    if (!hasImages) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Text(
            'Noch keine Bilder ausgewählt.',
            style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
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
                Expanded(child: _ImageCard(label: 'Vergangenheit', url: pastImageUrl!)),
              if (pastImageUrl != null && futureImageUrl != null) const SizedBox(width: 12),
              if (futureImageUrl != null)
                Expanded(child: _ImageCard(label: 'Zukunft', url: futureImageUrl!)),
            ],
          ),
          if (takeaway.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text('Meine Erkenntnis', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(takeaway, style: theme.textTheme.bodyLarge),
            ),
          ],
        ],
      ),
    );
  }
}

class _ImageCard extends StatelessWidget {
  final String label;
  final String url;

  const _ImageCard({required this.label, required this.url});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary)),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 3 / 4,
            child: Image.network(url, fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }
}
