import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

/// Zustand der Leiter-Checklisten: abgehakte Punkte und eigene Punkte.
class LeaderChecklistState extends Equatable {
  /// Schlüssel "<Liste>|<Text>" der abgehakten Punkte.
  final Set<String> checked;

  /// Eigene Punkte je Liste (Schlüssel siehe [LeaderChecklistCubit.listKey]).
  final Map<String, List<String>> custom;

  const LeaderChecklistState({
    this.checked = const <String>{},
    this.custom = const <String, List<String>>{},
  });

  @override
  List<Object?> get props => [checked, custom];
}

/// Merkt sich lokal (HydratedBloc, wie die Teilnehmer-Checkliste), welche
/// Punkte der Leiter-Checklisten abgehakt sind und welche eigenen Punkte
/// hinzugefügt wurden. Schlüssel ist "<Liste>|<Text>", damit gleiche Texte in
/// verschiedenen Listen nicht gemeinsam abgehakt werden.
class LeaderChecklistCubit extends HydratedCubit<LeaderChecklistState> {
  LeaderChecklistCubit() : super(const LeaderChecklistState());

  static String keyFor(String heading, String item) => '$heading|$item';

  /// Schlüssel einer Liste: Abschnittsüberschrift + Position des Blocks, da ein
  /// Abschnitt mehrere Checklisten enthalten kann.
  static String listKey(String heading, int blockIndex) =>
      '$heading#$blockIndex';

  void toggle(String key) {
    final next = {...state.checked};
    if (!next.remove(key)) next.add(key);
    emit(LeaderChecklistState(checked: next, custom: state.custom));
  }

  /// Fügt einer Liste einen eigenen Punkt hinzu (leere Eingaben und Dubletten
  /// werden ignoriert).
  void addItem(String listKey, String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    final existing = state.custom[listKey] ?? const <String>[];
    if (existing.contains(trimmed)) return;
    emit(
      LeaderChecklistState(
        checked: state.checked,
        custom: {
          ...state.custom,
          listKey: [...existing, trimmed],
        },
      ),
    );
  }

  /// Entfernt einen eigenen Punkt samt Haken.
  void removeItem(String listKey, String text) {
    final existing = state.custom[listKey];
    if (existing == null || !existing.contains(text)) return;
    final remaining = existing.where((e) => e != text).toList();
    final custom = {...state.custom};
    if (remaining.isEmpty) {
      custom.remove(listKey);
    } else {
      custom[listKey] = remaining;
    }
    emit(
      LeaderChecklistState(
        checked: {...state.checked}..remove(keyFor(listKey, text)),
        custom: custom,
      ),
    );
  }

  /// Entfernt alle Haken (z. B. vor dem nächsten Wochenende); eigene Punkte
  /// bleiben erhalten.
  void reset() =>
      emit(LeaderChecklistState(checked: const {}, custom: state.custom));

  @override
  LeaderChecklistState? fromJson(Map<String, dynamic> json) {
    final list = json['checked'];
    if (list is! List) return null;
    final custom = <String, List<String>>{};
    final raw = json['custom'];
    if (raw is Map) {
      raw.forEach((k, v) {
        if (k is String && v is List) {
          custom[k] = v.whereType<String>().toList();
        }
      });
    }
    return LeaderChecklistState(
      checked: list.whereType<String>().toSet(),
      custom: custom,
    );
  }

  @override
  Map<String, dynamic>? toJson(LeaderChecklistState state) => {
    'checked': state.checked.toList()..sort(),
    'custom': state.custom,
  };
}
