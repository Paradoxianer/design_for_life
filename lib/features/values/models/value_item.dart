class ValueItem {
  final String name;
  final int rating; // 1: very important, 2: important, 3: not important
  final String? definition;

  const ValueItem({
    required this.name,
    this.rating = 3,
    this.definition,
  });

  ValueItem copyWith({
    String? name,
    int? rating,
    String? definition,
  }) {
    return ValueItem(
      name: name ?? this.name,
      rating: rating ?? this.rating,
      definition: definition ?? this.definition,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'rating': rating,
      'definition': definition,
    };
  }

  factory ValueItem.fromJson(Map<String, dynamic> json) {
    return ValueItem(
      name: json['name'] as String,
      rating: json['rating'] as int? ?? 3,
      definition: json['definition'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ValueItem &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          rating == other.rating &&
          definition == other.definition;

  @override
  int get hashCode => name.hashCode ^ rating.hashCode ^ definition.hashCode;
}
