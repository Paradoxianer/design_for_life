import 'package:flutter/material.dart';
import 'screens/values_assessment_screen.dart';

class ValuesModule {
  static Route route() {
    return MaterialPageRoute(
      builder: (_) => const ValuesAssessmentScreen(
        title: 'Werte herausfinden',
      ),
    );
  }
}
