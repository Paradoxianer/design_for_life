import 'package:design_for_life/core/blocs/entry_list_bloc.dart';
import 'package:design_for_life/core/models/shareable_content.dart';
import 'package:design_for_life/features/goals/bloc/goals_bloc.dart';
import 'package:design_for_life/features/imagine/bloc/imagine_bloc.dart';
import 'package:design_for_life/features/life_tree/bloc/life_tree_bloc.dart';
import 'package:design_for_life/features/life_tree/models/life_tree_node_data.dart';
import 'package:design_for_life/features/personal_style/bloc/personal_style_state.dart';
import 'package:design_for_life/features/spiritual_gifts/bloc/spiritual_gifts_bloc.dart';
import 'package:design_for_life/features/synthesis/bloc/synthesis_bloc.dart';
import 'package:design_for_life/features/values/bloc/values_state.dart';
import 'package:design_for_life/l10n/generated/app_localizations.dart';

/// Baut je Modul ein [ShareableContent] aus dem *gesamten* Bloc-State (alle
/// Sessions kombiniert, nicht nur eine Timeline-Session) für den Abschluss-
/// Export (#28). Nutzt bewusst dasselbe Datenmodell wie das normale Teilen,
/// damit die Bild-Erzeugung über ShareImageGenerator wiederverwendet werden
/// kann, statt einen zweiten Rendering-Pfad zu bauen.
class ExportContentBuilder {
  const ExportContentBuilder._();

  static ShareableContent? values(AppLocalizations l10n, ValuesState state) {
    final topThree = state.topEightValues.take(3).toList();
    if (topThree.isEmpty) return null;

    return ShareableContent(
      title: l10n.valuesShareSectionTitle,
      items: [
        ShareableItem(
          id: 'export_values_card',
          label: l10n.valuesShareCardLabel,
          textValue: [
            for (int i = 0; i < topThree.length; i++) '${i + 1}. ${topThree[i].name}',
          ].join('\n'),
          data: {
            'type': 'text_card',
            'entries': [
              for (int i = 0; i < topThree.length; i++)
                {'title': '${i + 1}. ${topThree[i].name}', 'body': topThree[i].definition},
            ],
          },
        ),
      ],
    );
  }

  static ShareableContent? spiritualGifts(AppLocalizations l10n, SpiritualGiftsState state) {
    final topThree = state.getRankedGifts().take(3).toList();
    if (topThree.isEmpty) return null;
    final scores = state.getScoresPerGift();

    return ShareableContent(
      title: l10n.spiritualGiftsTitle,
      items: [
        ShareableItem(
          id: 'export_gifts_card',
          label: l10n.giftsShareCardLabel,
          textValue: [
            for (int i = 0; i < topThree.length; i++)
              '${l10n.shareGiftItem(i + 1, topThree[i].name)} '
                  '(${l10n.giftsScorePoints(scores[topThree[i].id] ?? 0)})',
          ].join('\n'),
          data: {
            'type': 'text_card',
            'entries': [
              for (int i = 0; i < topThree.length; i++)
                {
                  'title': '${l10n.shareGiftItem(i + 1, topThree[i].name)} '
                      '(${l10n.giftsScorePoints(scores[topThree[i].id] ?? 0)})',
                  'body': topThree[i].description,
                },
            ],
          },
        ),
      ],
    );
  }

  static ShareableContent? goals(AppLocalizations l10n, GoalsState state) {
    final filledGoals = state.goals.values.expand((g) => g).where((g) => g.text.isNotEmpty).toList();
    if (filledGoals.isEmpty) return null;

    List<Map<String, Object>> smartChips(dynamic goal) => [
          {'label': 'S', 'title': l10n.smartSpecific, 'isActive': goal.isSpecific},
          {'label': 'M', 'title': l10n.smartMeasurable, 'isActive': goal.isMeasurable},
          {'label': 'A', 'title': l10n.smartAchievable, 'isActive': goal.isAchievable},
          {'label': 'R', 'title': l10n.smartRelevant, 'isActive': goal.isRelevant},
          {'label': 'T', 'title': l10n.smartTimeBound, 'isActive': goal.isTimeBound},
        ];

    return ShareableContent(
      title: l10n.goalsTitle,
      items: [
        ShareableItem(
          id: 'export_goals_card',
          label: l10n.goalsShareCardLabel,
          textValue: [
            for (int i = 0; i < filledGoals.length; i++)
              '${l10n.shareGoalItem(i + 1)}: ${filledGoals[i].text}',
          ].join('\n'),
          data: {
            'type': 'text_card',
            'entries': [
              for (int i = 0; i < filledGoals.length; i++)
                {
                  'title': l10n.shareGoalItem(i + 1),
                  'body': filledGoals[i].text,
                  'chips': smartChips(filledGoals[i]),
                },
            ],
          },
        ),
      ],
    );
  }

