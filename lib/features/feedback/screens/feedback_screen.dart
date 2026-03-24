import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/dfl_module_scaffold.dart';
import '../../../core/models/shareable_content.dart';
import '../../../core/services/share_service.dart';
import '../bloc/feedback_bloc.dart';
import '../bloc/feedback_event.dart';
import '../bloc/feedback_state.dart';
import '../widgets/feedback_editor.dart';
import '../widgets/feedback_result.dart';

class FeedbackScreen extends StatefulWidget {
  final String title;
  final bool initialEditMode;

  const FeedbackScreen({
    super.key,
    required this.title,
    this.initialEditMode = true,
  });

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize the global bloc
    context.read<FeedbackBloc>().add(const FeedbackStarted());
  }

  ShareableContent _getShareableContent(FeedbackState state) {
    return ShareableContent(
      title: 'Feedback Seminar',
      items: const [], 
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedbackBloc, FeedbackState>(
      builder: (context, state) {
        final shareContent = _getShareableContent(state);

        return DflModuleScaffold(
          title: widget.title,
          initialEditMode: widget.initialEditMode,
          shareableContent: shareContent.items.isNotEmpty ? shareContent : null,
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
          result: FeedbackResult(response: state.response),
        );
      },
    );
  }
}
