import 'package:flutter/material.dart';
import '../models/editor_stage.dart';

class StageHeader extends StatelessWidget {
  final List<EditorStage> stages;
  final int currentStageIndex;
  final Function(int) onStageTapped;

  const StageHeader({
    super.key,
    required this.stages,
    required this.currentStageIndex,
    required this.onStageTapped,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (stages.length <= 1) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: theme.dividerColor.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        children: List.generate(stages.length, (index) {
          final isSelected = index == currentStageIndex;
          final isPast = index < currentStageIndex;
          
          return Expanded(
            child: InkWell(
              onTap: () => onStageTapped(index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected 
                          ? theme.colorScheme.primary 
                          : (isPast ? theme.colorScheme.primary.withValues(alpha: 0.2) : theme.colorScheme.surfaceContainer),
                      border: isSelected 
                          ? null 
                          : Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.5)),
                    ),
                    child: Center(
                      child: isPast 
                        ? Icon(Icons.check, size: 14, color: theme.colorScheme.primary)
                        : Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stages[index].title,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
