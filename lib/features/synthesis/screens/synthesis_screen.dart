import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/dfl_module_scaffold.dart';
import '../../../core/models/shareable_content.dart';
import '../../../core/services/share_service.dart';
import '../../spiritual_gifts/bloc/spiritual_gifts_bloc.dart';
import '../../values/bloc/values_bloc.dart';
import '../../listening_prayer/bloc/listening_prayer_bloc.dart';
import '../../goals/bloc/goals_bloc.dart';
import '../widgets/synthesis_editor.dart';
import '../widgets/synthesis_result.dart';

/// Synthesis aggregates Top-3 takeaways from every other module into a
/// reorderable matrix. It has no own BLoC — it reads live from each module's
/// BLoC, so it is always up to date. The user can reorder each section in the
/// editor; the sorted order is what gets shared.
class SynthesisScreen extends StatefulWidget {
  final String giftsSessionId;
  final String prayerSessionId;
  final String goalsSessionId;
  final String title;
  final bool initialEditMode;

  const SynthesisScreen({
    super.key,
    required this.giftsSessionId,
    required this.prayerSessionId,
    required this.goalsSessionId,
    required this.title,
    this.initialEditMode = true,
  });

  @override
  State<SynthesisScreen> createState() => _SynthesisScreenState();
}

class _SynthesisScreenState extends State<SynthesisScreen> {
  // The current ordering — updated by the editor on every reorder gesture
  Map<String, List<String>> _orderedLists = {};

  void _onOrderChanged(Map<String, List<String>> updated) {
    setState(() => _orderedLists = updated);
  }

  ShareableContent _buildShareContent() {
    final items = <ShareableItem>[];
    const sections = [
      ('gifts', 'Gabe'),
      ('values', 'Wert'),
      ('prayer', 'Gebet-Eindruck'),
      ('goals', 'Ziel'),
    ];
    for (final (key, label) in sections) {
      final list = _orderedLists[key] ?? [];
      for (int i = 0; i < list.length; i++) {
        items.add(ShareableItem(
          id: '${key}_$i',
          label: '$label ${i + 1}',
          textValue: list[i],
        ));
      }
    }
    return ShareableContent(title: 'Mein Lebensprofil', items: items);
  }

  @override
  Widget build(BuildContext context) {
    // Initialise _orderedLists from the BLoCs on first build
    if (_orderedLists.isEmpty) {
      final giftsState = context.read<SpiritualGiftsBloc>().state;
      final valuesState = context.read<ValuesBloc>().state;
      final prayerState = context.read<ListeningPrayerBloc>().state;
      final goalsState = context.read<GoalsBloc>().state;

      _orderedLists = {
        'gifts': _extractGifts(giftsState),
        'values': valuesState.topEightValues.take(3).map((v) => v.name).toList(),
        'prayer': (prayerState.takeaways[widget.prayerSessionId] ?? [])
            .where((x) => x.trim().isNotEmpty).take(3).toList(),
        'goals': (goalsState.takeaways[widget.goalsSessionId] ?? [])
            .where((x) => x.trim().isNotEmpty).take(3).toList(),
      };
    }

    final shareContent = _buildShareContent();

    return DflModuleScaffold(
      title: widget.title,
      initialEditMode: widget.initialEditMode,
      shareableContent: shareContent.items.isNotEmpty ? shareContent : null,
      onShare: (selectedItems) => ShareService.shareContent(
        context: context,
        content: shareContent,
        selectedItems: selectedItems,
      ),
      editor: _OrderedSynthesisEditor(
        giftsSessionId: widget.giftsSessionId,
        prayerSessionId: widget.prayerSessionId,
        goalsSessionId: widget.goalsSessionId,
        onOrderChanged: _onOrderChanged,
      ),
      result: SynthesisResult(orderedLists: _orderedLists),
    );
  }

  List<String> _extractGifts(SpiritualGiftsState s) {
    final t = s.takeaways[widget.giftsSessionId];
    if (t != null && t.any((x) => x.trim().isNotEmpty)) {
      return t.where((x) => x.trim().isNotEmpty).take(3).toList();
    }
    return s.getRankedGifts().take(3).map((g) => g.name).toList();
  }
}

/// Thin wrapper that exposes reorder callbacks from SynthesisEditor up to the Screen.
class _OrderedSynthesisEditor extends SynthesisEditor {
  final ValueChanged<Map<String, List<String>>> onOrderChanged;

  const _OrderedSynthesisEditor({
    required super.giftsSessionId,
    required super.prayerSessionId,
    required super.goalsSessionId,
    required this.onOrderChanged,
  });
}
