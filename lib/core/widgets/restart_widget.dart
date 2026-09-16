import 'package:flutter/material.dart';

/// Lets any descendant trigger a full in-process "restart" of the widget
/// tree below it (#84): after writing new HydratedBloc storage during a
/// backup import, the already-running bloc instances still hold their old
/// in-memory state - there's no per-bloc "reload from storage" API, and
/// there's no cross-platform "restart the app" call either. Rebuilding this
/// subtree under a fresh [Key] is the standard Flutter way to get the same
/// effect: every descendant (including all BlocProviders) is disposed and
/// recreated, so hydration runs again and picks up the freshly written data.
class RestartWidget extends StatefulWidget {
  final Widget child;

  const RestartWidget({super.key, required this.child});

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?._restart();
  }

  @override
  State<RestartWidget> createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key _key = UniqueKey();

  void _restart() {
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(key: _key, child: widget.child);
  }
}
