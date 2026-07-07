import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../bloc/values_bloc.dart';
import '../bloc/values_state.dart';
import 'values_rating_view.dart';
import 'values_definitions_view.dart';
import 'values_reflection_view.dart';

class ValuesEditor extends StatefulWidget {
  final int currentStep;
  final ValueChanged<int> onStepTapped;

  const ValuesEditor({
    super.key,
    required this.currentStep,
    required this.onStepTapped,
  });

  @override
  State<ValuesEditor> createState() => _ValuesEditorState();
}

// Flutter's Stepper (horizontal) rendert Kopfzeile (Nummern-Kreise) und
// Step-Inhalt als EINEN gemeinsamen, intern scrollenden Block - es gibt
// keine Möglichkeit, zwischen beiden eigenen fixen Inhalt einzufügen. Das
// Fortschritts-Widget muss aber sowohl unter der Kopfzeile sitzen als auch
// beim Scrollen sichtbar bleiben (#56). Lösung: als Positioned-Overlay direkt
// unter der Kopfzeile rendern (deren Höhe bei diesem Stepper ohne
// stepIconHeight/Step.label immer exakt 72px beträgt, siehe
// flutter/material/stepper.dart) und dessen eigene, gemessene Höhe der
// Werteliste als Top-Padding mitgeben, damit der Erklärtext nicht darunter
// verschwindet.
class _ValuesEditorState extends State<ValuesEditor> {
  static const double _stepperHeaderHeight = 72;
  final GlobalKey _bannerKey = GlobalKey();
  double _bannerHeight = 0;

  void _measureBanner() {
    final renderBox = _bannerKey.currentContext?.findRenderObject() as RenderBox?;
    final height = renderBox?.size.height ?? 0;
    if (height > 0 && height != _bannerHeight) {
      setState(() => _bannerHeight = height);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (widget.currentStep == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _measureBanner();
      });
    }

    return Stack(
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.transparent,
          ),
          child: Stepper(
            type: StepperType.horizontal,
            currentStep: widget.currentStep,
            onStepTapped: widget.onStepTapped,
            controlsBuilder: (context, details) => const SizedBox.shrink(),
            steps: [
              Step(
                title: _StepTitle(number: 1, fullLabel: l10n.valuesPhase1Title),
                content: ValuesRatingView(topPadding: widget.currentStep == 0 ? _bannerHeight : 0),
                isActive: widget.currentStep >= 0,
                state: widget.currentStep > 0 ? StepState.complete : StepState.indexed,
              ),
              Step(
                title: _StepTitle(number: 2, fullLabel: l10n.valuesPhase2Title),
                content: const ValuesDefinitionsView(),
                isActive: widget.currentStep >= 1,
                state: widget.currentStep > 1 ? StepState.complete : StepState.indexed,
              ),
              Step(
                title: _StepTitle(number: 3, fullLabel: l10n.valuesPhase3Title),
                content: const ValuesReflectionView(),
                isActive: widget.currentStep >= 2,
              ),
            ],
          ),
        ),
        if (widget.currentStep == 0)
          Positioned(
            top: _stepperHeaderHeight,
            left: 0,
            right: 0,
            child: _RatingProgressBanner(key: _bannerKey),
          ),
      ],
    );
  }
}

/// Zeigt "X von 8 Werten bewertet" fix oberhalb der Werteliste, unabhängig
/// vom Scroll-Zustand darin (#56).
class _RatingProgressBanner extends StatelessWidget {
  const _RatingProgressBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<ValuesBloc, ValuesState>(
      builder: (context, state) {
        final top8Count = state.topEightValues.length;
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Card(
            color: top8Count == 8 ? Colors.green.shade50 : Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Icon(
                    top8Count == 8 ? Icons.check_circle : Icons.info_outline,
                    color: top8Count == 8 ? Colors.green : Colors.blue,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.valuesSelectionStatus(top8Count),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: top8Count > 8 ? Colors.red : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
