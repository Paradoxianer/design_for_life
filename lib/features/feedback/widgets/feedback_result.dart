import 'package:flutter/material.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../models/feedback_response.dart';

class FeedbackResult extends StatelessWidget {
  final FeedbackResponse response;

  const FeedbackResult({
    super.key,
    required this.response,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(
          l10n.feedbackTitle,
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        
        _buildSection(context, l10n.feedbackSectionContent, [
          _buildResultRow(l10n.feedbackContentExpectations, response.contentExpectations),
          _buildResultRow(l10n.feedbackContentPracticalUtility, response.contentPracticalUtility),
          _buildResultRow(l10n.feedbackContentStructure, response.contentStructure),
        ]),

        _buildSection(context, l10n.feedbackSectionSpeaker, [
          _buildResultRow(l10n.feedbackSpeakerGodWorking, response.speakerGodWorking),
          _buildResultRow(l10n.feedbackSpeakerFaithProgress, response.speakerFaithProgress),
          _buildResultRow(l10n.feedbackSpeakerDidactics, response.speakerDidactics),
          _buildResultRow(l10n.feedbackSpeakerMethods, response.speakerMethods),
          _buildResultRow(l10n.feedbackSpeakerInvolvement, response.speakerInvolvement),
          _buildResultRow(l10n.feedbackSpeakerRespect, response.speakerRespect),
          _buildResultRow(l10n.feedbackAtmosphere, response.atmosphere),
        ]),

        _buildSection(context, l10n.feedbackSectionDocs, [
          _buildResultRow(l10n.feedbackDocsStructure, response.docsStructure),
          _buildResultRow(l10n.feedbackDocsUnderstandability, response.docsUnderstandability),
          _buildResultRow(l10n.feedbackDocsDifficulty, response.docsDifficulty),
        ]),

        _buildSection(context, l10n.feedbackSectionOrg, [
          _buildResultRow(l10n.feedbackRoomsAppropriateness, response.roomsAppropriateness),
          _buildResultRow(l10n.feedbackPrepQuality, response.prepQuality),
          _buildResultRow(l10n.feedbackDuration, response.duration),
          _buildResultRow(l10n.feedbackTempo, response.tempo),
          _buildResultRow(l10n.feedbackCatering, response.catering),
        ]),

        if (response.commentsMissing.isNotEmpty || 
            response.recommendation.isNotEmpty || 
            response.generalNotes.isNotEmpty)
          _buildSection(context, l10n.feedbackSectionComments, [
            if (response.commentsMissing.isNotEmpty)
              _buildTextResult(l10n.feedbackCommentsMissing, response.commentsMissing),
            if (response.recommendation.isNotEmpty)
              _buildTextResult(l10n.feedbackRecommendation, response.recommendation),
            if (response.generalNotes.isNotEmpty)
              _buildTextResult(l10n.feedbackGeneralNotes, response.generalNotes),
          ]),
          
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
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

  Widget _buildResultRow(String label, int rating) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: rating == 0 ? Colors.grey[200] : _getRatingColor(rating),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              rating == 0 ? '-' : rating.toString(),
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
      case 1: return Colors.green[300]!;
      case 2: return Colors.green[100]!;
      case 3: return Colors.yellow[100]!;
      case 4: return Colors.orange[100]!;
      case 5: return Colors.red[100]!;
      case 6: return Colors.red[300]!;
      default: return Colors.grey[200]!;
    }
  }
}
