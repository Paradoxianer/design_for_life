import 'package:flutter/material.dart';
import 'key_takeaway_field.dart';

abstract class DflModuleResult extends StatelessWidget {
  final List<String> takeaways;

  const DflModuleResult({
    super.key,
    required this.takeaways,
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
          onUpdate: (_, __) {},
          isReadOnly: true,
        ),
      ],
    );
  }
}
