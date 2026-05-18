import 'package:flutter/material.dart';
import 'package:test_vuln/theme/cyber_theme.dart';

class BackgroundStack extends StatelessWidget {
  final Widget child;
  final String? backgroundImageAsset;
  final bool showVignette;

  const BackgroundStack({
    Key? key,
    required this.child,
    this.backgroundImageAsset = 'assets/images/mission_bg.jpg',
    this.showVignette = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [
            // Circuit board background at bottom of stack
            Positioned.fill(
              child: Image.asset(
                backgroundImageAsset!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          CyberTheme.background,
                          CyberTheme.surface,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Vignette overlay to make central UI elements pop
            if (showVignette)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.7),
                      ],
                      stops: const [0.0, 0.6, 1.0],
                      center: Alignment.center,
                      radius: 1.0,
                    ),
                  ),
                ),
              ),

            // SafeArea integration for status bar handling
            SafeArea(
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
