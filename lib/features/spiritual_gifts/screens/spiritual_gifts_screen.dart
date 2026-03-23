import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/dfl_module_scaffold.dart';
import '../../../core/models/shareable_content.dart';
import '../../../core/services/share_service.dart';
import '../bloc/spiritual_gifts_bloc.dart';
import '../widgets/spiritual_gifts_editor.dart';
import '../widgets/spiritual_gifts_result.dart';

class SpiritualGiftsScreen extends StatelessWidget {
  final String sessionId;
  final String title;
  final bool initialEditMode;

  const SpiritualGiftsScreen({
    super.key,
    required this.sessionId,
    required this.title,
    this.initialEditMode = true,
  });

  ShareableContent _getShareableContent(SpiritualGiftsState state) {
    final rankedGifts = state.getRankedGifts();
    final topThree = rankedGifts.take(3).toList();
    final takeaways = state.takeaways[sessionId] ?? [];

    final List<ShareableItem> items = [];

    // Top 3 Gifts
    for (int i = 0; i < topThree.length; i++) {
      items.add(ShareableItem(
        id: 'gift_${topThree[i].id}',
        label: 'Gabe ${i + 1}: ${topThree[i].name}',
        textValue: topThree[i].description,
      ));
    }

    // Key Takeaways (Highlights)
    for (int i = 0; i < takeaways.length; i++) {
      if (takeaways[i].trim().isNotEmpty) {
        items.add(ShareableItem(
          id: 'gift_takeaway_$i',
          label: 'Highlight ${i + 1}',
          textValue: takeaways[i],
        ));
      }
    }

    return ShareableContent(
      title: 'Geistliche Gaben',
      items: items,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpiritualGiftsBloc, SpiritualGiftsState>(
      builder: (context, state) {
        final shareContent = _getShareableContent(state);

        return DflModuleScaffold(
          title: title,
          initialEditMode: initialEditMode,
          shareableContent: shareContent.items.isNotEmpty ? shareContent : null,
          onShare: (selectedItems) {
            ShareService.shareContent(
              content: shareContent,
              selectedItems: selectedItems,
            );
          },
          onWillToggleMode: () async {
            return await _validateCompletion(context, state);
          },
          editor: SpiritualGiftsEditor(sessionId: sessionId),
          result: const SpiritualGiftsResult(),
        );
      },
    );
  }

  Future<bool> _validateCompletion(BuildContext context, SpiritualGiftsState state) async {
    final totalQuestions = state.questionOrder.length;
    final answeredQuestions = state.answers.length;

    if (answeredQuestions < totalQuestions) {
      final bool? result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Test unvollständig'),
          content: Text(
            'Du hast erst $answeredQuestions von $totalQuestions Fragen beantwortet. '
            'Möchtest du den Test wirklich abschließen?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Weiter ausfüllen'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Trotzdem beenden'),
            ),
          ],
        ),
      );
      return result ?? false;
    }
    return true;
  }
}
