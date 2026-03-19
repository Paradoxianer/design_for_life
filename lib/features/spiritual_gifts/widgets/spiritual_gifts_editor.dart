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
  late ScrollController _scrollController;
  final double _itemHeight = 180.0; // Deutlich kompakter

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToIndex(int index) {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        index * _itemHeight,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SpiritualGiftsBloc, SpiritualGiftsState>(
      listener: (context, state) {
        _scrollToIndex(state.currentQuestionIndex);
      },
      builder: (context, state) {
        if (state.questionOrder.isEmpty) {
          context.read<SpiritualGiftsBloc>().add(
            InitTest(locale: Localizations.localeOf(context).languageCode),
          );
          return const Center(child: CircularProgressIndicator());
        }

        final screenHeight = MediaQuery.of(context).size.height;
        // Padding oben/unten, damit die erste/letzte Karte mittig stehen kann
        final verticalPadding = (screenHeight / 2) - (_itemHeight / 2) - 80;

        return Column(
          children: [
            LinearProgressIndicator(
              value: state.progress,
              backgroundColor: Colors.grey.shade200,
              minHeight: 4,
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(top: verticalPadding, bottom: verticalPadding),
                itemCount: state.questionOrder.length,
                itemBuilder: (context, index) {
                  final questionId = state.questionOrder[index];
                  final gift = state.gifts.firstWhere((g) => g.questions.any((q) => q.id == questionId));
                  final question = gift.questions.firstWhere((q) => q.id == questionId);
                  final score = state.answers[questionId];

                  double scale = 0.8;
                  double opacity = 0.5;

                  if (_scrollController.hasClients) {
                    final offset = _scrollController.offset;
                    final distance = (offset - (index * _itemHeight)).abs();
                    final normalized = (distance / _itemHeight).clamp(0.0, 1.0);
                    scale = 1.0 - (normalized * 0.25);
                    opacity = 1.0 - (normalized * 0.5);
                  } else if (index == state.currentQuestionIndex) {
                    scale = 1.0;
                    opacity = 1.0;
                  }

                  return Container(
                    height: _itemHeight,
                    alignment: Alignment.center,
                    child: Transform.scale(
                      scale: scale,
                      child: Opacity(
                        opacity: opacity.clamp(0.3, 1.0),
                        child: _QuestionCard(
                          question: question,
                          currentScore: score,
                          onAnswer: (s) {
                            context.read<SpiritualGiftsBloc>().add(
                              AnswerQuestion(questionId: questionId, score: s),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
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
  final Function(int) onAnswer;

  const _QuestionCard({
    required this.question,
    required this.currentScore,
    required this.onAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              question.text,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            _buildChoiceRow(context),
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceRow(BuildContext context) {
    final List<String> labels = ['Gar nicht', 'Kaum', 'Wenig', 'Etwas', 'Oft', 'Voll!'];
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (index) {
        final isSelected = currentScore == index;
        final theme = Theme.of(context);
        
        return InkWell(
          onTap: () => onAnswer(index),
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surfaceVariant,
                  shape: BoxShape.circle,
                  border: Border.all(color: isSelected ? theme.colorScheme.primary : Colors.transparent),
                ),
                alignment: Alignment.center,
                child: Text(
                  labels[index].substring(0, 1), // Nur erster Buchstabe für Kompaktheit
                  style: TextStyle(
                    color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$index',
                style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        );
      }),
    );
  }
}