  static ShareableContent? notes(AppLocalizations l10n, EntryListState state) {
    // Notizen bestehen aus zwei getrennten Dingen: den freien Notiz-Einträgen
    // (Text/Foto pro Einheit) UND den 3 "Wichtigste Erkenntnisse"-Feldern
    // (vom generischen KeyTakeawayField in DflModuleEditor). Beide gehören in
    // den Export, nicht nur die Takeaways.
    final takeaways = state.takeaways.values.expand((t) => t).where((t) => t.trim().isNotEmpty).toList();
    final entries = state.entries.values
        .expand((e) => e)
        .where((e) => e.text.trim().isNotEmpty || e.imagePath != null)
        .toList();
    if (takeaways.isEmpty && entries.isEmpty) return null;

    return ShareableContent(
      title: l10n.notes,
      items: [
        for (int i = 0; i < takeaways.length; i++)
          ShareableItem(
            id: 'export_note_takeaway_$i',
            label: l10n.shareHighlightItem(i + 1),
            textValue: takeaways[i],
          ),
        for (int i = 0; i < entries.length; i++)
          ShareableItem(
            id: 'export_note_$i',
            label: l10n.shareNoteItem(i + 1),
            textValue: entries[i].text.isNotEmpty ? entries[i].text : null,
            imagePath: entries[i].imagePath,
          ),
      ],
    );
  }

  static ShareableContent? listeningPrayer(AppLocalizations l10n, EntryListState state) {
    final highlights = state.takeaways.values.expand((t) => t).where((t) => t.trim().isNotEmpty).toList();
    final impressions = state.entries.values
        .expand((e) => e)
        .where((e) => e.text.trim().isNotEmpty || e.imagePath != null)
        .toList();
    if (highlights.isEmpty && impressions.isEmpty) return null;

    return ShareableContent(
      title: l10n.listeningPrayerTitle,
      items: [
        for (int i = 0; i < highlights.length; i++)
          ShareableItem(
            id: 'export_lp_highlight_$i',
            label: l10n.shareHighlightItem(i + 1),
            textValue: highlights[i],
          ),
        for (int i = 0; i < impressions.length; i++)
          ShareableItem(
            id: 'export_lp_impression_$i',
            label: l10n.shareImpressionItem(i + 1),
            textValue: impressions[i].text.isNotEmpty ? impressions[i].text : null,
            imagePath: impressions[i].imagePath,
          ),
      ],
    );
  }

  static ShareableContent? groupPhoto(AppLocalizations l10n, EntryListState state, String sessionId) {
    final entries = (state.entries[sessionId] ?? [])
        .where((e) => e.text.trim().isNotEmpty || e.imagePath != null)
        .toList();
    if (entries.isEmpty) return null;

    return ShareableContent(
      title: l10n.session11Title,
      items: [
        for (int i = 0; i < entries.length; i++)
          ShareableItem(
            id: 'export_group_photo_$i',
            label: l10n.shareNoteItem(i + 1),
            textValue: entries[i].text.isNotEmpty ? entries[i].text : null,
            imagePath: entries[i].imagePath,
          ),
      ],
    );
  }

  static ShareableContent? lifeTree(AppLocalizations l10n, LifeTreeState state) {
    final takeaways = state.takeaways.values.expand((t) => t).where((t) => t.trim().isNotEmpty).toList();
    final entries = state.entries.values
        .expand((e) => e)
        .where((e) => e.text.trim().isNotEmpty || e.imagePath != null)
        .toList();
    // Der digitale Baum ist konzeptionell immer genau eine Session
    // (session_3), aber auf echten Geräten wurden vereinzelt zusätzliche,
    // unvollständige Session-Keys persistiert (z.B. durch frühere
    // Routing-Stände ohne expliziten moduleSessionId-Query-Parameter).
    // firstWhere() griff dabei nicht-deterministisch nach Map-Reihenfolge
    // irgendeinen (ggf. unvollständigen) Eintrag heraus, was zu einem
    // durcheinandergewürfelten Baum im Export führte. Stattdessen die
    // umfangreichste Liste wählen - das ist praktisch immer der echte,
    // vollständige Baum, während Karteileichen nur wenige Knoten enthalten.
    final nodes = state.treeNodes.values.fold<List<LifeTreeNodeData>>(
      const [],
      (best, current) => current.length > best.length ? current : best,
    );
    if (takeaways.isEmpty && entries.isEmpty && nodes.isEmpty) return null;

    return ShareableContent(
      title: l10n.lifeTreeTitle,
      items: [
        if (nodes.isNotEmpty)
          ShareableItem(
            id: 'export_lt_graph',
            label: l10n.lifeTreeShareGraph,
            data: {'type': 'life_tree_graph_data', 'nodes': nodes},
          ),
        for (int i = 0; i < takeaways.length; i++)
          ShareableItem(
            id: 'export_lt_takeaway_$i',
            label: l10n.shareInsightItem(i + 1),
            textValue: takeaways[i],
          ),
        for (int i = 0; i < entries.length; i++)
          ShareableItem(
            id: 'export_lt_entry_$i',
            label: l10n.shareNoteOrDrawing,
            textValue: entries[i].text.isNotEmpty ? entries[i].text : null,
            imagePath: entries[i].imagePath,
          ),
      ],
    );
  }

