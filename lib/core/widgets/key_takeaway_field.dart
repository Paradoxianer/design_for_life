import 'package:flutter/material.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';

class KeyTakeawayField extends StatelessWidget {
  final List<String> takeaways;
  final Function(int, String) onUpdate;
  final bool isReadOnly;

  const KeyTakeawayField({
    super.key,
    required this.takeaways,
    required this.onUpdate,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    
    final String titleLabel = l10n.keyTakeaways;
    final String hintLabel = l10n.takeawayHint;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.tertiary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.stars_rounded, color: theme.colorScheme.tertiary),
              const SizedBox(width: 8),
              Text(
                titleLabel,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...List.generate(3, (index) {
            final text = index < takeaways.length ? takeaways[index] : '';
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: isReadOnly
                  ? _buildReadOnlyItem(context, text, index)
                  : _buildEditItem(context, text, index, hintLabel),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildReadOnlyItem(BuildContext context, String text, int index) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${index + 1}. ', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
        Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyLarge)),
      ],
    );
  }

  Widget _buildEditItem(BuildContext context, String text, int index, String hint) {
    return _TakeawayEditField(
      key: ValueKey('takeaway_$index'),
      text: text,
      index: index,
      hint: hint,
      onUpdate: onUpdate,
    );
  }
}

/// Hält einen eigenen [TextEditingController], statt bei jedem Rebuild neu
/// erzeugt zu werden (wie zuvor in KeyTakeawayField._buildEditItem) - das
/// sprang den Cursor nach jedem Tastendruck ans Textende und konnte bei
/// verschachtelten Rebuilds sogar den Fokus verlieren (#58).
class _TakeawayEditField extends StatefulWidget {
  final String text;
  final int index;
  final String hint;
  final Function(int, String) onUpdate;

  const _TakeawayEditField({
    super.key,
    required this.text,
    required this.index,
    required this.hint,
    required this.onUpdate,
  });

  @override
  State<_TakeawayEditField> createState() => _TakeawayEditFieldState();
}

class _TakeawayEditFieldState extends State<_TakeawayEditField> {
  late final TextEditingController _controller = TextEditingController(text: widget.text);
  late final FocusNode _focusNode = FocusNode()..addListener(_onFocusChange);

  void _onFocusChange() {
    // Nur synchronisieren, wenn das Feld nicht fokussiert ist, damit externe
    // State-Updates während des Tippens den Cursor nicht verspringen lassen.
    if (!_focusNode.hasFocus && _controller.text != widget.text) {
      _controller.text = widget.text;
    }
  }

  @override
  void didUpdateWidget(_TakeawayEditField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_focusNode.hasFocus && widget.text != _controller.text) {
      _controller.text = widget.text;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      decoration: InputDecoration(
        hintText: widget.hint,
        prefixText: '${widget.index + 1}. ',
        border: InputBorder.none,
      ),
      style: Theme.of(context).textTheme.bodyLarge,
      onChanged: (value) => widget.onUpdate(widget.index, value),
    );
  }
}
