import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/dfl_entry.dart';

class DflEntryWidget extends StatefulWidget {
  final DflEntry entry;
  final String hintText;
  final Function(String) onTextChanged;
  final Function(String?) onImageChanged;
  final VoidCallback onToggleCompleted;

  const DflEntryWidget({
    super.key,
    required this.entry,
    this.hintText = 'Schreibe hier...',
    required this.onTextChanged,
    required this.onImageChanged,
    required this.onToggleCompleted,
  });

  @override
  State<DflEntryWidget> createState() => _DflEntryWidgetState();
}

class _DflEntryWidgetState extends State<DflEntryWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.entry.text);
  }

  @override
  void didUpdateWidget(DflEntryWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.entry.text != widget.entry.text && _controller.text != widget.entry.text) {
      _controller.text = widget.entry.text;
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
    final isDone = widget.entry.isCompleted;
    final hasContent = widget.entry.text.trim().isNotEmpty || widget.entry.imagePath != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDone 
            ? theme.colorScheme.primaryContainer.withOpacity(0.3) 
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDone 
              ? theme.colorScheme.primary.withOpacity(0.5) 
              : theme.colorScheme.outline.withOpacity(0.2),
          width: isDone ? 2 : 1,
        ),
        boxShadow: isDone ? [] : [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  onChanged: widget.onTextChanged,
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
                        : (hasContent ? Colors.green.withOpacity(0.7) : Colors.grey.withOpacity(0.5)),
                    onPressed: () {
                      if (hasContent || isDone) widget.onToggleCompleted();
                    },
                  ),
                  if (!isDone)
                    IconButton(
                      icon: const Icon(Icons.add_a_photo_outlined),
                      onPressed: () async {
                        final picker = ImagePicker();
                        final image = await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) widget.onImageChanged(image.path);
                      },
                    ),
                ],
              ),
            ],
          ),
          if (widget.entry.imagePath != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  _buildImage(widget.entry.imagePath!),
                  if (!isDone)
                    Positioned(
                      right: 8, top: 8,
                      child: GestureDetector(
                        onTap: () => widget.onImageChanged(null),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                          child: const Icon(Icons.close, color: Colors.white, size: 16),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
          if (widget.entry.metadata != null) ...[
            const SizedBox(height: 8),
            Text(
              widget.entry.metadata!,
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
    return kIsWeb 
        ? Image.network(path, width: double.infinity, height: 200, fit: BoxFit.cover)
        : Image.file(File(path), width: double.infinity, height: 200, fit: BoxFit.cover);
  }
}
