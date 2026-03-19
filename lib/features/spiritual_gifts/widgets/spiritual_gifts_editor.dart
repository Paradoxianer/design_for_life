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
  final double _itemHeight = 200.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (mounted) setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<SpiritualGiftsBloc>().add(
          InitTest(
            locale: Localizations.localeOf(context).languageCode,
            sessionId: widget.sessionId,
          ),
        );
        
        // Verzoegerter Sprung zum Fortschritt nach dem Laden
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            final state = context.read<SpiritualGiftsBloc>().state;
            if (state.questionOrder.isNotEmpty) {
              _scrollToIndex(state.firstUnansweredIndex, instant: true);
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToIndex(int index, {bool instant = false}) {
    if (_scrollController.hasClients) {
      final target = index * _itemHeight;
      if (instant) {
        _scrollController.jumpTo(target);
      } else {
        _scrollController.animateTo(
          target,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SpiritualGiftsBloc, SpiritualGiftsState>(
      listener: (context, state) {
        // Nur automatisch weiterscrollen, wenn das beantwortete Item das "letzte neue" war
        // Damit verhindern wir Springen bei Korrekturen weiter oben.
        final answeredIndex = state.currentQuestionIndex - 1;
        if (answeredIndex >= 0 && answeredIndex == state.answers.length - 1) {
          _scrollToIndex(state.currentQuestionIndex);
        }
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

        final screenHeight = MediaQuery.of(context).size.height;
        final verticalPadding = (screenHeight / 2) - (_itemHeight / 2) - 100;

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
                itemExtent: _itemHeight,
                itemBuilder: (context, index) {
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

                  double scale = 0.85;
                  if (_scrollController.hasClients) {
                    final offset = _scrollController.offset;
                    final distance = (offset - (index * _itemHeight)).abs();
                    final normalized = (distance / _itemHeight).clamp(0.0, 1.0);
                    scale = 1.0 - (normalized * 0.15);
                  }

                  return Container(
                    height: _itemHeight,
                    alignment: Alignment.center,
                    child: Transform.scale(
                      scale: scale,
                      child: Opacity(
                        opacity: scale.clamp(0.5, 1.0),
                        child: _QuestionCard(
                          question: question,
                          currentScore: score,
                          isReadOnly: state.isCompleted,
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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: currentScore != null ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: currentScore != null ? theme.colorScheme.primary.withValues(alpha: 0.5) : Colors.transparent,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              question.text,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            _buildChoiceRow(context),
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceRow(BuildContext context) {
    final List<String> labels = ['Gar nicht', 'Kaum', 'Wenig', 'Etwas', 'Oft', 'Voll!'];
    final theme = Theme.of(context);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (index) {
        final isSelected = currentScore == index;
        
        return InkWell(
          onTap: isReadOnly ? null : () => onAnswer(index),
          borderRadius: BorderRadius.circular(8),
          child: Opacity(
            opacity: isReadOnly && !isSelected ? 0.5 : 1.0,
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    labels[index],
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
                  style: TextStyle(
                    fontSize: 10, 
                    color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
