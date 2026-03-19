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
            ...top8.map((value) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          value.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
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
                )),
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
                children: state.nextLifePhaseValues
                    .map((v) => Chip(label: Text(v.name)))
                    .toList(),
              ),
            ],
          ],
        );
      },
    );
  }
}
