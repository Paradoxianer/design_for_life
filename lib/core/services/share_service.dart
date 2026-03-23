import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    // 1. Generate the text blob (structured for easy copying/reading)
    final StringBuffer buffer = StringBuffer();
    buffer.writeln('${content.title}');
    buffer.writeln('=' * content.title.length);
    buffer.writeln();
    
    for (var item in selectedItems) {
      if (item.textValue != null && item.textValue!.isNotEmpty) {
        // If it's a multi-line comment, format it nicely
        if (item.textValue!.contains('\n') || item.textValue!.length > 40) {
          buffer.writeln('${item.label}:');
          buffer.writeln(item.textValue);
        } else {
          // Compact format for ratings/short values
          buffer.writeln('${item.label}: ${item.textValue}');
        }
        buffer.writeln();
      }
    }
    
    buffer.writeln('---');
    buffer.writeln(l10n.shareFooter);
    if (extraText != null) buffer.writeln('\n$extraText');

    final String text = buffer.toString();

    // 2. Generate the image
    final xFile = await ShareImageGenerator.generateShareImage(
      context: context,
      content: content,
      selectedItems: selectedItems,
    );

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

  /// Helper to just copy the text to clipboard
  static Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }
}
