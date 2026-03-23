import 'package:flutter/material.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';

class StageNavigator extends StatelessWidget {
  final int currentStage;
  final int totalStages;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final VoidCallback onFinish;
  final bool isNextEnabled;

  const StageNavigator({
    super.key,
    required this.currentStage,
    required this.totalStages,
    this.onNext,
    this.onPrevious,
    required this.onFinish,
    this.isNextEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final isLastStage = currentStage == totalStages - 1;
    final isMultiStage = totalStages > 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Left: Previous Button
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: (isMultiStage && currentStage > 0)
                    ? IconButton.filledTonal(
                        onPressed: onPrevious,
                        icon: const Icon(Icons.arrow_back),
                        tooltip: l10n.previous,
                      )
                    : const SizedBox.shrink(),
              ),
            ),

            // Middle: Finish Button (Floating style)
            Expanded(
              flex: 2,
              child: Center(
                child: FloatingActionButton.extended(
                  heroTag: 'finish_fab',
                  onPressed: isLastStage && !isNextEnabled ? null : onFinish,
                  icon: const Icon(Icons.check),
                  label: Text(l10n.finish),
                  backgroundColor: isLastStage ? theme.colorScheme.primary : theme.colorScheme.secondaryContainer,
                  foregroundColor: isLastStage ? theme.colorScheme.onPrimary : theme.colorScheme.onSecondaryContainer,
                  elevation: 4,
                ),
              ),
            ),

            // Right: Next Button
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: (isMultiStage && !isLastStage)
                    ? IconButton.filledTonal(
                        onPressed: isNextEnabled ? onNext : null,
                        icon: const Icon(Icons.arrow_forward),
                        tooltip: l10n.next,
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
