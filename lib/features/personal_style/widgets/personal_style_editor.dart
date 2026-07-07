import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../bloc/personal_style_bloc.dart';
import '../bloc/personal_style_event.dart';
import '../bloc/personal_style_state.dart';
import 'bipolar_question_card.dart';

class PersonalStyleEditor extends StatefulWidget {
  final String sessionId;

  const PersonalStyleEditor({super.key, required this.sessionId});

  @override
  State<PersonalStyleEditor> createState() => _PersonalStyleEditorState();
}

class _PersonalStyleEditorState extends State<PersonalStyleEditor> {
  @override
  void initState() {
    super.initState();
    // postFrameCallback, um den Localizations-Abhängigkeitsfehler in
    // initState zu vermeiden (gleiches Muster wie bei den Geistesgaben).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<PersonalStyleBloc>().add(
              InitPersonalStyleAssessment(locale: Localizations.localeOf(context).languageCode),
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return BlocBuilder<PersonalStyleBloc, PersonalStyleState>(
      builder: (context, state) {
        if (!state.isLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(l10n.personalStyleGuidance, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: state.progress,
              backgroundColor: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
              minHeight: 6,
            ),
            const SizedBox(height: 4),
            Text(
              l10n.personalStyleQuestionCounter(state.answers.length, state.questionnaire.questions.length),
              style: theme.textTheme.labelSmall,
            ),
            const SizedBox(height: 20),
            _buildSectionTitle(theme, l10n.personalStyleSectionOrganisation),
            for (final question in state.questionnaire.organisationQuestions)
              BipolarQuestionCard(
                leftLabel: question.leftLabel,
                rightLabel: question.rightLabel,
                currentValue: state.answers[question.id],
                onChanged: (value) => context.read<PersonalStyleBloc>().add(
                      AnswerPersonalStyleQuestion(widget.sessionId, question.id, value),
                    ),
              ),
            const SizedBox(height: 20),
            _buildSectionTitle(theme, l10n.personalStyleSectionEnergy),
            for (final question in state.questionnaire.energyQuestions)
              BipolarQuestionCard(
                leftLabel: question.leftLabel,
                rightLabel: question.rightLabel,
                currentValue: state.answers[question.id],
                onChanged: (value) => context.read<PersonalStyleBloc>().add(
                      AnswerPersonalStyleQuestion(widget.sessionId, question.id, value),
                    ),
              ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
