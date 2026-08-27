import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:design_for_life/main.dart';
import 'package:design_for_life/features/timeline/bloc/timeline_module_filter_bloc.dart';
import 'package:design_for_life/features/notes/bloc/notes_bloc.dart';
import 'package:design_for_life/features/listening_prayer/bloc/listening_prayer_bloc.dart';
import 'package:design_for_life/features/goals/bloc/goals_bloc.dart';
import 'package:design_for_life/features/spiritual_gifts/bloc/spiritual_gifts_bloc.dart';
import 'package:design_for_life/features/spiritual_gifts/bloc/gift_reference_answer_bloc.dart';
import 'package:design_for_life/features/spiritual_gifts/repositories/gifts_repository.dart';
import 'package:design_for_life/features/values/bloc/values_bloc.dart';
import 'package:design_for_life/features/feedback/bloc/feedback_bloc.dart';
import 'package:design_for_life/features/feedback/repositories/feedback_questions_repository.dart';
import 'package:design_for_life/features/personal_style/bloc/personal_style_bloc.dart';
import 'package:design_for_life/features/personal_style/repositories/personal_style_repository.dart';
import 'package:design_for_life/features/imagine/bloc/imagine_bloc.dart';
import 'package:design_for_life/features/life_tree/bloc/life_tree_bloc.dart';
import 'package:design_for_life/features/synthesis/bloc/synthesis_bloc.dart';
import 'package:design_for_life/features/group_photo/bloc/group_photo_bloc.dart';

class _MockStorage extends Mock implements Storage {}

void main() {
  // Every session card on the timeline watches its own module's bloc (to
  // show its completion status), so - unlike a minimal single-bloc test -
  // this needs the same full provider set DflApp gets from main().
  setUp(() {
    final storage = _MockStorage();
    when(() => storage.write(any(), any())).thenAnswer((_) async {});
    when(() => storage.read(any())).thenReturn(null);
    when(() => storage.delete(any())).thenAnswer((_) async {});
    when(() => storage.clear()).thenAnswer((_) async {});
    HydratedBloc.storage = storage;
  });

  testWidgets('shows the app title on the timeline start screen', (
    WidgetTester tester,
  ) async {
    // Pin a narrow phone-sized surface so this smoke test exercises the
    // plain single-pane layout regardless of the default test window size -
    // the >=840dp split-view layout (#40) is a separate concern.
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => NotesBloc()),
          BlocProvider(create: (context) => ListeningPrayerBloc()),
          BlocProvider(create: (context) => GoalsBloc()),
          BlocProvider(
            create: (context) =>
                SpiritualGiftsBloc(repository: GiftsRepository()),
          ),
          BlocProvider(create: (context) => GiftReferenceAnswerBloc()),
          BlocProvider(create: (context) => ValuesBloc()),
          BlocProvider(
            create: (context) =>
                FeedbackBloc(repository: FeedbackQuestionsRepository()),
          ),
          BlocProvider(
            create: (context) =>
                PersonalStyleBloc(repository: PersonalStyleRepository()),
          ),
          BlocProvider(create: (context) => ImagineBloc()),
          BlocProvider(create: (context) => LifeTreeBloc()),
          BlocProvider(create: (context) => SynthesisBloc()),
          BlocProvider(create: (context) => GroupPhotoBloc()),
          BlocProvider(create: (context) => TimelineModuleFilterBloc()),
        ],
        child: const DflApp(),
      ),
    );
    await tester.pumpAndSettle();

    // SliverAppBar.large keeps both its collapsed and expanded title Text
    // widgets in the tree at once (for the scroll crossfade), so more than
    // one match is expected here - just confirm it's actually showing.
    expect(find.text('DFL Weekend'), findsWidgets);
  });
}
