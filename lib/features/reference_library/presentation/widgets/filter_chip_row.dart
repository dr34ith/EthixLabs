import 'package:flutter/material.dart';

import '../../domain/reference_card.dart';
import 'library_card.dart' show kLibraryCrimson;

const List<MapEntry<String, ReferenceFilter>> kReferenceFilters = [
  MapEntry('All', ReferenceFilter.all),
  MapEntry('Foundations', ReferenceFilter.foundations),
  MapEntry('OWASP', ReferenceFilter.owasp),
  MapEntry('Reference', ReferenceFilter.reference),
];

class ReferenceFilterChipRow extends StatelessWidget {
  final ReferenceFilter selected;
  final ValueChanged<ReferenceFilter> onSelected;

  const ReferenceFilterChipRow({
    Key? key,
    required this.selected,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: kReferenceFilters.map((entry) {
          final isActive = selected == entry.value;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onSelected(entry.value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isActive ? kLibraryCrimson : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  border: isActive
                      ? null
                      : Border.all(color: const Color(0xFF3A3A4E)),
                ),
                child: Text(
                  entry.key,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isActive ? Colors.white : const Color(0xFFB0B0C0),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
