import 'package:flutter/material.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../models/shareable_content.dart';
import 'share_selection_dialog.dart';

class DflModuleScaffold extends StatefulWidget {
  final String title;
  final Widget editor;
  final Widget result;
  final bool initialEditMode;
  final Future<bool> Function()? onWillToggleMode;
  final Widget? customFooter;
  final ShareableContent? shareableContent;
  final Function(List<ShareableItem>)? onShare;

  const DflModuleScaffold({
    super.key,
    required this.title,
    required this.editor,
    required this.result,
    this.initialEditMode = true,
    this.onWillToggleMode,
    this.customFooter,
    this.shareableContent,
    this.onShare,
  });

  @override
  State<DflModuleScaffold> createState() => DflModuleScaffoldState();
}

class DflModuleScaffoldState extends State<DflModuleScaffold> {
  late bool _isEditMode;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.initialEditMode;
  }

  Future<void> toggleMode() async {
    if (_isEditMode && widget.onWillToggleMode != null) {
      final bool shouldToggle = await widget.onWillToggleMode!();
      if (!shouldToggle) return;
    }
    setState(() {
      _isEditMode = !_isEditMode;
    });
  }

  void _showShareDialog() {
    if (widget.shareableContent == null || widget.onShare == null) return;

    showDialog(
      context: context,
      builder: (context) => ShareSelectionDialog(
        content: widget.shareableContent!,
        onShare: widget.onShare!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (!_isEditMode && widget.shareableContent != null)
            IconButton(
              tooltip: l10n.share,
              icon: const Icon(Icons.share_outlined),
              onPressed: _showShareDialog,
            ),
          IconButton(
            tooltip: _isEditMode ? l10n.resultMode : l10n.editMode,
            icon: Icon(_isEditMode ? Icons.remove_red_eye_outlined : Icons.edit_outlined),
            onPressed: toggleMode,
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
                  child: widget.customFooter ?? Center(
                    child: ElevatedButton.icon(
                      onPressed: toggleMode,
                      icon: const Icon(Icons.check),
                      label: Text(l10n.finish),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
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
