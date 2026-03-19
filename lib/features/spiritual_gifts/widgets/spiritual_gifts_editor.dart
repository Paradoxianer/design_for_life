import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/spiritual_gifts_bloc.dart';
import '../models/gift_question.dart';
import '../models/gift_data.dart';

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
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.6);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SpiritualGiftsBloc, SpiritualGiftsState>(
      listener: (context, state) {
        if (_pageController.hasClients && 
            _pageController.page?.round() != state.currentQuestionIndex &&
            state.currentQuestionIndex < state.questionOrder.length) {
          _pageController.animateToPage(
            state.currentQuestionIndex,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutCubic,
          );
        }
      },
      builder: (context, state) {
        if (state.questionOrder.isEmpty) {
          context.read<SpiritualGiftsBloc>().add(
            InitTest(locale: Localizations.localeOf(context).languageCode),
          );
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            LinearProgressIndicator(
              value: state.progress,
              backgroundColor: Colors.grey.shade200,
              minHeight: 6,
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: state.questionOrder.length,
                itemBuilder: (context, index) {
                  final questionId = state.questionOrder[index];
                  final gift = state.gifts.firstWhere(
                    (g) => g.questions.any((q) => q.id == questionId),
                  );
                  final question = gift.questions.firstWhere((q) => q.id == questionId);
                  final score = state.answers[questionId];

                  return AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      double value = 1.0;
                      if (_pageController.position.hasContentDimensions) {
                        value = (_pageController.page! - index).abs();
                        value = (1 - (value * 0.4)).clamp(0.0, 1.0);
                      } else {
                        value = index == state.currentQuestionIndex ? 1.0 : 0.6;
                      }

                      return Center(
                        child: Transform.scale(
                          scale: value,
                          child: Opacity(
                            opacity: value,
                            child: child,
                          ),
                        ),
                      );
                    },
                    child: _QuestionCard(
                      question: question,
                      currentScore: score,
                      onAnswer: (s) {
                        context.read<SpiritualGiftsBloc>().add(
                          AnswerQuestion(questionId: questionId, score: s),
                        );
                      },
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

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            question.text,
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          _buildChoiceGrid(context),
        ],
      ),
    );
  }

  Widget _buildChoiceGrid(BuildContext context) {
    final List<String> labels = ['Gar nicht', 'Kaum', 'Wenig', 'Etwas', 'Oft', 'Voll!'];
    
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: List.generate(6, (index) {
        final isSelected = currentScore == index;
        final theme = Theme.of(context);
        
        return InkWell(
          onTap: () => onAnswer(index),
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 95,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            decoration: BoxDecoration(
              color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? theme.colorScheme.primary : Colors.transparent,
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Text(
                  labels[index],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  '$index',
                  style: TextStyle(
                    fontSize: 11,
                    color: isSelected ? Colors.white70 : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
