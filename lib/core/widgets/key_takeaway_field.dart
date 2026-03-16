import 'package:flutter/material.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';

class KeyTakeawayField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final List<String>? takeaways;
  final Function(List<String>)? onUpdate;
  final bool isReadOnly;

  const KeyTakeawayField({
    super.key,
    required this.controller,
    this.label,
    this.takeaways,
    this.onUpdate,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = label ?? l10n?.keyTakeaways ?? 'Key Takeaways';
    final hint = l10n?.takeawayHint ?? 'Enter your key takeaway here...';
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) ...[
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextField(
          controller: controller,
          readOnly: isReadOnly,
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: isReadOnly ? Colors.grey[200] : Colors.grey[50],
          ),
          maxLines: 3,
        ),
      ],
    );
  }
}
