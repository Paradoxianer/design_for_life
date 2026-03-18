import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/models/dfl_entry.dart';

class PrayerImpressionEntry extends StatefulWidget {
  final DflEntry impression;
  final Function(String) onTextChanged;
  final Function(String?) onImageChanged;
  final VoidCallback? onDelete;

  const PrayerImpressionEntry({
    super.key,
    required this.impression,
    required this.onTextChanged,
    required this.onImageChanged,
    this.onDelete,
  });

  @override
  State<PrayerImpressionEntry> createState() => _PrayerImpressionEntryState();
}

class _PrayerImpressionEntryState extends State<PrayerImpressionEntry> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.impression.text);
  }

  @override
  void didUpdateWidget(PrayerImpressionEntry oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.impression.text != widget.impression.text && _controller.text != widget.impression.text) {
      _controller.text = widget.impression.text;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    maxLines: null,
                    minLines: 2,
                    style: theme.textTheme.bodyLarge,
                    decoration: const InputDecoration(
                      hintText: 'Schreibe deinen Eindruck...',
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                    onChanged: widget.onTextChanged,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (widget.onDelete != null)
                      IconButton(
                        icon: const Icon(Icons.close, size: 20, color: Colors.black54),
                        onPressed: widget.onDelete,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        visualDensity: VisualDensity.compact,
                      ),
                    IconButton(
                      icon: const Icon(Icons.add_a_photo_outlined, size: 22),
                      onPressed: () async {
                        final picker = ImagePicker();
                        final image = await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          widget.onImageChanged(image.path);
                        }
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (widget.impression.imagePath != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  _buildImage(widget.impression.imagePath!),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: GestureDetector(
                      onTap: () {
                        widget.onImageChanged(null);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImage(String path) {
    if (kIsWeb) {
      return Image.network(path, width: double.infinity, height: 200, fit: BoxFit.cover);
    } else {
      return Image.file(File(path), width: double.infinity, height: 200, fit: BoxFit.cover);
    }
  }
}
