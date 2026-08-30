import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/reference_content.dart';
import '../../domain/reference_card.dart';
import '../controllers/reference_controller.dart';
import '../widgets/library_card.dart' show kLibraryGold;
import '../widgets/markdown_body_view.dart';

/// Generic detail screen for every non-interactive Reference Library card
/// (Payloads has its own screen instead — see PayloadsScreen).
class ReferenceDetailScreen extends StatefulWidget {
  final String cardId;

  const ReferenceDetailScreen({Key? key, required this.cardId})
      : super(key: key);

  @override
  State<ReferenceDetailScreen> createState() => _ReferenceDetailScreenState();
}

class _ReferenceDetailScreenState extends State<ReferenceDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReferenceController>().markRead(widget.cardId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ReferenceController>();
    final ReferenceCard? card =
        referenceCards.where((c) => c.id == widget.cardId).firstOrNull;
    final body = referenceBodies[widget.cardId] ?? '';

    if (card == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF0A0A1A),
        body: Center(
          child: Text('Not found', style: TextStyle(color: Colors.white54)),
        ),
      );
    }

    final isBookmarked = controller.isBookmarked(card.id);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white70),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.favorite : Icons.favorite_border,
              color: isBookmarked ? kLibraryGold : Colors.white70,
            ),
            onPressed: () => controller.toggleBookmark(card.id),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(card.icon, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(
                    card.categoryLabel,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8B0000),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                card.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 13, color: Color(0xFF8E8E9E)),
                  const SizedBox(width: 4),
                  Text(
                    '${card.readingMinutes} min read',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF8E8E9E)),
                  ),
                  const SizedBox(width: 10),
                  const Text('·', style: TextStyle(color: Color(0xFF8E8E9E))),
                  const SizedBox(width: 10),
                  Text(
                    card.difficulty,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF8E8E9E)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: Color(0xFF2A2A3E), height: 1),
              const SizedBox(height: 16),
              MarkdownBodyView(markdown: body),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
