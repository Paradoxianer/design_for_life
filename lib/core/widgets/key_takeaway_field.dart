import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class KeyTakeawayField extends StatelessWidget {
  final List<String> takeaways;
  final Function(int, String) onUpdate;
  final bool isReadOnly;

  const KeyTakeawayField({
    super.key,
    required this.takeaways,
    required this.onUpdate,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.tertiary.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.stars_rounded, color: theme.colorScheme.tertiary),
              const SizedBox(width: 8),
              Text(
                l10n.keyTakeaways,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...List.generate(3, (index) {
            final text = index < takeaways.length ? takeaways[index] : '';
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: isReadOnly
                  ? _buildReadOnlyItem(context, text, index)
                  : _buildEditItem(context, text, index, l10n),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildReadOnlyItem(BuildContext context, String text, int index) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${index + 1}. ', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
        Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyLarge)),
      ],
    );
  }

  Widget _buildEditItem(BuildContext context, String text, int index, AppLocalizations l10n) {
    return TextField(
      controller: TextEditingController(text: text)
        ..selection = TextSelection.fromPosition(TextPosition(offset: text.length)),
      decoration: InputDecoration(
        hintText: l10n.takeawayHint,
        prefixText: '${index + 1}. ',
        border: InputBorder.none,
      ),
      style: Theme.of(context).textTheme.bodyLarge,
      onChanged: (value) => onUpdate(index, value),
    );
  }
}
