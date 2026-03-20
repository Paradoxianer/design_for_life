import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/values_bloc.dart';
import '../bloc/values_event.dart';
import '../bloc/values_state.dart';
import '../models/value_item.dart';

class ValuesDefinitionsView extends StatefulWidget {
  const ValuesDefinitionsView({super.key});

  @override
  State<ValuesDefinitionsView> createState() => _ValuesDefinitionsViewState();
}

class _ValuesDefinitionsViewState extends State<ValuesDefinitionsView> {
  List<ValueItem>? _localValues;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ValuesBloc, ValuesState>(
      builder: (context, state) {
        final top8 = state.topEightValues;
        
        // Sync local values with BLoC state
        if (_localValues == null || 
            _localValues!.length != top8.length ||
            !_localValues!.every((v) => top8.any((t) => t.name == v.name))) {
          // Re-initialize if count or names changed (Phase 1 selection)
          _localValues = List.from(top8);
        } else {
          // Keep local order but update CONTENT (definitions) from BLoC state
          _localValues = _localValues!.map((localItem) {
            return top8.firstWhere((t) => t.name == localItem.name);
          }).toList();
        }

        if (_localValues!.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text(
                'Bitte wähle zuerst 8 Werte in Phase 1 (Bewertung) aus.',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        const double itemHeight = 180.0;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Sortiere deine Top-Werte nach Priorität. Die ersten 3 Plätze sind deine Key Takeaways.',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fixed Slot Column
                  Column(
                    children: List.generate(_localValues!.length, (index) {
                      final isKeySlot = index < 3;
                      return Container(
                        height: itemHeight,
                        width: 40,
                        alignment: Alignment.topCenter,
                        padding: const EdgeInsets.only(top: 24, left: 8),
                        child: Text(
                          '${index + 1}.',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isKeySlot ? Theme.of(context).colorScheme.primary : Colors.grey,
                            fontSize: isKeySlot ? 18 : 16,
                          ),
                        ),
                      );
                    }),
                  ),
                  // Reorderable List
                  Expanded(
                    child: ReorderableListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      buildDefaultDragHandles: false,
                      itemCount: _localValues!.length,
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          // Local update for immediate visual feedback
                          final item = _localValues!.removeAt(oldIndex);
                          int insertIndex = newIndex;
                          if (insertIndex > oldIndex) insertIndex--;
                          _localValues!.insert(insertIndex, item);
                        });
                        // Persist to BLoC
                        context.read<ValuesBloc>().add(ReorderTopValues(oldIndex, newIndex));
                      },
                      itemBuilder: (context, index) {
                        final value = _localValues![index];
                        final isKeyTakeaway = index < 3;

                        return Container(
                          key: ValueKey('def_${value.name}'),
                          height: itemHeight,
                          padding: const EdgeInsets.only(right: 16, bottom: 16),
                          child: Card(
                            elevation: isKeyTakeaway ? 3 : 1,
                            margin: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: isKeyTakeaway
                                  ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5)
                                  : BorderSide(color: Colors.grey.shade300, width: 0.5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      ReorderableDragStartListener(
                                        index: index,
                                        child: const Padding(
                                          padding: EdgeInsets.only(right: 8),
                                          child: Icon(Icons.drag_handle, color: Colors.grey, size: 24),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          value.name,
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (isKeyTakeaway)
                                        Icon(Icons.auto_awesome, color: Theme.of(context).colorScheme.primary, size: 18),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Expanded(
                                    child: _DefinitionField(
                                      value: value,
                                      onSaved: (text) {
                                        context.read<ValuesBloc>().add(
                                          UpdateDefinition(value.name, text),
                                        );
                                      },
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
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DefinitionField extends StatefulWidget {
  final ValueItem value;
  final ValueChanged<String> onSaved;

  const _DefinitionField({required this.value, required this.onSaved});

  @override
  State<_DefinitionField> createState() => _DefinitionFieldState();
}

class _DefinitionFieldState extends State<_DefinitionField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.definition);
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      // Sync with BLoC only when focus is lost (blur)
      widget.onSaved(_controller.text);
    }
  }

  @override
  void didUpdateWidget(_DefinitionField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync controller with external changes only if the field doesn't have focus
    if (!_focusNode.hasFocus && widget.value.definition != _controller.text) {
      _controller.text = widget.value.definition ?? '';
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      decoration: const InputDecoration(
        labelText: 'Meine Definition',
        border: OutlineInputBorder(),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        hintText: 'Was bedeutet dieser Wert für mich?',
      ),
      maxLines: 2,
      minLines: 2,
    );
  }
}
