import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import 'dart:io' as io;
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
      // 2. Analoge Bilder / Notizen
      else if (item.imagePath != null) {
        final file = io.File(item.imagePath!);
        if (await file.exists()) {
          files.add(XFile(item.imagePath!));
        }
      }
    }

    return files;
  }

  /// Nimmt das rohe Bild des Graphen und fügt Header, Footer und Branding hinzu.
  static Future<XFile?> _wrapCapturedImageWithBranding(
    BuildContext context, 
    ShareableContent content, 
    Uint8List graphBytes
  ) async {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    try {
      // Wir bauen eine saubere "Karte" um das existierende Bild
      final Uint8List? finalImage = await _brandingController.captureFromWidget(
        Material(
          color: Colors.white,
          child: Theme(
            data: theme,
            child: Container(
              width: 1000, // Etwas breiter für hohe Qualität
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
                  // Das Bild, das wir direkt aus der UI "fotografiert" haben
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
        delay: const Duration(milliseconds: 200), // Puffer für das Laden von Image.memory
        pixelRatio: 2.0,
      );

      if (finalImage == null) return null;

      final directory = await getTemporaryDirectory();
      // Eindeutiger Zeitstempel inkl. Mikrosekunden gegen Windows-Dateisperren
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
