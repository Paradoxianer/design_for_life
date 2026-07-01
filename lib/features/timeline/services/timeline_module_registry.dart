import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:design_for_life/features/feedback/bloc/feedback_bloc.dart';
import 'package:design_for_life/features/goals/bloc/goals_bloc.dart';
import 'package:design_for_life/features/life_tree/bloc/life_tree_bloc.dart';
import 'package:design_for_life/features/listening_prayer/bloc/listening_prayer_bloc.dart';
import 'package:design_for_life/features/notes/bloc/notes_bloc.dart';
import 'package:design_for_life/features/spiritual_gifts/bloc/spiritual_gifts_bloc.dart';
import 'package:design_for_life/features/values/bloc/values_bloc.dart';

import '../models/dfl_session.dart';

class TimelineModuleRegistry {
  const TimelineModuleRegistry._();

  static bool isCompleted(BuildContext context, DflSession session) {
    final moduleSessionId = session.moduleSessionId ?? session.id;

    switch (session.moduleId) {
      case 'module_notes':
      case 'module_synthesis':
      case 'module_imagine':
        return context.watch<NotesBloc>().state.isCompleted(moduleSessionId);
      case 'module_listening_prayer':
        return context.watch<ListeningPrayerBloc>().state.isCompleted(moduleSessionId);
      case 'module_goals':
        return context.watch<GoalsBloc>().state.isCompleted(moduleSessionId);
      case 'module_spiritual_gifts':
        return context.watch<SpiritualGiftsBloc>().state.isSessionCompleted(moduleSessionId);
      case 'module_life_tree':
        return context.watch<LifeTreeBloc>().state.isCompleted(moduleSessionId);
      case 'module_values':
        return context.watch<ValuesBloc>().state.isCompleted;
      case 'module_feedback':
        return context.watch<FeedbackBloc>().state.response.allRatingsFilled;
      default:
        return false;
    }
  }

  static String? buildRoute(DflSession session, {bool resultMode = false}) {
    final moduleSessionId = session.moduleSessionId ?? session.id;
    final titleParam = Uri.encodeQueryComponent(session.title);
    final modeSuffix = resultMode ? '&mode=result' : '';

    switch (session.moduleId) {
      case 'module_notes':
      case 'module_synthesis':
      case 'module_imagine':
        return 'notes/$moduleSessionId?title=$titleParam$modeSuffix';
      case 'module_life_tree':
        return 'life-tree/$moduleSessionId?title=$titleParam$modeSuffix';
      case 'module_listening_prayer':
        return 'listening-prayer/$moduleSessionId?title=$titleParam$modeSuffix';
      case 'module_goals':
        return 'goals/$moduleSessionId?title=$titleParam$modeSuffix';
      case 'module_spiritual_gifts':
        return 'spiritual-gifts/$moduleSessionId?title=$titleParam$modeSuffix';
      case 'module_values':
        return 'values?title=$titleParam${resultMode ? '&mode=result' : ''}';
      case 'module_feedback':
        return 'feedback?title=$titleParam${resultMode ? '&mode=result' : ''}';
      case 'module_group_photo':
        return 'group-photo';
      default:
        return null;
    }
  }
}
