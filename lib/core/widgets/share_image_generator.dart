import 'dart:io' as io;
import 'dart:typed_data';

import 'package:design_for_life/l10n/generated/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../features/imagine/models/imagine_visual_option.dart';
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
      // 3. Analoge Bilder / Notizen
      else if (item.imagePath != null) {
        final file = io.File(item.imagePath!);
        if (await file.exists()) {
          files.add(XFile(item.imagePath!));
        }
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
    final option = imagineOptionsById[optionId];
    if (option == null) return null;

    try {
      final rendered = await _brandingController.captureFromWidget(
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
                  child: Container(
                    height: 920,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: option.colors,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          option.label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.w700,
                            shadows: [Shadow(blurRadius: 5, color: Colors.black54)],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        pixelRatio: 2.0,
      );

      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/imagine_${option.id}_${DateTime.now().microsecondsSinceEpoch}.png';
      final file = io.File(path);
      await file.writeAsBytes(rendered);
      return XFile(path);
    } catch (e) {
      debugPrint('Error rendering imagine share image: $e');
      return null;
    }
  }

  /// Nimmt das rohe Bild des Graphen und fügt Header, Footer und Branding hinzu.
  static Future<XFile?> _wrapCapturedImageWithBranding(
    BuildContext context,
    ShareableContent content,
    Uint8List graphBytes,
  ) async {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    try {
      final Uint8List? finalImage = await _brandingController.captureFromWidget(
        Material(
          color: Colors.white,
          child: Theme(
            data: theme,
            child: Container(
              width: 1000,
              padding: const EdgeInsets.all(50),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green.shade50, width: 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildHeader(content),
                  const SizedBox(height: 40),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.memory(
                        graphBytes,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Divider(),
                  const SizedBox(height: 24),
                  Text(
                    l10n.shareFooter,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
        delay: const Duration(milliseconds: 200),
        pixelRatio: 2.0,
      );

      if (finalImage == null) return null;

      final directory = await getTemporaryDirectory();
      final ts = DateTime.now().microsecondsSinceEpoch;
      final path = '${directory.path}/lebensbaum_final_$ts.png';
      final file = io.File(path);

      await file.writeAsBytes(finalImage);
      return XFile(path);
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
