import 'dart:io' as io;
import 'dart:typed_data';

import 'package:design_for_life/l10n/generated/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../models/shareable_content.dart';

class ShareImageGenerator {
  static final ScreenshotController _brandingController = ScreenshotController();

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

      return XFile.fromData(
        rendered,
        name: 'imagine_$optionId.png',
        mimeType: 'image/png',
      );
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

      return XFile.fromData(
        rendered,
        name: 'imagine_composed.png',
        mimeType: 'image/png',
      );
    } catch (e) {
      debugPrint('Error rendering composed imagine share image: $e');
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
                  Image.memory(graphBytes, width: imageWidth, fit: BoxFit.fitWidth),
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

      return XFile.fromData(
        finalImage,
        name: 'lebensbaum.png',
        mimeType: 'image/png',
      );
    } catch (e) {
      debugPrint('Error wrapping graph image: $e');
      return null;
    }
  }

  static Widget _buildHeader(ShareableContent content) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.auto_awesome, color: Colors.green, size: 54),
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
