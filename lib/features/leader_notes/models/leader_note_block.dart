/// One piece of leader-facing content within a [LeaderNoteSection] (#83).
///
/// Modeled as a small set of block types rather than one free-text field,
/// so the Leiterheft's actual structure (talking-point paragraphs, bullet/
/// numbered lists, Bible quotes with their reference, discussion questions,
/// video cues) survives the transcription and can be rendered with the
/// right visual treatment for each - a Bible quote should look different
/// from a plain paragraph, a discussion question should stand out, etc.
sealed class LeaderNoteBlock {
  const LeaderNoteBlock();

  factory LeaderNoteBlock.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    switch (type) {
      case 'subheading':
        return LeaderNoteSubheading(json['text'] as String);
      case 'paragraph':
        return LeaderNoteParagraph(json['text'] as String);
      case 'bulletList':
        return LeaderNoteBulletList((json['items'] as List).cast<String>());
      case 'numberedList':
        return LeaderNoteNumberedList((json['items'] as List).cast<String>());
      case 'quote':
        return LeaderNoteQuote(
          text: json['text'] as String,
          reference: json['reference'] as String,
        );
      case 'question':
        return LeaderNoteQuestion(json['text'] as String);
      case 'video':
        return LeaderNoteVideo(
          label: json['label'] as String,
          url: json['url'] as String?,
        );
      default:
        // Forward-compatible: an unknown block type (e.g. content authored
        // for a newer app version) is skipped rather than crashing the
        // whole session's content.
        return const LeaderNoteParagraph('');
    }
  }
}

/// A short, bold section-internal heading (e.g. "Trete in den Riss" ->
/// "Du könntest berufen sein, das Leben eines Fremden zu verändern"), or a
/// standalone bold emphasis sentence used the same way in the source.
class LeaderNoteSubheading extends LeaderNoteBlock {
  final String text;
  const LeaderNoteSubheading(this.text);
}

/// A normal talking-point paragraph.
class LeaderNoteParagraph extends LeaderNoteBlock {
  final String text;
  const LeaderNoteParagraph(this.text);
}

class LeaderNoteBulletList extends LeaderNoteBlock {
  final List<String> items;
  const LeaderNoteBulletList(this.items);
}

class LeaderNoteNumberedList extends LeaderNoteBlock {
  final List<String> items;
  const LeaderNoteNumberedList(this.items);
}

/// A Bible passage to read aloud, with its reference shown separately (the
/// source consistently sets these apart in an indented, italic style with
/// the reference right-aligned underneath).
class LeaderNoteQuote extends LeaderNoteBlock {
  final String text;
  final String reference;
  const LeaderNoteQuote({required this.text, required this.reference});
}

/// A question posed to the group, meant to stand out from surrounding
/// narrative text.
class LeaderNoteQuestion extends LeaderNoteBlock {
  final String text;
  const LeaderNoteQuestion(this.text);
}

/// A referenced video clip. [url] is nullable because the source material
/// only gives these as QR codes on the printed page - fill in the real
/// link once someone has scanned/looked it up; until then the label alone
/// is still useful context for the leader.
class LeaderNoteVideo extends LeaderNoteBlock {
  final String label;
  final String? url;
  const LeaderNoteVideo({required this.label, this.url});
}
