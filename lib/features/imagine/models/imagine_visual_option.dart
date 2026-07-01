import 'package:flutter/material.dart';

class ImagineVisualOption {
  final String id;
  final String label;
  final List<Color> colors;

  const ImagineVisualOption({
    required this.id,
    required this.label,
    required this.colors,
  });
}

const List<ImagineVisualOption> pastImagineOptions = [
  ImagineVisualOption(
    id: 'past_roots',
    label: 'Wurzeln & Herkunft',
    colors: [Color(0xFF4E342E), Color(0xFF8D6E63), Color(0xFFBCAAA4)],
  ),
  ImagineVisualOption(
    id: 'past_stones',
    label: 'Erfahrung & Beständigkeit',
    colors: [Color(0xFF37474F), Color(0xFF607D8B), Color(0xFF90A4AE)],
  ),
  ImagineVisualOption(
    id: 'past_valley',
    label: 'Lernen in Tiefen',
    colors: [Color(0xFF1A237E), Color(0xFF3949AB), Color(0xFF7986CB)],
  ),
  ImagineVisualOption(
    id: 'past_warm_memory',
    label: 'Warme Erinnerungen',
    colors: [Color(0xFF6D4C41), Color(0xFFA1887F), Color(0xFFD7CCC8)],
  ),
  ImagineVisualOption(
    id: 'past_growth',
    label: 'Wachstum im Rückblick',
    colors: [Color(0xFF1B5E20), Color(0xFF43A047), Color(0xFF81C784)],
  ),
];

const List<ImagineVisualOption> futureImagineOptions = [
  ImagineVisualOption(
    id: 'future_horizon',
    label: 'Neuer Horizont',
    colors: [Color(0xFF0D47A1), Color(0xFF1976D2), Color(0xFF64B5F6)],
  ),
  ImagineVisualOption(
    id: 'future_light',
    label: 'Licht & Klarheit',
    colors: [Color(0xFFF9A825), Color(0xFFFFCA28), Color(0xFFFFF59D)],
  ),
  ImagineVisualOption(
    id: 'future_path',
    label: 'Weg & Richtung',
    colors: [Color(0xFF4A148C), Color(0xFF7B1FA2), Color(0xFFBA68C8)],
  ),
  ImagineVisualOption(
    id: 'future_peace',
    label: 'Frieden & Weite',
    colors: [Color(0xFF00695C), Color(0xFF26A69A), Color(0xFF80CBC4)],
  ),
  ImagineVisualOption(
    id: 'future_bloom',
    label: 'Aufbruch & Entfaltung',
    colors: [Color(0xFFAD1457), Color(0xFFEC407A), Color(0xFFF48FB1)],
  ),
];

final Map<String, ImagineVisualOption> imagineOptionsById = {
  for (final option in [...pastImagineOptions, ...futureImagineOptions])
    option.id: option,
};
