import 'dart:io';
import 'package:flutter/material.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../../../core/widgets/dfl_module_result.dart';

class NotesResult extends DflModuleResult {
  final String text;
  final List<String> imagePaths;

  const NotesResult({
    super.key,
    required this.text,
    required this.imagePaths,
    required super.takeaways,
    required super.onUpdate,
    required super.takeawayController,
  }) : super(
          title: 'Notes',
          result: const SizedBox.shrink(), // Placeholder since we override build
        );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.notes, style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              text.isEmpty ? 'No notes yet.' : text,
              style: theme.textTheme.bodyLarge,
            ),
          ),
          if (imagePaths.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(l10n.photosAndSlides, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: imagePaths.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(imagePaths[index]),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 16),
          // We use the super class logic for Takeaways via its build method if needed, 
          // but here we just render the KeyTakeawayField directly to match the desired layout.
          Builder(builder: (context) => super.build(context)),
        ],
      ),
    );
  }
}
