import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/reference_content.dart';
import '../../domain/reference_card.dart';
import '../controllers/reference_controller.dart';
import '../widgets/library_card.dart' show kLibraryGold, kLibraryCrimson;
import '../widgets/markdown_body_view.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/breathing_glow.dart';

/// Generic detail screen for every non-interactive Reference Library card
/// (Payloads has its own screen instead — see PayloadsScreen).
class ReferenceDetailScreen extends StatefulWidget {
  final String cardId;

  const ReferenceDetailScreen({Key? key, required this.cardId})
      : super(key: key);

  @override
  State<ReferenceDetailScreen> createState() => _ReferenceDetailScreenState();
}

class _ReferenceDetailScreenState extends State<ReferenceDetailScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entryCtrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReferenceController>().markRead(widget.cardId);
    });
    // Subtle fade + rise-in when the article opens — matches the reddish
    // "hacker terminal" feel used elsewhere in the app.
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _fade = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic));
    _entryCtrl.forward();
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ReferenceController>();
    final ReferenceCard? card =
        referenceCards.where((c) => c.id == widget.cardId).firstOrNull;
    final body = referenceBodies[widget.cardId] ?? '';

    if (card == null) {
      return const Scaffold(
        backgroundColor: AppColors.bgPrimary,
        body: Center(
          child: Text('Not found', style: TextStyle(color: Colors.white54)),
        ),
      );
    }

    final isBookmarked = controller.isBookmarked(card.id);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: DecoratedBox(
        // Soft crimson glow bleeding down from the top — same reddish
        // ambience as the dashboard, instead of the flat black before.
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -1.1),
            radius: 1.4,
            colors: [Color(0x338B0000), Colors.transparent],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white70),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (child, anim) =>
                            ScaleTransition(scale: anim, child: child),
                        child: Icon(
                          isBookmarked ? Icons.favorite : Icons.favorite_border,
                          key: ValueKey(isBookmarked),
                          color: isBookmarked ? kLibraryGold : Colors.white70,
                        ),
                      ),
                      onPressed: () => controller.toggleBookmark(card.id),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FadeTransition(
                  opacity: _fade,
                  child: SlideTransition(
                    position: _slide,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category chip with a slow breathing glow — gives the
                          // header a bit of life instead of sitting flat.
                          BreathingGlow(
                            color: kLibraryCrimson,
                            intensity: 0.25,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: kLibraryCrimson.withOpacity(0.14),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: kLibraryCrimson.withOpacity(0.4),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(card.icon,
                                      style: const TextStyle(fontSize: 15)),
                                  const SizedBox(width: 6),
                                  Text(
                                    card.categoryLabel,
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.4,
                                      color: kLibraryCrimson,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            card.title,
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Icons.access_time,
                                  size: 13, color: AppColors.textFaint),
                              const SizedBox(width: 4),
                              Text(
                                '${card.readingMinutes} min read',
                                style: TextStyle(
                                    fontSize: 12.5, color: AppColors.textFaint),
                              ),
                              const SizedBox(width: 10),
                              Text('·',
                                  style: TextStyle(color: AppColors.textFaint)),
                              const SizedBox(width: 10),
                              Text(
                                card.difficulty,
                                style: TextStyle(
                                    fontSize: 12.5, color: AppColors.textFaint),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          // Gradient divider instead of a flat gray line —
                          // reads like a scan line, fits the theme.
                          Container(
                            height: 1.2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  kLibraryCrimson.withOpacity(0.7),
                                  kLibraryCrimson.withOpacity(0.0),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          MarkdownBodyView(markdown: body),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
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