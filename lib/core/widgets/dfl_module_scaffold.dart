import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../../features/leader_notes/bloc/leader_mode_bloc.dart';
import '../../features/leader_notes/models/leader_note_session.dart';
import '../../features/leader_notes/repositories/leader_notes_repository.dart';
import '../../features/leader_notes/widgets/leader_note_view.dart';
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

  /// Zeigt den Teilen-Button auch ohne [shareableContent] (z.B. wenn ein
  /// Modul keine Bild-/Text-Auswahl anbietet, sondern immer denselben festen
  /// Export erzeugt, wie das CSV-Feedback-Modul, #7). Ohne [shareableContent]
  /// wird der Auswahl-Dialog übersprungen und [onShare] direkt mit einer
  /// leeren Liste aufgerufen.
  final bool showShareButtonWithoutContent;

  /// Timeline session id (e.g. "session_1") this module screen shows, used
  /// to look up leader-only content (#83). Null for modules the Leiterheft
  /// has no leader notes for (Gruppenfoto, Feedback, Persönlichkeitsprofil,
  /// Imagine, Verknüpfungen) - the leader-info button only ever appears when
  /// both this is set AND leader mode is unlocked AND content actually
  /// exists for this id, so passing it is always safe even if none of that
  /// is true yet.
  final String? leaderNoteSessionId;

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
    this.showShareButtonWithoutContent = false,
    this.leaderNoteSessionId,
  });

  @override
  State<DflModuleScaffold> createState() => DflModuleScaffoldState();
}

class DflModuleScaffoldState extends State<DflModuleScaffold> {
  late bool _isEditMode;
  LeaderNoteSession? _leaderNoteSession;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.initialEditMode;

    if (widget.leaderNoteSessionId != null) {
      // Locale isn't available yet this early (needs an inherited
      // Localizations lookup) - same postFrameCallback pattern used
      // elsewhere in this app (e.g. SpiritualGiftsEditor) to defer content
      // loading that depends on it until just after the first frame.
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;
        final locale = Localizations.localeOf(context).languageCode;
        final sessions = await LeaderNotesRepository().loadSessions(locale);
        if (!mounted) return;
        setState(() {
          _leaderNoteSession = sessions[widget.leaderNoteSessionId];
        });
      });
    }
  }

  void _showLeaderNotes() {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        builder: (context, scrollController) => Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.leaderInfoTitle,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(sheetContext).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: LeaderNoteView(
                session: _leaderNoteSession!,
                scrollController: scrollController,
              ),
            ),
          ],
        ),
      ),
    );
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
    if (widget.onShare == null) return;

    if (widget.shareableContent == null) {
      widget.onShare!(const []);
      return;
    }

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
        title: Text(widget.title, overflow: TextOverflow.ellipsis, maxLines: 1),
        actions: [
          if (_leaderNoteSession != null)
            BlocBuilder<LeaderModeBloc, LeaderModeState>(
              builder: (context, leaderModeState) {
                if (!leaderModeState.isUnlocked) return const SizedBox.shrink();
                return IconButton(
                  tooltip: l10n.leaderInfoButton,
                  icon: const Icon(Icons.menu_book_outlined),
                  onPressed: _showLeaderNotes,
                );
              },
            ),
          if (!_isEditMode &&
              (widget.shareableContent != null ||
                  (widget.onShare != null &&
                      widget.showShareButtonWithoutContent)))
            IconButton(
              tooltip: l10n.share,
              icon: const Icon(Icons.share_outlined),
              onPressed: _showShareDialog,
            ),
          IconButton(
            tooltip: _isEditMode ? l10n.resultMode : l10n.editMode,
            icon: Icon(
              _isEditMode ? Icons.remove_red_eye_outlined : Icons.edit_outlined,
            ),
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
                    child:
                        widget.customFooter ??
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: toggleMode,
                            icon: const Icon(Icons.check),
                            label: Text(l10n.finish),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 24,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
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
