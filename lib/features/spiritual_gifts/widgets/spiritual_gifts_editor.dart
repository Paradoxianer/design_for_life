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
  final double _itemExtent = 280.0; // Feste Höhe für die Zoom-Berechnung

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToIndex(int index) {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        index * _itemExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SpiritualGiftsBloc, SpiritualGiftsState>(
      listener: (context, state) {
        // Sync scroll position when auto-advancing
        _scrollToIndex(state.currentQuestionIndex);
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
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  // Wir nutzen AnimatedBuilder für den Zoom-Effekt basierend auf Scroll-Position
                  setState(() {});
                  return false;
                },
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    vertical: (MediaQuery.of(context).size.height / 2) - (_itemExtent / 2),
                  ),
                  itemCount: state.questionOrder.length,
                  itemExtent: _itemExtent,
                  itemBuilder: (context, index) {
                    final questionId = state.questionOrder[index];
                    final gift = state.gifts.firstWhere(
                      (g) => g.questions.any((q) => q.id == questionId),
                    );
                    final question = gift.questions.firstWhere((q) => q.id == questionId);
                    final score = state.answers[questionId];

                    // Zoom-Berechnung
                    double scale = 0.7;
                    double opacity = 0.4;
                    if (_scrollController.hasClients) {
                      final offset = _scrollController.offset;
                      final itemPosition = index * _itemExtent;
                      final difference = (offset - itemPosition).abs();
                      final normalized = (difference / _itemExtent).clamp(0.0, 1.0);
                      scale = 1.0 - (normalized * 0.3);
                      opacity = 1.0 - (normalized * 0.6);
                    } else if (index == state.currentQuestionIndex) {
                      scale = 1.0;
                      opacity = 1.0;
                    }

                    return Transform.scale(
                      scale: scale,
                      child: Opacity(
                        opacity: opacity.clamp(0.2, 1.0),
                        child: _QuestionCard(
                          question: question,
                          currentScore: score,
                          isFocused: scale > 0.9,
                          onAnswer: (s) {
                            context.read<SpiritualGiftsBloc>().add(
                              AnswerQuestion(questionId: questionId, score: s),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
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
  final bool isFocused;
  final Function(int) onAnswer;

  const _QuestionCard({
    required this.question,
    required this.currentScore,
    required this.isFocused,
    required this.onAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isFocused ? theme.colorScheme.primary : theme.dividerColor.withValues(alpha: 0.3),
          width: isFocused ? 2 : 1,
        ),
        boxShadow: isFocused ? [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ] : null,
      ),
      child: IgnorePointer(
        ignoring: !isFocused,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              question.text,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 24),
            _buildChoiceGrid(context),
          ],
        ),
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
            width: 90,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            decoration: BoxDecoration(
              color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? theme.colorScheme.primary : Colors.transparent,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                const SizedBox(height: 2),
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
