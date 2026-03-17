import 'package:flutter/material.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';

class DflModuleScaffold extends StatelessWidget {
  final String title;
  final Widget editor;
  final Widget result;
  final VoidCallback onSave;

  const DflModuleScaffold({
    super.key,
    required this.title,
    required this.editor,
    required this.result,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n?.editMode ?? 'Edit'),
              Tab(text: l10n?.resultMode ?? 'Result'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: onSave,
            ),
          ],
        ),
        body: TabBarView(
          children: [
            editor,
            result,
          ],
        ),
      ),
    );
  }
}
