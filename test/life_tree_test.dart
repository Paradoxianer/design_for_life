import 'package:flutter_test/flutter_test.dart';
import 'package:design_for_life/features/life_tree/bloc/life_tree_bloc.dart';
import 'package:design_for_life/features/life_tree/models/life_tree_node_data.dart';
import 'package:design_for_life/core/models/dfl_entry.dart';

void main() {
  group('LifeTreeState isCompleted', () {
    const sessionId = 'test_session';

    test('should return false when empty', () {
      const state = LifeTreeState();
      expect(state.isCompleted(sessionId), isFalse);
    });

    test('should return true when has analog entry with text', () {
      final state = LifeTreeState(
        entries: {
          sessionId: [DflEntry(id: '1', text: 'Some note')],
        },
      );
      expect(state.isCompleted(sessionId), isTrue);
    });

    test('should return true when has digital node with text', () {
      final state = LifeTreeState(
        treeNodes: {
          sessionId: [LifeTreeNodeData(id: '1', text: 'Birth')],
        },
      );
      expect(state.isCompleted(sessionId), isTrue);
    });

    test('should return false when has digital node with empty text', () {
      final state = LifeTreeState(
        treeNodes: {
          sessionId: [LifeTreeNodeData(id: '1', text: '  ')],
        },
      );
      expect(state.isCompleted(sessionId), isFalse);
    });

    test('should return true when has both', () {
      final state = LifeTreeState(
        entries: {
          sessionId: [DflEntry(id: '1', text: 'Note')],
        },
        treeNodes: {
          sessionId: [LifeTreeNodeData(id: '1', text: 'Event')],
        },
      );
      expect(state.isCompleted(sessionId), isTrue);
    });
  });
}
