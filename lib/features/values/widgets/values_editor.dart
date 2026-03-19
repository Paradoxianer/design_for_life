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
    return Column(
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.transparent,
          ),
          child: Stepper(
            type: StepperType.horizontal,
            currentStep: _currentStep,
            onStepTapped: (step) => setState(() => _currentStep = step),
            onStepContinue: _currentStep < 2 
                ? () => setState(() => _currentStep++) 
                : null,
            onStepCancel: _currentStep > 0 
                ? () => setState(() => _currentStep--) 
                : null,
            steps: const [
              Step(
                title: Text('Bewertung'),
                content: SizedBox.shrink(),
                isActive: true,
              ),
              Step(
                title: Text('Definition'),
                content: SizedBox.shrink(),
                isActive: true,
              ),
              Step(
                title: Text('Reflektion'),
                content: SizedBox.shrink(),
                isActive: true,
              ),
            ],
            controlsBuilder: (context, details) => const SizedBox.shrink(),
          ),
        ),
        Expanded(
          child: IndexedStack(
            index: _currentStep,
            children: const [
              ValuesRatingView(),
              ValuesDefinitionsView(),
              ValuesReflectionView(),
            ],
          ),
        ),
      ],
    );
  }
}
