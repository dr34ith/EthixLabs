import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ethixlabs/theme.dart';
import 'package:ethixlabs/core/widgets/screen_title_header.dart';

enum NodeState { locked, available, completed }

// ─── Node layout data ─────────────────────────────────────────────────────
class _NodeData {
  final String title;
  final String subtitle;
  final String icon;
  // Fractional positions (0.0–1.0) relative to the canvas
  final double cx; // center-x fraction
  final double cy; // center-y fraction
  final bool labelBelow; // true = label below chest, false = label above
  final bool isFinal;

  const _NodeData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.cx,
    required this.cy,
    this.labelBelow = false,
    this.isFinal = false,
  });
}

// ─── Screen ───────────────────────────────────────────────────────────────
class RoadmapScreen extends StatefulWidget {
  const RoadmapScreen({Key? key}) : super(key: key);

  @override
  State<RoadmapScreen> createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends State<RoadmapScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  final ScrollController _scrollController = ScrollController();

  // 0 = node 0 available, 1 = node 1 available, etc.
  int _currentLevel = 0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  NodeState _getNodeState(int i) {
    if (i < _currentLevel) return NodeState.completed;
    if (i == _currentLevel) return NodeState.available;
    return NodeState.locked;
  }

  void _handleNodeTap(int i, String title) {
    final state = _getNodeState(i);
    final msg = state == NodeState.locked
        ? 'Complete previous milestones first.'
        : state == NodeState.completed
            ? '$title already completed! 🎉'
            : 'Opening $title…';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: state == NodeState.completed
          ? Colors.green
          : AppColors.accent,
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            // ── Title ──
            const ScreenTitleHeader(
              title: 'RoadMap',
              subtitle: '7 milestones from Pre-Test to Graduation.',
            ),

            // ── Scrollable map ──
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                child: _RoadmapCanvas(
                  pulseController: _pulseController,
                  getNodeState: _getNodeState,
                  handleNodeTap: _handleNodeTap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Canvas ───────────────────────────────────────────────────────────────
class _RoadmapCanvas extends StatelessWidget {
  final AnimationController pulseController;
  final NodeState Function(int) getNodeState;
  final void Function(int, String) handleNodeTap;

  const _RoadmapCanvas({
    required this.pulseController,
    required this.getNodeState,
    required this.handleNodeTap,
  });

  // Canvas height — tall enough that nodes never crowd each other
  static const double _canvasHeight = 1320.0;

  /*
   * Candy-Crush snake layout:
   *   node 0  →  left  side  (cx ≈ 0.25)
   *   node 1  →  right side  (cx ≈ 0.72)
   *   node 2  →  left  side  (cx ≈ 0.25)
   *   …
   *   node 6  →  center      (cx = 0.50, final)
   *
   * cy values are evenly spaced so the gap between any two
   * consecutive nodes is identical (~0.13 of canvas height).
   */
  static const List<_NodeData> _nodes = [
    _NodeData(
      title: 'PRE-TEST',
      subtitle: 'Baseline Assessment\nBefore Missions',
      icon: 'assets/pixel_images/treasure_for_roadmap.png',
      cx: 0.25, cy: 0.07,
      labelBelow: true,
    ),
    _NodeData(
      title: 'BASICS',
      subtitle: 'Introduction to Basics\nMissions 1–4',
      icon: 'assets/pixel_images/treasure_for_roadmap.png',
      cx: 0.75, cy: 0.21,
      labelBelow: true,
    ),
    _NodeData(
      title: 'FOUNDATIONAL',
      subtitle: 'Core Attacks\nMissions 5–14',
      icon: 'assets/pixel_images/treasure_for_roadmap.png',
      cx: 0.25, cy: 0.35,
      labelBelow: true,
    ),
    _NodeData(
      title: 'INTERMEDIATE',
      subtitle: 'Auth & Crypto\nMissions 15–23',
      icon: 'assets/pixel_images/treasure_for_roadmap.png',
      cx: 0.75, cy: 0.49,
      labelBelow: true,
    ),
    _NodeData(
      title: 'ADVANCED',
      subtitle: 'Chain Attacks\nMissions 24–25',
      icon: 'assets/pixel_images/treasure_for_roadmap.png',
      cx: 0.25, cy: 0.63,
      labelBelow: true,
    ),
    _NodeData(
      title: 'POST-TEST',
      subtitle: 'Final Assessment\n20 items · 80% pass',
      icon: 'assets/pixel_images/treasure_for_roadmap.png',
      cx: 0.75, cy: 0.77,
      labelBelow: true,
    ),
    _NodeData(
      title: 'GRADUATION',
      subtitle: 'Certificate of Completion\nFinal Milestone',
      icon: 'assets/pixel_images/TROPHY.png',
      cx: 0.50, cy: 0.91,
      labelBelow: true,
      isFinal: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = _canvasHeight;

        return SizedBox(
          width: w,
          height: h,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Layer 1 — Background
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: Image.asset(
                    'assets/images/roadmap_for_LearningBG.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.background,
                            AppColors.surface,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Dark tint so nodes always pop
              Positioned.fill(
                child: Container(color: Colors.black.withOpacity(0.35)),
              ),

              // Layer 2 — Animated dashed trail
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: pulseController,
                  builder: (_, __) => CustomPaint(
                    painter: _SnakeTrailPainter(
                      nodes: _nodes,
                      canvasSize: Size(w, h),
                      pulseValue: pulseController.value,
                    ),
                  ),
                ),
              ),

              // Layer 3 — Nodes
              ..._nodes.asMap().entries.map((e) {
                final i = e.key;
                final node = e.value;
                final state = getNodeState(i);
                final cx = node.cx * w;
                final cy = node.cy * h;
                final chestSize = node.isFinal ? 88.0 : 64.0;

                return Positioned(
                  // Center the node widget on (cx, cy)
                  left: cx - chestSize / 2,
                  top: cy - chestSize / 2,
                  child: _ChestNode(
                    node: node,
                    state: state,
                    chestSize: chestSize,
                    pulseController: pulseController,
                    onTap: () => handleNodeTap(i, node.title),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

// ─── Snake Trail Painter ──────────────────────────────────────────────────
class _SnakeTrailPainter extends CustomPainter {
  final List<_NodeData> nodes;
  final Size canvasSize;
  final double pulseValue;

  const _SnakeTrailPainter({
    required this.nodes,
    required this.canvasSize,
    required this.pulseValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final points = nodes
        .map((n) => Offset(n.cx * w, n.cy * h))
        .toList();

    // Smooth curved path through all node centers
    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      // Cubic Bezier: control points push curve inward for S-shape
      final midX = (p0.dx + p1.dx) / 2;
      path.cubicTo(
        midX, p0.dy,
        midX, p1.dy,
        p1.dx, p1.dy,
      );
    }

    // Glow layer
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.accent.withOpacity(0.12 + pulseValue * 0.10)
        ..strokeWidth = 18
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Dashed line on top
    _drawDashed(
      canvas,
      path,
      Paint()
        ..color = AppColors.accent.withOpacity(0.55 + pulseValue * 0.20)
        ..strokeWidth = 3.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
      dashLen: 10,
      gapLen: 8,
    );
  }

  void _drawDashed(
    Canvas canvas,
    Path source,
    Paint paint, {
    required double dashLen,
    required double gapLen,
  }) {
    final dest = Path();
    for (final metric in source.computeMetrics()) {
      double dist = 0;
      bool drawing = true;
      while (dist < metric.length) {
        final len = drawing ? dashLen : gapLen;
        if (drawing) {
          dest.addPath(
            metric.extractPath(dist, dist + len),
            Offset.zero,
          );
        }
        dist += len;
        drawing = !drawing;
      }
    }
    canvas.drawPath(dest, paint);
  }

  @override
  bool shouldRepaint(_SnakeTrailPainter old) =>
      old.pulseValue != pulseValue;
}

// ─── Chest Node ───────────────────────────────────────────────────────────
class _ChestNode extends StatelessWidget {
  final _NodeData node;
  final NodeState state;
  final double chestSize;
  final AnimationController pulseController;
  final VoidCallback onTap;

  const _ChestNode({
    required this.node,
    required this.state,
    required this.chestSize,
    required this.pulseController,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Total widget height = chestSize + gap + labelCard height
    // Width is fixed so it never escapes its column
    final labelWidth = node.isFinal ? 160.0 : 130.0;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: labelWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Chest ──
            Center(child: _buildChest()),
            const SizedBox(height: 8),
            // ── Label card ──
            _buildLabel(labelWidth),
          ],
        ),
      ),
    );
  }

  // ── Chest visuals ────────────────────────────────────────────────────────
  Widget _buildChest() {
    switch (state) {
      case NodeState.locked:
        return _lockedChest();
      case NodeState.available:
        return _availableChest();
      case NodeState.completed:
        return _completedChest();
    }
  }

  Widget _lockedChest() {
    return Container(
      width: chestSize,
      height: chestSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black54,
        border: Border.all(color: Colors.grey.withOpacity(0.45), width: 2),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ColorFiltered(
            colorFilter: const ColorFilter.matrix([
              0.2126, 0.7152, 0.0722, 0, 0,
              0.2126, 0.7152, 0.0722, 0, 0,
              0.2126, 0.7152, 0.0722, 0, 0,
              0,      0,      0,      0.5, 0,
            ]),
            child: Image.asset(
              node.icon,
              width: chestSize * 0.65,
              height: chestSize * 0.65,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  Icon(Icons.lock_outline, color: Colors.grey, size: chestSize * 0.4),
            ),
          ),
          Positioned(
            bottom: 2, right: 2,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: Colors.black87,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.lock, color: Colors.grey, size: chestSize * 0.22),
            ),
          ),
        ],
      ),
    );
  }

  Widget _availableChest() {
    return AnimatedBuilder(
      animation: pulseController,
      builder: (_, __) {
        final p = pulseController.value;
        return Container(
          width: chestSize,
          height: chestSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withOpacity(0.25 + p * 0.45),
                blurRadius: 16 + p * 14,
                spreadRadius: 2 + p * 4,
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.3),
              border: Border.all(color: AppColors.accent, width: 2.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                node.icon,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.inventory_2_outlined,
                  color: AppColors.accent,
                  size: chestSize * 0.5,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _completedChest() {
    return Container(
      width: chestSize,
      height: chestSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.45),
            blurRadius: 20,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.3),
              border: Border.all(color: Colors.green, width: 2.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                node.icon,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    Icon(Icons.check_circle, color: Colors.green, size: chestSize * 0.5),
              ),
            ),
          ),
          // Star badge
          Positioned(
            top: -4, right: -4,
            child: Container(
              width: 22, height: 22,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: const Icon(Icons.star, color: Colors.white, size: 13),
            ),
          ),
        ],
      ),
    );
  }

  // ── Label card ────────────────────────────────────────────────────────────
  Widget _buildLabel(double width) {
    final Color borderColor = state == NodeState.available
        ? AppColors.accent
        : state == NodeState.completed
            ? Colors.green
            : Colors.grey.shade700;

    final Color bgColor = state == NodeState.locked
        ? Colors.black.withOpacity(0.55)
        : const Color(0xFF1A0A10).withOpacity(0.90);

    return Container(
      width: width,
      padding: EdgeInsets.symmetric(
        horizontal: node.isFinal ? 12 : 10,
        vertical: node.isFinal ? 8 : 6,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: state != NodeState.locked
            ? [
                BoxShadow(
                  color: borderColor.withOpacity(0.35),
                  blurRadius: state == NodeState.available ? 12 : 6,
                  spreadRadius: 1,
                ),
              ]
            : [],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            node.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.orbitron(
              fontSize: node.isFinal ? 11 : 9,
              fontWeight: FontWeight.bold,
              color: state == NodeState.locked
                  ? Colors.grey
                  : state == NodeState.completed
                      ? Colors.greenAccent
                      : AppColors.accentSoft,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            node.subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.robotoMono(
              fontSize: 8,
              color: state == NodeState.locked
                  ? Colors.grey.shade600
                  : Colors.white.withOpacity(0.80),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}