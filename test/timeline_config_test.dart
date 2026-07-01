import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:design_for_life/features/timeline/models/dfl_session.dart';
import 'package:design_for_life/features/timeline/services/timeline_module_registry.dart';

void main() {
  group('timeline config', () {
    test('contains synthesis before imagine and no legacy future idea entry', () {
      final configFile = File('assets/config/timeline_config.json');
      final decoded = jsonDecode(configFile.readAsStringSync()) as Map<String, dynamic>;
      final sessions = (decoded['sessions'] as List<dynamic>)
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();

      final moduleIds = sessions.map((session) => session['moduleId'] as String).toList();
      final synthesisIndex = moduleIds.indexOf('module_synthesis');
      final imagineIndex = moduleIds.indexOf('module_imagine');

      expect(synthesisIndex, greaterThanOrEqualTo(0));
      expect(imagineIndex, greaterThanOrEqualTo(0));
      expect(synthesisIndex, lessThan(imagineIndex));
      expect(moduleIds, isNot(contains('module_future_idea')));
      expect(sessions.any((session) => session['titleKey'] == 'session8Title'), isFalse);
    });
  });

  group('timeline module registry', () {
    test('maps synthesis and imagine modules through module ids', () {
      const synthesis = DflSession(
        id: 'session_synthesis',
        title: 'Synthesis (S)',
        type: SessionType.groupWork,
        moduleId: 'module_synthesis',
        moduleSessionId: 'session_synthesis',
      );
      const imagine = DflSession(
        id: 'session_imagine',
        title: 'Imagine',
        type: SessionType.groupWork,
        moduleId: 'module_imagine',
        moduleSessionId: 'session_imagine',
      );

      final synthesisRoute = TimelineModuleRegistry.buildRoute(synthesis);
      final imagineRoute = TimelineModuleRegistry.buildRoute(imagine, resultMode: true);

      expect(synthesisRoute, startsWith('notes/session_synthesis?title='));
      expect(imagineRoute, startsWith('notes/session_imagine?title='));
      expect(imagineRoute, contains('mode=result'));
    });
  });
}
