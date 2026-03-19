import 'package:flutter/material.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';

class DflModuleScaffold extends StatefulWidget {
  final String title;
  final Widget editor;
  final Widget result;
  final bool initialEditMode;
  final Future<bool> Function()? onWillToggleMode;

  const DflModuleScaffold({
    super.key,
    required this.title,
    required this.editor,
    required this.result,
    this.initialEditMode = true,
    this.onWillToggleMode,
  });

  @override
  State<DflModuleScaffold> createState() => _DflModuleScaffoldState();
}

class _DflModuleScaffoldState extends State<DflModuleScaffold> {
  late bool _isEditMode;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.initialEditMode;
  }

  Future<void> _toggleMode() async {
    if (_isEditMode && widget.onWillToggleMode != null) {
      final bool shouldToggle = await widget.onWillToggleMode!();
      if (!shouldToggle) return;
    }
    setState(() {
      _isEditMode = !_isEditMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            tooltip: _isEditMode ? l10n.resultMode : l10n.editMode,
            icon: Icon(_isEditMode ? Icons.remove_red_eye_outlined : Icons.edit_outlined),
            onPressed: _toggleMode,
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _isEditMode 
          ? Column(
              children: [
                Expanded(child: widget.editor),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _toggleMode,
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
          : widget.result,
      ),
    );
  }
}
