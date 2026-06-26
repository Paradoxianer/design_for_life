import 'package:design_for_life/features/spiritual_gifts/repositories/gifts_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:design_for_life/main.dart';
import 'package:design_for_life/core/blocs/entry_list_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:design_for_life/features/notes/bloc/notes_bloc.dart';
import 'package:design_for_life/features/listening_prayer/bloc/listening_prayer_bloc.dart';
import 'package:design_for_life/features/goals/bloc/goals_bloc.dart';
import 'package:design_for_life/features/spiritual_gifts/bloc/spiritual_gifts_bloc.dart';
import 'package:design_for_life/features/values/bloc/values_bloc.dart';
import 'package:design_for_life/features/feedback/bloc/feedback_bloc.dart';
import 'package:design_for_life/features/life_tree/bloc/life_tree_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockStorage extends Mock implements Storage {}
class MockGiftsRepository extends Mock implements GiftsRepository {}

void main() {
  late Storage storage;

  setUp(() {
    storage = MockStorage();
    registerFallbackValue(const Locale('en'));
    when(() => storage.write(any(), any())).thenAnswer((_) async {});
    when(() => storage.read(any())).thenReturn(null);
    HydratedBloc.storage = storage;
  });

  Widget createWidgetUnderTest(String? forcedLocale) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NotesBloc()),
        BlocProvider(create: (context) => ListeningPrayerBloc()),
        BlocProvider(create: (context) => GoalsBloc()),
        BlocProvider(create: (context) => SpiritualGiftsBloc(repository: MockGiftsRepository())),
        BlocProvider(create: (context) => ValuesBloc()),
        BlocProvider(create: (context) => FeedbackBloc()),
        BlocProvider(create: (context) => LifeTreeBloc()),
      ],
      child: DflApp(forcedLocale: forcedLocale),
    );
  }

  testWidgets('DflApp uses forced locale when provided', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest('de'));
    final MaterialApp materialApp = tester.widget(find.byType(MaterialApp));
    expect(materialApp.locale, const Locale('de'));
  });

  testWidgets('DflApp uses null locale (system default) when not provided', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(null));
    final MaterialApp materialApp = tester.widget(find.byType(MaterialApp));
    expect(materialApp.locale, isNull);
  });
}
