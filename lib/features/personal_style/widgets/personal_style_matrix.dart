import 'package:flutter/material.dart';
import '../models/personal_style_result.dart';

/// 2x2-Matrix-Visualisierung des Personal-Style-Ergebnisses (#50) mit
/// präziser Positionierung statt nur grober Quadranten-Hervorhebung: eine
/// Markierung sitzt an der exakten Position auf beiden Achsen
/// (organisationFraction/energyFraction, je 0.0-1.0), sodass sichtbar ist,
/// ob jemand eher in der Mitte oder eher am Rand eines Quadranten liegt.
/// Zusätzlich zeigt je eine kleine Prozent-Markierung genau am Schnittpunkt
/// mit der jeweiligen Mittellinie die exakte Zahl.
///
/// |              | People | Task |
/// | Structured   |   ..   |  ..  |
/// | Unstructured |   ..   |  ..  |
///
/// Bewusst KEIN Flutter-Tooltip für die Prozentzahlen: Dieses Widget wird
/// auch off-screen für Share-/PDF-Export gerendert (captureFromLongWidget),
/// wo kein Overlay-Vorfahre existiert - Tooltip.build() wirft dort zwingend
/// eine Exception (siehe _SmartChip in share_image_generator.dart für den
/// identischen, bereits einmal behobenen Fehler).
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

  /// Begrenzt die Darstellung auf eine kompakte, feste Maximalbreite (statt
  /// die gesamte verfügbare Breite auszufüllen) - auf breiten Bildschirmen
  /// (z.B. Tablet im Querformat) wirkte ein über die volle Breite gezogenes
  /// Koordinatensystem unübersichtlich. Im Export-/Share-Bild (feste
  /// Canvas-Breite) ist die volle Breite dagegen gewünscht, daher hier
  /// abschaltbar.
  final bool constrainWidth;

  const PersonalStyleMatrix({
    super.key,
    required this.quadrant,
    required this.organisationFraction,
    required this.energyFraction,
    required this.peopleLabel,
    required this.taskLabel,
    required this.structuredLabel,
    required this.unstructuredLabel,
    this.constrainWidth = true,
  });

  static const double _rowHeaderWidth = 120;
  static const double _tickStripWidth = 8;
  static const double _maxWidth = 340;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final organisationShare = dominantPoleShare(organisationFraction);
    final energyShare = dominantPoleShare(energyFraction);

    final content = Column(
      children: [
        Row(
          children: [
            const SizedBox(width: _rowHeaderWidth + _tickStripWidth),
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
                    _RowAxisHeader(structuredLabel),
                    _RowAxisHeader(unstructuredLabel),
                  ],
                ),
              ),
              // Prozent-Markierung für die Organisation-Achse, auf Höhe der
              // Positionsmarkierung, direkt am Rand zur Fläche hin - der
              // "Schnittpunkt" der gedachten waagrechten Linie vom Punkt zum
              // Rand.
              SizedBox(
                width: _tickStripWidth,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Align(
                      alignment: Alignment(1, organisationFraction * 2 - 1),
                      child: _PercentTick('${organisationShare.percent}%'),
                    ),
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
        const SizedBox(height: 6),
        // Prozent-Markierung für die Energie-Achse, unterhalb der Fläche,
        // horizontal auf Höhe der Positionsmarkierung - derselbe
        // Einrückungs-Offset wie oben, damit sie exakt unter der Fläche
        // (nicht unter der Zeilenbeschriftung) sitzt.
        Row(
          children: [
            const SizedBox(width: _rowHeaderWidth + _tickStripWidth + 8),
            Expanded(
              child: SizedBox(
                height: 18,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Align(
                      alignment: Alignment(energyFraction * 2 - 1, 0),
                      child: _PercentTick('${energyShare.percent}%'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );

    if (!constrainWidth) return content;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _maxWidth),
        child: content,
      ),
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

/// Variante für die schmalere seitliche Zeilenbeschriftung (Strukturiert/
/// Unstrukturiert): kleinere Schrift und rechtsbündig statt zentriert, damit
/// auch längere Wörter im begrenzten Platz sauber (ggf. zweizeilig) umbrechen
/// statt abgeschnitten oder gequetscht zu wirken.
class _RowAxisHeader extends StatelessWidget {
  final String label;

  const _RowAxisHeader(this.label);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      label,
      textAlign: TextAlign.right,
      style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

/// Kleine Prozent-Plakette, platziert am Schnittpunkt der Positions-
/// markierung mit der jeweiligen Mittellinie (statt als Tooltip, siehe
/// Klassenkommentar an [PersonalStyleMatrix]).
class _PercentTick extends StatelessWidget {
  final String text;

  const _PercentTick(this.text);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
      ),
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
