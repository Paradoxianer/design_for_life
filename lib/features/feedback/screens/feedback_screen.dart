import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../../../core/widgets/dfl_module_scaffold.dart';
import '../bloc/feedback_bloc.dart';
import '../bloc/feedback_event.dart';
import '../bloc/feedback_state.dart';
import '../services/feedback_csv_exporter.dart';
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
    // postFrameCallback, um den Localizations-Abhängigkeitsfehler in
    // initState zu vermeiden (gleiches Muster wie bei den Geistesgaben).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<FeedbackBloc>().add(
              LoadFeedbackQuestionnaire(locale: Localizations.localeOf(context).languageCode),
            );
      }
    });
  }

  Future<void> _shareCsv(FeedbackState state) async {
    final l10n = AppLocalizations.of(context);
    await FeedbackCsvExporter.share(
      questionnaire: state.questionnaire,
      response: state.response,
      filename: 'feedback.csv',
      subject: l10n.feedbackTitle,
      categoryColumnLabel: l10n.feedbackCsvColumnCategory,
      questionColumnLabel: l10n.feedbackCsvColumnQuestion,
      answerColumnLabel: l10n.feedbackCsvColumnAnswer,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedbackBloc, FeedbackState>(
      builder: (context, state) {
        return DflModuleScaffold(
          title: widget.title,
          initialEditMode: widget.initialEditMode,
          // Feedback teilt als CSV statt als Bild/Text (#7) - kein
          // ShareableContent nötig, daher hier direkt onShare ohne
          // shareableContent (der generische Auswahl-Dialog wird
          // übersprungen, siehe DflModuleScaffold).
          onShare: (_) => _shareCsv(state),
          showShareButtonWithoutContent: true,
          editor: FeedbackEditor(
            questionnaire: state.questionnaire,
            response: state.response,
            onAnswerChanged: (questionId, value) =>
                context.read<FeedbackBloc>().add(UpdateFeedbackAnswer(questionId, value)),
          ),
          result: FeedbackResult(questionnaire: state.questionnaire, response: state.response),
        );
      },
    );
  }
}
