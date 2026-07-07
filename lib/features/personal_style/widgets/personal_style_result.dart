import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../../../core/widgets/dfl_module_result.dart';
import '../bloc/personal_style_bloc.dart';
import '../bloc/personal_style_event.dart';
import '../bloc/personal_style_state.dart';
import '../models/personal_style_question.dart';
import 'personal_style_matrix.dart';

class PersonalStyleResult extends StatelessWidget {
  final String sessionId;

  const PersonalStyleResult({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return BlocBuilder<PersonalStyleBloc, PersonalStyleState>(
      builder: (context, state) {
        final quadrant = state.quadrant;
        final profile = state.profile;

        return DflModuleResult(
          title: l10n.personalStyleTitle,
          takeaways: state.takeaways[sessionId] ?? const [],
          onUpdate: (index, value) =>
              context.read<PersonalStyleBloc>().add(UpdatePersonalStyleTakeaway(sessionId, index, value)),
          result: quadrant == null
              ? Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    l10n.personalStyleIncomplete,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.personalStyleResultHeading,
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    PersonalStyleMatrix(
                      quadrant: quadrant,
                      peopleLabel: l10n.personalStyleAxisPeople,
                      taskLabel: l10n.personalStyleAxisTask,
                      structuredLabel: l10n.personalStyleAxisStructured,
                      unstructuredLabel: l10n.personalStyleAxisUnstructured,
                    ),
                    if (profile != null) ...[
                      const SizedBox(height: 24),
                      _ProfileCard(profile: profile),
                    ],
                  ],
                ),
        );
      },
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final PersonalStyleProfile profile;

  const _ProfileCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            profile.title,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          for (final trait in profile.traits)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('•  '),
                  Expanded(child: Text(trait, style: theme.textTheme.bodyMedium)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
