part of 'synthesis_bloc.dart';

class SynthesisCard extends Equatable {
  final String id;
  final String text;
  final String sourceModule;
  final String tag;

  const SynthesisCard({
    required this.id,
    required this.text,
    required this.sourceModule,
    this.tag = 'none',
  });

  SynthesisCard copyWith({
    String? sourceModule,
    String? tag,
  }) {
    return SynthesisCard(
      id: id,
      text: text,
      sourceModule: sourceModule ?? this.sourceModule,
      tag: tag ?? this.tag,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'sourceModule': sourceModule,
      'tag': tag,
    };
  }

  factory SynthesisCard.fromJson(Map<String, dynamic> json) {
    return SynthesisCard(
      id: json['id'] as String? ?? '',
      text: json['text'] as String? ?? '',
      sourceModule: json['sourceModule'] as String? ?? '',
      tag: json['tag'] as String? ?? 'none',
    );
  }

  @override
  List<Object?> get props => [id, text, sourceModule, tag];
}

class SynthesisState extends Equatable {
  final Map<String, List<SynthesisCard>> columns;
  final List<String> takeaways;
  final bool initialized;

  const SynthesisState({
    this.columns = const {},
    this.takeaways = const ['', '', ''],
    this.initialized = false,
  });

  bool get hasAnyCards => columns.values.any((cards) => cards.isNotEmpty);

  bool get isCompleted => hasAnyCards;

  Map<String, List<SynthesisCard>> copyColumns() =>
      columns.map((k, v) => MapEntry(k, List<SynthesisCard>.from(v)));

  SynthesisState copyWith({
    Map<String, List<SynthesisCard>>? columns,
    List<String>? takeaways,
    bool? initialized,
  }) {
    return SynthesisState(
      columns: columns ?? this.columns,
      takeaways: takeaways ?? this.takeaways,
      initialized: initialized ?? this.initialized,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'columns': columns.map(
        (key, value) => MapEntry(
          key,
          value.map((card) => card.toJson()).toList(),
        ),
      ),
      'takeaways': takeaways,
      'initialized': initialized,
    };
  }

  factory SynthesisState.fromJson(Map<String, dynamic> json) {
    final takeaways = List<String>.from(json['takeaways'] as List? ?? const ['', '', '']);
    while (takeaways.length < 3) {
      takeaways.add('');
    }
    return SynthesisState(
      columns: (json['columns'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(
              k,
              (v as List)
                  .map((e) => SynthesisCard.fromJson(e as Map<String, dynamic>))
                  .toList(),
            ),
          ) ??
          const {},
      takeaways: takeaways.take(3).toList(),
      initialized: json['initialized'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [columns, takeaways, initialized];
}
