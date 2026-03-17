import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/prayer_impression.dart';

class PrayerImpressionEntry extends StatelessWidget {
  final PrayerImpression impression;
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: impression.isCompleted 
            ? theme.colorScheme.surfaceVariant.withOpacity(0.5) 
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: impression.isCompleted 
              ? Colors.transparent 
              : theme.colorScheme.outline.withOpacity(0.2),
        ),
        boxShadow: impression.isCompleted ? [] : [
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
              // Text Area (Embossed Look)
              Expanded(
                child: TextField(
                  controller: TextEditingController(text: impression.text)
                    ..selection = TextSelection.fromPosition(
                      TextPosition(offset: impression.text.length),
                    ),
                  maxLines: null,
                  enabled: !impression.isCompleted,
                  decoration: InputDecoration(
                    hintText: 'Schreibe deinen Eindruck...',
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  onChanged: onTextChanged,
                ),
              ),
              const SizedBox(width: 8),
              // Action Column (Photo & Check)
              Column(
                children: [
                  IconButton(
                    icon: Icon(
                      impression.isCompleted 
                          ? Icons.check_circle 
                          : Icons.check_circle_outline,
                      color: impression.isCompleted 
                          ? Colors.green 
                          : theme.colorScheme.primary.withOpacity(0.5),
                    ),
                    onPressed: onToggleCompleted,
                  ),
                  if (!impression.isCompleted)
                    IconButton(
                      icon: const Icon(Icons.add_a_photo_outlined),
                      onPressed: () async {
                        final picker = ImagePicker();
                        final image = await picker.pickImage(source: ImageSource.camera);
                        if (image != null) {
                          onImageChanged(image.path);
                        }
                      },
                    ),
                ],
              ),
            ],
          ),
          if (impression.imagePath != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  Image.file(
                    File(impression.imagePath!),
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  if (!impression.isCompleted)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: GestureDetector(
                        onTap: () => onImageChanged(null),
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
          if (impression.authorName != null || impression.isReceived) ...[
            const SizedBox(height: 8),
            Text(
              impression.authorName ?? 'Empfangener Eindruck',
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
}
