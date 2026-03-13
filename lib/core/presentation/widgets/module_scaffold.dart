import 'package:flutter/material.dart';
import 'key_takeaway_component.dart';

class ModuleScaffold extends StatelessWidget {
  final String title;
  final Widget editor;
  final Widget result;
  final List<String> takeaways;
  final Function(int, String) onTakeawayUpdate;
  final bool isEditMode;
  final VoidCallback onToggleMode;
  final VoidCallback? onShare;

  const ModuleScaffold({
    super.key,
    required this.title,
    required this.editor,
    required this.result,
    required this.takeaways,
    required this.onTakeawayUpdate,
    this.isEditMode = true,
    required this.onToggleMode,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
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
            icon: Icon(isEditMode ? Icons.remove_red_eye_outlined : Icons.edit_outlined),
            onPressed: onToggleMode,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Der eigentliche Content des Moduls
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isEditMode ? editor : result,
            ),
            
            const SizedBox(height: 32),
            
            // Die immer vorhandene Key-Takeaway Komponente
            KeyTakeawayComponent(
              takeaways: takeaways,
              isReadOnly: !isEditMode,
              onUpdate: onTakeawayUpdate,
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
