import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';

import 'core/theme/app_theme.dart';
import 'features/timeline/screens/timeline_screen.dart';
import 'features/notes/screens/notes_screen.dart';
import 'features/notes/bloc/notes_bloc.dart';
import 'features/listening_prayer/bloc/listening_prayer_bloc.dart';
import 'features/listening_prayer/screens/listening_prayer_screen.dart';
import 'features/goals/bloc/goals_bloc.dart';
import 'features/goals/screens/goals_screen.dart';
import 'features/spiritual_gifts/bloc/spiritual_gifts_bloc.dart';
import 'features/spiritual_gifts/repositories/gifts_repository.dart';
import 'features/spiritual_gifts/screens/spiritual_gifts_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );

  final giftsRepository = GiftsRepository();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NotesBloc()),
        BlocProvider(create: (context) => ListeningPrayerBloc()),
        BlocProvider(create: (context) => GoalsBloc()),
        BlocProvider(
          create: (context) => SpiritualGiftsBloc(repository: giftsRepository),
        ),
      ],
      child: const DflApp(),
    ),
  );
}

class DflApp extends StatelessWidget {
  const DflApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const TimelineScreen(),
        ),
        GoRoute(
          path: '/notes/:sessionId',
          builder: (context, state) {
            final sessionId = state.pathParameters['sessionId']!;
            final title = state.uri.queryParameters['title'] ?? 'Notes';
            final mode = state.uri.queryParameters['mode'];
            return NotesScreen(
              sessionId: sessionId, 
              title: title,
              initialEditMode: mode != 'result',
            );
          },
        ),
        GoRoute(
          path: '/listening-prayer/:sessionId',
          builder: (context, state) {
            final sessionId = state.pathParameters['sessionId']!;
            final title = state.uri.queryParameters['title'] ?? 'Listening Prayer';
            final mode = state.uri.queryParameters['mode'];
            return ListeningPrayerScreen(
              sessionId: sessionId, 
              title: title,
              initialEditMode: mode != 'result',
            );
          },
        ),
        GoRoute(
          path: '/goals/:sessionId',
          builder: (context, state) {
            final sessionId = state.pathParameters['sessionId']!;
            final title = state.uri.queryParameters['title'] ?? 'Goals';
            final mode = state.uri.queryParameters['mode'];
            return GoalsScreen(
              sessionId: sessionId, 
              title: title,
              initialEditMode: mode != 'result',
            );
          },
        ),
        GoRoute(
          path: '/spiritual-gifts/:sessionId',
          builder: (context, state) {
            final sessionId = state.pathParameters['sessionId']!;
            final title = state.uri.queryParameters['title'] ?? 'Spiritual Gifts';
            final mode = state.uri.queryParameters['mode'];
            return SpiritualGiftsScreen(
              sessionId: sessionId,
              title: title,
              initialEditMode: mode != 'result',
            );
          },
        ),
      ],
    );

    return MaterialApp.router(
      title: 'DFL App',
      theme: AppTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
