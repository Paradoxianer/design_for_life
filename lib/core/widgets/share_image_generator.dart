import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io' as io;
import '../models/shareable_content.dart';

class ShareImageGenerator {
  static final ScreenshotController screenshotController = ScreenshotController();

  static Future<XFile?> generateShareImage(ShareableContent content, List<ShareableItem> selectedItems) async {
    try {
      final Uint8List? imageBytes = await screenshotController.captureFromWidget(
        Material(child: _buildShareCard(content, selectedItems)),
        delay: const Duration(milliseconds: 300), // Slightly longer for images to load
        pixelRatio: 2.0,
      );

      if (imageBytes == null) return null;

      if (kIsWeb) {
        return XFile.fromData(
          imageBytes,
          mimeType: 'image/png',
          name: 'dfl_result.png',
        );
      } else {
        final directory = await getTemporaryDirectory();
        final imagePath = '${directory.path}/share_result_${DateTime.now().millisecondsSinceEpoch}.png';
        final imageFile = io.File(imagePath);
        await imageFile.writeAsBytes(imageBytes);
        return XFile(imagePath);
      }
    } catch (e) {
      debugPrint('Error generating share image: $e');
      return null;
    }
  }

  static Widget _buildShareCard(ShareableContent content, List<ShareableItem> selectedItems) {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/DFL_Logo.png',
                width: 40,
                height: 40,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.auto_awesome,
                  color: Colors.blue,
                  size: 40,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Design for Life',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      content.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          ...selectedItems.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                if (item.textValue != null && item.textValue!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.textValue!,
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
                if (item.imagePath != null) ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: kIsWeb 
                      ? Image.network(item.imagePath!, width: double.infinity, height: 200, fit: BoxFit.cover)
                      : Image.file(io.File(item.imagePath!), width: double.infinity, height: 200, fit: BoxFit.cover),
                  ),
                ],
              ],
            ),
          )),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Erstellt während des DFL-Wochenendes',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
