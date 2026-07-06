import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:design_for_life/core/models/export_document.dart';
import 'package:design_for_life/core/models/shareable_content.dart';
import 'package:design_for_life/core/widgets/share_image_generator.dart';

/// Baut ein [ExportDocument] aus mehreren Modul-Inhalten, indem die
/// bestehende Share-Bild-Erzeugung wiederverwendet wird - ein Export ist im
/// Kern ein "simuliertes Teilen mit allen Inhalten automatisch akzeptiert"
/// (#28), kein zweiter Rendering-Pfad.
class ExportService {
  const ExportService._();

  static const _imageDataTypes = {'life_tree_graph', 'imagine_option', 'imagine_composed', 'text_card'};

  static bool _hasImage(ShareableItem item) =>
      item.imagePath != null || (item.data is Map && _imageDataTypes.contains(item.data['type']));

  /// Ein fehlerhafter Abschnitt (z.B. ein einzelnes Bild-Rendering schlägt
  /// fehl) darf den restlichen Export nicht blockieren (#27, mvp.md 6.2).
  static Future<ExportDocument> build({
    required BuildContext context,
    required List<ShareableContent> contents,
  }) async {
    final sections = <ExportSection>[];

    for (final content in contents) {
      try {
        final section = await _buildSection(context, content);
        if (!section.isEmpty) sections.add(section);
      } catch (e) {
        debugPrint('Error building export section "${content.title}": $e');
      }
    }

    return ExportDocument(sections: sections);
  }

  static Future<ExportSection> _buildSection(BuildContext context, ShareableContent content) async {
    final imageItems = content.items.where(_hasImage).toList();
    final images = <Uint8List>[];

    if (imageItems.isNotEmpty) {
      final files = await ShareImageGenerator.generateShareImages(
        context: context,
        content: content,
        selectedItems: imageItems,
      );
      for (final file in files) {
        try {
          images.add(await file.readAsBytes());
        } catch (e) {
          debugPrint('Error reading generated export image: $e');
        }
      }
    }

    final textBlocks = <String>[];
    for (final item in content.items) {
      if (_hasImage(item)) continue;
      if (item.textValue != null && item.textValue!.trim().isNotEmpty) {
        textBlocks.add('${item.label}\n${item.textValue}');
      }
    }

    return ExportSection(title: content.title, images: images, textBlocks: textBlocks);
  }
}
