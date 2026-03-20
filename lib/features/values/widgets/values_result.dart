import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/values_bloc.dart';
import '../bloc/values_state.dart';

class ValuesResult extends StatelessWidget {
  const ValuesResult({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ValuesBloc, ValuesState>(
      builder: (context, state) {
        final top8 = state.topEightValues;

        if (top8.isEmpty) {
          return const Center(
            child: Text('Noch keine Werte ausgewählt.'),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Meine Top 8 Werte',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            ...top8.asMap().entries.map((entry) {
              final index = entry.key;
              final value = entry.value;
              final isKeyTakeaway = index < 3;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: isKeyTakeaway ? 2 : 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: isKeyTakeaway
                      ? BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.5), width: 1)
                      : BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${index + 1}. ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: isKeyTakeaway ? Theme.of(context).colorScheme.primary : null,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              value.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          if (isKeyTakeaway)
                            Icon(
                              Icons.auto_awesome,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                        ],
                      ),
                      if (value.definition != null && value.definition!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          value.definition!,
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
            if (state.reflectionThoughts.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                'Reflektion',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(state.reflectionThoughts),
            ],
            if (state.nextLifePhaseDescription.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                'Nächster Lebensabschnitt',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(state.nextLifePhaseDescription),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: state.nextLifePhaseValues.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final v = entry.value;
                  return Chip(label: Text('${idx + 1}. ${v.name}'));
                }).toList(),
              ),
            ],
          ],
        );
      },
    );
  }
}
