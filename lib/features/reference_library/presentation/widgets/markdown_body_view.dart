import 'package:flutter/material.dart';

import 'library_card.dart' show kLibraryCrimson;

/// Renders the small subset of markdown actually used by
/// reference_content.dart: `#`/`##`/`###` headings, `**bold**` inline
/// spans, `- ` bullet items, and blank-line-separated paragraphs.
///
/// Deliberately hand-rolled instead of pulling in a markdown package —
/// the content is fully static and only ever uses this subset, so a full
/// markdown renderer (and its parsing edge cases) would be pure overhead.
class MarkdownBodyView extends StatelessWidget {
  final String markdown;

  const MarkdownBodyView({Key? key, required this.markdown}) : super(key: key);

  static const TextStyle _bodyStyle = TextStyle(
    fontSize: 15,
    height: 1.6,
    color: Color(0xFFE8E8EC),
  );

  @override
  Widget build(BuildContext context) {
    final lines = markdown.trim().split('\n');
    final blocks = <Widget>[];

    for (final rawLine in lines) {
      final line = rawLine.trim();
      if (line.isEmpty) continue;

      if (line.startsWith('### ')) {
        blocks.add(_heading(line.substring(4), 3));
      } else if (line.startsWith('## ')) {
        blocks.add(_heading(line.substring(3), 2));
      } else if (line.startsWith('# ')) {
        blocks.add(_heading(line.substring(2), 1));
      } else if (line.startsWith('- ')) {
        blocks.add(_bullet(line.substring(2)));
      } else {
        blocks.add(_paragraph(line));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: blocks,
    );
  }

  Widget _heading(String text, int level) {
    switch (level) {
      case 1:
        return Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 12),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );
      case 2:
        return Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 8),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );
      default:
        return Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: kLibraryCrimson,
            ),
          ),
        );
    }
  }

  Widget _paragraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: RichText(text: TextSpan(children: _parseInline(text, _bodyStyle))),
    );
  }

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•  ', style: _bodyStyle),
          Expanded(
            child: RichText(
              text: TextSpan(children: _parseInline(text, _bodyStyle)),
            ),
          ),
        ],
      ),
    );
  }

  /// Splits `text` on `**bold**` markers into alternating regular/bold
  /// [TextSpan]s, so a line like "**Authorization** — never test without
  /// permission." renders with just the label bolded.
  static List<InlineSpan> _parseInline(String text, TextStyle baseStyle) {
    final spans = <InlineSpan>[];
    final pattern = RegExp(r'\*\*(.+?)\*\*');
    var lastEnd = 0;
    for (final match in pattern.allMatches(text)) {
      if (match.start > lastEnd) {
        spans.add(TextSpan(
          text: text.substring(lastEnd, match.start),
          style: baseStyle,
        ));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: baseStyle.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
      ));
      lastEnd = match.end;
    }
    if (lastEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastEnd), style: baseStyle));
    }
    return spans;
  }
}
