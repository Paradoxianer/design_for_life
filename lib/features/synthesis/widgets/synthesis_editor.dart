import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/blocs/entry_list_bloc.dart';
import '../../../core/widgets/dfl_module_editor.dart';
import '../../spiritual_gifts/bloc/spiritual_gifts_bloc.dart';
import '../../values/bloc/values_bloc.dart';
import '../../values/bloc/values_state.dart';
import '../../listening_prayer/bloc/listening_prayer_bloc.dart';
import '../../goals/bloc/goals_bloc.dart';

// ignore: avoid_positional_boolean_parameters
void _noOp(int i, String v) {}

/// The editor view of Synthesis: shows all Top-3 takeaways from every module
/// and lets the user reorder each list by drag & drop. The reordered state
/// lives locally — it is used immediately for sharing and does not need its
/// own BLoC because the source-of-truth data always lives in each module's BLoC.
class SynthesisEditor extends DflModuleEditor {
  final String giftsSessionId;
  final String prayerSessionId;
  final String goalsSessionId;

  const SynthesisEditor({
    super.key,
    required this.giftsSessionId,
    required this.prayerSessionId,
    required this.goalsSessionId,
  }) : super(takeaways: const [], onUpdate: _noOp, showTakeaways: false);

  @override
  Widget buildContent(BuildContext context) {
    return _SynthesisEditorBody(
      giftsSessionId: giftsSessionId,
      prayerSessionId: prayerSessionId,
      goalsSessionId: goalsSessionId,
    );
  }
}

class _SynthesisEditorBody extends StatefulWidget {
  final String giftsSessionId;
  final String prayerSessionId;
  final String goalsSessionId;

  const _SynthesisEditorBody({
    required this.giftsSessionId,
    required this.prayerSessionId,
    required this.goalsSessionId,
  });

  @override
  State<_SynthesisEditorBody> createState() => _SynthesisEditorBodyState();
}

class _SynthesisEditorBodyState extends State<_SynthesisEditorBody> {
  // Local ordering — starts from BLoC data, user can reorder freely
  Map<String, List<String>> _orderedLists = {};
  bool _initialized = false;

  void _initFromBlocs(BuildContext context) {
    if (_initialized) return;
    final giftsState = context.read<SpiritualGiftsBloc>().state;
    final valuesState = context.read<ValuesBloc>().state;
    final prayerState = context.read<ListeningPrayerBloc>().state;
    final goalsState = context.read<GoalsBloc>().state;

    _orderedLists = {
      'gifts': _extractGifts(giftsState, widget.giftsSessionId),
      'values': _extractValues(valuesState),
      'prayer': _extractPrayer(prayerState, widget.prayerSessionId),
      'goals': _extractGoals(goalsState, widget.goalsSessionId),
    };
    _initialized = true;
  }

  List<String> _extractGifts(SpiritualGiftsState s, String sessionId) {
    final t = s.takeaways[sessionId];
    if (t != null && t.any((x) => x.trim().isNotEmpty)) {
      return t.where((x) => x.trim().isNotEmpty).take(3).toList();
    }
    return s.getRankedGifts().take(3).map((g) => g.name).toList();
  }

  List<String> _extractValues(ValuesState s) =>
      s.topEightValues.take(3).map((v) => v.name).toList();

  List<String> _extractPrayer(EntryListState s, String sessionId) =>
      (s.takeaways[sessionId] ?? [])
          .where((x) => x.trim().isNotEmpty)
          .take(3)
          .toList();

  List<String> _extractGoals(GoalsState s, String sessionId) =>
      (s.takeaways[sessionId] ?? [])
          .where((x) => x.trim().isNotEmpty)
          .take(3)
          .toList();

