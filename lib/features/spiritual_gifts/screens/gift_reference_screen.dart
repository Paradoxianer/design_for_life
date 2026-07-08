import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';

import '../../../core/services/share_service.dart';
import '../bloc/gift_reference_answer_bloc.dart';
import '../bloc/spiritual_gifts_bloc.dart';
import '../models/gift_question.dart';
import '../repositories/gifts_repository.dart';
import '../services/gift_reference_link_service.dart';
import '../widgets/gift_question_card.dart';

/// Standalone screen for the external "Referenz" (R) assessment mini-flow
/// (#42), opened via a dfl://open?flow=gift-reference deep link. Reached by
/// someone who was invited to assess another person's spiritual gifts - it
/// intentionally does NOT touch that reviewer's own SpiritualGiftsBloc/
/// self-assessment (see GiftReferenceAnswerBloc), and isn't part of the
/// normal timeline/module scaffold.
class GiftReferenceScreen extends StatefulWidget {
  final String assessmentId;

  const GiftReferenceScreen({super.key, required this.assessmentId});

  @override
  State<GiftReferenceScreen> createState() => _GiftReferenceScreenState();
}

class _GiftReferenceScreenState extends State<GiftReferenceScreen> {
  final GiftsRepository _repository = GiftsRepository();
  final TextEditingController _nameController = TextEditingController();
  List<GiftQuestion>? _questionOrder;
  bool _loadFailed = false;
  // Gesetzt sobald abgeschickt (#42) - zeigt den fertigen Link zum
  // Kopieren/Teilen an statt sofort wegzunavigieren, da native Share-Sheets
  // auf Desktop/Web keinen zuverlässigen Weg bieten, den Link tatsächlich zu
  // sehen (z.B. beim Testen via "flutter run -d chrome").
  String? _resultLink;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadQuestions());
  }

  Future<void> _loadQuestions() async {
    if (!mounted) return;
    final locale = Localizations.localeOf(context).languageCode;
    final gifts = await _repository.loadGifts(locale);
    if (!mounted) return;
    setState(() {
      _loadFailed = gifts.isEmpty;
      _questionOrder = SpiritualGiftsState(
        gifts: gifts,
      ).getReferenceQuestionOrder();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit(
    BuildContext context,
    List<GiftQuestion> questionOrder,
    Map<String, int> answers,
  ) {
    final link = GiftReferenceLinkService.buildResultLink(
      assessmentId: widget.assessmentId,
      questionOrder: questionOrder,
      answers: answers,
      label: _nameController.text.trim(),
    );

    context.read<GiftReferenceAnswerBloc>().add(
      ClearReferenceAssessment(widget.assessmentId),
    );
    setState(() => _resultLink = link);
  }

  Future<void> _copyResultLink(BuildContext context, String link) async {
    final l10n = AppLocalizations.of(context);
    await ShareService.copyToClipboard(l10n.giftsReferenceShareText(link));
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.giftsReferenceLinkCopied)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final questionOrder = _questionOrder;
    final resultLink = _resultLink;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.giftsReferenceScreenTitle)),
      body: resultLink != null
          ? _buildDoneView(context, resultLink)
          : questionOrder == null
          ? const Center(child: CircularProgressIndicator())
          : _loadFailed
          ? Center(child: Text(l10n.giftsReferenceLoadFailed))
          : BlocBuilder<GiftReferenceAnswerBloc, GiftReferenceAnswerState>(
              builder: (context, state) {
                final answers = state.answersFor(widget.assessmentId);
                final allAnswered = answers.length >= questionOrder.length;

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: Column(
                        children: [
                          LinearProgressIndicator(
                            value: questionOrder.isEmpty
                                ? 0
                                : answers.length / questionOrder.length,
                            backgroundColor: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                            minHeight: 6,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.giftsQuestionCounter(
                              answers.length,
                              questionOrder.length,
                            ),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          Text(
                            l10n.giftsReferenceIntro,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: l10n.giftsReferenceNameLabel,
                              hintText: l10n.giftsReferenceNameHint,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          for (final question in questionOrder)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: GiftQuestionCard(
                                question: question,
                                currentScore: answers[question.id],
                                isReadOnly: false,
                                onAnswer: (score) =>
                                    context.read<GiftReferenceAnswerBloc>().add(
                                      AnswerReferenceQuestion(
                                        assessmentId: widget.assessmentId,
                                        questionId: question.id,
                                        score: score,
                                      ),
                                    ),
                              ),
                            ),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: allAnswered
                              ? () => _submit(context, questionOrder, answers)
                              : null,
                          child: Text(l10n.giftsReferenceSubmitButton),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildDoneView(BuildContext context, String link) {
    final l10n = AppLocalizations.of(context);
    final shareText = l10n.giftsReferenceShareText(link);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.giftsReferenceDoneTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.giftsReferenceDoneMessage,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(link, style: Theme.of(context).textTheme.bodySmall),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              alignment: WrapAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _copyResultLink(context, link),
                  icon: const Icon(Icons.copy_outlined, size: 18),
                  label: Text(l10n.giftsReferenceCopyLink),
                ),
                OutlinedButton.icon(
                  onPressed: () => Share.share(shareText),
                  icon: const Icon(Icons.share_outlined, size: 18),
                  label: Text(l10n.giftsReferenceSubmitButton),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: Text(l10n.finish),
            ),
          ],
        ),
      ),
    );
  }
}
