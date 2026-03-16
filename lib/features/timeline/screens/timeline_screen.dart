import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../widgets/timeline_card.dart';
import '../models/dfl_session.dart';

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final appTitle = l10n?.appTitle ?? 'DFL Weekend';
    
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSessionGroup(context, 'Friday', [
            TimelineCard(
              session: DflSession(
                id: 'fri_session',
                title: l10n?.notes ?? 'Notes',
                type: SessionType.other,
                startTime: DateTime(2026, 3, 20, 19, 0),
              ),
              onTap: () => context.push('/notes/fri_session?title=${l10n?.notes ?? "Notes"}'),
            ),
          ]),
          const SizedBox(height: 24),
          _buildSessionGroup(context, 'Saturday', [
            TimelineCard(
              session: DflSession(
                id: 'sat_s1',
                title: 'Session 1: Vision',
                type: SessionType.lecture,
                startTime: DateTime(2026, 3, 21, 9, 0),
              ),
              onTap: () => context.push('/notes/sat_s1?title=Vision'),
            ),
            TimelineCard(
              session: DflSession(
                id: 'sat_lp',
                title: l10n?.listeningPrayer ?? 'Listening Prayer',
                type: SessionType.prayer,
                startTime: DateTime(2026, 3, 21, 11, 0),
              ),
              onTap: () => context.push('/listening-prayer/sat_lp?title=${l10n?.listeningPrayer ?? "Listening Prayer"}'),
            ),
          ]),
          const SizedBox(height: 24),
          _buildSessionGroup(context, 'Sunday', [
            TimelineCard(
              session: DflSession(
                id: 'sun_goals',
                title: l10n?.goalsTitle ?? 'SMART Goals',
                type: SessionType.groupWork,
                startTime: DateTime(2026, 3, 22, 10, 0),
              ),
              onTap: () => context.push('/goals/sun_goals?title=${l10n?.goalsTitle ?? "SMART Goals"}'),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSessionGroup(BuildContext context, String day, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            day,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        ...items,
      ],
    );
  }
}
