import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';

import '../../features/timeline/screens/timeline_screen.dart';

/// Shows a persistent module list alongside the routed screen on large
/// landscape screens (#40), instead of the module screen replacing the
/// whole window on navigation. Below the breakpoint, this returns `child`
/// unchanged - the exact pre-#40 behavior on phones and portrait tablets.
///
/// Breakpoint: Material 3's "expanded" window size class boundary (>=840dp
/// width) - the point at which there's comfortably enough room for both a
/// module list and detail content side by side.
class AdaptiveNavigationShell extends StatelessWidget {
  static const double splitViewBreakpoint = 840;
  static const double _navWidth = 380;

  final GoRouterState routerState;
  final Widget child;

  const AdaptiveNavigationShell({
    super.key,
    required this.routerState,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < splitViewBreakpoint) return child;

    final currentPath = routerState.uri.path;
    final isRoot = currentPath == '/';

    return Row(
      children: [
        SizedBox(
          width: _navWidth,
          child: TimelineScreen(
            selectedPath: isRoot ? null : currentPath,
            useReplaceNavigation: true,
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(child: isRoot ? const _SplitViewPlaceholder() : child),
      ],
    );
  }
}

class _SplitViewPlaceholder extends StatelessWidget {
  const _SplitViewPlaceholder();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ColoredBox(
      color: theme.scaffoldBackgroundColor,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            AppLocalizations.of(context).splitViewSelectModule,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
