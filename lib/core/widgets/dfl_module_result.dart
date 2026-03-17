import 'package:flutter/material.dart';
import 'key_takeaway_field.dart';

class DflModuleResult extends StatelessWidget {
  final String title;
  final Widget result;
  final List<String> takeaways;
  final Function(int, String) onUpdate;
  final bool isReadOnly;

  const DflModuleResult({
    super.key,
    required this.title,
    required this.result,
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
            takeaways: takeaways,
            onUpdate: onUpdate,
            isReadOnly: isReadOnly,
          ),
        ],
      ),
    );
  }
}
