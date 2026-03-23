import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../../../core/widgets/dfl_module_scaffold.dart';
import '../../../core/models/shareable_content.dart';
import '../../../core/services/share_service.dart';
import '../bloc/values_bloc.dart';
import '../bloc/values_event.dart';
import '../bloc/values_state.dart';
import '../widgets/values_editor.dart';
import '../widgets/values_result.dart';

class ValuesAssessmentScreen extends StatefulWidget {
  final String title;
  final bool initialEditMode;

  const ValuesAssessmentScreen({
    super.key,
    required this.title,
    this.initialEditMode = true,
  });

  @override
  State<ValuesAssessmentScreen> createState() => _ValuesAssessmentScreenState();
}

class _ValuesAssessmentScreenState extends State<ValuesAssessmentScreen> {
  final GlobalKey<DflModuleScaffoldState> _scaffoldKey = GlobalKey<DflModuleScaffoldState>();
  int _currentStep = 0;

  ShareableContent _getShareableContent(ValuesState state) {
    return ShareableContent(
      title: 'Meine Werte',
      items: state.topEightValues.asMap().entries.map((entry) {
        final index = entry.key;
        final value = entry.value;
        return ShareableItem(
          id: 'value_$index',
          label: '${index + 1}. ${value.name}',
          textValue: value.definition,
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocProvider(
      create: (context) => ValuesBloc()..add(const ValuesStarted()),
      child: BlocBuilder<ValuesBloc, ValuesState>(
        builder: (context, state) {
          final shareContent = _getShareableContent(state);
          
          return DflModuleScaffold(
            key: _scaffoldKey,
            title: widget.title,
            initialEditMode: widget.initialEditMode,
            onWillToggleMode: () async {
              return await _validateCompletion(context, state);
            },
            shareableContent: shareContent,
            onShare: (selectedItems) {
              ShareService.shareContent(
                context: context,
                content: shareContent,
                selectedItems: selectedItems,
              );
            },
            customFooter: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 100,
                  child: _currentStep > 0
                      ? TextButton.icon(
                          onPressed: () => setState(() => _currentStep--),
                          icon: const Icon(Icons.chevron_left),
                          label: Text(l10n.previous),
                        )
                      : const SizedBox.shrink(),
                ),
                ElevatedButton.icon(
                  onPressed: () => _scaffoldKey.currentState?.toggleMode(),
                  icon: const Icon(Icons.check),
                  label: Text(l10n.finish),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: _currentStep < 2
                      ? ElevatedButton(
                          onPressed: () => setState(() => _currentStep++),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(l10n.next),
                              const Icon(Icons.chevron_right),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
            editor: ValuesEditor(
              currentStep: _currentStep,
              onStepTapped: (step) => setState(() => _currentStep = step),
            ),
            result: const ValuesResult(),
          );
        },
      ),
    );
  }

  Future<bool> _validateCompletion(BuildContext context, ValuesState state) async {
    if (state.topEightValues.length != 8) {
      final bool? result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Auswahl unvollständig'),
          content: Text(
            'Du hast aktuell ${state.topEightValues.length} von 8 Werten ausgewählt. '
            'Für ein optimales Ergebnis sollten es genau 8 sein. '
            'Möchtest du trotzdem fortfahren?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Zurück'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Trotzdem weiter'),
            ),
          ],
        ),
      );
      return result ?? false;
    }
    return true;
  }
}
