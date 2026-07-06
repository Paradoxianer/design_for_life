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
import 'features/values/bloc/values_bloc.dart';
import 'features/values/screens/values_assessment_screen.dart';
import 'features/feedback/bloc/feedback_bloc.dart';
import 'features/feedback/screens/feedback_screen.dart';
import 'features/imagine/bloc/imagine_bloc.dart';
import 'features/imagine/screens/imagine_screen.dart';
import 'features/life_tree/bloc/life_tree_bloc.dart';
import 'features/life_tree/screens/life_tree_screen.dart';
import 'features/synthesis/bloc/synthesis_bloc.dart';
import 'features/synthesis/screens/synthesis_screen.dart';
import 'features/group_photo/bloc/group_photo_bloc.dart';
import 'features/group_photo/screens/group_photo_screen.dart';

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
        BlocProvider(create: (context) => ValuesBloc()),
        BlocProvider(create: (context) => FeedbackBloc()),
        BlocProvider(create: (context) => ImagineBloc()),
        BlocProvider(create: (context) => LifeTreeBloc()),
        BlocProvider(create: (context) => SynthesisBloc()),
        BlocProvider(create: (context) => GroupPhotoBloc()),
      ],
      child: const DflApp(),
    ),
  );
}

class DflApp extends StatelessWidget {
  final String? forcedLocale;

  const DflApp({super.key, this.forcedLocale});

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
            final l10n = AppLocalizations.of(context);
            final sessionId = state.pathParameters['sessionId']!;
            final title = state.uri.queryParameters['title'] ?? l10n.notes;
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
            final l10n = AppLocalizations.of(context);
            final sessionId = state.pathParameters['sessionId']!;
            final title = state.uri.queryParameters['title'] ?? l10n.listeningPrayerTitle;
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
            final l10n = AppLocalizations.of(context);
            final sessionId = state.pathParameters['sessionId']!;
            final title = state.uri.queryParameters['title'] ?? l10n.goalsTitle;
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
            final l10n = AppLocalizations.of(context);
            final sessionId = state.pathParameters['sessionId']!;
            final title = state.uri.queryParameters['title'] ?? l10n.spiritualGiftsTitle;
            final mode = state.uri.queryParameters['mode'];
            return SpiritualGiftsScreen(
              sessionId: sessionId,
              title: title,
              initialEditMode: mode != 'result',
            );
          },
        ),
        GoRoute(
          path: '/values',
          builder: (context, state) {
            final l10n = AppLocalizations.of(context);
            final title = state.uri.queryParameters['title'] ?? l10n.valuesTitle;
            final mode = state.uri.queryParameters['mode'];
            return ValuesAssessmentScreen(
              title: title,
              initialEditMode: mode != 'result',
            );
          },
        ),
        GoRoute(
          path: '/feedback',
          builder: (context, state) {
            final l10n = AppLocalizations.of(context);
            final title = state.uri.queryParameters['title'] ?? l10n.feedbackTitle;
            final mode = state.uri.queryParameters['mode'];
            return FeedbackScreen(
              title: title,
              initialEditMode: mode != 'result',
            );
          },
        ),
        GoRoute(
          path: '/imagine/:sessionId',
          builder: (context, state) {
            final l10n = AppLocalizations.of(context);
            final sessionId = state.pathParameters['sessionId']!;
            final title = state.uri.queryParameters['title'] ?? l10n.timelineImagineTitle;
            final mode = state.uri.queryParameters['mode'];
            return ImagineScreen(
              sessionId: sessionId,
              title: title,
              initialEditMode: mode != 'result',
            );
          },
        ),
        GoRoute(
          path: '/life-tree/:sessionId',
          builder: (context, state) {
            final l10n = AppLocalizations.of(context);
            final sessionId = state.pathParameters['sessionId']!;
            final title = state.uri.queryParameters['title'] ?? l10n.lifeTreeTitle;
            final mode = state.uri.queryParameters['mode'];
            return LifeTreeScreen(
              sessionId: sessionId,
              title: title,
              initialEditMode: mode != 'result',
            );
          },
        ),
        GoRoute(
          path: '/group-photo',
          builder: (context, state) {
            final l10n = AppLocalizations.of(context);
            final title = state.uri.queryParameters['title'] ?? l10n.session11Title;
            final mode = state.uri.queryParameters['mode'];
            return GroupPhotoScreen(
              title: title,
              initialEditMode: mode != 'result',
            );
          },
        ),
        GoRoute(
          path: '/synthesis',
          builder: (context, state) {
            final l10n = AppLocalizations.of(context);
            final title = state.uri.queryParameters['title'] ?? l10n.timelineSynthesisTitle;
            final mode = state.uri.queryParameters['mode'];
            return SynthesisScreen(
              giftsSessionId: state.uri.queryParameters['giftsSession'] ?? 'session_5',
              prayerSessionId: state.uri.queryParameters['prayerSession'] ?? 'session_7',
              goalsSessionId: state.uri.queryParameters['goalsSession'] ?? 'session_10',
              lifeTreeSessionId: state.uri.queryParameters['lifeTreeSession'] ?? 'session_3',
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
      locale: forcedLocale == null ? null : Locale(forcedLocale!),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
