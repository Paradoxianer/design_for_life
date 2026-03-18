import 'package:flutter/material.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../models/goal.dart';

class GoalsResult extends StatelessWidget {
  final List<Goal> goals;
  final Map<int, Map<String, bool>>? smartChecks;

  const GoalsResult({
    super.key,
    required this.goals,
    this.smartChecks,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.goalsTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          ...List.generate(goals.length, (index) {
            final goal = goals[index];
            if (goal.text.isEmpty) return const SizedBox.shrink();
            
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Goal ${index + 1}: ${goal.text}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        _buildSmartChip(context, 'S', goal.isSpecific),
                        _buildSmartChip(context, 'M', goal.isMeasurable),
                        _buildSmartChip(context, 'A', goal.isAchievable),
                        _buildSmartChip(context, 'R', goal.isRelevant),
                        _buildSmartChip(context, 'T', goal.isTimeBound),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSmartChip(BuildContext context, String label, bool isChecked) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: isChecked ? Colors.white : Colors.grey[600],
        ),
      ),
      backgroundColor: isChecked ? Theme.of(context).primaryColor : Colors.grey[200],
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
