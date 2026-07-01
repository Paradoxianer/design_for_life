part of 'imagine_bloc.dart';

/// Holds selected abstract image ids for past and future, keyed by sessionId.
class ImagineState extends Equatable {
  final Map<String, String?> pastImageUrls;
  final Map<String, String?> futureImageUrls;

  const ImagineState({
    this.pastImageUrls = const {},
    this.futureImageUrls = const {},
  });

  String? pastImageUrl(String sessionId) => pastImageUrls[sessionId];
  String? futureImageUrl(String sessionId) => futureImageUrls[sessionId];

  bool isCompleted(String sessionId) =>
      pastImageUrls[sessionId] != null && futureImageUrls[sessionId] != null;

  @override
  List<Object?> get props => [pastImageUrls, futureImageUrls];

  ImagineState copyWith({
    Map<String, String?>? pastImageUrls,
    Map<String, String?>? futureImageUrls,
  }) =>
      ImagineState(
        pastImageUrls: pastImageUrls ?? this.pastImageUrls,
        futureImageUrls: futureImageUrls ?? this.futureImageUrls,
      );

  Map<String, dynamic> toJson() => {
        'pastImageUrls': pastImageUrls,
        'futureImageUrls': futureImageUrls,
      };

  factory ImagineState.fromJson(Map<String, dynamic> json) => ImagineState(
        pastImageUrls: (json['pastImageUrls'] as Map<String, dynamic>?)
                ?.map((k, v) => MapEntry(k, v as String?)) ??
            {},
        futureImageUrls: (json['futureImageUrls'] as Map<String, dynamic>?)
                ?.map((k, v) => MapEntry(k, v as String?)) ??
            {},
      );
}
