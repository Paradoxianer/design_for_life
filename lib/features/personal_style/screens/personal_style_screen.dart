import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../../../core/widgets/dfl_module_scaffold.dart';
import '../../../core/models/shareable_content.dart';
import '../../../core/services/share_service.dart';
import '../bloc/personal_style_bloc.dart';
import '../bloc/personal_style_state.dart';
import '../widgets/personal_style_editor.dart';
import '../widgets/personal_style_result.dart';

class PersonalStyleScreen extends StatefulWidget {
  final String sessionId;
  final String title;
  final bool initialEditMode;

  const PersonalStyleScreen({
    super.key,
    required this.sessionId,
    required this.title,
    this.initialEditMode = true,
  });

  @override
  State<PersonalStyleScreen> createState() => _PersonalStyleScreenState();
}

class _PersonalStyleScreenState extends State<PersonalStyleScreen> {
  ShareableContent _getShareableContent(BuildContext context, PersonalStyleState state) {
    final l10n = AppLocalizations.of(context);
    final profile = state.profile;
    final quadrant = state.quadrant;
    final takeaways = state.takeaways[widget.sessionId] ?? const [];

    final List<ShareableItem> items = [];

    // Matrix (mit präziser Positionsmarkierung + O-/E-Prozentwerten) UND
    // Profil-Erklärung als EIN gemeinsames Bild, damit die Erklärung beim
    // Teilen nicht separat abgewählt werden/verloren gehen kann.
    if (quadrant != null) {
      items.add(ShareableItem(
        id: 'personal_style_matrix',
        label: l10n.personalStyleShareCardLabel,
        textValue: profile != null ? '${profile.title}\n${profile.traits.join('\n')}' : null,
        data: {
          'type': 'personal_style_matrix',
          'quadrant': quadrant,
          'organisationFraction': state.organisationFraction,
          'energyFraction': state.energyFraction,
          'peopleLabel': l10n.personalStyleAxisPeople,
          'taskLabel': l10n.personalStyleAxisTask,
          'structuredLabel': l10n.personalStyleAxisStructured,
          'unstructuredLabel': l10n.personalStyleAxisUnstructured,
          'organisationAxisLabel': l10n.personalStyleScoreOrganisation,
          'energyAxisLabel': l10n.personalStyleScoreEnergy,
          if (profile != null) 'profileTitle': profile.title,
          if (profile != null) 'profileTraits': profile.traits,
        },
      ));
    }

    for (int i = 0; i < takeaways.length; i++) {
      if (takeaways[i].trim().isNotEmpty) {
        items.add(ShareableItem(
          id: 'personal_style_takeaway_$i',
          label: l10n.shareHighlightItem(i + 1),
          textValue: takeaways[i],
        ));
      }
    }

    return ShareableContent(title: l10n.personalStyleTitle, items: items);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalStyleBloc, PersonalStyleState>(
      builder: (context, state) {
        final shareContent = _getShareableContent(context, state);

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
          onWillToggleMode: () async {
            return await _validateCompletion(context, state);
          },
          editor: PersonalStyleEditor(sessionId: widget.sessionId),
          result: PersonalStyleResult(sessionId: widget.sessionId),
        );
      },
    );
  }

  Future<bool> _validateCompletion(BuildContext context, PersonalStyleState state) async {
    final l10n = AppLocalizations.of(context);
    final totalQuestions = state.questionnaire.questions.length;
    final answeredQuestions = state.answers.length;

    if (totalQuestions > 0 && answeredQuestions < totalQuestions) {
      final bool? result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.giftsIncompleteTitle),
          content: Text(l10n.giftsIncompleteMessage(answeredQuestions, totalQuestions)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.giftsContinue),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.giftsFinishAnyway),
            ),
          ],
        ),
      );
      return result ?? false;
    }
    return true;
  }
}
