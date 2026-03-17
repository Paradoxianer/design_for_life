import 'package:flutter/material.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';

class DflModuleScaffold extends StatelessWidget {
  final String title;
  final Widget editor;
  final Widget result;
  final bool isEditMode;
  final VoidCallback onToggleMode;
  final VoidCallback? onSave;

  const DflModuleScaffold({
    super.key,
    required this.title,
    required this.editor,
    required this.result,
    required this.isEditMode,
    required this.onToggleMode,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (onSave != null)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: onSave,
            ),
          IconButton(
            tooltip: isEditMode ? l10n?.resultMode : l10n?.editMode,
            icon: Icon(isEditMode ? Icons.remove_red_eye_outlined : Icons.edit_outlined),
            onPressed: onToggleMode,
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: isEditMode ? editor : result,
      ),
    );
  }
}
