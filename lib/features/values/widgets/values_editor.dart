import 'package:flutter/material.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import 'values_rating_view.dart';
import 'values_definitions_view.dart';
import 'values_reflection_view.dart';

class ValuesEditor extends StatelessWidget {
  final int currentStep;
  final ValueChanged<int> onStepTapped;

  const ValuesEditor({
    super.key,
    required this.currentStep,
    required this.onStepTapped,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.transparent,
      ),
      child: Stepper(
        type: StepperType.horizontal,
        currentStep: currentStep,
        onStepTapped: onStepTapped,
        controlsBuilder: (context, details) => const SizedBox.shrink(),
        steps: [
          Step(
            title: _StepTitle(number: 1, fullLabel: l10n.valuesPhase1Title),
            content: const ValuesRatingView(),
            isActive: currentStep >= 0,
            state: currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: _StepTitle(number: 2, fullLabel: l10n.valuesPhase2Title),
            content: const ValuesDefinitionsView(),
            isActive: currentStep >= 1,
            state: currentStep > 1 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: _StepTitle(number: 3, fullLabel: l10n.valuesPhase3Title),
            content: const ValuesReflectionView(),
            isActive: currentStep >= 2,
          ),
        ],
      ),
    );
  }
}

/// Flutter's horizontal [Stepper] lays out each step's icon+title in a Row
/// without any Expanded/Flexible (only the connector lines between steps
/// are flexible), so a localized phase name ("Persönliche Definition")
/// overflows on narrow/medium screens. Showing just the step number keeps
/// the header's width fixed and overflow-proof regardless of locale or
/// screen size; the step circle itself swaps its number for a checkmark
/// once complete, so repeating the number here also keeps it visible. The
/// full phase name stays reachable via a long-press tooltip.
class _StepTitle extends StatelessWidget {
  final int number;
  final String fullLabel;

  const _StepTitle({required this.number, required this.fullLabel});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: fullLabel,
      child: Text('$number', style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}
