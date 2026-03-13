import 'package:flutter/material.dart';
import 'key_takeaway_field.dart';

abstract class DflModuleEditor extends StatelessWidget {
  final List<String> takeaways;
  final Function(int, String) onTakeawayUpdate;

  const DflModuleEditor({
    super.key,
    required this.takeaways,
    required this.onTakeawayUpdate,
  });

  Widget buildContent(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildContent(context),
        const SizedBox(height: 32),
        KeyTakeawayField(
          takeaways: takeaways,
          onUpdate: onTakeawayUpdate,
          isReadOnly: false,
        ),
      ],
    );
  }
}
