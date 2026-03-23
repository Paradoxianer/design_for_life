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

    // Add key ratings to share content
    items.add(ShareableItem(
      id: 'fb_overall',
      label: l10n.feedbackContentExpectations,
      textValue: l10n.feedbackLabel(response.contentExpectations),
    ));
    items.add(ShareableItem(
      id: 'fb_god',
      label: l10n.feedbackSpeakerGodWorking,
      textValue: l10n.feedbackLabel(response.speakerGodWorking),
    ));

    if (response.generalNotes.isNotEmpty) {
      items.add(ShareableItem(
        id: 'fb_notes',
        label: l10n.feedbackGeneralNotes,
        textValue: response.generalNotes,
      ));
    }

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
