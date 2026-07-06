import 'package:flutter/material.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../models/shareable_content.dart';
import 'resolved_image.dart';

class ShareSelectionDialog extends StatefulWidget {
  final ShareableContent content;
  final Function(List<ShareableItem>) onShare;

  const ShareSelectionDialog({
    super.key,
    required this.content,
    required this.onShare,
  });

  @override
  State<ShareSelectionDialog> createState() => _ShareSelectionDialogState();
}

class _ShareSelectionDialogState extends State<ShareSelectionDialog> {
  late List<ShareableItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.content.items);
  }

  void _toggleAll(bool select) {
    setState(() {
      _items = _items.map((item) => item.copyWith(isSelected: select)).toList();
    });
  }

  /// Zeigt eine visuelle Vorschau statt einer reinen Text-Checkliste, wo ein
  /// Bild bereits bekannt ist (#24). Der Lebensbaum-Graph wird erst beim
  /// eigentlichen Teilen gerendert, daher nur ein Platzhalter-Icon.
  Widget? _buildPreview(ShareableItem item) {
    if (item.imagePath != null) {
      return SizedBox(
        width: 44,
        height: 44,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: buildResolvedImage(item.imagePath!, width: 44, height: 44),
        ),
      );
    }
    if (item.data is Map) {
      final data = item.data as Map;
      if (data['type'] == 'imagine_option') {
        final optionId = data['optionId'] as String?;
        if (optionId != null) {
          return SizedBox(
            width: 44,
            height: 44,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: buildResolvedImage(
                'assets/images/imagine/$optionId',
                width: 44,
                height: 44,
              ),
            ),
          );
        }
      }
      if (data['type'] == 'life_tree_graph') {
        return const Icon(Icons.account_tree_outlined);
      }
      if (data['type'] == 'text_card') {
        return const Icon(Icons.image_outlined);
      }
      if (data['type'] == 'imagine_composed') {
        final pastOptionId = data['pastOptionId'] as String?;
        if (pastOptionId != null) {
          return SizedBox(
            width: 44,
            height: 44,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: buildResolvedImage(
                'assets/images/imagine/$pastOptionId',
                width: 44,
                height: 44,
              ),
            ),
          );
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final allSelected = _items.every((item) => item.isSelected);
    final anySelected = _items.any((item) => item.isSelected);

    return AlertDialog(
      title: Text(l10n.shareTitle),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () => _toggleAll(!allSelected),
                  child: Text(allSelected ? l10n.deselectAll : l10n.selectAll),
                ),
              ],
            ),
            const Divider(),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return CheckboxListTile(
                    title: Text(item.label),
                    subtitle: item.textValue != null
                        ? Text(item.textValue!, maxLines: 1, overflow: TextOverflow.ellipsis)
                        : null,
                    secondary: _buildPreview(item),
                    value: item.isSelected,
                    onChanged: (val) {
                      setState(() {
                        _items[index] = item.copyWith(isSelected: val ?? false);
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton.icon(
          onPressed: anySelected ? () {
            widget.onShare(_items.where((i) => i.isSelected).toList());
            Navigator.pop(context);
          } : null,
          icon: const Icon(Icons.share),
          label: Text(l10n.share),
        ),
      ],
    );
  }
}
