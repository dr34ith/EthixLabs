import 'package:flutter/material.dart';

import 'library_card.dart' show kLibraryCrimson;
import '../../../../core/theme/app_colors.dart';

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

  // Wider line-height + slightly larger size + softer white for less eye
  // strain on long reads.
  static const TextStyle _bodyStyle = TextStyle(
    fontSize: 15.5,
    height: 1.75,
    letterSpacing: 0.1,
    color: Color(0xFFEDEDF2),
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
          padding: const EdgeInsets.only(top: 28, bottom: 14),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.3,
            ),
          ),
        );
      case 2:
        // Small crimson accent bar to the left — makes section breaks easy
        // to scan without leaning on emoji.
        return Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: kLibraryCrimson,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 18.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      default:
        return Padding(
          padding: const EdgeInsets.only(top: 18, bottom: 8),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: kLibraryCrimson,
              letterSpacing: 0.3,
            ),
          ),
        );
    }
  }

  Widget _paragraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: RichText(text: TextSpan(children: _parseInline(text, _bodyStyle))),
    );
  }

  Widget _bullet(String text) {
    // Bullets now sit inside a faint reddish-tinted row so a list of
    // points reads as a distinct block instead of blending into plain
    // paragraphs — helps scannability on long articles.
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.bgCard.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
          border: Border(
            left: BorderSide(color: kLibraryCrimson.withOpacity(0.6), width: 3),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Icon(Icons.circle, size: 6, color: kLibraryCrimson),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: RichText(
                text: TextSpan(children: _parseInline(text, _bodyStyle)),
              ),
            ),
          ],
        ),
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