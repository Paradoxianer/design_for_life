import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../bloc/spiritual_gifts_bloc.dart';
import 'gift_question_card.dart';

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
              final target = (state.currentQuestionIndex > 0) 
                  ? state.currentQuestionIndex - 1 
                  : 0;
              _carouselController.animateToItem(
                target,
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
        final scrollTarget = (state.currentQuestionIndex > 0) 
            ? state.currentQuestionIndex - 1 
            : 0;
            
        _carouselController.animateToItem(
          scrollTarget,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      },
      builder: (context, state) {
        if (!state.isLoaded || state.questionOrder.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(AppLocalizations.of(context).giftsLoading),
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
                    minHeight: 6,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizations.of(context).giftsQuestionCounter(state.answers.length, state.questionOrder.length),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
            Expanded(
              child: CarouselView(
                controller: _carouselController,
                scrollDirection: Axis.vertical,
                itemExtent: 150,
                shrinkExtent: 120,
                enableSplash: false,
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
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

                  return GiftQuestionCard(
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
