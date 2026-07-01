import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/dfl_module_scaffold.dart';
import '../../../core/models/shareable_content.dart';
import '../../../core/services/share_service.dart';
import '../bloc/imagine_bloc.dart';
import '../models/imagine_visual_option.dart';
import '../widgets/imagine_editor.dart';
import '../widgets/imagine_result.dart';

class ImagineScreen extends StatelessWidget {
  final String sessionId;
  final String title;
  final bool initialEditMode;

  const ImagineScreen({
    super.key,
    required this.sessionId,
    required this.title,
    this.initialEditMode = true,
  });

  ShareableContent _buildShareContent(ImagineState state) {
    return ShareableContent(
      title: 'Imagine',
      items: [
        if (state.pastImageId(sessionId) != null)
          ShareableItem(
            id: 'past_image',
            label: 'Vergangenheit',
            textValue:
                imagineOptionsById[state.pastImageId(sessionId)]?.label ??
                state.pastImageId(sessionId),
          ),
        if (state.futureImageId(sessionId) != null)
          ShareableItem(
            id: 'future_image',
            label: 'Zukunft',
            textValue:
                imagineOptionsById[state.futureImageId(sessionId)]?.label ??
                state.futureImageId(sessionId),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImagineBloc, ImagineState>(
      builder: (context, state) {
        final shareContent = _buildShareContent(state);
        return DflModuleScaffold(
          title: title,
          initialEditMode: initialEditMode,
          shareableContent: shareContent.items.isNotEmpty ? shareContent : null,
          onShare: (selectedItems) => ShareService.shareContent(
            context: context,
            content: shareContent,
            selectedItems: selectedItems,
          ),
          editor: ImagineEditor(
            sessionId: sessionId,
            selectedPastId: state.pastImageId(sessionId),
            selectedFutureId: state.futureImageId(sessionId),
          ),
          result: ImagineResult(
            pastImageId: state.pastImageId(sessionId),
            futureImageId: state.futureImageId(sessionId),
          ),
        );
      },
    );
  }
}
