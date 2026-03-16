import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'core/theme/app_theme.dart';
import 'features/timeline/screens/timeline_screen.dart';
import 'features/notes/screens/notes_screen.dart';
import 'features/notes/bloc/notes_bloc.dart';
import 'features/listening_prayer/bloc/listening_prayer_bloc.dart';
import 'features/listening_prayer/screens/listening_prayer_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NotesBloc()),
        BlocProvider(create: (context) => ListeningPrayerBloc()),
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
            return NotesScreen(sessionId: sessionId, title: title);
          },
        ),
        GoRoute(
          path: '/listening-prayer/:sessionId',
          builder: (context, state) {
            final sessionId = state.pathParameters['sessionId']!;
            final title = state.uri.queryParameters['title'] ?? 'Listening Prayer';
            return ListeningPrayerScreen(sessionId: sessionId, title: title);
          },
        ),
      ],
    );

    return MaterialApp.router(
      title: 'DFL App',
      theme: AppTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('de'),
      ],
    );
  }
}
