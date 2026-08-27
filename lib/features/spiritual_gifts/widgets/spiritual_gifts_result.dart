import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';

import '../../../core/services/bible_reference_service.dart';
import '../../../core/services/share_service.dart';
import '../bloc/spiritual_gifts_bloc.dart';
import '../models/spiritual_gift.dart';
import '../services/gift_reference_link_service.dart';

class SpiritualGiftsResult extends StatefulWidget {
  const SpiritualGiftsResult({super.key});

  @override
  State<SpiritualGiftsResult> createState() => _SpiritualGiftsResultState();
}

class _SpiritualGiftsResultState extends State<SpiritualGiftsResult> {
  // Nur relevant, sobald mind. eine Referenz importiert wurde (#42) - vorher
  // ist Gesamt==Eigene und die Auswahl wäre wirkungslos.
  GiftScoreMetric _sortMetric = GiftScoreMetric.blended;

  void _inviteReference(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final assessmentId = 'ref_${DateTime.now().microsecondsSinceEpoch}';
    context.read<SpiritualGiftsBloc>().add(IssueReferenceInvite(assessmentId));
    final link = GiftReferenceLinkService.buildInviteLink(assessmentId);
    final shareText = l10n.giftsReferenceInviteShareText(link);

    // Als Dialog statt direkt Share.share(...), damit der Link auch sichtbar
    // ist, wenn kein natives Share-Sheet zur Verfügung steht (z.B. beim
    // Testen via "flutter run -d chrome") - Kopieren funktioniert überall.
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.giftsReferenceInviteButton),
        content: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(dialogContext).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: SelectableText(
            link,
            style: Theme.of(dialogContext).textTheme.bodySmall,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () async {
              await ShareService.copyToClipboard(shareText);
              if (!dialogContext.mounted) return;
              ScaffoldMessenger.of(dialogContext).showSnackBar(
                SnackBar(content: Text(l10n.giftsReferenceLinkCopied)),
              );
            },
            icon: const Icon(Icons.copy_outlined, size: 18),
            label: Text(l10n.giftsReferenceCopyLink),
          ),
          TextButton.icon(
            onPressed: () => Share.share(shareText),
            icon: const Icon(Icons.share_outlined, size: 18),
            label: Text(l10n.share),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.finish),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<SpiritualGiftsBloc, SpiritualGiftsState>(
      builder: (context, state) {
        final hasReferences = state.hasReferences;
        final rankedGifts = hasReferences
            ? state.getRankedGiftsByMetric(_sortMetric)
            : state.getRankedGifts();
        final scores = state.getScoresPerGift();
        final maxPossibleScore = 35; // 7 Fragen * 5 Punkte

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.giftsRankingTitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.giftsRankingGuidance,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              // Bewusst in der bereits etablierten "Highlight"-Akzentfarbe
              // (tertiary/sunlightGold, sonst z.B. für Rang 1 verwendet)
              // statt einem schlichten Outline-Button - diese Aktion soll
              // auffallen, nicht wie eine Nebensache wirken.
              FilledButton.icon(
                onPressed: () => _inviteReference(context),
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.tertiary,
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                ),
                icon: const Icon(Icons.person_add_alt_1, size: 20),
                label: Text(
                  l10n.giftsReferenceInviteButton,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              if (hasReferences) ...[
                const SizedBox(height: 16),
                Text(l10n.giftsSortBy, style: theme.textTheme.labelMedium),
                const SizedBox(height: 4),
                SegmentedButton<GiftScoreMetric>(
                  segments: [
                    ButtonSegment(
                      value: GiftScoreMetric.blended,
                      label: Text(l10n.giftsColumnTotal),
                    ),
                    ButtonSegment(
                      value: GiftScoreMetric.self,
                      label: Text(l10n.giftsColumnSelf),
                    ),
                    ButtonSegment(
                      value: GiftScoreMetric.reference,
                      label: Text(l10n.giftsColumnReference),
                    ),
                  ],
                  selected: {_sortMetric},
                  onSelectionChanged: (selection) =>
                      setState(() => _sortMetric = selection.first),
                ),
              ],
              const SizedBox(height: 24),

              ...rankedGifts.asMap().entries.expand((entry) {
                final index = entry.key;
                final gift = entry.value;
                final score = scores[gift.id] ?? 0;
                final isTop3 = index < 3;

                return [
                  // Kurzer Abstand + eigene Überschrift zwischen den drei
                  // Hauptgaben und den "latenten" Gaben (Rang 4-6), damit die
                  // beiden Gruppen klar unterscheidbar sind (#59).
                  if (index == 3) ...[
                    const SizedBox(height: 20),
                    Text(
                      l10n.giftsDormantHeading,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.giftsDormantGuidance,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  // Es gibt insgesamt deutlich mehr als 6 Gaben (aktuell 18) -
                  // ohne eigenen Abschluss lief die "Latente Gaben"-Sektion ab
                  // Rang 7 optisch undifferenziert weiter, kaum vom Ende der
                  // eigentlich nur 3 latenten Gaben (Rang 4-6) zu unterscheiden.
                  if (index == 6) ...[
                    const SizedBox(height: 20),
                    Text(
                      l10n.giftsOtherHeading,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  _GiftResultCard(
                    gift: gift,
                    score: score,
                    rank: index + 1,
                    isTop3: isTop3,
                    maxScore: maxPossibleScore,
                    hasReferences: hasReferences,
                    selfPercent: state.getSelfScorePercent(gift),
                    referencePercent: state.getReferenceMeanPercent(gift),
                    blendedPercent: state.getBlendedScorePercent(gift),
                  ),
                ];
              }),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }
}

class _GiftResultCard extends StatelessWidget {
  final SpiritualGift gift;
  final int score;
  final int rank;
  final bool isTop3;
  final int maxScore;
  final bool hasReferences;
  final double selfPercent;
  final double? referencePercent;
  final double blendedPercent;

  const _GiftResultCard({
    required this.gift,
    required this.score,
    required this.rank,
    required this.isTop3,
    required this.maxScore,
    required this.hasReferences,
    required this.selfPercent,
    required this.referencePercent,
    required this.blendedPercent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final color = isTop3
        ? (rank == 1
              ? const Color(0xFFFFD700)
              : (rank == 2 ? const Color(0xFFC0C0C0) : const Color(0xFFCD7F32)))
        : theme.colorScheme.primary.withValues(alpha: 0.1);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isTop3 ? 2 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isTop3 ? color : theme.dividerColor,
          width: isTop3 ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () => _showDetails(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$rank',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isTop3
                            ? Colors.black87
                            : theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      gift.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: isTop3
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                  Text(
                    hasReferences
                        ? '${blendedPercent.round()}%'
                        : l10n.giftsScorePoints(score),
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: hasReferences
                    ? (blendedPercent / 100).clamp(0.0, 1.0)
                    : (score / maxScore).clamp(0.0, 1.0),
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                color: isTop3 ? color : theme.colorScheme.primary,
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
              // Eigene/Fremd-Aufschlüsselung nur sobald mind. eine Referenz
              // importiert wurde (#42) - vorher wäre sie redundant, da
              // Gesamt==Eigene ist.
              if (hasReferences) ...[
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${l10n.giftsColumnSelf}: ${selfPercent.round()}%',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${l10n.giftsColumnReference}: ${(referencePercent ?? 0).round()}%',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
              // Kurzbeschreibung direkt sichtbar nur für die drei Hauptgaben
              // (#59) - für die restlichen bleibt es beim Antippen für Details.
              if (isTop3 && gift.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    gift.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _GiftDetailSheet(gift: gift),
    );
  }
}

class _GiftDetailSheet extends StatelessWidget {
  final SpiritualGift gift;

  const _GiftDetailSheet({required this.gift});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 8, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      gift.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                children: [
                  if (gift.originalWord.isNotEmpty) ...[
                    Text(
                      gift.originalWord,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  _Section(
                    title: AppLocalizations.of(context).giftsMeaning,
                    content: gift.meaning,
                  ),
                  const SizedBox(height: 24),
                  _Section(
                    title: AppLocalizations.of(context).giftsDescription,
                    content: gift.description,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    AppLocalizations.of(context).giftsBibleReferences,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: gift.bibleReferences
                        .map(
                          (ref) => ActionChip(
                            label: Text(
                              ref,
                              style: const TextStyle(fontSize: 12),
                            ),
                            onPressed: () =>
                                BibleReferenceService.open(context, ref),
                            avatar: const Icon(Icons.menu_book, size: 14),
                            backgroundColor:
                                theme.colorScheme.surfaceContainerHighest,
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String content;

  const _Section({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(content, style: theme.textTheme.bodyLarge?.copyWith(height: 1.5)),
      ],
    );
  }
}
