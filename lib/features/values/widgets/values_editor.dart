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
            title: Text(l10n.valuesPhase1Title),
            content: const ValuesRatingView(),
            isActive: currentStep >= 0,
            state: currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: Text(l10n.valuesPhase2Title),
            content: const ValuesDefinitionsView(),
            isActive: currentStep >= 1,
            state: currentStep > 1 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: Text(l10n.valuesPhase3Title),
            content: const ValuesReflectionView(),
            isActive: currentStep >= 2,
          ),
        ],
      ),
    );
  }
}
