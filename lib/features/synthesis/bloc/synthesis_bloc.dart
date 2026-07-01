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
    // Skip re-initialization only when the board already has cards the user may
    // have rearranged.  If initialized but empty (first visit had no data),
    // always try again so newly filled modules appear.
    if (state.initialized && state.hasAnyCards && !event.force) return;

    final seededColumns = <String, List<SynthesisCard>>{};
    var counter = 0;
    event.sourceTakeaways.forEach((columnKey, takeaways) {
      seededColumns[columnKey] = takeaways
          .where((t) => t.trim().isNotEmpty)
          .map((text) {
            counter += 1;
            return SynthesisCard(
              id: '${columnKey}_${DateTime.now().microsecondsSinceEpoch}_$counter',
              text: text.trim(),
              sourceModule: columnKey,
            );
          })
          .toList();
    });

    emit(state.copyWith(
      columns: seededColumns,
      initialized: true,
    ));
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
