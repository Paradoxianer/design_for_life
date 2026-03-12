import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'features/timeline/presentation/screens/timeline_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Setup HydratedBloc for local persistence
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );

  runApp(const DflApp());
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
      ],
    );

    return MaterialApp.router(
      title: 'DFL App',
      theme: AppTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
