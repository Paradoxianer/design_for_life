part of 'imagine_bloc.dart';

/// Holds selected abstract image ids and takeaways for past and future,
/// keyed by sessionId.
class ImagineState extends Equatable {
  final Map<String, String?> pastImageIds;
  final Map<String, String?> futureImageIds;
  final Map<String, List<String>> takeaways;

  const ImagineState({
    this.pastImageIds = const {},
    this.futureImageIds = const {},
    this.takeaways = const {},
  });

  String? pastImageId(String sessionId) => pastImageIds[sessionId];
  String? futureImageId(String sessionId) => futureImageIds[sessionId];
  List<String> sessionTakeaways(String sessionId) =>
      takeaways[sessionId] ?? const ['', '', ''];

  bool isCompleted(String sessionId) =>
      pastImageIds[sessionId] != null && futureImageIds[sessionId] != null;

  @override
  List<Object?> get props => [pastImageIds, futureImageIds, takeaways];

  ImagineState copyWith({
    Map<String, String?>? pastImageIds,
    Map<String, String?>? futureImageIds,
    Map<String, List<String>>? takeaways,
  }) =>
      ImagineState(
        pastImageIds: pastImageIds ?? this.pastImageIds,
        futureImageIds: futureImageIds ?? this.futureImageIds,
        takeaways: takeaways ?? this.takeaways,
      );

  Map<String, dynamic> toJson() => {
        // Keep json keys stable for backwards compatibility.
        'pastImageUrls': pastImageIds,
        'futureImageUrls': futureImageIds,
        'takeaways': takeaways,
      };

  factory ImagineState.fromJson(Map<String, dynamic> json) => ImagineState(
        pastImageIds: (json['pastImageUrls'] as Map<String, dynamic>?)
                ?.map((k, v) => MapEntry(k, v as String?)) ??
            {},
        futureImageIds: (json['futureImageUrls'] as Map<String, dynamic>?)
                ?.map((k, v) => MapEntry(k, v as String?)) ??
            {},
        takeaways: (json['takeaways'] as Map<String, dynamic>?)?.map(
              (k, v) => MapEntry(
                k,
                (v as List<dynamic>).cast<String>(),
              ),
            ) ??
            {},
      );
}
