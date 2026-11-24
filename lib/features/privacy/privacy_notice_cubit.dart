import 'package:hydrated_bloc/hydrated_bloc.dart';

/// Merkt sich, ob der Willkommens-Hinweis zu Datenschutz und lokaler
/// Speicherung auf diesem Gerät schon bestätigt wurde. Es ist eine
/// Kenntnisnahme, keine Einwilligung – die App braucht keine, da sie weder
/// trackt noch Daten an Dritte sendet. „Alle Daten löschen“ setzt auch das
/// zurück, der Hinweis erscheint dann wieder.
class PrivacyNoticeCubit extends HydratedCubit<bool> {
  /// [acknowledged] ist nur der Startwert, wenn nichts gespeichert ist
  /// (Tests setzen ihn auf true, damit der Hinweis nicht die App überdeckt).
  PrivacyNoticeCubit({bool acknowledged = false}) : super(acknowledged);

  void acknowledge() => emit(true);

  @override
  bool fromJson(Map<String, dynamic> json) => json['acknowledged'] == true;

  @override
  Map<String, dynamic>? toJson(bool state) => {'acknowledged': state};
}
