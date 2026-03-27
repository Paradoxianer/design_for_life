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

    // 1. Text-Inhalt generieren (Strukturiert für Takeaways)
    final StringBuffer buffer = StringBuffer();
    buffer.writeln('🌟 ${content.title} 🌟');
    buffer.writeln('=' * (content.title.length + 4));
    buffer.writeln();
    
    bool hasTakeaways = false;
    bool hasNotes = false;

    // Zuerst Takeaways (Erkenntnisse)
    for (var item in selectedItems) {
      if (item.id.startsWith('takeaway') && item.textValue != null && item.textValue!.isNotEmpty) {
        if (!hasTakeaways) {
          buffer.writeln('Key Takeaways:');
          hasTakeaways = true;
        }
        buffer.writeln('• ${item.textValue}');
      }
    }

    if (hasTakeaways) buffer.writeln();

    // Dann sonstige Texte (Notizen etc.), aber keine Grafik-Metadaten
    for (var item in selectedItems) {
      if (item.id.startsWith('takeaway')) continue;
      if (item.data is Map && item.data['type'] == 'life_tree_graph') continue;
      if (item.id == 'tree_include_notes') continue;

      if (item.textValue != null && item.textValue!.trim().isNotEmpty) {
        if (!hasNotes) {
          buffer.writeln('Details & Notizen:');
          hasNotes = true;
        }
        buffer.writeln('${item.label}:');
        buffer.writeln(item.textValue);
        buffer.writeln();
      }
    }
    
    buffer.writeln('---');
    buffer.writeln(l10n.shareFooter);
    if (extraText != null) buffer.writeln('\n$extraText');

    final String text = buffer.toString();

    // 2. Bilder generieren/sammeln (Grafik + Analoge Bilder)
    final List<XFile> files = await ShareImageGenerator.generateShareImages(
      context: context,
      content: content,
      selectedItems: selectedItems,
    );

    // 3. Teilen
    try {
      if (files.isNotEmpty) {
        await Share.shareXFiles(
          files,
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

  static Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }
}
