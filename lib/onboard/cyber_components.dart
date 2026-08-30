import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design system colors
class CyberColors {
  static const Color primaryNeon = Color(0xFFFF2E2E);
  static const Color primaryGlow = Color(0xFFFF5F5F);
  static const Color secondaryGlow = Color(0xFFFF8A8A);
  static const Color textRose = Color(0xFFFDC7C7);
  static const Color textDim = Color(0xFFB0A0A0);
  static const Color darkBg = Color(0xFF0F0D13);
  static const Color cardBg = Color(0x66000000);
}

/// Cyberpunk Monospace & Display Typography
class CyberTypography {
  static TextStyle heading({
    double fontSize = 24,
    Color color = CyberColors.textRose,
    double letterSpacing = 1.5,
    double height = 1.2,
    FontWeight fontWeight = FontWeight.bold,
  }) {
    return GoogleFonts.orbitron(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static TextStyle monospace({
    double fontSize = 14,
    Color color = CyberColors.textDim,
    double letterSpacing = 1.0,
    double height = 1.5,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return GoogleFonts.robotoMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }
}

/// A premium, animated cyber button with glow, gradient, and scale animation on press.
class CyberButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const CyberButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
  }) : super(key: key);

  @override
  State<CyberButton> createState() => _CyberButtonState();
}

class _CyberButtonState extends State<CyberButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = widget.onPressed != null && !widget.isLoading;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = isEnabled && true),
      onExit: (_) => setState(() => _isHovered = false),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: GestureDetector(
          onTapDown: isEnabled
              ? (_) {
                  _controller.forward();
                }
              : null,
          onTapUp: isEnabled
              ? (_) {
                  _controller.reverse();
                  widget.onPressed!();
                }
              : null,
          onTapCancel: isEnabled
              ? () {
                  _controller.reverse();
                }
              : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isEnabled
                    ? (_isHovered ? Colors.white : CyberColors.primaryNeon)
                    : CyberColors.primaryNeon.withOpacity(0.3),
                width: 2,
              ),
              gradient: isEnabled
                  ? const LinearGradient(
                      colors: [Color(0xFFFF1A1A), Color(0xFFFF5F5F)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.6),
                        CyberColors.primaryNeon.withOpacity(0.15)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              boxShadow: isEnabled
                  ? [
                      BoxShadow(
                        color: CyberColors.primaryNeon.withOpacity(_isHovered ? 0.6 : 0.4),
                        blurRadius: _isHovered ? 16 : 8,
                        spreadRadius: _isHovered ? 2 : 0,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.isLoading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                else ...[
                  if (!isEnabled && !widget.isLoading) ...[
                    const Icon(
                      Icons.lock_outline,
                      color: Colors.white60,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                  ] else if (widget.icon != null) ...[
                    Icon(
                      widget.icon,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    fit: FlexFit.loose,
                    child: Text(
                      widget.text.toUpperCase(),
                      style: GoogleFonts.orbitron(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                        color: isEnabled ? Colors.white : Colors.white60,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A premium, glassmorphic option selection card with custom icons, glowing borders, and smooth transitions.
class CyberOptionCard extends StatefulWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const CyberOptionCard({
    Key? key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  State<CyberOptionCard> createState() => _CyberOptionCardState();
}

class _CyberOptionCardState extends State<CyberOptionCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool selected = widget.isSelected;
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          width: 320,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected
                  ? CyberColors.primaryGlow
                  : (_isHovered
                      ? CyberColors.primaryGlow.withOpacity(0.6)
                      : CyberColors.primaryGlow.withOpacity(0.2)),
              width: selected ? 2.0 : 1.0,
            ),
            gradient: selected
                ? LinearGradient(
                    colors: [
                      CyberColors.primaryNeon.withOpacity(0.25),
                      CyberColors.primaryGlow.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: selected ? null : Colors.black.withOpacity(0.4),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: CyberColors.primaryNeon.withOpacity(0.25),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected
                      ? CyberColors.primaryNeon.withOpacity(0.2)
                      : Colors.white.withOpacity(0.05),
                  border: Border.all(
                    color: selected
                        ? CyberColors.primaryGlow
                        : CyberColors.primaryGlow.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Icon(
                  widget.icon,
                  color: selected ? Colors.white : CyberColors.textRose,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.title,
                      style: GoogleFonts.orbitron(
                        fontSize: 16,
                        fontWeight: selected ? FontWeight.bold : FontWeight.w600,
                        color: selected ? Colors.white : CyberColors.textRose,
                        letterSpacing: 1.0,
                      ),
                    ),
                    if (widget.subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        widget.subtitle!,
                        style: GoogleFonts.robotoMono(
                          fontSize: 11,
                          color: selected ? Colors.white70 : CyberColors.textDim,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? CyberColors.primaryNeon : Colors.transparent,
                  border: Border.all(
                    color: selected ? Colors.white : CyberColors.primaryGlow.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: selected
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 14,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A custom cyberpunk input field with a glowing focused state and corner brackets [ ].
class CyberTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final IconData icon;

  const CyberTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.icon,
  }) : super(key: key);

  @override
  State<CyberTextField> createState() => _CyberTextFieldState();
}

class _CyberTextFieldState extends State<CyberTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            widget.labelText.toUpperCase(),
            style: GoogleFonts.orbitron(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: _isFocused ? Colors.white : CyberColors.textRose,
              letterSpacing: 1.5,
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isFocused ? CyberColors.primaryGlow : CyberColors.primaryGlow.withOpacity(0.3),
              width: _isFocused ? 2.0 : 1.0,
            ),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: CyberColors.primaryNeon.withOpacity(0.15),
                      blurRadius: 10,
                      spreadRadius: 1,
                    )
                  ]
                : [],
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            style: GoogleFonts.robotoMono(
              color: Colors.white,
              fontSize: 15,
            ),
            cursorColor: CyberColors.primaryGlow,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: GoogleFonts.robotoMono(
                color: Colors.white.withOpacity(0.3),
                fontSize: 14,
              ),
              prefixIcon: Icon(
                widget.icon,
                color: _isFocused ? Colors.white : CyberColors.textRose.withOpacity(0.6),
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}

/// A sleek custom-drawn progress bar representing steps.
class CyberProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const CyberProgressBar({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double percent = currentStep / totalSteps;
    
    return Container(
      width: 320,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '[ STEP 0$currentStep / 0$totalSteps ]',
                style: GoogleFonts.orbitron(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: CyberColors.secondaryGlow,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                '${(percent * 100).toInt()}% READY',
                style: GoogleFonts.robotoMono(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: CyberColors.textDim,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                width: 320 * percent,
                height: 6,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [CyberColors.primaryNeon, CyberColors.primaryGlow],
                  ),
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      color: CyberColors.primaryNeon.withOpacity(0.25),
                      blurRadius: 6,
                      spreadRadius: 0.5,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
