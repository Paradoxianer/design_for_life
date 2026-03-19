import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../bloc/spiritual_gifts_bloc.dart';
import '../models/spiritual_gift.dart';
import '../models/gift_data.dart';

class SpiritualGiftsEditor extends StatelessWidget {
  final String sessionId;

  const SpiritualGiftsEditor({
    super.key,
    required this.sessionId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpiritualGiftsBloc, SpiritualGiftsState>(
      builder: (context, state) {
        if (state.questionOrder.isEmpty) {
          context.read<SpiritualGiftsBloc>().add(
            InitTest(locale: Localizations.localeOf(context).languageCode),
          );
          return const Center(child: CircularProgressIndicator());
        }

        if (state.isCompleted) {
          return _buildCompletionScreen(context);
        }

        final questionId = state.questionOrder[state.currentQuestionIndex];
        // Suche die Frage in den Daten
        final gift = GiftData.allGifts.firstWhere(
          (g) => g.questions.any((q) => q.id == questionId),
        );
        final question = gift.questions.firstWhere((q) => q.id == questionId);

        return Column(
          children: [
            LinearProgressIndicator(
              value: state.progress,
              backgroundColor: Colors.grey.shade200,
              minHeight: 8,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Frage ${state.currentQuestionIndex + 1} von ${state.questionOrder.length}',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  if (state.currentQuestionIndex > 0)
                    TextButton.icon(
                      onPressed: () => context.read<SpiritualGiftsBloc>().add(PreviousQuestion()),
                      icon: const Icon(Icons.arrow_back, size: 16),
                      label: const Text('Zurück'),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: KeyedSubtree(
                      key: ValueKey(questionId),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            question.text,
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: MainCenter,
                          ),
                          const SizedBox(height: 48),
                          _buildChoiceButtons(context, questionId, state.answers[questionId]),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildChoiceButtons(BuildContext context, String questionId, int? currentScore) {
    final List<String> labels = ['Gar nicht', 'Kaum', 'Wenig', 'Etwas', 'Oft', 'Voll!'];
    
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: List.generate(6, (index) {
        final isSelected = currentScore == index;
        return InkWell(
          onTap: () {
            context.read<SpiritualGiftsBloc>().add(
              AnswerQuestion(questionId: questionId, score: index),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 100,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: isSelected ? Theme.of(context).colorScheme.primary : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade300,
                width: 2,
              ),
              boxShadow: isSelected ? [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ] : null,
            ),
            child: Column(
              children: [
                Text(
                  '$index',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  labels[index],
                  style: TextStyle(
                    fontSize: 10,
                    color: isSelected ? Colors.white70 : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCompletionScreen(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
          const SizedBox(height: 24),
          Text(
            'Test abgeschlossen!',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          const Text('Schau dir jetzt deine Ergebnisse an.'),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              // Hier könnte man den Modus auf "Result" umschalten
            },
            child: const Text('Ergebnisse zeigen'),
          ),
        ],
      ),
    );
  }
}

const MainCenter = TextAlign.center;
