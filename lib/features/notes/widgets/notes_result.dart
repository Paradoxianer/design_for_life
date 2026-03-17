import 'package:flutter/material.dart';
import 'package:design_for_life/core/models/dfl_entry.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../../../core/widgets/dfl_module_result.dart';
import '../../../core/widgets/dfl_entry_widget.dart';

class NotesResult extends DflModuleResult {
  final List<DflEntry> entries;

  const NotesResult({
    super.key,
    required this.entries,
    required super.takeaways,
    required super.onUpdate,
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
          Text(l10n.notes, style: theme.textTheme.titleLarge),
          const SizedBox(height: 24),
          ...entries.where((e) => e.text.isNotEmpty || e.imagePath != null).map((entry) => DflEntryWidget(
            entry: entry,
            onTextChanged: (_) {},
            onImageChanged: (_) {},
            onToggleCompleted: () {},
            // Result view is read-only implicitly by not providing actions
          )),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 16),
          // Takeaways via base class logic
          Builder(builder: (context) => super.build(context)),
        ],
      ),
    );
  }
}
