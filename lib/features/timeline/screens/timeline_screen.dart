import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';

import '../models/dfl_session.dart';
import '../services/timeline_config_repository.dart';
import '../services/timeline_module_registry.dart';
import '../widgets/timeline_card.dart';

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return FutureBuilder<List<DflSession>>(
      future: const TimelineConfigRepository().loadSessions(l10n),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text(l10n.timelineUnavailable)),
          );
        }

        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final theme = Theme.of(context);
        final sessions = snapshot.data!;

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
      },
    );
  }
}

class _TimelineCardWrapper extends StatelessWidget {
  final DflSession session;

  const _TimelineCardWrapper({required this.session});

  @override
  Widget build(BuildContext context) {
    final isCompleted = TimelineModuleRegistry.isCompleted(context, session);
    final isStarted = TimelineModuleRegistry.isStarted(context, session);

    SessionStatus effectiveStatus;
    if (isCompleted) {
      effectiveStatus = SessionStatus.done;
    } else if (isStarted) {
      effectiveStatus = SessionStatus.inProgress;
    } else {
      effectiveStatus = session.status;
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
      status: effectiveStatus,
      moduleId: session.moduleId,
      moduleSessionId: session.moduleSessionId,
    );

    return TimelineCard(
      session: updatedSession,
      onTap: () {
        final shouldOpenInResultMode =
            updatedSession.status == SessionStatus.done;
        final targetRoute = TimelineModuleRegistry.buildRoute(
          updatedSession,
          resultMode: shouldOpenInResultMode,
        );
        if (targetRoute != null) {
          context.push('/$targetRoute');
        }
      },
    );
  }
}
