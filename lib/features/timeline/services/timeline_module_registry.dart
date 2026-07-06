import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:design_for_life/features/feedback/bloc/feedback_bloc.dart';
import 'package:design_for_life/features/goals/bloc/goals_bloc.dart';
import 'package:design_for_life/features/group_photo/bloc/group_photo_bloc.dart';
import 'package:design_for_life/features/group_photo/screens/group_photo_screen.dart';
import 'package:design_for_life/features/imagine/bloc/imagine_bloc.dart';
import 'package:design_for_life/features/life_tree/bloc/life_tree_bloc.dart';
import 'package:design_for_life/features/listening_prayer/bloc/listening_prayer_bloc.dart';
import 'package:design_for_life/features/notes/bloc/notes_bloc.dart';
import 'package:design_for_life/features/spiritual_gifts/bloc/spiritual_gifts_bloc.dart';
import 'package:design_for_life/features/synthesis/bloc/synthesis_bloc.dart';
import 'package:design_for_life/features/values/bloc/values_bloc.dart';

import '../models/dfl_session.dart';

class TimelineModuleRegistry {
  const TimelineModuleRegistry._();

  static bool isCompleted(BuildContext context, DflSession session) {
    final moduleSessionId = session.moduleSessionId ?? session.id;

    switch (session.moduleId) {
      case 'module_notes':
        return context.watch<NotesBloc>().state.isCompleted(moduleSessionId);
      case 'module_synthesis':
        return context.watch<SynthesisBloc>().state.isCompleted;
      case 'module_imagine':
        return context.watch<ImagineBloc>().state.isCompleted(moduleSessionId);
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
      case 'module_group_photo':
        return context.watch<GroupPhotoBloc>().state.isCompleted(groupPhotoSessionId);
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
        return 'notes/$moduleSessionId?title=$titleParam$modeSuffix';
      case 'module_synthesis':
        return 'synthesis?title=$titleParam'
            '&giftsSession=session_5'
            '&prayerSession=session_7'
            '&goalsSession=session_10'
            '&lifeTreeSession=session_3'
            '$modeSuffix';
      case 'module_imagine':
        return 'imagine/$moduleSessionId?title=$titleParam$modeSuffix';
      case 'module_life_tree':
        return 'life-tree/$moduleSessionId?title=$titleParam$modeSuffix';
      case 'module_listening_prayer':
        return 'listening-prayer/$moduleSessionId?title=$titleParam$modeSuffix';
      case 'module_goals':
        return 'goals/$moduleSessionId?title=$titleParam$modeSuffix';
      case 'module_spiritual_gifts':
        return 'spiritual-gifts/$moduleSessionId?title=$titleParam$modeSuffix';
      case 'module_values':
        return 'values?title=$titleParam$modeSuffix';
      case 'module_feedback':
        return 'feedback?title=$titleParam$modeSuffix';
      case 'module_group_photo':
        return 'group-photo?title=$titleParam$modeSuffix';
      default:
        return null;
    }
  }
}
