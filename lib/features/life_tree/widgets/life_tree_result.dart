import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import 'package:design_for_life/core/models/dfl_entry.dart';
import 'package:design_for_life/core/widgets/dfl_module_result.dart';
import 'package:design_for_life/core/widgets/result_image_thumbnail.dart';
import '../models/life_tree_node_data.dart';
import 'life_tree_graph_widget.dart';

class LifeTreeResult extends StatefulWidget {
  final List<DflEntry> entries;
  final List<LifeTreeNodeData> nodes;
  final List<String> takeaways;
  final Function(int, String)? onUpdate;
  final bool showNotesInitially;
  final ScreenshotController? screenshotController;

  const LifeTreeResult({
    super.key,
    required this.entries,
    required this.takeaways,
    required this.nodes,
    this.onUpdate,
    this.showNotesInitially = false,
    this.screenshotController,
  });

  @override
  State<LifeTreeResult> createState() => _LifeTreeResultState();
}

class _LifeTreeResultState extends State<LifeTreeResult> {
  final TransformationController _transformationController = TransformationController();
  bool _showNotes = false;

  @override
  void initState() {
    super.initState();
    _showNotes = widget.showNotesInitially;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Initial centering of the root node
        // Target: Center of view (250) minus (RootX=0 + Padding=400) minus HalfNodeWidth=85
        _transformationController.value = Matrix4.identity()..translate(-235.0, 50.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return DflModuleResult(
      title: l10n.lifeTreeTitle,
      takeaways: widget.takeaways,
      onUpdate: widget.onUpdate,
      result: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.nodes.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.lifeTreeDigital,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Text(l10n.lifeTreeShowNotes, style: theme.textTheme.bodySmall),
                    Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: _showNotes,
                        onChanged: (v) => setState(() => _showNotes = v),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 500,
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: InteractiveViewer(
                transformationController: _transformationController,
                constrained: false,
                boundaryMargin: const EdgeInsets.all(800),
                minScale: 0.1,
                maxScale: 2.0,
                child: Screenshot(
                  controller: widget.screenshotController ?? ScreenshotController(),
                  child: LifeTreeGraphWidget(nodes: widget.nodes, showNotes: _showNotes),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
          
          Text(
            l10n.lifeTreeAnalog,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...widget.entries.map((entry) => _DflEntryReadOnlyWidget(entry: entry)),
        ],
      ),
    );
  }
}

class _DflEntryReadOnlyWidget extends StatelessWidget {
  final DflEntry entry;
  const _DflEntryReadOnlyWidget({required this.entry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (entry.text.isNotEmpty)
            Text(entry.text, style: theme.textTheme.bodyMedium),
          if (entry.imagePath != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ResultImageThumbnail(imagePath: entry.imagePath!),
            ),
          ],
        ],
      ),
    );
  }
}
