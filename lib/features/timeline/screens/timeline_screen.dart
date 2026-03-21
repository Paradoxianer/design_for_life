import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import 'package:design_for_life/features/notes/bloc/notes_bloc.dart';
import 'package:design_for_life/features/listening_prayer/bloc/listening_prayer_bloc.dart';
import 'package:design_for_life/features/goals/bloc/goals_bloc.dart';
import 'package:design_for_life/features/values/bloc/values_bloc.dart';
import 'package:design_for_life/features/spiritual_gifts/bloc/spiritual_gifts_bloc.dart';
import '../models/static_timeline_data.dart';
import '../models/dfl_session.dart';
import '../widgets/timeline_card.dart';

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
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

  String _parseId(String route) {
    final parts = route.split('/');
    if (parts.length > 1) {
      return parts[1].split('?')[0];
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    bool isCompleted = false;
    final route = session.moduleRoute ?? '';

    if (route.startsWith('notes/')) {
      isCompleted = context.watch<NotesBloc>().state.isCompleted(_parseId(route));
    } else if (route.startsWith('listening-prayer/')) {
      isCompleted = context.watch<ListeningPrayerBloc>().state.isCompleted(_parseId(route));
    } else if (route.startsWith('goals/')) {
      isCompleted = context.watch<GoalsBloc>().state.isCompleted(_parseId(route));
    } else if (route.startsWith('spiritual-gifts/')) {
      isCompleted = context.watch<SpiritualGiftsBloc>().state.isSessionCompleted(_parseId(route));
    } else if (route == 'values') {
      isCompleted = context.watch<ValuesBloc>().state.isCompleted;
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
          final targetRoute = isCompleted 
            ? '${session.moduleRoute}${session.moduleRoute!.contains('?') ? '&' : '?'}mode=result'
            : session.moduleRoute!;
          context.push('/$targetRoute');
        }
      },
    );
  }
}
