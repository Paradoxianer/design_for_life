import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import 'package:design_for_life/features/notes/bloc/notes_bloc.dart';
import 'package:design_for_life/features/listening_prayer/bloc/listening_prayer_bloc.dart';
import 'package:design_for_life/features/goals/bloc/goals_bloc.dart';
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
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final session = sessions[index];
                  return _TimelineCardWrapper(session: session);
                },
                childCount: sessions.length,
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
    bool isCompleted = false;
    String? sessionId;

    if (session.moduleRoute != null) {
      if (session.moduleRoute!.startsWith('notes/')) {
        sessionId = session.moduleRoute!.split('/')[1].split('?')[0];
        final state = context.watch<NotesBloc>().state;
        isCompleted = _hasEntryContent(state, sessionId);
      } else if (session.moduleRoute!.startsWith('listening-prayer/')) {
        sessionId = session.moduleRoute!.split('/')[1].split('?')[0];
        final state = context.watch<ListeningPrayerBloc>().state;
        isCompleted = _hasEntryContent(state, sessionId);
      } else if (session.moduleRoute!.startsWith('goals/')) {
        sessionId = session.moduleRoute!.split('/')[1].split('?')[0];
        final state = context.watch<GoalsBloc>().state;
        isCompleted = _hasGoalsContent(state, sessionId);
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
          final route = isCompleted 
            ? '${session.moduleRoute}${session.moduleRoute!.contains('?') ? '&' : '?'}mode=result'
            : session.moduleRoute!;
          context.push('/$route');
        }
      },
    );
  }

  bool _hasEntryContent(EntryListState state, String sessionId) {
    final entries = state.entries[sessionId] ?? [];
    return entries.any((e) => e.text.trim().isNotEmpty || e.imagePath != null);
  }

  bool _hasGoalsContent(GoalsState state, String sessionId) {
    final goals = state.goals[sessionId] ?? [];
    return goals.any((g) => g.text.trim().isNotEmpty);
  }
}
