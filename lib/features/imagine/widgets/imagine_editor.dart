import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/dfl_module_editor.dart';
import '../../../core/widgets/key_takeaway_field.dart';
import '../bloc/imagine_bloc.dart';
import '../models/imagine_visual_option.dart';

// ignore: avoid_positional_boolean_parameters
void _noOp(int i, String v) {}

class ImagineEditor extends DflModuleEditor {
  final String sessionId;
  final String? selectedPastId;
  final String? selectedFutureId;
  final List<String> takeaways;

  const ImagineEditor({
    super.key,
    required this.sessionId,
    required this.takeaways,
    this.selectedPastId,
    this.selectedFutureId,
  }) : super(takeaways: const [], onUpdate: _noOp, showTakeaways: false);

  @override
  Widget buildContent(BuildContext context) {
    return _ImagineEditorBody(
      sessionId: sessionId,
      selectedPastId: selectedPastId,
      selectedFutureId: selectedFutureId,
      takeaways: takeaways,
    );
  }
}

class _ImagineEditorBody extends StatelessWidget {
  final String sessionId;
  final String? selectedPastId;
  final String? selectedFutureId;
  final List<String> takeaways;

  const _ImagineEditorBody({
    required this.sessionId,
    required this.takeaways,
    this.selectedPastId,
    this.selectedFutureId,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ImagineVisualOption>>(
      future: loadImagineOptions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        final options = snapshot.data ?? [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _OptionSection(
              label: 'Vergangenheit',
              subtitle: 'Wähle ein Bild für deine Vergangenheit',
              icon: Icons.history_rounded,
              options: options,
              selectedId: selectedPastId,
              onSelect: (id) => context.read<ImagineBloc>().add(
                    SelectPastImage(sessionId, id),
                  ),
            ),
            const SizedBox(height: 24),
            _OptionSection(
              label: 'Zukunft',
              subtitle: 'Wähle ein Bild für deine Zukunft',
              icon: Icons.auto_awesome_rounded,
              options: options,
              selectedId: selectedFutureId,
              onSelect: (id) => context.read<ImagineBloc>().add(
                    SelectFutureImage(sessionId, id),
                  ),
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            KeyTakeawayField(
              takeaways: takeaways,
              onUpdate: (index, value) => context.read<ImagineBloc>().add(
                    UpdateImagineTakeaway(sessionId, index, value),
                  ),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
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
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
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
      width: 102,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected ? theme.colorScheme.primary : Colors.transparent,
          width: 3,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              option.imagePath,
              fit: BoxFit.cover,
            ),
            if (selected)
              Positioned(
                top: 6,
                right: 6,
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

