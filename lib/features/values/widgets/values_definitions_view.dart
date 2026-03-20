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
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text(
                'Bitte wähle zuerst 8 Werte in Phase 1 (Bewertung) aus.',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Sortiere deine Top-Werte nach Priorität. Die ersten 3 sind deine Key Takeaways.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: top8.length,
              onReorder: (oldIndex, newIndex) {
                context.read<ValuesBloc>().add(ReorderTopValues(oldIndex, newIndex));
              },
              itemBuilder: (context, index) {
                final value = top8[index];
                final isKeyTakeaway = index < 3;
                
                return Padding(
                  key: ValueKey(value.name),
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.drag_handle, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${index + 1}. ${value.name} ${isKeyTakeaway ? "(Key Takeaway)" : ""}',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isKeyTakeaway ? Theme.of(context).colorScheme.primary : null,
                              ),
                            ),
                          ),
                        ],
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
            ),
          ],
        );
      },
    );
  }
}
