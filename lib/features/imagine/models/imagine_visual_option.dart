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

/// Resolves a raw image id to a path usable with [buildResolvedImage].
///
/// Ids come in two shapes: bare asset filenames from the bundled option pool
/// (e.g. "img_01.jpg", see index.json) and absolute file paths from a camera
/// capture (#53 - "offline" photos representing past/future). Only the first
/// shape needs the `assets/images/imagine/` prefix; a path that already
/// contains a separator (or is a URL) is used as-is.
String resolveImagineImagePath(String id) {
  if (id.startsWith('assets/') || id.startsWith('http') || id.contains('/') || id.contains('\\')) {
    return id;
  }
  return 'assets/images/imagine/$id';
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
