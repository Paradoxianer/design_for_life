import 'dart:io' as io;
import 'dart:typed_data';

import 'package:design_for_life/l10n/generated/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../models/shareable_content.dart';

/// Parst einen '#RRGGBB'-String zu einer [Color]. Fällt auf Grau zurück, wenn
/// [hex] fehlt oder ungültig ist.
Color _parseColor(String? hex) {
  if (hex == null) return Colors.grey;
  final normalized = hex.replaceFirst('#', '');
  final value = int.tryParse(normalized, radix: 16);
  if (value == null) return Colors.grey;
  return Color(0xFF000000 | value);
}

class ShareImageGenerator {
  static final ScreenshotController _brandingController = ScreenshotController();

  /// Wandelt gerenderte Bild-Bytes in ein teilbares [XFile].
  ///
  /// Auf Web gibt es kein Dateisystem, daher bleiben die Bytes im Speicher
  /// (XFile.fromData). Auf Mobile/Desktop ignoriert cross_file's XFile.fromData
  /// den `name`-Parameter jedoch komplett (siehe cross_file/src/types/io.dart -
  /// ohne `path` bekommt die Datei einen leeren Pfad/Namen). Beim Teilen
  /// mehrerer generierter Bilder in einem Rutsch führte das dazu, dass
  /// share_plus intern alle Bytes unter demselben (leeren) Namen ablegte -
  /// nur das zuletzt geschriebene Bild kam beim Empfänger an, der Rest war
  /// ungültig. Deshalb hier auf Mobile/Desktop einen echten, eindeutig
  /// benannten Temp-Datei-Pfad schreiben.
  static Future<XFile> _toXFile(Uint8List bytes, String fileName) async {
    if (kIsWeb) {
      return XFile.fromData(bytes, name: fileName, mimeType: 'image/png');
    }
    final directory = await getTemporaryDirectory();
    final uniqueName = '${DateTime.now().microsecondsSinceEpoch}_$fileName';
    final path = '${directory.path}/$uniqueName';
    await io.File(path).writeAsBytes(bytes);
    return XFile(path, mimeType: 'image/png');
  }

  /// Generiert die Liste der zu teilenden Bilder.
  static Future<List<XFile>> generateShareImages({
    required BuildContext context,
    required ShareableContent content,
    required List<ShareableItem> selectedItems,
  }) async {
    final List<XFile> files = [];

    for (var item in selectedItems) {
      // Jedes Item wird isoliert verarbeitet: ein Fehler bei einem Share-Typ
      // (z.B. ein kaputtes Bild oder ein Rendering-Fehler) darf die übrigen
      // ausgewählten Items nicht blockieren (#24).
      try {
        // 1. Digitaler Lebensbaum (nutzt das bereits gecapturte Bild aus der UI)
        if (item.data is Map && item.data['type'] == 'life_tree_graph') {
          final Uint8List? capturedBytes = item.data['capturedImage'] as Uint8List?;

          if (capturedBytes != null && capturedBytes.isNotEmpty) {
            final xFile = await _wrapCapturedImageWithBranding(context, content, capturedBytes);
            if (xFile != null) files.add(xFile);
          }
        }
        // 2. Imagine-Visualisierung (Gradient-Karte als Bild rendern)
        else if (item.data is Map && item.data['type'] == 'imagine_option') {
          final xFile = await _buildImagineOptionImage(
            context: context,
            content: content,
            item: item,
          );
          if (xFile != null) files.add(xFile);
        }
        // 2b. Imagine Vergangenheit+Zukunft als ein komponiertes Bild (#54)
        else if (item.data is Map && item.data['type'] == 'imagine_composed') {
          final xFile = await _buildComposedImagineImage(
            context: context,
            content: content,
            item: item,
          );
          if (xFile != null) files.add(xFile);
        }
        // 2c. Generische Text-Karte (z.B. Top-Gaben/-Werte/-Ziele als Bild statt reinem Text, #24)
        else if (item.data is Map && item.data['type'] == 'text_card') {
          final xFile = await _buildTextCardImage(
            context: context,
            content: content,
            item: item,
          );
          if (xFile != null) files.add(xFile);
        }
        // 3. Analoge Bilder / Notizen
        else if (item.imagePath != null) {
          // dart:io hat auf Web kein echtes Dateisystem (Blob-URLs lassen sich
          // nicht per File.exists() prüfen) - dort direkt als XFile übergeben,
          // cross_file liest den Blob beim Teilen selbst aus.
          if (kIsWeb) {
            files.add(XFile(item.imagePath!));
          } else if (await io.File(item.imagePath!).exists()) {
            files.add(XFile(item.imagePath!));
          }
        }
      } catch (e) {
        debugPrint('Error generating share image for item "${item.id}": $e');
      }
    }

    return files;
  }

