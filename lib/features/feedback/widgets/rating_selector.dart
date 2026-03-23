import 'package:flutter/material.dart';

class RatingSelector extends StatelessWidget {
  final String label;
  final int currentRating;
  final ValueChanged<int> onRatingChanged;
  final int minRating;
  final int maxRating;
  final List<String>? ratingLabels;

  const RatingSelector({
    super.key,
    required this.label,
    required this.currentRating,
    required this.onRatingChanged,
    this.minRating = 1,
    this.maxRating = 6,
    this.ratingLabels,
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
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.start,
            children: List.generate(maxRating - minRating + 1, (index) {
              final rating = minRating + index;
              final isSelected = currentRating == rating;
              
              return InkWell(
                onTap: () => onRatingChanged(rating),
                borderRadius: BorderRadius.circular(8),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                  width: 62, // Optimized width for labels and numbers
                  decoration: BoxDecoration(
                    color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? theme.colorScheme.primary : Colors.black12,
                      width: 1.2,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (ratingLabels != null && index < ratingLabels!.length)
                        Text(
                          ratingLabels![index],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            fontSize: 9,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      Text(
                        '$rating',
                        style: TextStyle(
                          color: isSelected ? Colors.white70 : Colors.black87,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
