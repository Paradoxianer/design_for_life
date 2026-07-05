import 'package:flutter/material.dart';
import 'image_fullscreen_viewer.dart';
import 'resolved_image.dart';

/// Fixed-height, cropped image preview used across module result views, with
/// a tap target that opens the full, zoomable image via
/// [showImageFullscreen]. Without this, previews only ever show a
/// "fit to width" crop with no way to see the full picture (#17).
class ResultImageThumbnail extends StatelessWidget {
  final String imagePath;
  final double height;

  const ResultImageThumbnail({
    super.key,
    required this.imagePath,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showImageFullscreen(context, imagePath),
      child: Stack(
        children: [
          buildResolvedImage(imagePath, width: double.infinity, height: height),
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.fullscreen, size: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
