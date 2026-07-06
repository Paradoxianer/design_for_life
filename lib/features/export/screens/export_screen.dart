import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printing/printing.dart';

import 'package:design_for_life/core/models/shareable_content.dart';
import 'package:design_for_life/features/goals/bloc/goals_bloc.dart';
import 'package:design_for_life/features/group_photo/bloc/group_photo_bloc.dart';
import 'package:design_for_life/features/group_photo/screens/group_photo_screen.dart';
import 'package:design_for_life/features/imagine/bloc/imagine_bloc.dart';
import 'package:design_for_life/features/life_tree/bloc/life_tree_bloc.dart';
import 'package:design_for_life/features/listening_prayer/bloc/listening_prayer_bloc.dart';
import 'package:design_for_life/features/notes/bloc/notes_bloc.dart';
import 'package:design_for_life/features/spiritual_gifts/bloc/spiritual_gifts_bloc.dart';
import 'package:design_for_life/features/synthesis/bloc/synthesis_bloc.dart';
import 'package:design_for_life/features/timeline/services/timeline_config_repository.dart';
import 'package:design_for_life/features/values/bloc/values_bloc.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';

import '../services/export_content_builder.dart';
import '../services/export_service.dart';
import '../services/pdf_builder.dart';

/// Reihenfolge der Export-Abschnitte folgt der chronologischen Timeline
/// (Einheit 1 zuerst, Gruppenfoto zuletzt) statt einer beliebigen Reihenfolge.
const Map<String, String> _moduleIdToSectionKey = {
  'module_values': 'values',
  'module_spiritual_gifts': 'gifts',
  'module_goals': 'goals',
  'module_notes': 'notes',
  'module_listening_prayer': 'listeningPrayer',
  'module_life_tree': 'lifeTree',
  'module_imagine': 'imagine',
  'module_synthesis': 'connections',
  'module_group_photo': 'groupPhoto',
};

/// Auswahl-Screen vor dem PDF-Export (#29): listet alle Module mit Inhalt
/// auf, Standardauswahl ist "alles ausgewählt".
class ExportScreen extends StatefulWidget {
  const ExportScreen({super.key});

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  Map<String, ShareableContent> _availableSections = {};
  Set<String> _selectedKeys = {};
  bool _loaded = false;
  bool _isGenerating = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) _loadSections();
  }

  Future<void> _loadSections() async {
    final l10n = AppLocalizations.of(context);
    final unordered = <String, ShareableContent>{};

    void addIfPresent(String key, ShareableContent? content) {
      if (content != null) unordered[key] = content;
    }

    addIfPresent('values', ExportContentBuilder.values(l10n, context.read<ValuesBloc>().state));
    addIfPresent(
        'gifts', ExportContentBuilder.spiritualGifts(l10n, context.read<SpiritualGiftsBloc>().state));
    addIfPresent('goals', ExportContentBuilder.goals(l10n, context.read<GoalsBloc>().state));
    addIfPresent('notes', ExportContentBuilder.notes(l10n, context.read<NotesBloc>().state));
    addIfPresent('listeningPrayer',
        ExportContentBuilder.listeningPrayer(l10n, context.read<ListeningPrayerBloc>().state));
    addIfPresent('lifeTree', ExportContentBuilder.lifeTree(l10n, context.read<LifeTreeBloc>().state));
    addIfPresent('imagine', ExportContentBuilder.imagine(l10n, context.read<ImagineBloc>().state));
    addIfPresent(
      'groupPhoto',
      ExportContentBuilder.groupPhoto(l10n, context.read<GroupPhotoBloc>().state, groupPhotoSessionId),
    );
    addIfPresent('connections', ExportContentBuilder.connections(l10n, context.read<SynthesisBloc>().state));

    // Reihenfolge an die tatsächliche Timeline-Chronologie anpassen (Einheit 1
    // zuerst, Gruppenfoto zuletzt), statt der Reihenfolge oben.
    var orderedKeys = unordered.keys.toList();
    try {
      final sessions = await const TimelineConfigRepository().loadSessions(l10n);
      final chronological = <String>[];
      for (final session in sessions) {
        final key = _moduleIdToSectionKey[session.moduleId];
        if (key != null && unordered.containsKey(key) && !chronological.contains(key)) {
          chronological.add(key);
        }
      }
      // Alles, was aus irgendeinem Grund nicht in der Timeline auftaucht,
      // hinten anhängen statt stillschweigend zu verlieren.
      for (final key in unordered.keys) {
        if (!chronological.contains(key)) chronological.add(key);
      }
      orderedKeys = chronological;
    } catch (e) {
      debugPrint('Could not load timeline order for export sections: $e');
    }

    final ordered = {for (final key in orderedKeys) key: unordered[key]!};

    if (!mounted) return;
    setState(() {
      _availableSections = ordered;
      _selectedKeys = ordered.keys.toSet();
      _loaded = true;
    });
  }

  Future<void> _generate() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _isGenerating = true);
    try {
      final contents = _selectedKeys.map((k) => _availableSections[k]!).toList();
      final document = await ExportService.build(context: context, contents: contents);
      final languageCode = Localizations.localeOf(context).languageCode;
      final pdfBytes = await PdfBuilder.build(document, languageCode: languageCode);
      if (!mounted) return;
      await Printing.sharePdf(bytes: pdfBytes, filename: 'dfl_abschlussdokument.pdf');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.exportError)));
      }
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (!_loaded) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.exportTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final sectionLabels = {
      'values': l10n.valuesShareSectionTitle,
      'gifts': l10n.spiritualGiftsTitle,
      'goals': l10n.goalsTitle,
      'notes': l10n.notes,
      'listeningPrayer': l10n.listeningPrayerTitle,
      'lifeTree': l10n.lifeTreeTitle,
      'imagine': l10n.timelineImagineTitle,
      'groupPhoto': l10n.session11Title,
      'connections': l10n.timelineSynthesisTitle,
    };

    if (_availableSections.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.exportTitle)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(l10n.exportEmptyState, textAlign: TextAlign.center),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.exportTitle)),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(l10n.exportSelectionGuidance),
              ),
              Expanded(
                child: ListView(
                  children: [
                    for (final key in _availableSections.keys)
                      CheckboxListTile(
                        title: Text(sectionLabels[key] ?? key),
                        value: _selectedKeys.contains(key),
                        onChanged: _isGenerating
                            ? null
                            : (val) {
                                setState(() {
                                  if (val ?? false) {
                                    _selectedKeys.add(key);
                                  } else {
                                    _selectedKeys.remove(key);
                                  }
                                });
                              },
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (_isGenerating)
            ColoredBox(
              color: Colors.black.withValues(alpha: 0.4),
              child: Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(l10n.exportGenerating),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: _isGenerating || _selectedKeys.isEmpty ? null : _generate,
            icon: _isGenerating
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.picture_as_pdf_outlined),
            label: Text(l10n.exportGenerateButton),
          ),
        ),
      ),
    );
  }
}
