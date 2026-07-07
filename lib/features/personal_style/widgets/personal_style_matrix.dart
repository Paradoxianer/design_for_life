import 'package:flutter/material.dart';
import '../models/personal_style_result.dart';

/// 2x2-Matrix-Visualisierung des Personal-Style-Ergebnisses (#50):
///
/// |              | People | Task |
/// | Structured   |   ..   |  ..  |
/// | Unstructured |   ..   |  ..  |
///
/// Das Feld des Nutzers wird hervorgehoben. Feste, kompakte Zellenhöhen
/// statt AspectRatio-Quadraten, damit die Matrix auch auf sehr schmalen
/// Handy-Displays nicht zu klein wird (Akzeptanzkriterium "mobile-friendly").
class PersonalStyleMatrix extends StatelessWidget {
  final PersonalStyleQuadrant quadrant;
  final String peopleLabel;
  final String taskLabel;
  final String structuredLabel;
  final String unstructuredLabel;

  const PersonalStyleMatrix({
    super.key,
    required this.quadrant,
    required this.peopleLabel,
    required this.taskLabel,
    required this.structuredLabel,
    required this.unstructuredLabel,
  });

  static const double _rowHeaderWidth = 96;
  static const double _cellHeight = 88;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: _rowHeaderWidth),
            Expanded(child: _AxisHeader(peopleLabel)),
            const SizedBox(width: 8),
            Expanded(child: _AxisHeader(taskLabel)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(width: _rowHeaderWidth, child: _AxisHeader(structuredLabel, height: _cellHeight)),
            const SizedBox(width: 8),
            Expanded(
              child: _MatrixCell(
                height: _cellHeight,
                isActive: quadrant == PersonalStyleQuadrant.peopleStructured,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _MatrixCell(
                height: _cellHeight,
                isActive: quadrant == PersonalStyleQuadrant.taskStructured,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(width: _rowHeaderWidth, child: _AxisHeader(unstructuredLabel, height: _cellHeight)),
            const SizedBox(width: 8),
            Expanded(
              child: _MatrixCell(
                height: _cellHeight,
                isActive: quadrant == PersonalStyleQuadrant.peopleUnstructured,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _MatrixCell(
                height: _cellHeight,
                isActive: quadrant == PersonalStyleQuadrant.taskUnstructured,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AxisHeader extends StatelessWidget {
  final String label;
  final double? height;

  const _AxisHeader(this.label, {this.height});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: height,
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _MatrixCell extends StatelessWidget {
  final double height;
  final bool isActive;

  const _MatrixCell({required this.height, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isActive ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? theme.colorScheme.primary : theme.dividerColor,
          width: isActive ? 2 : 1,
        ),
      ),
      child: isActive
          ? Icon(Icons.person_pin_circle, color: theme.colorScheme.onPrimary, size: 32)
          : null,
    );
  }
}
