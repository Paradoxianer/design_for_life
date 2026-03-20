import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/values_bloc.dart';
import '../bloc/values_event.dart';
import '../bloc/values_state.dart';

class ValuesReflectionView extends StatelessWidget {
  const ValuesReflectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ValuesBloc, ValuesState>(
      builder: (context, state) {
        return ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Reflektion',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            const Text(
              'Was denkst du über die Punkte, die du ausgesucht hast? Gibt es irgendwelche Überraschungen?',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Deine Gedanken...',
              ),
              maxLines: 5,
              controller: TextEditingController(text: state.reflectionThoughts)
                ..selection = TextSelection.collapsed(offset: state.reflectionThoughts.length),
              onChanged: (text) => context.read<ValuesBloc>().add(UpdateReflection(text)),
            ),
            const SizedBox(height: 32),
            Text(
              'Mein nächster Lebensabschnitt',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            const Text(
              'Beschreibe deinen nächsten Lebensabschnitt (z.B. neuer Job, Rente, etc.):',
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Zukünftige Phase...',
              ),
              controller: TextEditingController(text: state.nextLifePhaseDescription)
                ..selection = TextSelection.collapsed(offset: state.nextLifePhaseDescription.length),
              onChanged: (text) => context.read<ValuesBloc>().add(UpdateNextLifePhase(text)),
            ),
            const SizedBox(height: 24),
            const Text(
              'Wähle bis zu 8 Werte, die für diesen neuen Abschnitt wichtig sein werden:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: state.allValues.map((value) {
                final isSelected = state.nextLifePhaseValues.any((v) => v.name == value.name);
                return FilterChip(
                  label: Text(value.name),
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
