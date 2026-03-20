import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/values_bloc.dart';
import '../bloc/values_event.dart';
import '../bloc/values_state.dart';
import '../models/value_item.dart';

class ValuesRatingView extends StatelessWidget {
  const ValuesRatingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ValuesBloc, ValuesState>(
      builder: (context, state) {
        final top8Count = state.topEightValues.length;
        
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: top8Count == 8 ? Colors.green.shade50 : Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Icon(
                        top8Count == 8 ? Icons.check_circle : Icons.info_outline,
                        color: top8Count == 8 ? Colors.green : Colors.blue,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Wähle genau 8 Werte mit "1" (sehr wichtig) aus. Aktuell: $top8Count / 8',
                          style: TextStyle(
                            fontSize: 13,
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
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(), // Let the Stepper or outer ScrollView handle it
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
      dense: true,
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
            UpdateRating(value.name, newSelection.first),
          );
        },
      ),
    );
  }
}
