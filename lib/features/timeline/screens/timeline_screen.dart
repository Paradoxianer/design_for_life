import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import 'package:design_for_life/features/notes/bloc/notes_bloc.dart';
import 'package:design_for_life/features/listening_prayer/bloc/listening_prayer_bloc.dart';
import 'package:design_for_life/core/blocs/entry_list_bloc.dart';
import '../models/static_timeline_data.dart';
import '../models/dfl_session.dart';
import '../widgets/timeline_card.dart';

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final sessions = StaticTimelineData.sessions;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Text(
              l10n.appTitle,
              style: theme.textTheme.displayLarge,
            ),
            backgroundColor: theme.scaffoldBackgroundColor,
            surfaceTintColor: Colors.transparent,
          ),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 24),
            sliver: MultiBlocListener(
              listeners: [
                // Wir lauschen auf beide Blocs, um die Timeline bei Änderungen zu aktualisieren
                BlocListener<NotesBloc, EntryListState>(listener: (context, state) {}),
                BlocListener<ListeningPrayerBloc, EntryListState>(listener: (context, state) {}),
              ],
              child: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final session = sessions[index];
                    return _TimelineCardWrapper(session: session);
                  },
                  childCount: sessions.length,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineCardWrapper extends StatelessWidget {
  final DflSession session;

  const _TimelineCardWrapper({required this.session});

  @override
  Widget build(BuildContext context) {
    // Bestimmung des Status basierend auf dem Inhalt der Blocs
    bool isCompleted = false;

    if (session.moduleRoute != null) {
      if (session.moduleRoute!.startsWith('notes/')) {
        final sessionId = session.moduleRoute!.split('/')[1].split('?')[0];
        final state = context.watch<NotesBloc>().state;
        isCompleted = _hasContent(state, sessionId);
      } else if (session.moduleRoute!.startsWith('listening-prayer/')) {
        final sessionId = session.moduleRoute!.split('/')[1].split('?')[0];
        final state = context.watch<ListeningPrayerBloc>().state;
        isCompleted = _hasContent(state, sessionId);
      }
    }

    final updatedSession = DflSession(
      id: session.id,
      title: session.title,
      description: session.description,
      type: session.type,
      startTime: session.startTime,
      endTime: session.endTime,
      room: session.room,
      groupAssignment: session.groupAssignment,
      status: isCompleted ? SessionStatus.done : session.status,
      moduleRoute: session.moduleRoute,
    );

    return TimelineCard(
      session: updatedSession,
      onTap: () {
        if (session.moduleRoute != null) {
          context.push('/${session.moduleRoute}');
        }
      },
    );
  }

  bool _hasContent(EntryListState state, String sessionId) {
    final entries = state.entries[sessionId] ?? [];
    // Ein Modul gilt als "bearbeitet", wenn mindestens ein Eintrag Text oder ein Bild hat
    return entries.any((e) => e.text.trim().isNotEmpty || e.imagePath != null);
  }
}
