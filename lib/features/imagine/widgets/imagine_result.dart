import 'package:flutter/material.dart';
import '../../../core/widgets/image_fullscreen_viewer.dart';
import '../../../core/widgets/key_takeaway_field.dart';
import '../models/imagine_visual_option.dart';

class ImagineResult extends StatelessWidget {
  final String? pastImageId;
  final String? futureImageId;
  final List<String> takeaways;
  final Function(int, String) onUpdate;

  const ImagineResult({
    super.key,
    this.pastImageId,
    this.futureImageId,
    required this.takeaways,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final hasImages = pastImageId != null || futureImageId != null;

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

    return FutureBuilder<List<ImagineVisualOption>>(
      future: loadImagineOptions(),
      builder: (context, snapshot) {
        final options = {
          for (final o in snapshot.data ?? <ImagineVisualOption>[]) o.id: o,
        };
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (pastImageId != null)
                    Expanded(
                      child: _ImageResultCard(
                        label: 'Vergangenheit',
                        option: options[pastImageId!],
                        imagePath: pastImageId,
                      ),
                    ),
                  if (pastImageId != null && futureImageId != null)
                    const SizedBox(width: 12),
                  if (futureImageId != null)
                    Expanded(
                      child: _ImageResultCard(
                        label: 'Zukunft',
                        option: options[futureImageId!],
                        imagePath: futureImageId,
                      ),
                    ),
                ],
              ),
              if (takeaways.any((t) => t.isNotEmpty)) ...[
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 16),
                KeyTakeawayField(
                  takeaways: takeaways,
                  onUpdate: onUpdate,
                  isReadOnly: true,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _ImageResultCard extends StatelessWidget {
  final String label;
  final ImagineVisualOption? option;
  final String? imagePath;

  const _ImageResultCard({
    required this.label,
    this.option,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resolvedPath = option?.imagePath ??
        (imagePath != null ? 'assets/images/imagine/$imagePath' : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge
              ?.copyWith(color: theme.colorScheme.primary),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: resolvedPath != null
              ? () => showImageFullscreen(context, resolvedPath)
              : null,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 2 / 3,
              child: resolvedPath != null
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(resolvedPath, fit: BoxFit.cover),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Icons.fullscreen,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    )
                  : ColoredBox(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: const SizedBox.expand(),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

