/// Die vier Felder der 2x2-Matrix (#50). Reihenfolge/Namen spiegeln die
/// Pol-Konvention aus personal_style_question.dart: niedriger O-Score =
/// strukturiert, niedriger E-Score = Mensch-orientiert.
enum PersonalStyleQuadrant {
  peopleStructured,
  peopleUnstructured,
  taskStructured,
  taskUnstructured,
}

extension PersonalStyleQuadrantKey on PersonalStyleQuadrant {
  /// Schlüssel im "profiles"-Objekt der JSON-Fragebogen-Datei.
  String get profileKey {
    switch (this) {
      case PersonalStyleQuadrant.peopleStructured:
        return 'people_structured';
      case PersonalStyleQuadrant.peopleUnstructured:
        return 'people_unstructured';
      case PersonalStyleQuadrant.taskStructured:
        return 'task_structured';
      case PersonalStyleQuadrant.taskUnstructured:
        return 'task_unstructured';
    }
  }
}

/// Bestimmt das Quadrant aus O-/E-Score. Pro Frage ist Wert 1 immer der
/// "strukturiert"- bzw. "Mensch"-Pol, Wert 6 immer der "unstrukturiert"- bzw.
/// "Aufgabe"-Pol (siehe PersonalStyleQuestion) - eine gerade 6er-Skala
/// erzwingt bewusst eine Tendenz ohne neutrale Mitte, der Mittelwert
/// (minSum+maxSum)/2 ist daher eine eindeutige Schwelle.
PersonalStyleQuadrant determinePersonalStyleQuadrant({
  required int organisationScore,
  required int organisationQuestionCount,
  required int energyScore,
  required int energyQuestionCount,
}) {
  final organisationMidpoint = organisationQuestionCount * 3.5;
  final energyMidpoint = energyQuestionCount * 3.5;

  final isStructured = organisationScore <= organisationMidpoint;
  final isPeople = energyScore <= energyMidpoint;

  if (isPeople && isStructured) return PersonalStyleQuadrant.peopleStructured;
  if (isPeople && !isStructured) return PersonalStyleQuadrant.peopleUnstructured;
  if (!isPeople && isStructured) return PersonalStyleQuadrant.taskStructured;
  return PersonalStyleQuadrant.taskUnstructured;
}
