import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/values_bloc.dart';
import '../bloc/values_event.dart';
import '../models/value_item.dart';

class ValuesRatingView extends StatelessWidget {
  const ValuesRatingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ValuesBloc, ValuesState>(
      builder: (context, state) {
        final top8Count = state.topEightValues.length;
        
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: top8Count == 8 ? Colors.green.shade50 : Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        top8Count == 8 ? Icons.check_circle : Icons.info_outline,
                        color: top8Count == 8 ? Colors.green : Colors.blue,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Wähle genau 8 Werte mit "1" (sehr wichtig) aus.\n'
                          'Aktuell gewählt: $top8Count / 8',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: top8Count > 8 ? Colors.red : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: state.allValues.length,
                itemBuilder: (context, index) {
                  final value = state.allValues[index];
                  return _ValueRatingTile(value: value);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ValueRatingTile extends StatelessWidget {
  final ValueItem value;

  const _ValueRatingTile({required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(value.name),
      trailing: SegmentedButton<int>(
        segments: const [
          ButtonSegment(value: 1, label: Text('1')),
          ButtonSegment(value: 2, label: Text('2')),
          ButtonSegment(value: 3, label: Text('3')),
        ],
        selected: {value.rating},
        onSelectionChanged: (Set<int> newSelection) {
          context.read<ValuesBloc>().add(
            ValuesEvent.updateRating(value.name, newSelection.first),
          );
        },
      ),
    );
  }
}
