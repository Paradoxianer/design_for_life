import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../models/static_timeline_data.dart';
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
                  return TimelineCard(
                    session: session,
                    onTap: () {
                      if (session.moduleRoute != null) {
                        context.push('/${session.moduleRoute}');
                      }
                    },
                  );
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
