import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:design_for_life/features/values/bloc/values_bloc.dart';
import 'package:design_for_life/features/values/widgets/values_editor.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';

class MockStorage extends Mock implements Storage {}

void main() {
  setUp(() {
    final storage = MockStorage();
    when(() => storage.write(any(), any())).thenAnswer((_) async {});
    when(() => storage.read(any())).thenReturn(null);
    HydratedBloc.storage = storage;
  });

  Future<void> pumpAtWidth(WidgetTester tester, double width) async {
    tester.view.physicalSize = Size(width, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      BlocProvider(
        create: (_) => ValuesBloc(),
        child: MaterialApp(
          locale: const Locale('de'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: ValuesEditor(currentStep: 0, onStepTapped: (_) {}),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('horizontal stepper header does not overflow with long German titles on a small phone', (tester) async {
    await pumpAtWidth(tester, 360);
    expect(tester.takeException(), isNull);
  });

  testWidgets('horizontal stepper header does not overflow on a narrow small phone', (tester) async {
    await pumpAtWidth(tester, 320);
    expect(tester.takeException(), isNull);
  });

  testWidgets('horizontal stepper header does not overflow on a very small phone', (tester) async {
    await pumpAtWidth(tester, 300);
    expect(tester.takeException(), isNull);
  });
}
