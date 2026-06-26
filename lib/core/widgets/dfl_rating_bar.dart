import 'package:flutter/material.dart';

class DflRatingBar extends StatelessWidget {
  final String? title;
  final int? currentValue;
  final int min;
  final int max;
  final ValueChanged<int>? onChanged;
  final List<String>? itemLabels;
  final bool isReadOnly;

  const DflRatingBar({
    super.key,
    this.title,
    required this.currentValue,
    this.onChanged,
    this.min = 1,
    this.max = 6,
    this.itemLabels,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = max - min + 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 4),
            child: Text(
              title!,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        LayoutBuilder(
          builder: (context, constraints) {
            const double spacing = 4.0;
            final double itemWidth = (constraints.maxWidth - (spacing * (count - 1))) / count;
            final bool hasLabels = itemLabels != null && itemLabels!.any((l) => l.isNotEmpty);
            
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(count, (index) {
                final value = min + index;
                final isSelected = currentValue == value;
                final label = (itemLabels != null && index < itemLabels!.length) 
                    ? itemLabels![index] 
                    : null;
                
                return GestureDetector(
                  onTap: isReadOnly || onChanged == null ? null : () => onChanged!(value),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: itemWidth,
                    height: hasLabels ? 46 : 38,
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? theme.colorScheme.primary 
                          : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? theme.colorScheme.primary : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (label != null && label.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: Text(
                              label,
                              style: TextStyle(
                                color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
                                fontSize: 10,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                height: 1.1,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        Text(
                          value.toString(),
                          style: TextStyle(
                            color: isSelected 
                                ? theme.colorScheme.onPrimary.withValues(alpha: 0.8) 
                                : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: hasLabels ? 9 : 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ],
    );
  }
}
