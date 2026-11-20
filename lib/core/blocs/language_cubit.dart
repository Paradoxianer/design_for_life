import 'package:hydrated_bloc/hydrated_bloc.dart';

/// Vom Nutzer gewählte App-Sprache (Sprachcode wie "pl") oder `null` =
/// automatisch nach Gerätesprache. Lokal gespeichert wie die übrigen
/// Einstellungen.
class LanguageCubit extends HydratedCubit<String?> {
  LanguageCubit() : super(null);

  void select(String? code) => emit(code);

  @override
  String? fromJson(Map<String, dynamic> json) => json['code'] as String?;

  @override
  Map<String, dynamic>? toJson(String? state) => {'code': state};
}
