import 'value_item.dart';

class StaticValuesData {
  static const List<String> rawValues = [
    'Genauigkeit', 'Familie', 'pers. Entwicklung',
    'Ausführung', 'finanzielle Sicherheit', 'Beitrag/Mitarbeit',
    'Aufstieg', 'Flexibilität', 'Leistung (Energie)',
    'Abenteuer', 'Freundschaft', 'Prestige',
    'Ästhetik', 'Großzügigkeit', 'Anerkennung',
    'künstlerischer Ausdruck', 'Glück', 'pers. Glaube',
    'Echtheit', 'Humor', 'Verantwortung',
    'Gleichgewicht', 'Unabhängigkeit', 'Sicherheit',
    'Herausforderung', 'Integrität', 'Selbstachtung',
    'Befähigung', 'Lernen', 'Dienst',
    'Wettbewerb', 'Freizeit', 'Beständigkeit',
    'Anpassung', 'Wohnort', 'Toleranz',
    'körperliche Fitness + Gesundheit', 'Liebe', 'Tradition',
    'Kontrolle', 'Ausdauer - Beharrlichkeit', 'Vielfältigkeit',
    'Kooperation', 'Natur', 'Einfluss',
    'Kreativität', 'Organisation', 'Effektivität',
    'Friede', 'Fairness', 'Loyalität'
  ];

  static List<ValueItem> get initialValues =>
      rawValues.map((name) => ValueItem(name: name)).toList();
}
