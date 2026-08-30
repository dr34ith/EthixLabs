import 'package:flutter/material.dart';

import '../../domain/payload_technique.dart';
import 'payload_copy_row.dart';

/// Renders one technique: its name, a short description, and every payload
/// row that belongs to it.
class PayloadTechniqueBlock extends StatelessWidget {
  final PayloadTechnique technique;

  const PayloadTechniqueBlock({Key? key, required this.technique})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '▸ ${technique.name}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8B0000),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            technique.description,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF9E9E9E),
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 8),
          ...technique.payloads.map((p) => PayloadCopyRow(payload: p)),
        ],
      ),
    );
  }
}
