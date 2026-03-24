import 'package:flutter/material.dart';
import 'package:design_for_life/core/models/dfl_entry.dart';
import 'package:design_for_life/core/widgets/dfl_module_result.dart';
import 'package:design_for_life/core/widgets/dfl_entry_widget.dart';
import '../models/life_tree_node_data.dart';

class LifeTreeResult extends StatelessWidget {
  final List<DflEntry> entries;
  final List<LifeTreeNodeData> nodes;
  final List<String> takeaways;
  final Function(int, String)? onUpdate;

  const LifeTreeResult({
    super.key,
    required this.entries,
    required this.takeaways,
    required this.nodes,
    this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DflModuleResult(
      title: 'Mein Lebensbaum',
      takeaways: takeaways,
      onUpdate: onUpdate,
      result: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (nodes.isNotEmpty) ...[
            Text(
              'Digitaler Lebensbaum',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: theme.dividerColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('${nodes.length} Knoten im Lebensbaum'),
            ),
            const SizedBox(height: 24),
          ],
          
          Text(
            'Analoge Notizen & Zeichnungen',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...entries.map((entry) => DflEntryWidget(
                entry: entry,
                // Removed isReadOnly: true because it's not supported by DflEntryWidget
              )),
        ],
      ),
    );
  }
}
