import 'package:flutter/material.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../models/feedback_question.dart';
import '../models/feedback_response.dart';
import 'rating_selector.dart';

/// Rendert den Fragebogen dynamisch aus dem geladenen [FeedbackQuestionnaire]
/// (#7) statt aus hartkodierten Feldern - neue/geänderte Fragen erfordern nur
/// eine Anpassung der JSON-Datei in assets/data/, keinen Code.
class FeedbackEditor extends StatelessWidget {
  final FeedbackQuestionnaire questionnaire;
  final FeedbackResponse response;
  final void Function(String questionId, Object value) onAnswerChanged;

  const FeedbackEditor({
    super.key,
    required this.questionnaire,
    required this.response,
    required this.onAnswerChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    if (questionnaire.categories.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(l10n.feedbackGuidance, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 16),
        for (final category in questionnaire.categories) ...[
          _buildSectionTitle(theme, category.title),
          for (final question in category.questions)
            question.type == FeedbackQuestionType.scale
                ? RatingSelector(
                    label: question.label,
                    currentRating: response.scaleAnswer(question.id) ?? 0,
                    ratingLabels: questionnaire.scaleLabels,
                    onRatingChanged: (val) => onAnswerChanged(question.id, val),
                  )
                : _buildTextField(
                    question.label,
                    response.textAnswer(question.id),
                    (val) => onAnswerChanged(question.id, val),
                  ),
          const SizedBox(height: 24),
        ],
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String value, ValueChanged<String> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: _FeedbackTextField(label: label, value: value, onChanged: onChanged),
    );
  }
}

/// Eigener StatefulWidget statt TextField mit inline erzeugtem
/// TextEditingController: letzteres wird bei jedem Rebuild neu erstellt und
/// setzt den Cursor auf Tastendruck ans Textende zurück (bekanntes Muster,
/// siehe key_takeaway_field.dart).
class _FeedbackTextField extends StatefulWidget {
  final String label;
  final String value;
  final ValueChanged<String> onChanged;

  const _FeedbackTextField({required this.label, required this.value, required this.onChanged});

  @override
  State<_FeedbackTextField> createState() => _FeedbackTextFieldState();
}

class _FeedbackTextFieldState extends State<_FeedbackTextField> {
  late final TextEditingController _controller = TextEditingController(text: widget.value);
  late final FocusNode _focusNode = FocusNode()..addListener(_onFocusChange);

  void _onFocusChange() {
    if (!_focusNode.hasFocus && _controller.text != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void didUpdateWidget(_FeedbackTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_focusNode.hasFocus && widget.value != _controller.text) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      decoration: InputDecoration(
        labelText: widget.label,
        alignLabelWithHint: true,
        border: const OutlineInputBorder(),
      ),
      maxLines: 3,
      onChanged: widget.onChanged,
    );
  }
}
