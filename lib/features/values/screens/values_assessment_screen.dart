import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';
import '../../../core/widgets/dfl_module_scaffold.dart';
import '../../../core/models/shareable_content.dart';
import '../../../core/services/share_service.dart';
import '../bloc/values_bloc.dart';
import '../bloc/values_event.dart';
import '../bloc/values_state.dart';
import '../models/static_values_data.dart';
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

  @override
  void initState() {
    super.initState();
  }
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      final l10n = AppLocalizations.of(context)!;

      context.read<ValuesBloc>().add(
        ValuesStarted(StaticValuesData.getInitialValues(l10n)),
      );

      _initialized = true;
    }
  }


  ShareableContent _getShareableContent(BuildContext context, ValuesState state) {
    final l10n = AppLocalizations.of(context);
    final topThree = state.topEightValues.take(3).toList();

    return ShareableContent(
      title: l10n.valuesResultTitle,
      items: [
        // Top 3 Werte als eine gebrandete Bild-Karte statt einzelner Text-Zeilen (#24)
        if (topThree.isNotEmpty)
          ShareableItem(
            id: 'values_card',
            label: l10n.valuesShareCardLabel,
            data: {
              'type': 'text_card',
              'entries': [
                for (int i = 0; i < topThree.length; i++)
                  {
                    'title': '${i + 1}. ${topThree[i].name}',
                    'body': topThree[i].definition,
                  },
              ],
            },
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<ValuesBloc, ValuesState>(
      builder: (context, state) {
        final shareContent = _getShareableContent(context, state);
        
        return DflModuleScaffold(
          key: _scaffoldKey,
          title: widget.title,
          initialEditMode: widget.initialEditMode,
          onWillToggleMode: () async {
            return await _validateCompletion(context, state);
          },
          shareableContent: shareContent.items.isNotEmpty ? shareContent : null,
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
              Flexible(
                child: _currentStep > 0
                    ? TextButton.icon(
                        onPressed: () => setState(() => _currentStep--),
                        icon: const Icon(Icons.chevron_left),
                        label: Text(
                          l10n.previous,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              Flexible(
                child: ElevatedButton.icon(
                  onPressed: () => _scaffoldKey.currentState?.toggleMode(),
                  icon: const Icon(Icons.check),
                  label: Text(
                    l10n.finish,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              Flexible(
                child: _currentStep < 2
                    ? ElevatedButton(
                        onPressed: () => setState(() => _currentStep++),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                l10n.next,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
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
    );
  }

  Future<bool> _validateCompletion(BuildContext context, ValuesState state) async {
    final l10n = AppLocalizations.of(context);
    if (state.topEightValues.length != 8) {
      final bool? result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.valuesSelectionStatus(8)),
          content: Text(l10n.valuesSelectionMissing(state.topEightValues.length)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.previous),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.next),
            ),
          ],
        ),
      );
      return result ?? false;
    }
    return true;
  }
}
