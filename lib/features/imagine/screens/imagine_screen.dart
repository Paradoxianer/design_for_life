import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../../../core/widgets/dfl_module_scaffold.dart';
import '../../../core/models/shareable_content.dart';
import '../../../core/services/share_service.dart';
import '../bloc/imagine_bloc.dart';
import '../widgets/imagine_editor.dart';
import '../widgets/imagine_result.dart';

class ImagineScreen extends StatelessWidget {
  final String sessionId;
  final String title;
  final bool initialEditMode;

  const ImagineScreen({
    super.key,
    required this.sessionId,
    required this.title,
    this.initialEditMode = true,
  });

  ShareableContent _buildShareContent(BuildContext context, ImagineState state) {
    final l10n = AppLocalizations.of(context);
    final takeaways = state.sessionTakeaways(sessionId);
    final takeawayText = takeaways.where((t) => t.isNotEmpty).join(' | ');
    return ShareableContent(
      title: l10n.timelineImagineTitle,
      items: [
        if (state.pastImageId(sessionId) != null)
          ShareableItem(
            id: 'past_image',
            label: l10n.imagineLabelPast,
            textValue: state.pastImageId(sessionId)!,
            data: {
              'type': 'imagine_option',
              'phase': l10n.imagineLabelPast,
              'optionId': state.pastImageId(sessionId),
            },
          ),
        if (state.futureImageId(sessionId) != null)
          ShareableItem(
            id: 'future_image',
            label: l10n.imagineLabelFuture,
            textValue: state.futureImageId(sessionId)!,
            data: {
              'type': 'imagine_option',
              'phase': l10n.imagineLabelFuture,
              'optionId': state.futureImageId(sessionId),
            },
          ),
        if (state.pastImageId(sessionId) != null && state.futureImageId(sessionId) != null)
          ShareableItem(
            id: 'combined_image',
            label: l10n.imagineLabelCombined,
            isSelected: false,
            data: {
              'type': 'imagine_composed',
              'pastOptionId': state.pastImageId(sessionId),
              'futureOptionId': state.futureImageId(sessionId),
              'pastLabel': l10n.imagineLabelPast,
              'futureLabel': l10n.imagineLabelFuture,
            },
          ),
        if (takeawayText.isNotEmpty)
          ShareableItem(
            id: 'takeaways',
            label: l10n.keyTakeaways,
            textValue: takeawayText,
            data: {'type': 'takeaways', 'value': takeawayText},
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImagineBloc, ImagineState>(
      builder: (context, state) {
        final shareContent = _buildShareContent(context, state);
        final takeaways = state.sessionTakeaways(sessionId);
        return DflModuleScaffold(
          title: title,
          initialEditMode: initialEditMode,
          shareableContent: shareContent.items.isNotEmpty ? shareContent : null,
          onShare: (selectedItems) => ShareService.shareContent(
            context: context,
            content: shareContent,
            selectedItems: selectedItems,
          ),
          editor: ImagineEditor(
            sessionId: sessionId,
            selectedPastId: state.pastImageId(sessionId),
            selectedFutureId: state.futureImageId(sessionId),
            takeaways: takeaways,
          ),
          result: ImagineResult(
            pastImageId: state.pastImageId(sessionId),
            futureImageId: state.futureImageId(sessionId),
            takeaways: takeaways,
            onUpdate: (index, value) => context.read<ImagineBloc>().add(
                  UpdateImagineTakeaway(sessionId, index, value),
                ),
          ),
        );
      },
    );
  }
}

