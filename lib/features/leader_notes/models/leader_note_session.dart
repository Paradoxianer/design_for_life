import 'leader_note_block.dart';

/// One named group of [LeaderNoteBlock]s within a session's leader notes -
/// mirrors the Leiterheft's own subsections (e.g. within "Einheit Eins":
/// "Erwartungen", then "Trete in den Riss").
class LeaderNoteSection {
  final String heading;
  final List<LeaderNoteBlock> blocks;

  const LeaderNoteSection({required this.heading, required this.blocks});

  factory LeaderNoteSection.fromJson(Map<String, dynamic> json) {
    return LeaderNoteSection(
      heading: json['heading'] as String,
      blocks: (json['blocks'] as List)
          .map((b) => LeaderNoteBlock.fromJson(b as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// The full leader-only content for one timeline session (#83) - the
/// Leiterheft's counterpart to what participants see in that module,
/// gated behind the Leiter-Key so participants never see it.
class LeaderNoteSession {
  final String sessionTitle;
  final List<LeaderNoteSection> sections;

  const LeaderNoteSession({required this.sessionTitle, required this.sections});

  factory LeaderNoteSession.fromJson(Map<String, dynamic> json) {
    return LeaderNoteSession(
      sessionTitle: json['sessionTitle'] as String,
      sections: (json['sections'] as List)
          .map((s) => LeaderNoteSection.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }
}
