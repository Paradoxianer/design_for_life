import 'package:flutter/material.dart';
import '../models/shareable_content.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final allSelected = _items.every((item) => item.isSelected);
    final anySelected = _items.any((item) => item.isSelected);

    return AlertDialog(
      title: Text(widget.content.title),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () => _toggleAll(!allSelected),
                  child: Text(allSelected ? 'Nichts auswählen' : 'Alle auswählen'),
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
          child: const Text('Abbrechen'),
        ),
        ElevatedButton.icon(
          onPressed: anySelected ? () {
            widget.onShare(_items.where((i) => i.isSelected).toList());
            Navigator.pop(context);
          } : null,
          icon: const Icon(Icons.share),
          label: const Text('Teilen'),
        ),
      ],
    );
  }
}
