import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../../../core/widgets/dfl_module_scaffold.dart';
import '../../../core/models/shareable_content.dart';
import '../../../core/services/share_service.dart';
import '../bloc/feedback_bloc.dart';
import '../bloc/feedback_event.dart';
import '../bloc/feedback_state.dart';
import '../widgets/feedback_editor.dart';
import '../widgets/feedback_result.dart';

class FeedbackScreen extends StatelessWidget {
  final String title;
  final bool initialEditMode;

  const FeedbackScreen({
    super.key,
    required this.title,
    this.initialEditMode = true,
  });

  ShareableContent _getShareableContent(BuildContext context, FeedbackState state) {
    final l10n = AppLocalizations.of(context);
    final response = state.response;
    final List<ShareableItem> items = [];

    // 1. Content
    items.add(ShareableItem(id: 'c1', label: l10n.feedbackContentExpectations, textValue: response.contentExpectations.toString()));
    items.add(ShareableItem(id: 'c2', label: l10n.feedbackContentPracticalUtility, textValue: response.contentPracticalUtility.toString()));
    items.add(ShareableItem(id: 'c3', label: l10n.feedbackContentStructure, textValue: response.contentStructure.toString()));

    // 2. Speaker
    items.add(ShareableItem(id: 's1', label: l10n.feedbackSpeakerGodWorking, textValue: response.speakerGodWorking.toString()));
    items.add(ShareableItem(id: 's2', label: l10n.feedbackSpeakerFaithProgress, textValue: response.speakerFaithProgress.toString()));
    items.add(ShareableItem(id: 's3', label: l10n.feedbackSpeakerDidactics, textValue: response.speakerDidactics.toString()));
    items.add(ShareableItem(id: 's4', label: l10n.feedbackSpeakerMethods, textValue: response.speakerMethods.toString()));
    items.add(ShareableItem(id: 's5', label: l10n.feedbackSpeakerInvolvement, textValue: response.speakerInvolvement.toString()));
    items.add(ShareableItem(id: 's6', label: l10n.feedbackSpeakerRespect, textValue: response.speakerRespect.toString()));
    items.add(ShareableItem(id: 's7', label: l10n.feedbackAtmosphere, textValue: response.atmosphere.toString()));

    // 3. Docs
    items.add(ShareableItem(id: 'd1', label: l10n.feedbackDocsStructure, textValue: response.docsStructure.toString()));
    items.add(ShareableItem(id: 'd2', label: l10n.feedbackDocsUnderstandability, textValue: response.docsUnderstandability.toString()));
    items.add(ShareableItem(id: 'd3', label: l10n.feedbackDocsDifficulty, textValue: response.docsDifficulty.toString()));

    // 4. Org
    items.add(ShareableItem(id: 'o1', label: l10n.feedbackRoomsAppropriateness, textValue: response.roomsAppropriateness.toString()));
    items.add(ShareableItem(id: 'o2', label: l10n.feedbackPrepQuality, textValue: response.prepQuality.toString()));
    items.add(ShareableItem(id: 'o3', label: l10n.feedbackDuration, textValue: response.duration.toString()));
    items.add(ShareableItem(id: 'o4', label: l10n.feedbackTempo, textValue: response.tempo.toString()));
    items.add(ShareableItem(id: 'o5', label: l10n.feedbackCatering, textValue: response.catering.toString()));

    // 5. Comments
    if (response.commentsMissing.isNotEmpty) items.add(ShareableItem(id: 'comm1', label: l10n.feedbackCommentsMissing, textValue: response.commentsMissing));
    if (response.recommendation.isNotEmpty) items.add(ShareableItem(id: 'comm2', label: l10n.feedbackRecommendation, textValue: response.recommendation));
    if (response.generalNotes.isNotEmpty) items.add(ShareableItem(id: 'comm3', label: l10n.feedbackGeneralNotes, textValue: response.generalNotes));

    return ShareableContent(
      title: l10n.feedbackTitle,
      items: items,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FeedbackBloc()..add(FeedbackStarted()),
      child: BlocBuilder<FeedbackBloc, FeedbackState>(
        builder: (context, state) {
          final shareContent = _getShareableContent(context, state);

          return DflModuleScaffold(
            title: title,
            initialEditMode: initialEditMode,
            shareableContent: shareContent,
            onShare: (selectedItems) {
              ShareService.shareContent(
                context: context,
                content: shareContent,
                selectedItems: selectedItems,
              );
            },
            editor: FeedbackEditor(
              response: state.response,
              onChanged: (newResponse) {
                context.read<FeedbackBloc>().add(UpdateFeedback(newResponse));
              },
            ),
            result: FeedbackResult(
              response: state.response,
            ),
          );
        },
      ),
    );
  }
}
