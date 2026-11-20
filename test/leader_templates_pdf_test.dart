import 'package:flutter_test/flutter_test.dart';
import 'package:design_for_life/features/leader_notes/services/leader_templates_pdf.dart';
import 'package:design_for_life/l10n/generated/app_localizations_de.dart';
import 'package:design_for_life/l10n/generated/app_localizations_en.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  bool isPdf(List<int> bytes) =>
      bytes.length > 1000 && String.fromCharCodes(bytes.take(4)) == '%PDF';

  test('certificates: blank and with names, in both languages', () async {
    expect(isPdf(await LeaderTemplatesPdf.certificates(AppLocalizationsDe())), isTrue);
    final named = await LeaderTemplatesPdf.certificates(
      AppLocalizationsEn(),
      names: ['Anna', ' ', 'Ben'],
      place: 'Chemnitz',
      date: '31.01.2027',
    );
    expect(isPdf(named), isTrue);
  });

  test('schedules build a PDF', () async {
    expect(isPdf(await LeaderTemplatesPdf.schedules(AppLocalizationsDe())), isTrue);
  });
}
