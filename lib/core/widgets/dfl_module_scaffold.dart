import 'package:flutter/material.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';

class DflModuleScaffold extends StatelessWidget {
  final String title;
  final Widget editor;
  final Widget result;
  final bool isEditMode;
  final VoidCallback onToggleMode;

  const DflModuleScaffold({
    super.key,
    required this.title,
    required this.editor,
    required this.result,
    required this.isEditMode,
    required this.onToggleMode,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            tooltip: isEditMode ? l10n.resultMode : l10n.editMode,
            icon: Icon(isEditMode ? Icons.remove_red_eye_outlined : Icons.edit_outlined),
            onPressed: onToggleMode,
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: isEditMode 
          ? Column(
              children: [
                Expanded(child: editor),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onToggleMode,
                      icon: const Icon(Icons.check),
                      label: const Text('Fertig'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : result,
      ),
    );
  }
}
