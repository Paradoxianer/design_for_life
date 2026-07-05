import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../../../core/widgets/dfl_module_editor.dart';
import '../../../core/widgets/image_fullscreen_viewer.dart';
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
    final l10n = AppLocalizations.of(context);
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
              label: l10n.imagineLabelPast,
              subtitle: l10n.imagineSubtitlePast,
              icon: Icons.history_rounded,
              options: options,
              selectedId: selectedPastId,
              onSelect: (id) => context.read<ImagineBloc>().add(
                    SelectPastImage(sessionId, id),
                  ),
            ),
            const SizedBox(height: 24),
            _OptionSection(
              label: l10n.imagineLabelFuture,
              subtitle: l10n.imagineSubtitleFuture,
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
  void _showFullscreenCarousel(
      BuildContext context, {
        required List<ImagineVisualOption> options,
        required int initialIndex,
        required String? selectedId,
        required ValueChanged<String> onSelect,
      }) {
    showDialog(
      context: context,
      barrierColor: Colors.black,
      builder: (_) => _FullscreenCarouselDialog(
        options: options,
        initialIndex: initialIndex,
        selectedId: selectedId,
        onSelect: onSelect,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shuffledOptions = List<ImagineVisualOption>.from(options)
      ..shuffle(Random(label.hashCode));
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
              itemCount: shuffledOptions.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final option = shuffledOptions[index];
                final isSelected = option.id == selectedId;
                return GestureDetector(
                  key: ValueKey(option.id),
                  onTap: () => onSelect(option.id),
                  child: _OptionCard(
                    option: option,
                    selected: isSelected,

                    onFullscreen: () {
                      _showFullscreenCarousel(
                        context,
                        options: shuffledOptions,
                        initialIndex: index,
                        selectedId: selectedId,
                        onSelect: onSelect,
                      );
                    },
                  ),
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
  final VoidCallback onFullscreen;

  const _OptionCard({
    required this.option,
    required this.selected,
    required this.onFullscreen,
  });

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
            Positioned(
              bottom: 4,
              right: 4,
              child: GestureDetector(
                onTap: onFullscreen,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.fullscreen,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FullscreenCarouselDialog extends StatefulWidget {
  final List<ImagineVisualOption> options;
  final int initialIndex;
  final String? selectedId;
  final ValueChanged<String> onSelect;

  const _FullscreenCarouselDialog({
    required this.options,
    required this.initialIndex,
    required this.selectedId,
    required this.onSelect,
  });

  @override
  State<_FullscreenCarouselDialog> createState() =>
      _FullscreenCarouselDialogState();
}

class _FullscreenCarouselDialogState
    extends State<_FullscreenCarouselDialog> {
  late final PageController _controller;
  late int _currentIndex;
  late String? currentSelectedId;

  @override
  @override
  void initState() {
    super.initState();

    _currentIndex = widget.initialIndex;

    currentSelectedId = widget.selectedId;

    _controller = PageController(
      initialPage: _currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final option = widget.options[_currentIndex];
    final selected = option.id == currentSelectedId;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.options.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
              itemBuilder: (context, index) {
                final imageOption = widget.options[index];
                final selected = imageOption.id == currentSelectedId;

                return Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      InteractiveViewer(
                        minScale: 1,
                        maxScale: 4,
                        child: Image.asset(
                          imageOption.imagePath,
                          fit: BoxFit.contain,
                        ),
                      ),

                      Positioned(
                        top: 20,
                        right: 20,
                        child: GestureDetector(
                          onTap: () {
                            final isAlreadySelected =
                                currentSelectedId == imageOption.id;

                            if (isAlreadySelected) {
                              setState(() {
                                currentSelectedId = null;
                              });

                              // Falls dein Bloc "keine Auswahl" unterstützt:
                              // widget.onSelect('');
                            } else {
                              widget.onSelect(imageOption.id);

                              setState(() {
                                currentSelectedId = imageOption.id;
                              });
                            }
                          },
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                              selected ? Colors.green : Colors.black87,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            child: selected
                                ? const Icon(
                              Icons.check,
                              color: Colors.white,
                            )
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
          ),

          Positioned(
            top: 40,
            right: 16,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.white,
                size: 32,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),

          /*Positioned(
            top: 40,
            right: 16,
            child: GestureDetector(
              onTap: () {
                widget.onSelect(option.id);

                setState(() {});
              },
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected
                      ? Colors.green
                      : Colors.black87,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: selected
                    ? const Icon(Icons.check, color: Colors.white)
                    : null,
              ),
            ),
          ),*/

          Positioned(
            left: 12,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                iconSize: 42,
                color: Colors.white,
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  if (_currentIndex > 0) {
                    _controller.previousPage(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                    );
                  }
                },
              ),
            ),
          ),

          Positioned(
            right: 12,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                iconSize: 42,
                color: Colors.white,
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  if (_currentIndex < widget.options.length - 1) {
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                    );
                  }
                },
              ),
            ),
          ),

          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                '${_currentIndex + 1} / ${widget.options.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}