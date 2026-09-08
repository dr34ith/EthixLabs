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
          Expanded(
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                // Gradient fade instead of a flat gray line, so it reads
                // clearly against the circuit-board background art instead
                // of disappearing into it.
                gradient: LinearGradient(
                  colors: [
                    kLibraryCrimson.withOpacity(0.55),
                    kLibraryCrimson.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}