import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../bloc/values_bloc.dart';
import '../bloc/values_event.dart';
import '../bloc/values_state.dart';

class ValuesReflectionView extends StatelessWidget {
  const ValuesReflectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return BlocBuilder<ValuesBloc, ValuesState>(
      builder: (context, state) {
        return ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              l10n.valuesPhase3Title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                l10n.valuesPhase3Guidance,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            Text(
              l10n.valuesReflectionLabel,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: l10n.valuesReflectionHint,
              ),
              maxLines: 5,
              controller: TextEditingController(text: state.reflectionThoughts)
                ..selection = TextSelection.collapsed(offset: state.reflectionThoughts.length),
              onChanged: (text) => context.read<ValuesBloc>().add(UpdateReflection(text)),
            ),
            const SizedBox(height: 32),
            Text(
              l10n.valuesNextPhaseLabel,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: l10n.valuesNextPhaseHint,
              ),
              controller: TextEditingController(text: state.nextLifePhaseDescription)
                ..selection = TextSelection.collapsed(offset: state.nextLifePhaseDescription.length),
              onChanged: (text) => context.read<ValuesBloc>().add(UpdateNextLifePhase(text)),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.valuesNextPhaseValuesGuidance,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: state.allValues.map((value) {
                final selectedIndex = state.nextLifePhaseValues.indexWhere((v) => v.name == value.name);
                final isSelected = selectedIndex != -1;
                return FilterChip(
                  label: Text(isSelected ? '${selectedIndex + 1}. ${value.name}' : value.name),
                  selected: isSelected,
                  onSelected: (_) {
                    context.read<ValuesBloc>().add(ToggleNextLifeValue(value));
                  },
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
