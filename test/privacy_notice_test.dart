import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:design_for_life/features/privacy/legal_texts.dart';
import 'package:design_for_life/features/privacy/privacy_notice_cubit.dart';
import 'package:design_for_life/features/privacy/privacy_notice_gate.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';

class _MockStorage extends Mock implements Storage {}

void main() {
  setUpAll(() {
    final storage = _MockStorage();
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    when(() => storage.read(any())).thenReturn(null);
    HydratedBloc.storage = storage;
  });

  Widget app(PrivacyNoticeCubit cubit) => MaterialApp(
        home: BlocProvider.value(
          value: cubit,
          child: const PrivacyNoticeGate(child: Scaffold(body: Text('app'))),
        ),
      );

  testWidgets('shows the notice first and hides it after acknowledging', (
    tester,
  ) async {
    final cubit = PrivacyNoticeCubit();
    await tester.pumpWidget(app(cubit));

    expect(find.text(LegalTexts.de.welcomeTitle), findsNothing); // en locale
    expect(find.text(LegalTexts.en.welcomeTitle), findsOneWidget);

    await tester.tap(find.text(LegalTexts.en.welcomeAck));
    await tester.pump();
    expect(find.text(LegalTexts.en.welcomeTitle), findsNothing);
    expect(cubit.state, isTrue);
  });

  testWidgets('does not show the notice once acknowledged', (tester) async {
    await tester.pumpWidget(app(PrivacyNoticeCubit(acknowledged: true)));
    expect(find.text(LegalTexts.en.welcomeTitle), findsNothing);
  });

  testWidgets('privacy policy can be read from the notice and closed again', (
    tester,
  ) async {
    await tester.pumpWidget(app(PrivacyNoticeCubit()));
    await tester.tap(find.text(LegalTexts.en.readPrivacy));
    await tester.pump();
    expect(find.text(LegalTexts.en.privacyPolicy.title), findsOneWidget);
    await tester.tap(find.text(LegalTexts.en.back));
    await tester.pump();
    expect(find.text(LegalTexts.en.welcomeTitle), findsOneWidget);
  });
}