  static Future<XFile?> _buildImagineOptionImage({
    required BuildContext context,
    required ShareableContent content,
    required ShareableItem item,
  }) async {
    final data = item.data as Map;
    final optionId = data['optionId'] as String?;
    if (optionId == null) return null;
    // optionId is the filename, e.g. "img_01.png"
    final imagePath = 'assets/images/imagine/$optionId';

    try {
      final rendered = await _brandingController.captureFromLongWidget(
        Material(
          color: Colors.white,
          child: Container(
            width: 1000,
            padding: const EdgeInsets.all(50),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(content),
                const SizedBox(height: 32),
                Text(
                  data['phase'] as String? ?? item.label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: AspectRatio(
                    aspectRatio: 2 / 3,
                    child: Image.asset(imagePath, fit: BoxFit.cover),
                  ),
                ),
              ],
            ),
          ),
        ),
        constraints: const BoxConstraints(maxWidth: 1000),
        pixelRatio: 2.0,
      );

      return await _toXFile(rendered, 'imagine_$optionId.png');
    } catch (e) {
      debugPrint('Error rendering imagine share image: $e');
      return null;
    }
  }

  /// Komponiert die Vergangenheit- und Zukunft-Bilder des Imagine-Moduls
  /// verlustfrei (beide in voller Auflösung, nur nebeneinander gesetzt und
  /// mit Branding umrahmt) zu einem einzigen teilbaren Bild (#54).
  static Future<XFile?> _buildComposedImagineImage({
    required BuildContext context,
    required ShareableContent content,
    required ShareableItem item,
  }) async {
    final data = item.data as Map;
    final pastOptionId = data['pastOptionId'] as String?;
    final futureOptionId = data['futureOptionId'] as String?;
    if (pastOptionId == null || futureOptionId == null) return null;

    final pastPath = 'assets/images/imagine/$pastOptionId';
    final futurePath = 'assets/images/imagine/$futureOptionId';
    final pastLabel = data['pastLabel'] as String? ?? '';
    final futureLabel = data['futureLabel'] as String? ?? '';

    try {
      final rendered = await _brandingController.captureFromLongWidget(
        Material(
          color: Colors.white,
          child: Container(
            width: 1000,
            padding: const EdgeInsets.all(50),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(content),
                const SizedBox(height: 32),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _ComposedImagineHalf(label: pastLabel, imagePath: pastPath),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _ComposedImagineHalf(label: futureLabel, imagePath: futurePath),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        constraints: const BoxConstraints(maxWidth: 1000),
        pixelRatio: 2.0,
      );

      return await _toXFile(rendered, 'imagine_composed.png');
    } catch (e) {
      debugPrint('Error rendering composed imagine share image: $e');
      return null;
    }
  }

  /// Rendert reinen Text (z.B. Top-3-Gaben mit Erklärung, Top-Werte mit
  /// Definition, SMARTe Ziele) als gebrandete Bild-Karte statt als reine
  /// Text-Checkliste zu teilen - Grundfunktion aus #24: jedes Modul soll ein
  /// Bild erzeugen können, auch ohne eigenes Foto/Grafik.
  static Future<XFile?> _buildTextCardImage({
    required BuildContext context,
    required ShareableContent content,
    required ShareableItem item,
  }) async {
    final data = item.data as Map;
    final heading = data['heading'] as String?;
    final entries = (data['entries'] as List? ?? const [])
        .cast<Map>()
        .toList();
    if (entries.isEmpty) return null;

    try {
      final rendered = await _brandingController.captureFromLongWidget(
        Material(
          color: Colors.white,
          child: Container(
            width: 1000,
            padding: const EdgeInsets.all(50),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(content),
                const SizedBox(height: 32),
                if (heading != null && heading.isNotEmpty) ...[
                  Text(
                    heading,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 28),
                ],
                for (final entry in entries) ...[
                  _TextCardEntry(
                    title: entry['title'] as String? ?? '',
                    body: entry['body'] as String?,
                    chips: (entry['chips'] as List?)?.cast<Map>(),
                    lines: (entry['lines'] as List?)?.cast<Map>(),
                  ),
                  if (entry != entries.last) const SizedBox(height: 20),
                ],
              ],
            ),
          ),
        ),
        constraints: const BoxConstraints(maxWidth: 1000),
        pixelRatio: 2.0,
      );

      return await _toXFile(rendered, 'card.png');
    } catch (e) {
      debugPrint('Error rendering text card share image: $e');
      return null;
    }
  }

  /// Fügt dem rohen Lebensbaum-Graph Branding als Streifen ober- und
  /// unterhalb hinzu, ohne das Originalbild in eine starre Karte
  /// einzupassen oder zu verkleinern. Die Canvas-Breite entspricht exakt
  /// der tatsächlichen Pixelbreite des Graphen (pixelRatio: 1.0), damit
  /// nichts nachskaliert wird (#25).
  static Future<XFile?> _wrapCapturedImageWithBranding(
    BuildContext context,
    ShareableContent content,
    Uint8List graphBytes,
  ) async {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    try {
      final decodedGraph = await decodeImageFromList(graphBytes);
      final double imageWidth = decodedGraph.width.toDouble();

      final Uint8List? finalImage = await _brandingController.captureFromLongWidget(
        Material(
          color: Colors.white,
          child: Theme(
            data: theme,
            child: Container(
              width: imageWidth,
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                    child: _buildHeader(content),
                  ),
                  // RawImage statt Image.memory: captureFromLongWidget misst die
                  // Höhe zuerst synchron, bevor Image.memory seine eigene
                  // asynchrone Decodierung abgeschlossen hat (v.a. auf Web spürbar
                  // träge) - das ergab eine zu kleine Messung und dadurch einen
                  // Overflow beim eigentlichen Rendern. decodedGraph ist hier
                  // bereits fertig decodiert und hat sofort eine bekannte Größe.
                  RawImage(image: decodedGraph, width: imageWidth, fit: BoxFit.fitWidth),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Divider(),
                        const SizedBox(height: 12),
                        Text(
                          l10n.shareFooter,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        constraints: BoxConstraints(maxWidth: imageWidth),
        delay: const Duration(milliseconds: 200),
        pixelRatio: 1.0,
      );

      if (finalImage == null) return null;

      return await _toXFile(finalImage, 'lebensbaum.png');
    } catch (e) {
      debugPrint('Error wrapping graph image: $e');
      return null;
    }
  }

  static Widget _buildHeader(ShareableContent content) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/DFL_Logo.png', height: 54),
        const SizedBox(width: 20),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'DESIGN FOR LIFE',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.green.shade700,
                  letterSpacing: 2.0,
                ),
              ),
              Text(
                content.title.split(':').last.trim(),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TextCardEntry extends StatelessWidget {
  final String title;
  final String? body;
  final List<Map>? chips;
  final List<Map>? lines;

  const _TextCardEntry({required this.title, this.body, this.chips, this.lines});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          if (chips != null && chips!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                for (final chip in chips!) ...[
                  _SmartChip(
                    label: chip['label'] as String? ?? '',
                    isActive: chip['isActive'] as bool? ?? false,
                  ),
                  if (chip != chips!.last) const SizedBox(width: 8),
                ],
              ],
            ),
          ],
          if (lines != null && lines!.isNotEmpty) ...[
            const SizedBox(height: 10),
            for (final line in lines!)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      margin: const EdgeInsets.only(top: 4, right: 8),
                      decoration: BoxDecoration(
                        color: _parseColor(line['color'] as String?),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        line['text'] as String? ?? '',
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade800, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
          ],
          if (body != null && body!.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              body!,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade800, height: 1.4),
            ),
          ],
        ],
      ),
    );
  }
}

/// Kompakte Variante der App-eigenen SmartIndicator-Chips (S/M/A/R/T) für
/// die Share-Karte - Kreis+Buchstabe, eingefärbt wenn aktiv, sonst grau.
///
/// Bewusst ohne Tooltip: Dieser Baum wird off-screen über
/// captureFromLongWidget zu einem statischen Bild gerendert, ohne
/// Navigator/Overlay-Vorfahren. Tooltip.build() verlangt aber zwingend einen
/// Overlay (auch wenn der Popup nie ausgelöst wird) und wirft sonst eine
/// Exception, die die gesamte Karte (z.B. bei Zielen) zum Verschwinden
/// brachte, weil sie vom umgebenden try/catch verschluckt wurde.
class _SmartChip extends StatelessWidget {
  final String label;
  final bool isActive;

  const _SmartChip({required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final color = isActive ? Colors.green.shade600 : Colors.grey.shade400;
    return Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }
}

class _ComposedImagineHalf extends StatelessWidget {
  final String label;
  final String imagePath;

  const _ComposedImagineHalf({required this.label, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (label.isNotEmpty)
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 2 / 3,
            child: Image.asset(imagePath, fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }
}