  static ShareableContent? imagine(AppLocalizations l10n, ImagineState state) {
    final sessionIds = {...state.pastImageIds.keys, ...state.futureImageIds.keys};
    final items = <ShareableItem>[];

    for (final sessionId in sessionIds) {
      final pastId = state.pastImageId(sessionId);
      final futureId = state.futureImageId(sessionId);

      if (pastId != null && futureId != null) {
        items.add(ShareableItem(
          id: 'export_imagine_combined_$sessionId',
          label: l10n.imagineLabelCombined,
          data: {
            'type': 'imagine_composed',
            'pastOptionId': pastId,
            'futureOptionId': futureId,
            'pastLabel': l10n.imagineLabelPast,
            'futureLabel': l10n.imagineLabelFuture,
          },
        ));
      } else if (pastId != null) {
        items.add(ShareableItem(
          id: 'export_imagine_past_$sessionId',
          label: l10n.imagineLabelPast,
          data: {'type': 'imagine_option', 'phase': l10n.imagineLabelPast, 'optionId': pastId},
        ));
      } else if (futureId != null) {
        items.add(ShareableItem(
          id: 'export_imagine_future_$sessionId',
          label: l10n.imagineLabelFuture,
          data: {'type': 'imagine_option', 'phase': l10n.imagineLabelFuture, 'optionId': futureId},
        ));
      }
    }

    if (items.isEmpty) return null;
    return ShareableContent(title: l10n.timelineImagineTitle, items: items);
  }

  static ShareableContent? personalStyle(AppLocalizations l10n, PersonalStyleState state) {
    final profile = state.profile;
    final quadrant = state.quadrant;
    final takeaways = state.takeaways.values.expand((t) => t).where((t) => t.trim().isNotEmpty).toList();
    if (profile == null && quadrant == null && takeaways.isEmpty) return null;

    return ShareableContent(
      title: l10n.personalStyleTitle,
      items: [
        if (quadrant != null)
          ShareableItem(
            id: 'export_personal_style_matrix',
            label: l10n.personalStyleShareCardLabel,
            textValue: profile != null ? '${profile.title}\n${profile.traits.join('\n')}' : null,
            data: {
              'type': 'personal_style_matrix',
              'quadrant': quadrant,
              'organisationFraction': state.organisationFraction,
              'energyFraction': state.energyFraction,
              'peopleLabel': l10n.personalStyleAxisPeople,
              'taskLabel': l10n.personalStyleAxisTask,
              'structuredLabel': l10n.personalStyleAxisStructured,
              'unstructuredLabel': l10n.personalStyleAxisUnstructured,
              if (profile != null) 'profileTitle': profile.title,
              if (profile != null) 'profileTraits': profile.traits,
            },
          ),
        for (int i = 0; i < takeaways.length; i++)
          ShareableItem(
            id: 'export_personal_style_takeaway_$i',
            label: l10n.shareHighlightItem(i + 1),
            textValue: takeaways[i],
          ),
      ],
    );
  }

  static ShareableContent? connections(AppLocalizations l10n, SynthesisState state) {
    final labels = {
      'gifts': l10n.connectionsColGifts,
      'values': l10n.connectionsColValues,
      'prayer': l10n.connectionsColPrayer,
      'goals': l10n.connectionsColGoals,
      'lifeTree': l10n.connectionsColLifeTree,
      'personalStyle': l10n.connectionsColPersonalStyle,
    };

    // Farbe als echte gerenderte Form statt Emoji-Zeichen (🔴 etc.) - je nach
    // Plattform/Schrift wurden Emojis beim Rendern zu Bildern sonst als
    // Ersatzzeichen ("Tofu-Box") angezeigt.
    const tagColors = {
      'red': '#E53935',
      'blue': '#1E88E5',
      'green': '#43A047',
      'gold': '#FBC02D',
      'none': '#BDBDBD',
    };

    final boardEntries = <Map<String, Object>>[];
    for (final columnEntry in state.columns.entries) {
      if (columnEntry.value.isEmpty) continue;
      final section = labels[columnEntry.key] ?? columnEntry.key;
      boardEntries.add({
        'title': section,
        'lines': [
          for (final card in columnEntry.value)
            {'text': card.text, 'color': tagColors[card.tag] ?? tagColors['none']!},
        ],
      });
    }
    final summaryText = state.takeaways.where((t) => t.trim().isNotEmpty).join('\n');
    if (summaryText.isNotEmpty) {
      boardEntries.add({'title': l10n.keyTakeaways, 'body': summaryText});
    }
    if (boardEntries.isEmpty) return null;

    return ShareableContent(
      title: l10n.timelineSynthesisTitle,
      items: [
        ShareableItem(
          id: 'export_connections_card',
          label: l10n.connectionsShareCardLabel,
          data: {'type': 'text_card', 'entries': boardEntries},
        ),
      ],
    );
  }
}
