import 'package:share_plus/share_plus.dart';
import '../models/shareable_content.dart';
import '../widgets/share_image_generator.dart';

class ShareService {
  static Future<void> shareContent({
    required ShareableContent content,
    required List<ShareableItem> selectedItems,
    String? extraText,
  }) async {
    // 1. Generate the image
    final imagePath = await ShareImageGenerator.generateShareImage(content, selectedItems);

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

    // 3. Share
    if (imagePath != null) {
      await Share.shareXFiles(
        [XFile(imagePath)],
        text: buffer.toString(),
        subject: content.title,
      );
    } else {
      // Fallback to text only if image generation fails
      await Share.share(
        buffer.toString(),
        subject: content.title,
      );
    }
  }
}
