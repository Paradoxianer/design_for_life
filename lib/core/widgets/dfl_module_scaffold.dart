import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';

class DflModuleScaffold extends StatelessWidget {
  final String title;
  final Widget editor;
  final Widget result;
  final bool isEditMode;
  final VoidCallback onToggleMode;
  final VoidCallback? onShare;

  const DflModuleScaffold({
    super.key,
    required this.title,
    required this.editor,
    required this.result,
    required this.isEditMode,
    required this.onToggleMode,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (onShare != null)
            IconButton(
              icon: const Icon(Icons.share_outlined),
              onPressed: onShare,
            ),
          IconButton(
            tooltip: isEditMode ? l10n.resultMode : l10n.editMode,
            icon: Icon(isEditMode ? Icons.remove_red_eye_outlined : Icons.edit_outlined),
            onPressed: onToggleMode,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isEditMode ? editor : result,
        ),
      ),
    );
  }
}