  @override
  Widget build(BuildContext context) {
    _initFromBlocs(context);
    final theme = Theme.of(context);
    final hasAny = _orderedLists.values.any((l) => l.isNotEmpty);

    if (!hasAny) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome_outlined,
                size: 48, color: theme.colorScheme.outline),
            const SizedBox(height: 16),
            Text('Noch keine Ergebnisse vorhanden',
                style: theme.textTheme.titleMedium, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              'Schließe zuerst Gaben, Werte, Hörendes Gebet und Ziele ab.',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            'Reihenfolge per Drag & Drop anpassen',
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ),
        const SizedBox(height: 12),
        _SortableSection(
          icon: Icons.volunteer_activism_rounded,
          label: 'Geistliche Gaben',
          color: const Color(0xFF6B4C9A),
          items: _orderedLists['gifts'] ?? [],
          onReorder: (items) => setState(() => _orderedLists['gifts'] = items),
        ),
        const SizedBox(height: 16),
        _SortableSection(
          icon: Icons.diamond_outlined,
          label: 'Werte',
          color: const Color(0xFF2D5A27),
          items: _orderedLists['values'] ?? [],
          onReorder: (items) => setState(() => _orderedLists['values'] = items),
        ),
        const SizedBox(height: 16),
        _SortableSection(
          icon: Icons.hearing_rounded,
          label: 'Hörendes Gebet',
          color: const Color(0xFF1565C0),
          items: _orderedLists['prayer'] ?? [],
          onReorder: (items) => setState(() => _orderedLists['prayer'] = items),
        ),
        const SizedBox(height: 16),
        _SortableSection(
          icon: Icons.flag_rounded,
          label: 'Ziele',
          color: const Color(0xFF8B5E3C),
          items: _orderedLists['goals'] ?? [],
          onReorder: (items) => setState(() => _orderedLists['goals'] = items),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _SortableSection extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final List<String> items;
  final ValueChanged<List<String>> onReorder;

  const _SortableSection({
    required this.icon,
    required this.label,
    required this.color,
    required this.items,
    required this.onReorder,
  });

  @override
  State<_SortableSection> createState() => _SortableSectionState();
}

class _SortableSectionState extends State<_SortableSection> {
  late List<String> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.items);
  }

  @override
  void didUpdateWidget(_SortableSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      setState(() => _items = List.from(widget.items));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_items.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: theme.dividerColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(children: [
          Icon(widget.icon, size: 18, color: theme.colorScheme.outline),
          const SizedBox(width: 8),
          Text(widget.label,
              style: theme.textTheme.titleSmall
                  ?.copyWith(color: theme.colorScheme.outline)),
          const Spacer(),
          Text('noch nicht ausgefüllt',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.outline)),
        ]),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: widget.color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: widget.color.withOpacity(0.08),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
          ),
          child: Row(children: [
            Icon(widget.icon, color: widget.color, size: 18),
            const SizedBox(width: 8),
            Text(widget.label,
                style: theme.textTheme.titleSmall?.copyWith(color: widget.color)),
            const Spacer(),
            Icon(Icons.drag_indicator,
                size: 16, color: widget.color.withOpacity(0.5)),
          ]),
        ),
        // Reorderable list
        ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (newIndex > oldIndex) newIndex -= 1;
              final item = _items.removeAt(oldIndex);
              _items.insert(newIndex, item);
            });
            widget.onReorder(List.from(_items));
          },
          children: [
            for (int i = 0; i < _items.length; i++)
              ListTile(
                key: ValueKey('${widget.label}_$i'),
                dense: true,
                leading: CircleAvatar(
                  radius: 11,
                  backgroundColor: widget.color.withOpacity(0.12),
                  child: Text('${i + 1}',
                      style: TextStyle(
                          fontSize: 11,
                          color: widget.color,
                          fontWeight: FontWeight.w600)),
                ),
                title: Text(_items[i], style: theme.textTheme.bodyMedium),
                trailing: Icon(Icons.drag_handle,
                    size: 18, color: theme.colorScheme.outline),
              ),
          ],
        ),
      ]),
    );
  }
}
