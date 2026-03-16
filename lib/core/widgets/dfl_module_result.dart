import 'package:flutter/material.dart';
import 'key_takeaway_field.dart';

class DflModuleResult extends StatelessWidget {
  final String title;
  final Widget result;
  final TextEditingController takeawayController;
  final List<String> takeaways;
  final Function(List<String>) onUpdate;
  final bool isReadOnly;

  const DflModuleResult({
    super.key,
    required this.title,
    required this.result,
    required this.takeawayController,
    required this.takeaways,
    required this.onUpdate,
    this.isReadOnly = true,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          result,
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 16),
          KeyTakeawayField(
            controller: takeawayController,
            label: 'Key Takeaways',
            takeaways: takeaways,
            onUpdate: onUpdate,
            isReadOnly: isReadOnly,
          ),
        ],
      ),
    );
  }
}
