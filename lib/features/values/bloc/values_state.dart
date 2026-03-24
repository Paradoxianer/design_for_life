import '../models/value_item.dart';

class ValuesState {
  final List<ValueItem> allValues;
  final String reflectionThoughts;
  final String nextLifePhaseDescription;
  final List<ValueItem> nextLifePhaseValues;

  const ValuesState({
    this.allValues = const [],
    this.reflectionThoughts = '',
    this.nextLifePhaseDescription = '',
    this.nextLifePhaseValues = const [],
  });

  List<ValueItem> get topEightValues =>
      allValues.where((v) => v.rating == 1).toList();

  bool get isValid => topEightValues.length == 8;

  /// A module is considered completed when at least 3 values are selected 
  /// AND the first 3 (Key Takeaways) have a personal definition.
  bool get isCompleted {
    final top8 = topEightValues;
    if (top8.length < 3) return false;
    
    // Check if the first 3 (Key Takeaways) have a definition
    for (int i = 0; i < 3; i++) {
      final definition = top8[i].definition;
      if (definition == null || definition.trim().isEmpty) {
        return false;
      }
    }
    return true;
  }

  ValuesState copyWith({
    List<ValueItem>? allValues,
    String? reflectionThoughts,
    String? nextLifePhaseDescription,
    List<ValueItem>? nextLifePhaseValues,
  }) {
    return ValuesState(
      allValues: allValues ?? this.allValues,
      reflectionThoughts: reflectionThoughts ?? this.reflectionThoughts,
      nextLifePhaseDescription: nextLifePhaseDescription ?? this.nextLifePhaseDescription,
      nextLifePhaseValues: nextLifePhaseValues ?? this.nextLifePhaseValues,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'allValues': allValues.map((v) => v.toJson()).toList(),
      'reflectionThoughts': reflectionThoughts,
      'nextLifePhaseDescription': nextLifePhaseDescription,
      'nextLifePhaseValues': nextLifePhaseValues.map((v) => v.toJson()).toList(),
    };
  }

  factory ValuesState.fromJson(Map<String, dynamic> json) {
    return ValuesState(
      allValues: (json['allValues'] as List<dynamic>?)
              ?.map((e) => ValueItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      reflectionThoughts: json['reflectionThoughts'] as String? ?? '',
      nextLifePhaseDescription: json['nextLifePhaseDescription'] as String? ?? '',
      nextLifePhaseValues: (json['nextLifePhaseValues'] as List<dynamic>?)
              ?.map((e) => ValueItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
