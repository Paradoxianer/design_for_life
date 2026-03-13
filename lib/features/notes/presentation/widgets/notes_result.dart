import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/module_result.dart';

class NotesResult extends ModuleResult {
  final String text;

  const NotesResult({
    super.key,
    required this.text,
  });

  @override
  Widget buildResult(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notes Summary',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Text(
          text.isEmpty ? '_No notes recorded._' : text,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
