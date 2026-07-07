import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Resolves [path] to the right [Image] widget depending on whether it is a
/// bundled asset, a remote URL, or a local file path - the three shapes used
/// across modules (Imagine's asset options vs. Notes/Life Tree/Listening
/// Prayer's camera/gallery picks).
Widget buildResolvedImage(
  String path, {
  BoxFit fit = BoxFit.cover,
  double? width,
  double? height,
}) {
  if (path.startsWith('assets/')) {
    return Image.asset(path, width: width, height: height, fit: fit);
  }
  if (kIsWeb || path.startsWith('http')) {
    return Image.network(path, width: width, height: height, fit: fit);
  }
  return Image.file(File(path), width: width, height: height, fit: fit);
}
