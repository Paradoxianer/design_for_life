import 'package:flutter/material.dart';

class RatingSelector extends StatelessWidget {
  final String label;
  final int currentRating;
  final ValueChanged<int> onRatingChanged;
  final int minRating;
  final int maxRating;

  const RatingSelector({
    super.key,
    required this.label,
    required this.currentRating,
    required this.onRatingChanged,
    this.minRating = 1,
    this.maxRating = 6,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(maxRating - minRating + 1, (index) {
                final rating = minRating + index;
                final isSelected = currentRating == rating;
                
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(
                      rating.toString(),
                      style: TextStyle(
                        color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) onRatingChanged(rating);
                    },
                    selectedColor: theme.colorScheme.primary,
                    backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
