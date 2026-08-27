import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';

import '../../../core/utils/localized_logo.dart';
import '../bloc/timeline_module_filter_bloc.dart';
import '../models/dfl_session.dart';
import '../services/timeline_config_repository.dart';
import '../services/timeline_module_registry.dart';
import '../widgets/timeline_card.dart';

class TimelineScreen extends StatelessWidget {
  /// Path (without query, e.g. `/spiritual-gifts/session_5`) of the session
  /// currently shown in the detail pane, when embedded as the persistent
  /// list in AdaptiveNavigationShell's split view (#40). Null in the normal
  /// full-screen usage, where nothing needs to be highlighted.
  final String? selectedPath;

  /// True when this list is the persistent rail in AdaptiveNavigationShell's
  /// split view (#40). Selecting a session there uses `context.go` (replace)
  /// instead of `context.push`: pushing a sibling route under the same
  /// ShellRoute mounts a whole separate shell page rather than updating this
  /// one in place (go_router builds the new ShellRoute instance from the
  /// pushed ImperativeRouteMatch, leaving this persistent instance's
  /// `GoRouterState` stale) - so the detail pane never updated, and pushes
  /// kept accumulating on the stack (needing repeated back-taps once the
  /// window narrowed again). `go` avoids that entirely by replacing the
  /// single current location instead of stacking a new one.
  final bool useReplaceNavigation;

  const TimelineScreen({
    super.key,
    this.selectedPath,
    this.useReplaceNavigation = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return FutureBuilder<List<DflSession>>(
      future: const TimelineConfigRepository().loadSessions(l10n),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text(l10n.timelineUnavailable)));
        }

        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final theme = Theme.of(context);
        final allSessions = snapshot.data!;
        // Deep-link-basierte Modul-Beschränkung (#49): kein Locking - wenn
        // eine Liste erlaubter Module übergeben wurde, werden nur diese
        // angezeigt, alle anderen tauchen gar nicht erst auf (stripped-down
        // DFL für ein verkürztes Format, ohne dass sichtbar wird, was es
        // sonst noch gäbe). Ohne Deep-Link (allowedSessionIds == null)
        // bleibt die volle Timeline wie gehabt.
        final allowedSessionIds = context
            .watch<TimelineModuleFilterBloc>()
            .state
            .allowedSessionIds;
        final sessions = allowedSessionIds == null
            ? allSessions
            : allSessions
                  .where((s) => allowedSessionIds.contains(s.id))
                  .toList();

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar.large(
                title: Text(l10n.appTitle, style: theme.textTheme.displayLarge),
                backgroundColor: theme.scaffoldBackgroundColor,
                surfaceTintColor: Colors.transparent,
                actions: [
                  IconButton(
                    tooltip: l10n.exportTitle,
                    icon: const Icon(Icons.picture_as_pdf_outlined),
                    onPressed: () => context.push('/export'),
                  ),
                ],
              ),
              // Datum/Ort, die per Deep-Link mitgegeben wurden (#49), als
              // eigene Zeile statt im SliverAppBar.large-Titel selbst - der
              // hat eine feste expandedHeight und würde bei einer zweiten
              // Zeile riskieren zu überlaufen.
              SliverToBoxAdapter(
                child:
                    BlocBuilder<
                      TimelineModuleFilterBloc,
                      TimelineModuleFilterState
                    >(
                      builder: (context, filterState) {
                        final subtitle = _eventSubtitle(filterState);
                        if (subtitle == null) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                          child: Row(
                            children: [
                              Icon(
                                Icons.event_outlined,
                                size: 16,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                subtitle,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final session = sessions[index];
                    return _TimelineCardWrapper(
                      session: session,
                      selectedPath: selectedPath,
                      useReplaceNavigation: useReplaceNavigation,
                    );
                  }, childCount: sessions.length),
                ),
              ),
              SliverToBoxAdapter(child: _BrandingFooter()),
            ],
          ),
        );
      },
    );
  }
}

class _BrandingFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/DFL_Logo.png', height: 36),
          const SizedBox(width: 16),
          Image.asset(localizedPartnerLogoAsset(context), height: 36),
        ],
      ),
    );
  }
}

/// Formats the event date/location a deep link (#49) attached, for display
/// as a small subtitle under the timeline header.
String? _eventSubtitle(TimelineModuleFilterState filterState) {
  final parts = [
    if (filterState.eventDate != null && filterState.eventDate!.isNotEmpty)
      filterState.eventDate!,
    if (filterState.eventLocation != null &&
        filterState.eventLocation!.isNotEmpty)
      filterState.eventLocation!,
  ];
  if (parts.isEmpty) return null;
  return parts.join(' · ');
}

class _TimelineCardWrapper extends StatelessWidget {
  final DflSession session;
  final String? selectedPath;
  final bool useReplaceNavigation;

  const _TimelineCardWrapper({
    required this.session,
    this.selectedPath,
    this.useReplaceNavigation = false,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = TimelineModuleRegistry.isCompleted(context, session);

    final route = TimelineModuleRegistry.buildRoute(session);
    final isSelected =
        selectedPath != null &&
        route != null &&
        '/${route.split('?').first}' == selectedPath;

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
      moduleId: session.moduleId,
      moduleSessionId: session.moduleSessionId,
    );

    return TimelineCard(
      session: updatedSession,
      isSelected: isSelected,
      onTap: () {
        final shouldOpenInResultMode =
            updatedSession.status == SessionStatus.done;
        final targetRoute = TimelineModuleRegistry.buildRoute(
          updatedSession,
          resultMode: shouldOpenInResultMode,
        );
        if (targetRoute == null) return;
        if (useReplaceNavigation) {
          context.go('/$targetRoute');
        } else {
          context.push('/$targetRoute');
        }
      },
    );
  }
}
