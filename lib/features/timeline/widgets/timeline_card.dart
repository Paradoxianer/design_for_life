import 'package:flutter/material.dart';
import '../models/dfl_session.dart';

class TimelineCard extends StatelessWidget {
  final DflSession session;
  final VoidCallback? onTap;

  const TimelineCard({
    super.key,
    required this.session,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TypeIcon(type: session.type),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (session.startTime != null)
                          Text(
                            '${session.startTime!.hour.toString().padLeft(2, '0')}:${session.startTime!.minute.toString().padLeft(2, '0')}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        Text(
                          session.title,
                          style: theme.textTheme.titleMedium,
                        ),
                        if (session.description != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            session.description!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  _StatusIcon(status: session.status),
                ],
              ),
              if (session.room != null || session.groupAssignment != null) ...[
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (session.room != null) ...[
                      const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        session.room!,
                        style: theme.textTheme.labelSmall,
                      ),
                      const SizedBox(width: 16),
                    ],
                    if (session.groupAssignment != null) ...[
                      const Icon(Icons.people_outline, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        session.groupAssignment!,
                        style: theme.textTheme.labelSmall,
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeIcon extends StatelessWidget {
  final SessionType type;

  const _TypeIcon({required this.type});

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    switch (type) {
      case SessionType.lecture:
        iconData = Icons.menu_book_rounded;
        break;
      case SessionType.groupWork:
        iconData = Icons.groups_rounded;
        break;
      case SessionType.personalReflection:
        iconData = Icons.self_improvement_rounded;
        break;
      case SessionType.prayer:
        iconData = Icons.volunteer_activism_rounded;
        break;
      case SessionType.other:
        iconData = Icons.more_horiz_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        iconData,
        color: Theme.of(context).colorScheme.primary,
        size: 20,
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  final SessionStatus status;

  const _StatusIcon({required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case SessionStatus.done:
        return const Icon(Icons.check_circle_rounded, color: Colors.green, size: 20);
      case SessionStatus.locked:
        return const Icon(Icons.lock_outline_rounded, color: Colors.grey, size: 20);
      case SessionStatus.override:
        return const Icon(Icons.lock_open_rounded, color: Color(0xFFF4D03F), size: 20);
      case SessionStatus.notStarted:
        return const Icon(Icons.radio_button_unchecked_rounded, color: Colors.grey, size: 20);
    }
  }
}
