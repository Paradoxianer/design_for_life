import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/models/dfl_entry.dart';

class PrayerImpressionEntry extends StatefulWidget {
  final DflEntry impression;
  final Function(String) onTextChanged;
  final Function(String?) onImageChanged;
  final VoidCallback onToggleCompleted;

  const PrayerImpressionEntry({
    super.key,
    required this.impression,
    required this.onTextChanged,
    required this.onImageChanged,
    required this.onToggleCompleted,
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
    final isDone = widget.impression.isCompleted;
    final hasContent = widget.impression.text.trim().isNotEmpty || widget.impression.imagePath != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDone 
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3) 
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDone 
              ? theme.colorScheme.primary.withValues(alpha: 0.5) 
              : theme.colorScheme.outline.withValues(alpha: 0.2),
          width: isDone ? 2 : 1,
        ),
        boxShadow: isDone ? [] : [
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  enabled: !isDone,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: isDone ? theme.colorScheme.onSurfaceVariant : null,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Schreibe deinen Eindruck...',
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                  ),
                  onChanged: (val) {
                    widget.onTextChanged(val);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  IconButton(
                    icon: Icon(
                      isDone ? Icons.check_circle : Icons.check_circle_outline,
                      size: 28,
                    ),
                    color: isDone 
                        ? Colors.green 
                        : (hasContent ? Colors.green.withValues(alpha: 0.7) : Colors.grey.withValues(alpha: 0.5)),
                    onPressed: () {
                      if (hasContent || isDone) {
                        widget.onToggleCompleted();
                      }
                    },
                  ),
                  if (!isDone)
                    IconButton(
                      icon: const Icon(Icons.add_a_photo_outlined),
                      onPressed: () async {
                        final picker = ImagePicker();
                        final image = await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          widget.onImageChanged(image.path);
                        }
                      },
                    ),
                ],
              ),
            ],
          ),
          if (widget.impression.imagePath != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  _buildImage(widget.impression.imagePath!),
                  if (!isDone)
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
          if (widget.impression.metadata != null && widget.impression.metadata!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              widget.impression.metadata!,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.secondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImage(String path) {
    if (kIsWeb) {
      return Image.network(
        path,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
      );
    } else {
      return Image.file(
        File(path),
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
      );
    }
  }
}
