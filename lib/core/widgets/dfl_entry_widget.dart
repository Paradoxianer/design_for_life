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
  final VoidCallback? onDelete;

  const DflEntryWidget({
    super.key,
    required this.entry,
    this.hintText = 'Schreibe hier...',
    required this.onTextChanged,
    required this.onImageChanged,
    this.onDelete,
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

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      maxLines: null,
                      minLines: 2, // Garantiert Platz für beide Icons
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      onChanged: widget.onTextChanged,
                    ),
                  ),
                  const SizedBox(width: 4),
                  SizedBox(
                    width: 40,
                    child: IconButton(
                      icon: const Icon(Icons.add_a_photo_outlined),
                      onPressed: () async {
                        final picker = ImagePicker();
                        final image = await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) widget.onImageChanged(image.path);
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
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
            ],
          ),
        ),
        if (widget.onDelete != null)
          Positioned(
            right: 4,
            top: 4,
            child: IconButton(
              onPressed: widget.onDelete,
              padding: EdgeInsets.zero, // Hitbox verkleinern
              constraints: const BoxConstraints(),
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.1)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                    )
                  ],
                ),
                child: const Icon(Icons.close, size: 14, color: Colors.black87),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildImage(String path) {
    return kIsWeb 
        ? Image.network(path, width: double.infinity, height: 200, fit: BoxFit.cover)
        : Image.file(File(path), width: double.infinity, height: 200, fit: BoxFit.cover);
  }
}
