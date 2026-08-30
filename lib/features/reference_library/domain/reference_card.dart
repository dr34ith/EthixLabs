/// Which group a card is displayed under on the Reference Library screen.
enum ReferenceSection { foundations, owaspAndTechniques, reference }

extension ReferenceSectionLabel on ReferenceSection {
  String get label {
    switch (this) {
      case ReferenceSection.foundations:
        return 'Foundations';
      case ReferenceSection.owaspAndTechniques:
        return 'OWASP & Techniques';
      case ReferenceSection.reference:
        return 'Reference';
    }
  }
}

/// (chip label, matching section) used by the filter row. "All" is handled
/// separately by the controller.
enum ReferenceFilter { all, foundations, owasp, reference }

/// Static metadata for one Reference Library card. Body content (for the
/// generic markdown-rendered cards) lives separately in
/// `referenceBodies` inside reference_content.dart — `isInteractive` cards
/// (Payloads) have their own bespoke screen instead of a markdown body.
class ReferenceCard {
  final String id;
  final String title;
  final String categoryLabel;
  final String icon;
  final String description;
  final int readingMinutes;
  final String difficulty; // 'Easy' | 'Medium' | 'Hard'
  final ReferenceSection section;
  final bool isInteractive;

  const ReferenceCard({
    required this.id,
    required this.title,
    required this.categoryLabel,
    required this.icon,
    required this.description,
    required this.readingMinutes,
    required this.difficulty,
    required this.section,
    this.isInteractive = false,
  });
}
