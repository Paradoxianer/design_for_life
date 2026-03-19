import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/spiritual_gifts_bloc.dart';
import '../models/gift_question.dart';

class SpiritualGiftsEditor extends StatefulWidget {
  final String sessionId;

  const SpiritualGiftsEditor({
    super.key,
    required this.sessionId,
  });

  @override
  State<SpiritualGiftsEditor> createState() => _SpiritualGiftsEditorState();
}

class _SpiritualGiftsEditorState extends State<SpiritualGiftsEditor> {
  late CarouselController _carouselController;

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<SpiritualGiftsBloc>().add(
          InitTest(
            locale: Localizations.localeOf(context).languageCode,
            sessionId: widget.sessionId,
          ),
        );
        
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            final state = context.read<SpiritualGiftsBloc>().state;
            if (state.questionOrder.isNotEmpty) {
              _carouselController.animateToItem(
                state.currentQuestionIndex,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SpiritualGiftsBloc, SpiritualGiftsState>(
      listenWhen: (previous, current) => 
          previous.currentQuestionIndex != current.currentQuestionIndex,
      listener: (context, state) {
        _carouselController.animateToItem(
          state.currentQuestionIndex,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      },
      builder: (context, state) {
        if (!state.isLoaded || state.questionOrder.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Lade Fragen...'),
              ],
            ),
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: state.progress,
                    backgroundColor: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                    minHeight: 8,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Frage ${state.answers.length} von ${state.questionOrder.length}',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
            Expanded(
              child: CarouselView(
                controller: _carouselController,
                scrollDirection: Axis.vertical,
                itemExtent: 240, // Etwas mehr Platz für die seriösen Texte
                shrinkExtent: 180,
                enableSplash: false,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                children: List.generate(state.questionOrder.length, (index) {
                  final questionId = state.questionOrder[index];
                  final gift = state.gifts.firstWhere(
                    (g) => g.questions.any((q) => q.id == questionId),
                    orElse: () => state.gifts.first,
                  );
                  final question = gift.questions.firstWhere(
                    (q) => q.id == questionId,
                    orElse: () => gift.questions.first,
                  );
                  final score = state.answers[questionId];

                  return _QuestionCard(
                    question: question,
                    currentScore: score,
                    isReadOnly: state.isCompleted,
                    onAnswer: (s) {
                      context.read<SpiritualGiftsBloc>().add(
                        AnswerQuestion(questionId: questionId, score: s),
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final GiftQuestion question;
  final int? currentScore;
  final bool isReadOnly;
  final Function(int) onAnswer;

  const _QuestionCard({
    required this.question,
    required this.currentScore,
    required this.isReadOnly,
    required this.onAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      elevation: currentScore != null ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: currentScore != null ? theme.colorScheme.primary.withOpacity(0.5) : Colors.transparent,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              question.text,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 24),
            Center(
              child: Wrap(
                spacing: 10,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: List.generate(6, (index) {
                  final isSelected = currentScore == index;
                  return InkWell(
                    onTap: isReadOnly ? null : () => onAnswer(index),
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: isSelected ? [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          )
                        ] : null,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _getLabel(index),
                            style: TextStyle(
                              color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$index',
                            style: TextStyle(
                              color: isSelected ? Colors.white70 : theme.colorScheme.onSurfaceVariant,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getLabel(int index) {
    switch (index) {
      case 0: return 'Gar nicht';
      case 1: return 'Kaum';
      case 2: return 'Wenig';
      case 3: return 'Teilweise';
      case 4: return 'Viel';
      case 5: return 'Sehr stark';
      default: return '';
    }
  }
}
