import 'package:flutter/material.dart';

import 'library_card.dart' show kLibraryCrimson;

/// Lightweight section divider used to group cards on the Reference
/// Library screen ("Foundations", "OWASP & Techniques", "Reference").
class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Row(
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: kLibraryCrimson,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Divider(color: Color(0xFF2A2A3E), height: 1, thickness: 1),
          ),
        ],
      ),
    );
  }
}
