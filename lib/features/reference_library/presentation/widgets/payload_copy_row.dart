import 'package:flutter/material.dart';

import '../../domain/payload_item.dart';
import '../../../../core/utils/platform_safe.dart';

/// A single copy-pasteable payload row: monospace value on the left, a
/// copy-to-clipboard button on the right, and the target location below.
class PayloadCopyRow extends StatefulWidget {
  final PayloadItem payload;

  const PayloadCopyRow({Key? key, required this.payload}) : super(key: key);

  @override
  State<PayloadCopyRow> createState() => _PayloadCopyRowState();
}

class _PayloadCopyRowState extends State<PayloadCopyRow> {
  bool _justCopied = false;

  Future<void> _copy() async {
    await safeCopyToClipboard(widget.payload.value);
    if (!mounted) return;

    setState(() => _justCopied = true);
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) setState(() => _justCopied = false);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color(0xFF8B0000),
        duration: Duration(milliseconds: 1500),
        content: Row(
          children: [
            Icon(Icons.check, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text('Copied to clipboard', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: AnimatedOpacity(
        opacity: _justCopied ? 0.5 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF2A2A3E)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SelectableText(
                      widget.payload.value,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
                        color: Color(0xFFE0E0E0),
                      ),
                    ),
                  ),
                  Semantics(
                    label: 'Copy payload',
                    button: true,
                    child: SizedBox(
                      width: 44,
                      height: 44,
                      child: IconButton(
                        icon: const Icon(Icons.copy, color: Color(0xFFE68C8C)),
                        onPressed: _copy,
                        tooltip: 'Copy payload',
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                'Location: ${widget.payload.location}',
                style: const TextStyle(fontSize: 11, color: Color(0xFF9E9E9E)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
