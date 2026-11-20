import 'package:hydrated_bloc/hydrated_bloc.dart';

/// Merkt sich lokal (HydratedBloc, wie die Teilnehmer-Checkliste), welche
/// Punkte der Leiter-Checklisten abgehakt sind. Schlüssel ist
/// "<Abschnitt>|<Text>", damit gleiche Texte in verschiedenen Listen nicht
/// gemeinsam abgehakt werden.
class LeaderChecklistCubit extends HydratedCubit<Set<String>> {
  LeaderChecklistCubit() : super(const <String>{});

  static String keyFor(String heading, String item) => '$heading|$item';

  void toggle(String key) {
    final next = {...state};
    if (!next.remove(key)) next.add(key);
    emit(next);
  }

  /// Entfernt alle Haken (z. B. vor dem nächsten Wochenende).
  void reset() => emit(const <String>{});

  @override
  Set<String>? fromJson(Map<String, dynamic> json) {
    final list = json['checked'];
    if (list is! List) return null;
    return list.whereType<String>().toSet();
  }

  @override
  Map<String, dynamic>? toJson(Set<String> state) => {
    'checked': state.toList()..sort(),
  };
}
