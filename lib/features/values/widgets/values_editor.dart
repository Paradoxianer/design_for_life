import 'package:flutter/material.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../../../core/models/editor_stage.dart';
import '../../../core/widgets/stage_header.dart';
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

    final stages = [
      EditorStage(title: l10n.valuesPhase1Title, content: const ValuesRatingView()),
      EditorStage(title: l10n.valuesPhase2Title, content: const ValuesDefinitionsView()),
      EditorStage(title: l10n.valuesPhase3Title, content: const ValuesReflectionView()),
    ];

    return Column(
      children: [
        StageHeader(
          stages: stages,
          currentStageIndex: currentStep,
          onStageTapped: onStepTapped,
        ),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: KeyedSubtree(
              key: ValueKey<int>(currentStep),
              child: stages[currentStep].content,
            ),
          ),
        ),
      ],
    );
  }
}
