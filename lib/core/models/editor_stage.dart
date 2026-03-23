import 'package:flutter/material.dart';

class EditorStage {
  final String title;
  final Widget content;
  final bool isValid;

  const EditorStage({
    required this.title,
    required this.content,
    this.isValid = true,
  });
}
