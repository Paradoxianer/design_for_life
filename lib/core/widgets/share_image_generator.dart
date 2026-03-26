import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:graphview/GraphView.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import 'dart:io' as io;
import '../models/shareable_content.dart';
import '../../features/life_tree/models/life_tree_node_data.dart';

class ShareImageGenerator {
  static final ScreenshotController screenshotController = ScreenshotController();

  static Future<XFile?> generateShareImage({
    required BuildContext context,
    required ShareableContent content,
    required List<ShareableItem> selectedItems,
  }) async {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    
    try {
      // Use captureFromWidget but provide all necessary inherited widgets
      // to avoid "View.of()" and other missing ancestor errors.
      final Uint8List? imageBytes = await screenshotController.captureFromWidget(
        Material(
          color: Colors.white,
          child: Theme(
            data: theme,
            child: MediaQuery(
              data: mediaQuery.copyWith(size: const Size(600, 1200)), // Provide a fixed width for layout
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Localizations(
                  locale: const Locale('de'), // Or get from context
                  delegates: AppLocalizations.localizationsDelegates,
                  child: _buildShareCard(context, content, selectedItems, l10n),
                ),
              ),
            ),
          ),
        ),
        delay: const Duration(milliseconds: 800), // More time for GraphView to settle
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

  static Widget _buildShareCard(BuildContext context, ShareableContent content, List<ShareableItem> selectedItems, AppLocalizations l10n) {
    return Container(
      width: 600,
      padding: const EdgeInsets.all(32),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(content),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          ...selectedItems.map((item) {
            if (item.data != null && item.data is Map && item.data['type'] == 'life_tree_graph') {
              return _buildLifeTreeGraph(context, item);
            }
            if (item.id == 'tree_include_notes') return const SizedBox.shrink();
            return _buildStandardItem(item);
          }),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          Center(
            child: Text(
              l10n.shareFooter,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildHeader(ShareableContent content) {
    return Row(
      children: [
        const Icon(Icons.auto_awesome, color: Colors.blue, size: 40),
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
    );
  }

  static Widget _buildStandardItem(ShareableItem item) {
    if (item.label.startsWith('---')) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          item.label.replaceAll('-', '').trim(),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueGrey),
        ),
      );
    }

    return Padding(
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
                color: Colors.grey[700],
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
    );
  }

  static Widget _buildLifeTreeGraph(BuildContext context, ShareableItem item) {
    final List<LifeTreeNodeData> nodes = item.data['nodes'] as List<LifeTreeNodeData>;
    final bool showNotes = item.data['showNotes'] as bool;

    final Graph graph = Graph()..isTree = true;
    final Map<String, Node> nodeCache = {};

    for (var nodeData in nodes) {
      final node = nodeCache.putIfAbsent(nodeData.id, () => Node.Id(nodeData.id));
      graph.addNode(node);
    }

    for (var nodeData in nodes) {
      if (nodeData.parentId != null) {
        final parent = nodeCache[nodeData.parentId];
        final child = nodeCache[nodeData.id];
        if (parent != null && child != null) {
          graph.addEdge(parent, child);
        }
      }
    }

    final builder = BuchheimWalkerConfiguration()
      ..siblingSeparation = (25)
      ..levelSeparation = (showNotes ? 60 : 40)
      ..subtreeSeparation = (25)
      ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Digitaler Lebensbaum',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 12),
        Container(
          // We provide a concrete width here
          width: 536, // 600 - 32*2 padding
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green.shade100),
            borderRadius: BorderRadius.circular(12),
            color: Colors.green.shade50.withValues(alpha: 0.1),
          ),
          padding: const EdgeInsets.all(16),
          child: GraphView(
            graph: graph,
            algorithm: BuchheimWalkerAlgorithm(builder, TreeEdgeRenderer(builder)),
            paint: Paint()..color = Colors.green.shade300..strokeWidth = 1.5..style = PaintingStyle.stroke,
            builder: (Node node) {
              final nodeId = node.key?.value as String;
              final nodeData = nodes.firstWhere((n) => n.id == nodeId);
              return _buildExportNode(nodeData, showNotes);
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  static Widget _buildExportNode(LifeTreeNodeData nodeData, bool showNote) {
    final bool hasNote = nodeData.note.isNotEmpty;
    
    return Container(
      width: 120,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.green.shade200, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            nodeData.text.isEmpty ? '...' : nodeData.text,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          if (hasNote && showNote) ...[
            const Divider(height: 8, thickness: 0.5),
            Text(
              nodeData.note,
              style: const TextStyle(fontSize: 8, fontStyle: FontStyle.italic, color: Colors.blueGrey),
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
          ],
        ],
      ),
    );
  }
}
