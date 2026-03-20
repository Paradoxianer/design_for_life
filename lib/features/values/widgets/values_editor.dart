import 'package:flutter/material.dart';
import 'values_rating_view.dart';
import 'values_definitions_view.dart';
import 'values_reflection_view.dart';

class ValuesEditor extends StatefulWidget {
  const ValuesEditor({super.key});

  @override
  State<ValuesEditor> createState() => _ValuesEditorState();
}

class _ValuesEditorState extends State<ValuesEditor> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.transparent,
      ),
      child: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        onStepTapped: (step) => setState(() => _currentStep = step),
        onStepContinue: _currentStep < 2 ? () => setState(() => _currentStep++) : null,
        onStepCancel: _currentStep > 0 ? () => setState(() => _currentStep--) : null,
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              children: [
                if (_currentStep < 2)
                  ElevatedButton(
                    onPressed: details.onStepContinue,
                    child: const Text('Weiter'),
                  ),
                if (_currentStep > 0) ...[
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: const Text('Zurück'),
                  ),
                ],
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text('Bewertung'),
            content: const ValuesRatingView(),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Definition'),
            content: const ValuesDefinitionsView(),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Reflektion'),
            content: const ValuesReflectionView(),
            isActive: _currentStep >= 2,
          ),
        ],
      ),
    );
  }
}
