import 'package:flutter/material.dart';
import 'key_takeaway_field.dart';

abstract class DflModuleEditor extends StatelessWidget {
  final List<String> takeaways;
  final Function(int, String) onUpdate;
  final bool isReadOnly;

  const DflModuleEditor({
    super.key,
    required this.takeaways,
    required this.onUpdate,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          buildContent(context),
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

  Widget buildContent(BuildContext context);
}
