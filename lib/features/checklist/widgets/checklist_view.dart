import 'package:flutter/material.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../models/checklist_item.dart';

/// Shows the packing/prep checklist as a checkable list, with a text field
/// at the bottom to add one's own items (#82). Used unchanged for both the
/// editor and result mode of ChecklistScreen - unlike most modules there is
/// no separate "read-only summary" view that would make sense here, since
/// checking items off *is* the module's entire purpose in either mode.
class ChecklistView extends StatefulWidget {
  final List<ChecklistItem> items;
  final void Function(String id) onToggle;
  final void Function(String text) onAdd;
  final void Function(String id) onRemove;

  const ChecklistView({
    super.key,
    required this.items,
    required this.onToggle,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  State<ChecklistView> createState() => _ChecklistViewState();
}

class _ChecklistViewState extends State<ChecklistView> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _labelFor(AppLocalizations l10n, ChecklistItem item) {
    if (item.customText != null) return item.customText!;
    switch (item.id) {
      case ChecklistItem.personalItems:
        return l10n.checklistItemPersonalItems;
      case ChecklistItem.bible:
        return l10n.checklistItemBible;
      case ChecklistItem.writingUtensils:
        return l10n.checklistItemWritingUtensils;
      case ChecklistItem.casualClothes:
        return l10n.checklistItemCasualClothes;
      case ChecklistItem.giftsValuesTest:
        return l10n.checklistItemGiftsValuesTest;
      default:
        return item.id;
    }
  }

  void _submit() {
    final text = _controller.text;
    if (text.trim().isEmpty) return;
    widget.onAdd(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.checklistGuidance,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        for (final item in widget.items)
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            value: item.isChecked,
            onChanged: (_) => widget.onToggle(item.id),
            title: Text(_labelFor(l10n, item)),
            secondary: item.isCustom
                ? IconButton(
                    tooltip: l10n.checklistRemoveItem,
                    icon: const Icon(Icons.close),
                    onPressed: () => widget.onRemove(item.id),
                  )
                : null,
          ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: l10n.checklistAddItemHint,
                    border: const OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _submit(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                tooltip: l10n.checklistAddItemButton,
                icon: const Icon(Icons.add),
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
