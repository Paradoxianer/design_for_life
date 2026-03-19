import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/values_bloc.dart';
import '../bloc/values_event.dart';
import '../bloc/values_state.dart';

class ValuesDefinitionsView extends StatelessWidget {
  const ValuesDefinitionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ValuesBloc, ValuesState>(
      builder: (context, state) {
        final top8 = state.topEightValues;

        if (top8.isEmpty) {
          return const Center(
            child: Text('Bitte wähle zuerst 8 Werte in Phase 1 aus.'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: top8.length,
          itemBuilder: (context, index) {
            final value = top8[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${index + 1}. ${value.name}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Meine Definition',
                      border: OutlineInputBorder(),
                      hintText: 'Was bedeutet dieser Wert für mich persönlich?',
                    ),
                    maxLines: 2,
                    controller: TextEditingController(text: value.definition)
                      ..selection = TextSelection.collapsed(offset: value.definition?.length ?? 0),
                    onChanged: (text) {
                      context.read<ValuesBloc>().add(
                        UpdateDefinition(value.name, text),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
