part of 'imagine_bloc.dart';

/// Holds selected abstract image ids for past and future, keyed by sessionId.
class ImagineState extends Equatable {
  final Map<String, String?> pastImageIds;
  final Map<String, String?> futureImageIds;

  const ImagineState({
    this.pastImageIds = const {},
    this.futureImageIds = const {},
  });

  String? pastImageId(String sessionId) => pastImageIds[sessionId];
  String? futureImageId(String sessionId) => futureImageIds[sessionId];

  bool isCompleted(String sessionId) =>
      pastImageIds[sessionId] != null && futureImageIds[sessionId] != null;

  @override
  List<Object?> get props => [pastImageIds, futureImageIds];

  ImagineState copyWith({
    Map<String, String?>? pastImageIds,
    Map<String, String?>? futureImageIds,
  }) =>
      ImagineState(
        pastImageIds: pastImageIds ?? this.pastImageIds,
        futureImageIds: futureImageIds ?? this.futureImageIds,
      );

  Map<String, dynamic> toJson() => {
        // Keep json keys stable for backwards compatibility.
        'pastImageUrls': pastImageIds,
        'futureImageUrls': futureImageIds,
      };

  factory ImagineState.fromJson(Map<String, dynamic> json) => ImagineState(
        pastImageIds: (json['pastImageUrls'] as Map<String, dynamic>?)
                ?.map((k, v) => MapEntry(k, v as String?)) ??
            {},
        futureImageIds: (json['futureImageUrls'] as Map<String, dynamic>?)
                ?.map((k, v) => MapEntry(k, v as String?)) ??
            {},
      );
}
