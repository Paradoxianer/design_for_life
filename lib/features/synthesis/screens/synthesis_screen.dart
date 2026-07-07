import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../../../core/models/shareable_content.dart';
import '../../../core/services/share_service.dart';
import '../../../core/widgets/dfl_module_scaffold.dart';
import '../../goals/bloc/goals_bloc.dart';
import '../../life_tree/bloc/life_tree_bloc.dart';
import '../../listening_prayer/bloc/listening_prayer_bloc.dart';
import '../../personal_style/bloc/personal_style_bloc.dart';
import '../../spiritual_gifts/bloc/spiritual_gifts_bloc.dart';
import '../../values/bloc/values_bloc.dart';
import '../bloc/synthesis_bloc.dart';
import '../widgets/synthesis_editor.dart';
import '../widgets/synthesis_result.dart';

class SynthesisScreen extends StatefulWidget {
  final String giftsSessionId;
  final String prayerSessionId;
  final String goalsSessionId;
  final String lifeTreeSessionId;
  final String personalStyleSessionId;
  final String title;
  final bool initialEditMode;

  const SynthesisScreen({
    super.key,
    required this.giftsSessionId,
    required this.prayerSessionId,
    required this.goalsSessionId,
    required this.lifeTreeSessionId,
    required this.personalStyleSessionId,
    required this.title,
    this.initialEditMode = true,
  });

  @override
  State<SynthesisScreen> createState() => _SynthesisScreenState();
}

class _SynthesisScreenState extends State<SynthesisScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;

    final giftsState = context.read<SpiritualGiftsBloc>().state;
    final valuesState = context.read<ValuesBloc>().state;
    final prayerState = context.read<ListeningPrayerBloc>().state;
    final goalsState = context.read<GoalsBloc>().state;
    final lifeTreeState = context.read<LifeTreeBloc>().state;
    final personalStyleState = context.read<PersonalStyleBloc>().state;

    final source = <String, List<String>>{
      'gifts': _extractGifts(giftsState),
      'values': valuesState.topEightValues.take(3).map((v) => v.name).toList(),
      'prayer': (prayerState.takeaways[widget.prayerSessionId] ?? const <String>[])
          .where((x) => x.trim().isNotEmpty)
          .take(3)
          .toList(),
      'goals': (goalsState.takeaways[widget.goalsSessionId] ?? const <String>[])
          .where((x) => x.trim().isNotEmpty)
          .take(3)
          .toList(),
      'lifeTree': (lifeTreeState.takeaways[widget.lifeTreeSessionId] ?? const <String>[])
          .where((x) => x.trim().isNotEmpty)
          .take(3)
          .toList(),
      // Erster Slot enthält bereits automatisch den Profil-Titel (Quadrant),
      // sobald der Fragebogen abgeschlossen ist (siehe PersonalStyleBloc).
      'personalStyle': (personalStyleState.takeaways[widget.personalStyleSessionId] ?? const <String>[])
          .where((x) => x.trim().isNotEmpty)
          .take(3)
          .toList(),
    };

    context.read<SynthesisBloc>().add(InitializeSynthesis(sourceTakeaways: source));
    _initialized = true;
  }

  List<String> _extractGifts(SpiritualGiftsState s) {
    final t = s.takeaways[widget.giftsSessionId];
    if (t != null && t.any((x) => x.trim().isNotEmpty)) {
      return t.where((x) => x.trim().isNotEmpty).take(3).toList();
    }
    return s.getRankedGifts().take(3).map((g) => g.name).toList();
  }

  ShareableContent _buildShareContent(BuildContext context, SynthesisState state) {
    final l10n = AppLocalizations.of(context);
    final items = <ShareableItem>[];
    final labels = {
      'gifts': l10n.connectionsColGifts,
      'values': l10n.connectionsColValues,
      'prayer': l10n.connectionsColPrayer,
      'goals': l10n.connectionsColGoals,
      'lifeTree': l10n.connectionsColLifeTree,
      'personalStyle': l10n.connectionsColPersonalStyle,
    };
    final tagIcons = {
      'red': '🔴',
      'blue': '🔵',
      'green': '🟢',
      'gold': '🟡',
      'none': '⚪',
    };

    for (final entry in state.columns.entries) {
      final section = labels[entry.key] ?? entry.key;
      for (int i = 0; i < entry.value.length; i++) {
        final card = entry.value[i];
        final tag = tagIcons[card.tag] ?? '⚪';
        items.add(
          ShareableItem(
            id: 'takeaway_connection_${entry.key}_$i',
            label: '$section ${i + 1}',
            textValue: '$tag ${card.text}',
          ),
        );
      }
    }

    for (int i = 0; i < state.takeaways.length; i++) {
      final text = state.takeaways[i].trim();
      if (text.isEmpty) continue;
      items.add(
        ShareableItem(
          id: 'takeaway_connection_summary_$i',
          label: l10n.connectionsSummaryItem(i + 1),
          textValue: text,
        ),
      );
    }

    // Bild-Karte des Verknüpfungs-Boards, gruppiert nach Spalte - bisher wurde
    // hier gar kein Bild geteilt, nur Text.
    final boardEntries = <Map<String, String>>[];
    for (final columnEntry in state.columns.entries) {
      if (columnEntry.value.isEmpty) continue;
      final section = labels[columnEntry.key] ?? columnEntry.key;
      final body = columnEntry.value
          .map((card) => '${tagIcons[card.tag] ?? '⚪'} ${card.text}')
          .join('\n');
      boardEntries.add({'title': section, 'body': body});
    }
    final summaryText = state.takeaways.where((t) => t.trim().isNotEmpty).join('\n');
    if (summaryText.isNotEmpty) {
      boardEntries.add({'title': l10n.keyTakeaways, 'body': summaryText});
    }
    if (boardEntries.isNotEmpty) {
      items.add(ShareableItem(
        id: 'connections_card',
        label: l10n.connectionsShareCardLabel,
        data: {'type': 'text_card', 'entries': boardEntries},
      ));
    }

    return ShareableContent(
      title: widget.title,
      items: items,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SynthesisBloc, SynthesisState>(
      builder: (context, state) {
        final shareContent = _buildShareContent(context, state);
        return DflModuleScaffold(
          title: widget.title,
          initialEditMode: widget.initialEditMode,
          shareableContent: shareContent.items.isNotEmpty ? shareContent : null,
          onShare: (selectedItems) => ShareService.shareContent(
            context: context,
            content: shareContent,
            selectedItems: selectedItems,
          ),
          editor: const SynthesisEditor(),
          result: SynthesisResult(state: state),
        );
      },
    );
  }
}
