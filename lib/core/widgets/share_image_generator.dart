import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import '../models/shareable_content.dart';

class ShareImageGenerator {
  static final ScreenshotController screenshotController = ScreenshotController();

  static Future<String?> generateShareImage(ShareableContent content, List<ShareableItem> selectedItems) async {
    try {
      final Uint8List? imageBytes = await screenshotController.captureFromWidget(
        _buildShareCard(content, selectedItems),
        delay: const Duration(milliseconds: 100),
        pixelRatio: 2.0,
      );

      if (imageBytes == null) return null;

      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/share_result_${DateTime.now().millisecondsSinceEpoch}.png';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(imageBytes);

      return imagePath;
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
              const Icon(Icons.auto_awesome, color: Colors.blue, size: 32),
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
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: const TextStyle(
                    fontSize: 18,
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
                      color: Colors.grey[700],
                    ),
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
              'www.dfl-weekend.de',
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
