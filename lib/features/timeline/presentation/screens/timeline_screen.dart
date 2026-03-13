import 'package:flutter/material.dart';
import '../../data/static_timeline_data.dart';
import '../widgets/timeline_card.dart';

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sessions = StaticTimelineData.sessions;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Text(
              'DFL Weekend',
              style: theme.textTheme.displayLarge,
            ),
            backgroundColor: theme.scaffoldBackgroundColor,
            surfaceTintColor: Colors.transparent,
            centerTitle: false,
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
                        // TODO: Implement navigation via GoRouter
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Opening ${session.title}')),
                        );
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
