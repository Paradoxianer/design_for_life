import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';
import '../models/shareable_content.dart';
import '../widgets/share_image_generator.dart';

class ShareService {
  static Future<void> shareContent({
    required ShareableContent content,
    required List<ShareableItem> selectedItems,
    String? extraText,
  }) async {
    // 1. Generate the image (platform independent XFile)
    final xFile = await ShareImageGenerator.generateShareImage(content, selectedItems);

    // 2. Prepare text
    final StringBuffer buffer = StringBuffer();
    buffer.writeln('Meine Ergebnisse vom DFL-Wochenende: ${content.title}');
    buffer.writeln('---');
    for (var item in selectedItems) {
      buffer.writeln('• ${item.label}');
      if (item.textValue != null && item.textValue!.isNotEmpty) {
        buffer.writeln('  "${item.textValue}"');
      }
    }
    buffer.writeln('---');
    buffer.writeln('Erstellt mit der Design for Life App.');
    if (extraText != null) buffer.writeln('\n$extraText');

    final String text = buffer.toString();

    // 3. Share with platform-specific behavior
    try {
      if (xFile != null) {
        // On Web Desktop, sharing files is often not supported by the browser's Share API.
        // share_plus will fall back to just text or do nothing.
        await Share.shareXFiles(
          [xFile],
          text: text,
          subject: content.title,
        );
      } else {
        await Share.share(
          text,
          subject: content.title,
        );
      }
    } catch (e) {
      debugPrint('Share failed: $e');
      // Final fallback to text only
      await Share.share(text, subject: content.title);
    }
  }
}
