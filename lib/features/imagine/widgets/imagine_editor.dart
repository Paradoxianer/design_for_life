import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/dfl_module_editor.dart';
import '../bloc/imagine_bloc.dart';

// ignore: avoid_positional_boolean_parameters
void _noOp(int i, String v) {}

class ImagineEditor extends DflModuleEditor {
  final String sessionId;
  final String? selectedPastUrl;
  final String? selectedFutureUrl;

  const ImagineEditor({
    super.key,
    required this.sessionId,
    this.selectedPastUrl,
    this.selectedFutureUrl,
  }) : super(takeaways: const [], onUpdate: _noOp, showTakeaways: false);

  @override
  Widget buildContent(BuildContext context) {
    return _ImagineEditorBody(
      sessionId: sessionId,
      selectedPastId: selectedPastUrl,
      selectedFutureId: selectedFutureUrl,
    );
  }
}

class _ImagineEditorBody extends StatelessWidget {
  final String sessionId;
  final String? selectedPastId;
  final String? selectedFutureId;

  const _ImagineEditorBody({
    required this.sessionId,
    this.selectedPastId,
    this.selectedFutureId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _OptionSection(
          label: 'Vergangenheit',
          subtitle: 'Wähle ein abstraktes Bild für deine Vergangenheit',
          icon: Icons.history_rounded,
          options: _pastOptions,
          selectedId: selectedPastId,
          onSelect: (id) => context.read<ImagineBloc>().add(
                SelectPastImage(sessionId, id),
              ),
        ),
        const SizedBox(height: 24),
        _OptionSection(
          label: 'Zukunft',
          subtitle: 'Wähle ein abstraktes Bild für deine Zukunft',
          icon: Icons.auto_awesome_rounded,
          options: _futureOptions,
          selectedId: selectedFutureId,
          onSelect: (id) => context.read<ImagineBloc>().add(
                SelectFutureImage(sessionId, id),
              ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _OptionSection extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final List<ImagineVisualOption> options;
  final String? selectedId;
  final ValueChanged<String> onSelect;

  const _OptionSection({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.options,
    this.selectedId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(label, style: theme.textTheme.titleMedium),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: theme.textTheme.bodySmall
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 152,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: options.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final option = options[index];
              final isSelected = option.id == selectedId;
              return GestureDetector(
                onTap: () => onSelect(option.id),
                child: _OptionCard(option: option, selected: isSelected),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _OptionCard extends StatelessWidget {
  final ImagineVisualOption option;
  final bool selected;

  const _OptionCard({required this.option, required this.selected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 166,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected ? theme.colorScheme.primary : Colors.transparent,
          width: 3,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: option.colors,
                ),
              ),
            ),
            Positioned(
              left: 8,
              bottom: 8,
              right: 8,
              child: Text(
                option.label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  shadows: const [Shadow(blurRadius: 4, color: Colors.black54)],
                ),
              ),
            ),
            if (selected)
              Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: theme.colorScheme.primary,
                  child: const Icon(Icons.check, size: 14, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ImagineVisualOption {
  final String id;
  final String label;
  final List<Color> colors;

  const ImagineVisualOption({
    required this.id,
    required this.label,
    required this.colors,
  });
}

const List<ImagineVisualOption> _pastOptions = [
  ImagineVisualOption(
    id: 'past_roots',
    label: 'Wurzeln & Herkunft',
    colors: [Color(0xFF4E342E), Color(0xFF8D6E63), Color(0xFFBCAAA4)],
  ),
  ImagineVisualOption(
    id: 'past_stones',
    label: 'Erfahrung & Beständigkeit',
    colors: [Color(0xFF37474F), Color(0xFF607D8B), Color(0xFF90A4AE)],
  ),
  ImagineVisualOption(
    id: 'past_valley',
    label: 'Lernen in Tiefen',
    colors: [Color(0xFF1A237E), Color(0xFF3949AB), Color(0xFF7986CB)],
  ),
  ImagineVisualOption(
    id: 'past_warm_memory',
    label: 'Warme Erinnerungen',
    colors: [Color(0xFF6D4C41), Color(0xFFA1887F), Color(0xFFD7CCC8)],
  ),
  ImagineVisualOption(
    id: 'past_growth',
    label: 'Wachstum im Rückblick',
    colors: [Color(0xFF1B5E20), Color(0xFF43A047), Color(0xFF81C784)],
  ),
];

const List<ImagineVisualOption> _futureOptions = [
  ImagineVisualOption(
    id: 'future_horizon',
    label: 'Neuer Horizont',
    colors: [Color(0xFF0D47A1), Color(0xFF1976D2), Color(0xFF64B5F6)],
  ),
  ImagineVisualOption(
    id: 'future_light',
    label: 'Licht & Klarheit',
    colors: [Color(0xFFF9A825), Color(0xFFFFCA28), Color(0xFFFFF59D)],
  ),
  ImagineVisualOption(
    id: 'future_path',
    label: 'Weg & Richtung',
    colors: [Color(0xFF4A148C), Color(0xFF7B1FA2), Color(0xFFBA68C8)],
  ),
  ImagineVisualOption(
    id: 'future_peace',
    label: 'Frieden & Weite',
    colors: [Color(0xFF00695C), Color(0xFF26A69A), Color(0xFF80CBC4)],
  ),
  ImagineVisualOption(
    id: 'future_bloom',
    label: 'Aufbruch & Entfaltung',
    colors: [Color(0xFFAD1457), Color(0xFFEC407A), Color(0xFFF48FB1)],
  ),
];
