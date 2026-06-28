part of 'imagine_bloc.dart';

/// Holds two selected Pixabay image URLs — one for "past", one for "future" —
/// plus a single reflection takeaway, all keyed by sessionId.
class ImagineState extends Equatable {
  final Map<String, String?> pastImageUrls;
  final Map<String, String?> futureImageUrls;
  final Map<String, String> takeaways;

  const ImagineState({
    this.pastImageUrls = const {},
    this.futureImageUrls = const {},
    this.takeaways = const {},
  });

  String? pastImageUrl(String sessionId) => pastImageUrls[sessionId];
  String? futureImageUrl(String sessionId) => futureImageUrls[sessionId];
  String takeaway(String sessionId) => takeaways[sessionId] ?? '';

  bool isCompleted(String sessionId) =>
      pastImageUrls[sessionId] != null && futureImageUrls[sessionId] != null;

  @override
  List<Object?> get props => [pastImageUrls, futureImageUrls, takeaways];

  ImagineState copyWith({
    Map<String, String?>? pastImageUrls,
    Map<String, String?>? futureImageUrls,
    Map<String, String>? takeaways,
  }) =>
      ImagineState(
        pastImageUrls: pastImageUrls ?? this.pastImageUrls,
        futureImageUrls: futureImageUrls ?? this.futureImageUrls,
        takeaways: takeaways ?? this.takeaways,
      );

  Map<String, dynamic> toJson() => {
        'pastImageUrls': pastImageUrls,
        'futureImageUrls': futureImageUrls,
        'takeaways': takeaways,
      };

  factory ImagineState.fromJson(Map<String, dynamic> json) => ImagineState(
        pastImageUrls: (json['pastImageUrls'] as Map<String, dynamic>?)
                ?.map((k, v) => MapEntry(k, v as String?)) ??
            {},
        futureImageUrls: (json['futureImageUrls'] as Map<String, dynamic>?)
                ?.map((k, v) => MapEntry(k, v as String?)) ??
            {},
        takeaways: (json['takeaways'] as Map<String, dynamic>?)
                ?.map((k, v) => MapEntry(k, v as String)) ??
            {},
      );
}
