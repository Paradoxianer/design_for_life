import 'package:equatable/equatable.dart';

class FeedbackResponse extends Equatable {
  // 1. Inhalt des Seminars (1-6)
  final int contentExpectations;
  final int contentPracticalUtility;
  final int contentStructure;

  // 2. Referent & Durchführung (1-6)
  final int speakerGodWorking;
  final int speakerFaithProgress;
  final int speakerDidactics;
  final int speakerMethods;
  final int speakerInvolvement;
  final int speakerRespect;
  final int atmosphere;

  // 3. Seminarunterlagen (1-6)
  final int docsStructure;
  final int docsUnderstandability;
  final int docsDifficulty;

  // 4. Organisation & Räume (1-6)
  final int roomsAppropriateness;
  final int prepQuality;
  final int duration;
  final int tempo;
  final int catering;

  // 5. Kommentare
  final String commentsMissing;
  final String recommendation;
  final String generalNotes;

  const FeedbackResponse({
    this.contentExpectations = 0,
    this.contentPracticalUtility = 0,
    this.contentStructure = 0,
    this.speakerGodWorking = 0,
    this.speakerFaithProgress = 0,
    this.speakerDidactics = 0,
    this.speakerMethods = 0,
    this.speakerInvolvement = 0,
    this.speakerRespect = 0,
    this.atmosphere = 0,
    this.docsStructure = 0,
    this.docsUnderstandability = 0,
    this.docsDifficulty = 0,
    this.roomsAppropriateness = 0,
    this.prepQuality = 0,
    this.duration = 0,
    this.tempo = 0,
    this.catering = 0,
    this.commentsMissing = '',
    this.recommendation = '',
    this.generalNotes = '',
  });

  FeedbackResponse copyWith({
    int? contentExpectations,
    int? contentPracticalUtility,
    int? contentStructure,
    int? speakerGodWorking,
    int? speakerFaithProgress,
    int? speakerDidactics,
    int? speakerMethods,
    int? speakerInvolvement,
    int? speakerRespect,
    int? atmosphere,
    int? docsStructure,
    int? docsUnderstandability,
    int? docsDifficulty,
    int? roomsAppropriateness,
    int? prepQuality,
    int? duration,
    int? tempo,
    int? catering,
    String? commentsMissing,
    String? recommendation,
    String? generalNotes,
  }) {
    return FeedbackResponse(
      contentExpectations: contentExpectations ?? this.contentExpectations,
      contentPracticalUtility: contentPracticalUtility ?? this.contentPracticalUtility,
      contentStructure: contentStructure ?? this.contentStructure,
      speakerGodWorking: speakerGodWorking ?? this.speakerGodWorking,
      speakerFaithProgress: speakerFaithProgress ?? this.speakerFaithProgress,
      speakerDidactics: speakerDidactics ?? this.speakerDidactics,
      speakerMethods: speakerMethods ?? this.speakerMethods,
      speakerInvolvement: speakerInvolvement ?? this.speakerInvolvement,
      speakerRespect: speakerRespect ?? this.speakerRespect,
      atmosphere: atmosphere ?? this.atmosphere,
      docsStructure: docsStructure ?? this.docsStructure,
      docsUnderstandability: docsUnderstandability ?? this.docsUnderstandability,
      docsDifficulty: docsDifficulty ?? this.docsDifficulty,
      roomsAppropriateness: roomsAppropriateness ?? this.roomsAppropriateness,
      prepQuality: prepQuality ?? this.prepQuality,
      duration: duration ?? this.duration,
      tempo: tempo ?? this.tempo,
      catering: catering ?? this.catering,
      commentsMissing: commentsMissing ?? this.commentsMissing,
      recommendation: recommendation ?? this.recommendation,
      generalNotes: generalNotes ?? this.generalNotes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contentExpectations': contentExpectations,
      'contentPracticalUtility': contentPracticalUtility,
      'contentStructure': contentStructure,
      'speakerGodWorking': speakerGodWorking,
      'speakerFaithProgress': speakerFaithProgress,
      'speakerDidactics': speakerDidactics,
      'speakerMethods': speakerMethods,
      'speakerInvolvement': speakerInvolvement,
      'speakerRespect': speakerRespect,
      'atmosphere': atmosphere,
      'docsStructure': docsStructure,
      'docsUnderstandability': docsUnderstandability,
      'docsDifficulty': docsDifficulty,
      'roomsAppropriateness': roomsAppropriateness,
      'prepQuality': prepQuality,
      'duration': duration,
      'tempo': tempo,
      'catering': catering,
      'commentsMissing': commentsMissing,
      'recommendation': recommendation,
      'generalNotes': generalNotes,
    };
  }

  factory FeedbackResponse.fromJson(Map<String, dynamic> json) {
    return FeedbackResponse(
      contentExpectations: json['contentExpectations'] ?? 0,
      contentPracticalUtility: json['contentPracticalUtility'] ?? 0,
      contentStructure: json['contentStructure'] ?? 0,
      speakerGodWorking: json['speakerGodWorking'] ?? 0,
      speakerFaithProgress: json['speakerFaithProgress'] ?? 0,
      speakerDidactics: json['speakerDidactics'] ?? 0,
      speakerMethods: json['speakerMethods'] ?? 0,
      speakerInvolvement: json['speakerInvolvement'] ?? 0,
      speakerRespect: json['speakerRespect'] ?? 0,
      atmosphere: json['atmosphere'] ?? 0,
      docsStructure: json['docsStructure'] ?? 0,
      docsUnderstandability: json['docsUnderstandability'] ?? 0,
      docsDifficulty: json['docsDifficulty'] ?? 0,
      roomsAppropriateness: json['roomsAppropriateness'] ?? 0,
      prepQuality: json['prepQuality'] ?? 0,
      duration: json['duration'] ?? 0,
      tempo: json['tempo'] ?? 0,
      catering: json['catering'] ?? 0,
      commentsMissing: json['commentsMissing'] ?? '',
      recommendation: json['recommendation'] ?? '',
      generalNotes: json['generalNotes'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
    contentExpectations, contentPracticalUtility, contentStructure,
    speakerGodWorking, speakerFaithProgress, speakerDidactics,
    speakerMethods, speakerInvolvement, speakerRespect, atmosphere,
    docsStructure, docsUnderstandability, docsDifficulty,
    roomsAppropriateness, prepQuality, duration, tempo, catering,
    commentsMissing, recommendation, generalNotes,
  ];
}
