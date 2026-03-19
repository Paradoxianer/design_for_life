import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/spiritual_gifts_bloc.dart';
import '../models/spiritual_gift.dart';

class SpiritualGiftsResult extends StatelessWidget {
  const SpiritualGiftsResult({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<SpiritualGiftsBloc, SpiritualGiftsState>(
      builder: (context, state) {
        final rankedGifts = state.getRankedGifts();
        final scores = state.getScoresPerGift();
        final maxPossibleScore = 35; // 7 Fragen * 5 Punkte

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Deine Gaben-Rangliste',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Tippe auf eine Gabe, um Details und Bibelstellen zu sehen.',
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 24),
              
              ...rankedGifts.asMap().entries.map((entry) {
                final index = entry.key;
                final gift = entry.value;
                final score = scores[gift.id] ?? 0;
                final isTop3 = index < 3;

                return _GiftResultCard(
                  gift: gift,
                  score: score,
                  rank: index + 1,
                  isTop3: isTop3,
                  maxScore: maxPossibleScore,
                );
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

  const _GiftResultCard({
    required this.gift,
    required this.score,
    required this.rank,
    required this.isTop3,
    required this.maxScore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isTop3 
        ? (rank == 1 ? const Color(0xFFFFD700) : (rank == 2 ? const Color(0xFFC0C0C0) : const Color(0xFFCD7F32)))
        : theme.colorScheme.primary.withValues(alpha: 0.1);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isTop3 ? 2 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isTop3 ? color : theme.dividerColor, width: isTop3 ? 2 : 1),
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
                        color: isTop3 ? Colors.black87 : theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      gift.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: isTop3 ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                  Text(
                    '$score Pkt.',
                    style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: (score / maxScore).clamp(0.0, 1.0),
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                color: isTop3 ? color : theme.colorScheme.primary,
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
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
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
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
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                  _Section(title: 'Bedeutung', content: gift.meaning),
                  const SizedBox(height: 24),
                  _Section(title: 'Beschreibung', content: gift.description),
                  const SizedBox(height: 24),
                  Text(
                    'Bibelstellen',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: gift.bibleReferences.map((ref) => ActionChip(
                      label: Text(ref, style: const TextStyle(fontSize: 12)),
                      onPressed: () {
                        // Logic for external link
                      },
                      avatar: const Icon(Icons.menu_book, size: 14),
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    )).toList(),
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
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
        ),
      ],
    );
  }
}
