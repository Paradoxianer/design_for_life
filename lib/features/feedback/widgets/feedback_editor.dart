import 'package:flutter/material.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../models/feedback_response.dart';
import 'rating_selector.dart';

class FeedbackEditor extends StatelessWidget {
  final FeedbackResponse response;
  final ValueChanged<FeedbackResponse> onChanged;

  const FeedbackEditor({
    super.key,
    required this.response,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildSectionTitle(theme, l10n.feedbackSectionContent),
        RatingSelector(
          label: l10n.feedbackContentExpectations,
          currentRating: response.contentExpectations,
          onRatingChanged: (val) => onChanged(response.copyWith(contentExpectations: val)),
        ),
        RatingSelector(
          label: l10n.feedbackContentPracticalUtility,
          currentRating: response.contentPracticalUtility,
          onRatingChanged: (val) => onChanged(response.copyWith(contentPracticalUtility: val)),
        ),
        RatingSelector(
          label: l10n.feedbackContentStructure,
          currentRating: response.contentStructure,
          onRatingChanged: (val) => onChanged(response.copyWith(contentStructure: val)),
        ),

        const SizedBox(height: 24),
        _buildSectionTitle(theme, l10n.feedbackSectionSpeaker),
        RatingSelector(
          label: l10n.feedbackSpeakerGodWorking,
          currentRating: response.speakerGodWorking,
          onRatingChanged: (val) => onChanged(response.copyWith(speakerGodWorking: val)),
        ),
        RatingSelector(
          label: l10n.feedbackSpeakerFaithProgress,
          currentRating: response.speakerFaithProgress,
          onRatingChanged: (val) => onChanged(response.copyWith(speakerFaithProgress: val)),
        ),
        RatingSelector(
          label: l10n.feedbackSpeakerDidactics,
          currentRating: response.speakerDidactics,
          onRatingChanged: (val) => onChanged(response.copyWith(speakerDidactics: val)),
        ),
        RatingSelector(
          label: l10n.feedbackSpeakerMethods,
          currentRating: response.speakerMethods,
          onRatingChanged: (val) => onChanged(response.copyWith(speakerMethods: val)),
        ),
        RatingSelector(
          label: l10n.feedbackSpeakerInvolvement,
          currentRating: response.speakerInvolvement,
          onRatingChanged: (val) => onChanged(response.copyWith(speakerInvolvement: val)),
        ),
        RatingSelector(
          label: l10n.feedbackSpeakerRespect,
          currentRating: response.speakerRespect,
          onRatingChanged: (val) => onChanged(response.copyWith(speakerRespect: val)),
        ),
        RatingSelector(
          label: l10n.feedbackAtmosphere,
          currentRating: response.atmosphere,
          onRatingChanged: (val) => onChanged(response.copyWith(atmosphere: val)),
        ),

        const SizedBox(height: 24),
        _buildSectionTitle(theme, l10n.feedbackSectionDocs),
        RatingSelector(
          label: l10n.feedbackDocsStructure,
          currentRating: response.docsStructure,
          onRatingChanged: (val) => onChanged(response.copyWith(docsStructure: val)),
        ),
        RatingSelector(
          label: l10n.feedbackDocsUnderstandability,
          currentRating: response.docsUnderstandability,
          onRatingChanged: (val) => onChanged(response.copyWith(docsUnderstandability: val)),
        ),
        RatingSelector(
          label: l10n.feedbackDocsDifficulty,
          currentRating: response.docsDifficulty,
          onRatingChanged: (val) => onChanged(response.copyWith(docsDifficulty: val)),
        ),

        const SizedBox(height: 24),
        _buildSectionTitle(theme, l10n.feedbackSectionOrg),
        RatingSelector(
          label: l10n.feedbackRoomsAppropriateness,
          currentRating: response.roomsAppropriateness,
          onRatingChanged: (val) => onChanged(response.copyWith(roomsAppropriateness: val)),
        ),
        RatingSelector(
          label: l10n.feedbackPrepQuality,
          currentRating: response.prepQuality,
          onRatingChanged: (val) => onChanged(response.copyWith(prepQuality: val)),
        ),
        RatingSelector(
          label: l10n.feedbackDuration,
          currentRating: response.duration,
          onRatingChanged: (val) => onChanged(response.copyWith(duration: val)),
        ),
        RatingSelector(
          label: l10n.feedbackTempo,
          currentRating: response.tempo,
          onRatingChanged: (val) => onChanged(response.copyWith(tempo: val)),
        ),
        RatingSelector(
          label: l10n.feedbackCatering,
          currentRating: response.catering,
          onRatingChanged: (val) => onChanged(response.copyWith(catering: val)),
        ),

        const SizedBox(height: 24),
        _buildSectionTitle(theme, l10n.feedbackSectionComments),
        _buildTextField(l10n.feedbackCommentsMissing, response.commentsMissing, (val) => onChanged(response.copyWith(commentsMissing: val))),
        _buildTextField(l10n.feedbackRecommendation, response.recommendation, (val) => onChanged(response.copyWith(recommendation: val))),
        _buildTextField(l10n.feedbackGeneralNotes, response.generalNotes, (val) => onChanged(response.copyWith(generalNotes: val))),
        
        const SizedBox(height: 40),
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
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          alignLabelWithHint: true,
          border: const OutlineInputBorder(),
        ),
        maxLines: 3,
        controller: TextEditingController(text: value)..selection = TextSelection.fromPosition(TextPosition(offset: value.length)),
        onChanged: onChanged,
      ),
    );
  }
}
