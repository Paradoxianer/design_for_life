import 'package:flutter/material.dart';

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      app_body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Text(
              'DFL Weekend',
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
          const SliverFillRemaining(
            child: Center(
              child: Text('Timeline Placeholder'),
            ),
          ),
        ],
      ),
    );
  }
}
