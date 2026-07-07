import 'package:flutter/material.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../models/feedback_question.dart';
import '../models/feedback_response.dart';

class FeedbackResult extends StatelessWidget {
  final FeedbackQuestionnaire questionnaire;
  final FeedbackResponse response;

  const FeedbackResult({
    super.key,
    required this.questionnaire,
    required this.response,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(l10n.feedbackTitle, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 16),
        for (final category in questionnaire.categories)
          _buildSection(context, category.title, _buildQuestionRows(category.questions)),
        const SizedBox(height: 24),
      ],
    );
  }

  List<Widget> _buildQuestionRows(List<FeedbackQuestion> questions) {
    final rows = <Widget>[];
    for (final question in questions) {
      if (question.type == FeedbackQuestionType.scale) {
        rows.add(_buildResultRow(question.label, response.scaleAnswer(question.id)));
      } else {
        final text = response.textAnswer(question.id);
        if (text.isNotEmpty) rows.add(_buildTextResult(question.label, text));
      }
    }
    return rows;
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    if (children.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const Divider(),
        ...children,
      ],
    );
  }

  Widget _buildResultRow(String label, int? rating) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: rating == null ? Colors.grey[200] : _getRatingColor(rating),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              rating?.toString() ?? '-',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextResult(String label, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12)),
          const SizedBox(height: 4),
          Text(text),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Color _getRatingColor(int rating) {
    // 1 is best (green), 6 is worst (red)
    switch (rating) {
      case 1:
        return Colors.green[300]!;
      case 2:
        return Colors.green[100]!;
      case 3:
        return Colors.yellow[100]!;
      case 4:
        return Colors.orange[100]!;
      case 5:
        return Colors.red[100]!;
      case 6:
        return Colors.red[300]!;
      default:
        return Colors.grey[200]!;
    }
  }
}
