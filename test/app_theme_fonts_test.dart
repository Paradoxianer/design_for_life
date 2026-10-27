import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:design_for_life/core/theme/app_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('theme uses the locally bundled font families', () {
    final textTheme = AppTheme.lightTheme.textTheme;

    expect(textTheme.displayLarge?.fontFamily, 'PlayfairDisplay');
    expect(textTheme.titleMedium?.fontFamily, 'Inter');
    expect(textTheme.bodyLarge?.fontFamily, 'Inter');
    expect(textTheme.labelSmall?.fontFamily, 'Inter');
  });

  test('bundled font families are declared in the font manifest', () async {
    final manifest =
        jsonDecode(await rootBundle.loadString('FontManifest.json')) as List;
    final families = manifest.map((entry) => (entry as Map)['family']).toSet();

    expect(families, containsAll(<String>['Inter', 'PlayfairDisplay']));
  });
}
