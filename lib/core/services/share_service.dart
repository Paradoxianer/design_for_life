import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../models/shareable_content.dart';
import '../widgets/share_image_generator.dart';

class ShareService {
  static Future<void> shareContent({
    required BuildContext context,
    required ShareableContent content,
    required List<ShareableItem> selectedItems,
    String? extraText,
  }) async {
    final l10n = AppLocalizations.of(context);

    // 1. Generate the image (platform independent XFile)
    final xFile = await ShareImageGenerator.generateShareImage(
      context: context,
      content: content,
      selectedItems: selectedItems,
    );

    // 2. Prepare text
    final StringBuffer buffer = StringBuffer();
    buffer.writeln('${l10n.shareIntro} ${content.title}');
    buffer.writeln('---');
    for (var item in selectedItems) {
      buffer.writeln('• ${item.label}');
      if (item.textValue != null && item.textValue!.isNotEmpty) {
        buffer.writeln('  "${item.textValue}"');
      }
    }
    buffer.writeln('---');
    buffer.writeln(l10n.shareFooter);
    if (extraText != null) buffer.writeln('\n$extraText');

    final String text = buffer.toString();

    // 3. Share with platform-specific behavior
    try {
      if (xFile != null) {
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
      await Share.share(text, subject: content.title);
    }
  }
}
