import 'package:flutter/material.dart';
import '../models/personal_style_result.dart';

/// 2x2-Matrix-Visualisierung des Personal-Style-Ergebnisses (#50) mit
/// präziser Positionierung statt nur grober Quadranten-Hervorhebung: eine
/// Markierung sitzt an der exakten Position auf beiden Achsen
/// (organisationFraction/energyFraction, je 0.0-1.0), sodass sichtbar ist,
/// ob jemand eher in der Mitte oder eher am Rand eines Quadranten liegt.
///
/// |              | People | Task |
/// | Structured   |   ..   |  ..  |
/// | Unstructured |   ..   |  ..  |
class PersonalStyleMatrix extends StatelessWidget {
  final PersonalStyleQuadrant quadrant;

  /// 0.0 = vollständig strukturiert (oben), 1.0 = vollständig unstrukturiert
  /// (unten) - vertikale Achse.
  final double organisationFraction;

  /// 0.0 = vollständig Mensch-orientiert (links), 1.0 = vollständig
  /// aufgabenorientiert (rechts) - horizontale Achse.
  final double energyFraction;

  final String peopleLabel;
  final String taskLabel;
  final String structuredLabel;
  final String unstructuredLabel;

  const PersonalStyleMatrix({
    super.key,
    required this.quadrant,
    required this.organisationFraction,
    required this.energyFraction,
    required this.peopleLabel,
    required this.taskLabel,
    required this.structuredLabel,
    required this.unstructuredLabel,
  });

  static const double _rowHeaderWidth = 96;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
        AspectRatio(
          aspectRatio: 1,
          child: Row(
            children: [
              SizedBox(
                width: _rowHeaderWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _AxisHeader(structuredLabel),
                    _AxisHeader(unstructuredLabel),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.dividerColor),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _QuadrantPlanePainter(
                            quadrant: quadrant,
                            activeColor: theme.colorScheme.primary.withValues(alpha: 0.18),
                            inactiveColor: theme.colorScheme.surfaceContainerHighest,
                            lineColor: theme.dividerColor,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment(energyFraction * 2 - 1, organisationFraction * 2 - 1),
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.colorScheme.primary,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AxisHeader extends StatelessWidget {
  final String label;

  const _AxisHeader(this.label);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      label,
      textAlign: TextAlign.center,
      style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

/// Zeichnet die vier (leicht eingefärbten, das aktive Quadrant stärker
/// betont) Hintergrundfelder plus die beiden Trennlinien, die die 2x2-Matrix
/// bilden - die Positionsmarkierung selbst kommt separat per [Align] oben
/// drauf, damit sie unabhängig von der Canvas-Größe exakt platziert wird.
class _QuadrantPlanePainter extends CustomPainter {
  final PersonalStyleQuadrant quadrant;
  final Color activeColor;
  final Color inactiveColor;
  final Color lineColor;

  _QuadrantPlanePainter({
    required this.quadrant,
    required this.activeColor,
    required this.inactiveColor,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final halfW = size.width / 2;
    final halfH = size.height / 2;

    final quadrantRects = {
      PersonalStyleQuadrant.peopleStructured: Rect.fromLTWH(0, 0, halfW, halfH),
      PersonalStyleQuadrant.taskStructured: Rect.fromLTWH(halfW, 0, halfW, halfH),
      PersonalStyleQuadrant.peopleUnstructured: Rect.fromLTWH(0, halfH, halfW, halfH),
      PersonalStyleQuadrant.taskUnstructured: Rect.fromLTWH(halfW, halfH, halfW, halfH),
    };

    final backgroundPaint = Paint()..color = inactiveColor;
    canvas.drawRect(Offset.zero & size, backgroundPaint);

    final activePaint = Paint()..color = activeColor;
    canvas.drawRect(quadrantRects[quadrant]!, activePaint);

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(halfW, 0), Offset(halfW, size.height), linePaint);
    canvas.drawLine(Offset(0, halfH), Offset(size.width, halfH), linePaint);
  }

  @override
  bool shouldRepaint(covariant _QuadrantPlanePainter oldDelegate) =>
      oldDelegate.quadrant != quadrant ||
      oldDelegate.activeColor != activeColor ||
      oldDelegate.inactiveColor != inactiveColor ||
      oldDelegate.lineColor != lineColor;
}
