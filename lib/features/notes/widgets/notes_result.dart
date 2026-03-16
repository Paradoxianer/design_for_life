import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/widgets/dfl_module_result.dart';

class NotesResult extends DflModuleResult {
  final String text;
  final List<String> imagePaths;

  const NotesResult({
    super.key,
    required this.text,
    required this.imagePaths,
    required super.takeaways,
  });

  @override
  Widget buildContent(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Notes Summary in a Frame
        Text('Notes Summary', style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            text.isEmpty ? '...' : text,
            style: theme.textTheme.bodyLarge,
          ),
        ),

        if (imagePaths.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text('Photos & Slides', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: imagePaths.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(imagePaths[index]),
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
