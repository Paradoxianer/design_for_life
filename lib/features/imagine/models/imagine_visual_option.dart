import 'dart:convert';
import 'package:flutter/services.dart';

class ImagineVisualOption {
  final String id;
  final String imagePath;

  const ImagineVisualOption({
    required this.id,
    required this.imagePath,
  });
}

/// Loads the image list from `assets/images/imagine/index.json`.
/// Returns an empty list if the file is missing or malformed.
Future<List<ImagineVisualOption>> loadImagineOptions() async {
  try {
    final raw = await rootBundle.loadString('assets/images/imagine/index.json');
    final filenames = (json.decode(raw) as List).cast<String>();
    return filenames
        .map((f) => ImagineVisualOption(
              id: f,
              imagePath: 'assets/images/imagine/$f',
            ))
        .toList();
  } catch (_) {
    return [];
  }
}
