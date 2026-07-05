import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'synthesis_event.dart';
part 'synthesis_state.dart';

class SynthesisBloc extends HydratedBloc<SynthesisEvent, SynthesisState> {
  SynthesisBloc() : super(const SynthesisState()) {
    on<InitializeSynthesis>(_onInitializeSynthesis);
    on<MoveSynthesisCard>(_onMoveSynthesisCard);
    on<SetSynthesisCardTag>(_onSetSynthesisCardTag);
    on<UpdateSynthesisTakeaway>(_onUpdateSynthesisTakeaway);
  }

  void _onInitializeSynthesis(
    InitializeSynthesis event,
    Emitter<SynthesisState> emit,
  ) {
    if (!state.initialized || event.force) {
      final seededColumns = <String, List<SynthesisCard>>{};
      final seededSource = <String, List<String>>{};
      var counter = 0;
      event.sourceTakeaways.forEach((columnKey, takeaways) {
        final trimmed = takeaways.map((t) => t.trim()).toList();
        seededSource[columnKey] = trimmed;
        seededColumns[columnKey] = trimmed
            .where((t) => t.isNotEmpty)
            .map((text) {
              counter += 1;
              return SynthesisCard(
                id: '${columnKey}_${DateTime.now().microsecondsSinceEpoch}_$counter',
                text: text,
                sourceModule: columnKey,
              );
            })
            .toList();
      });

      emit(state.copyWith(
        columns: seededColumns,
        seededSource: seededSource,
        initialized: true,
      ));
      return;
    }

    // Reconciliation pass: every subsequent visit re-reads the source modules'
    // takeaways and merges in anything new or edited, without touching cards
    // the user already moved, tagged or removed. See #52.
    final newColumns = state.copyColumns();
    final newSeededSource = state.seededSource.map(
      (k, v) => MapEntry(k, List<String>.from(v)),
    );
    var counter = 0;
    var changed = false;

    event.sourceTakeaways.forEach((columnKey, takeaways) {
      final trimmed = takeaways.map((t) => t.trim()).toList();
      final previous = newSeededSource[columnKey] ?? const <String>[];

      for (var i = 0; i < trimmed.length; i++) {
        final text = trimmed[i];
        final oldText = i < previous.length ? previous[i] : '';
        if (text == oldText) continue;
        changed = true;

        if (oldText.isEmpty) {
          if (text.isEmpty) continue;
          final cards = List<SynthesisCard>.from(newColumns[columnKey] ?? const []);
          counter += 1;
          cards.add(SynthesisCard(
            id: '${columnKey}_${DateTime.now().microsecondsSinceEpoch}_$counter',
            text: text,
            sourceModule: columnKey,
          ));
          newColumns[columnKey] = cards;
          continue;
        }

        // The slot previously held a value: find the matching card (it may
        // have been moved to another column by the user) and update or
        // remove it in place instead of appending a duplicate.
        final ownerKey = newColumns.keys.firstWhere(
          (key) => newColumns[key]!.any((c) => c.text == oldText),
          orElse: () => '',
        );

        if (ownerKey.isEmpty) {
          if (text.isEmpty) continue;
          final cards = List<SynthesisCard>.from(newColumns[columnKey] ?? const []);
          counter += 1;
          cards.add(SynthesisCard(
            id: '${columnKey}_${DateTime.now().microsecondsSinceEpoch}_$counter',
            text: text,
            sourceModule: columnKey,
          ));
          newColumns[columnKey] = cards;
          continue;
        }

        final cards = List<SynthesisCard>.from(newColumns[ownerKey]!);
        final idx = cards.indexWhere((c) => c.text == oldText);
        if (text.isEmpty) {
          cards.removeAt(idx);
        } else {
          cards[idx] = SynthesisCard(
            id: cards[idx].id,
            text: text,
            sourceModule: cards[idx].sourceModule,
            tag: cards[idx].tag,
          );
        }
        newColumns[ownerKey] = cards;
      }

      newSeededSource[columnKey] = trimmed;
    });

    if (!changed) return;

    emit(state.copyWith(columns: newColumns, seededSource: newSeededSource));
  }

  void _onMoveSynthesisCard(
    MoveSynthesisCard event,
    Emitter<SynthesisState> emit,
  ) {
    final newColumns = state.copyColumns();
    final fromCards = List<SynthesisCard>.from(newColumns[event.fromColumn] ?? const []);
    if (event.fromIndex < 0 || event.fromIndex >= fromCards.length) return;

    final card = fromCards.removeAt(event.fromIndex);
    newColumns[event.fromColumn] = fromCards;

    final toCards = List<SynthesisCard>.from(newColumns[event.toColumn] ?? const []);
    var targetIndex = event.toIndex;

    if (event.fromColumn == event.toColumn && event.fromIndex < targetIndex) {
      targetIndex -= 1;
    }
    targetIndex = targetIndex.clamp(0, toCards.length);

    toCards.insert(
      targetIndex,
      card.copyWith(sourceModule: event.toColumn),
    );
    newColumns[event.toColumn] = toCards;

    emit(state.copyWith(columns: newColumns));
  }

  void _onSetSynthesisCardTag(
    SetSynthesisCardTag event,
    Emitter<SynthesisState> emit,
  ) {
    final newColumns = state.copyColumns();
    for (final key in newColumns.keys) {
      final cards = List<SynthesisCard>.from(newColumns[key] ?? const []);
      final index = cards.indexWhere((c) => c.id == event.cardId);
      if (index != -1) {
        cards[index] = cards[index].copyWith(tag: event.tag);
        newColumns[key] = cards;
        emit(state.copyWith(columns: newColumns));
        return;
      }
    }
  }

  void _onUpdateSynthesisTakeaway(
    UpdateSynthesisTakeaway event,
    Emitter<SynthesisState> emit,
  ) {
    if (event.index < 0 || event.index >= state.takeaways.length) return;
    final takeaways = List<String>.from(state.takeaways);
    takeaways[event.index] = event.value;
    emit(state.copyWith(takeaways: takeaways));
  }

  @override
  SynthesisState? fromJson(Map<String, dynamic> json) => SynthesisState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(SynthesisState state) => state.toJson();
}
