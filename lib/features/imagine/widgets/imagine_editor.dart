import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../../core/widgets/dfl_module_editor.dart';
import '../bloc/imagine_bloc.dart';

// Free-use abstract queries — varied enough to fill two long carousels
const _pastQueries = ['abstract texture', 'roots nature', 'old stone', 'foggy forest', 'vintage light'];
const _futureQueries = ['horizon sunrise', 'open road', 'light abstract', 'growth plant', 'sky clouds'];

// ignore: avoid_positional_boolean_parameters
void _noOp(int i, String v) {}

class ImagineEditor extends DflModuleEditor {
  final String sessionId;
  final String? selectedPastUrl;
  final String? selectedFutureUrl;
  final String takeaway;

  const ImagineEditor({
    super.key,
    required this.sessionId,
    this.selectedPastUrl,
    this.selectedFutureUrl,
    this.takeaway = '',
  }) : super(takeaways: const [], onUpdate: _noOp, showTakeaways: false);

  @override
  Widget buildContent(BuildContext context) {
    return _ImagineEditorBody(
      sessionId: sessionId,
      selectedPastUrl: selectedPastUrl,
      selectedFutureUrl: selectedFutureUrl,
      takeaway: takeaway,
    );
  }
}

class _ImagineEditorBody extends StatefulWidget {
  final String sessionId;
  final String? selectedPastUrl;
  final String? selectedFutureUrl;
  final String takeaway;

  const _ImagineEditorBody({
    required this.sessionId,
    this.selectedPastUrl,
    this.selectedFutureUrl,
    required this.takeaway,
  });

  @override
  State<_ImagineEditorBody> createState() => _ImagineEditorBodyState();
}

class _ImagineEditorBodyState extends State<_ImagineEditorBody> {
  List<String> _pastImages = [];
  List<String> _futureImages = [];
  bool _loading = true;
  String? _error;

  // Pixabay API key — store in a secrets file or .env in production
  static const _pixabayKey = 'YOUR_PIXABAY_API_KEY';

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<List<String>> _fetchPixabay(List<String> queries) async {
    final results = <String>[];
    for (final q in queries) {
      final uri = Uri.https('pixabay.com', '/api/', {
        'key': _pixabayKey,
        'q': q,
        'image_type': 'photo',
        'orientation': 'horizontal',
        'safesearch': 'true',
        'per_page': '10',
        'order': 'popular',
      });
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final hits = data['hits'] as List<dynamic>;
        results.addAll(hits.map((h) => h['webformatURL'] as String));
      }
    }
    return results;
  }

  Future<void> _loadImages() async {
    try {
      final past = await _fetchPixabay(_pastQueries);
      final future = await _fetchPixabay(_futureQueries);
      if (mounted) {
        setState(() {
          _pastImages = past;
          _futureImages = future;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_loading) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(Icons.wifi_off_rounded, size: 48, color: theme.colorScheme.error),
            const SizedBox(height: 12),
            Text('Bilder konnten nicht geladen werden.', style: theme.textTheme.bodyLarge),
            const SizedBox(height: 8),
            TextButton(onPressed: _loadImages, child: const Text('Erneut versuchen')),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CarouselSection(
          label: 'Vergangenheit',
          subtitle: 'Wähle ein Bild, das deine Vergangenheit symbolisiert',
          icon: Icons.history_rounded,
          images: _pastImages,
          selectedUrl: widget.selectedPastUrl,
          onSelect: (url) => context.read<ImagineBloc>().add(
                SelectPastImage(widget.sessionId, url),
              ),
        ),
        const SizedBox(height: 28),
        _CarouselSection(
          label: 'Zukunft',
          subtitle: 'Wähle ein Bild, das deine Zukunft symbolisiert',
          icon: Icons.auto_awesome_rounded,
          images: _futureImages,
          selectedUrl: widget.selectedFutureUrl,
          onSelect: (url) => context.read<ImagineBloc>().add(
                SelectFutureImage(widget.sessionId, url),
              ),
        ),
        const SizedBox(height: 28),
        _TakeawayField(
          sessionId: widget.sessionId,
          initialValue: widget.takeaway,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _CarouselSection extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final List<String> images;
  final String? selectedUrl;
  final ValueChanged<String> onSelect;

  const _CarouselSection({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.images,
    this.selectedUrl,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(label, style: theme.textTheme.titleMedium),
          ],
        ),
        const SizedBox(height: 4),
        Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, i) {
              final url = images[i];
              final isSelected = url == selectedUrl;
              return GestureDetector(
                onTap: () => onSelect(url),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected
                        ? Border.all(color: theme.colorScheme.primary, width: 3)
                        : Border.all(color: Colors.transparent, width: 3),
                    boxShadow: isSelected
                        ? [BoxShadow(color: theme.colorScheme.primary.withOpacity(0.3), blurRadius: 8)]
                        : [],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(url, fit: BoxFit.cover,
                            loadingBuilder: (ctx, child, progress) => progress == null
                                ? child
                                : Container(color: theme.colorScheme.surfaceVariant)),
                        if (isSelected)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: theme.colorScheme.primary,
                              child: const Icon(Icons.check, size: 14, color: Colors.white),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TakeawayField extends StatefulWidget {
  final String sessionId;
  final String initialValue;
  const _TakeawayField({required this.sessionId, required this.initialValue});

  @override
  State<_TakeawayField> createState() => _TakeawayFieldState();
}

class _TakeawayFieldState extends State<_TakeawayField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Meine Erkenntnis', style: theme.textTheme.titleMedium),
        const SizedBox(height: 4),
        Text('Was nehme ich aus diesem Vergleich mit?',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        const SizedBox(height: 10),
        TextField(
          controller: _controller,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Deine Gedanken hier...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (v) =>
              context.read<ImagineBloc>().add(UpdateImagineTakeaway(widget.sessionId, v)),
        ),
      ],
    );
  }
}
