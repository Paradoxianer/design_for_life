import 'package:equatable/equatable.dart';

class Goal extends Equatable {
  final String text;
  final bool isSpecific;
  final bool isMeasurable;
  final bool isAchievable;
  final bool isRelevant;
  final bool isTimeBound;

  const Goal({
    this.text = '',
    this.isSpecific = false,
    this.isMeasurable = false,
    this.isAchievable = false,
    this.isRelevant = false,
    this.isTimeBound = false,
  });

  Goal copyWith({
    String? text,
    bool? isSpecific,
    bool? isMeasurable,
    bool? isAchievable,
    bool? isRelevant,
    bool? isTimeBound,
  }) {
    return Goal(
      text: text ?? this.text,
      isSpecific: isSpecific ?? this.isSpecific,
      isMeasurable: isMeasurable ?? this.isMeasurable,
      isAchievable: isAchievable ?? this.isAchievable,
      isRelevant: isRelevant ?? this.isRelevant,
      isTimeBound: isTimeBound ?? this.isTimeBound,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isSpecific': isSpecific,
      'isMeasurable': isMeasurable,
      'isAchievable': isAchievable,
      'isRelevant': isRelevant,
      'isTimeBound': isTimeBound,
    };
  }

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      text: json['text'] as String? ?? '',
      isSpecific: json['isSpecific'] as bool? ?? false,
      isMeasurable: json['isMeasurable'] as bool? ?? false,
      isAchievable: json['isAchievable'] as bool? ?? false,
      isRelevant: json['isRelevant'] as bool? ?? false,
      isTimeBound: json['isTimeBound'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [
        text,
        isSpecific,
        isMeasurable,
        isAchievable,
        isRelevant,
        isTimeBound,
      ];
}
