import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A soft, slowly-drifting mesh of pastel blobs rendered behind any screen.
/// Stays performant: a single [AnimationController] drives every blob via
/// different phase offsets and curves.
class AnimatedGradientBackground extends StatefulWidget {
  final List<Color> colors;
  final Widget child;

  const AnimatedGradientBackground({
    super.key,
    required this.colors,
    required this.child,
  });

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Base wash using the supplied palette.
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.colors,
            ),
          ),
          child: const SizedBox.expand(),
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return CustomPaint(
              painter: _BlobPainter(
                progress: _controller.value,
                seedColors: widget.colors,
              ),
              child: const SizedBox.expand(),
            );
          },
        ),
        widget.child,
      ],
    );
  }
}

class _BlobPainter extends CustomPainter {
  final double progress;
  final List<Color> seedColors;

  _BlobPainter({required this.progress, required this.seedColors});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..blendMode = BlendMode.plus;
    final tau = math.pi * 2;

    // Five blobs with different sizes / orbit speeds. We blend using low
    // alpha so they remain pastel and unobtrusive.
    final blobs = <_BlobSpec>[
      _BlobSpec(
        color: seedColors.length > 1
            ? seedColors[1].withValues(alpha: 0.35)
            : const Color(0xFFB6C2FF).withValues(alpha: 0.35),
        radius: size.width * 0.55,
        orbitA: 0.20,
        orbitB: 0.18,
        speed: 1.0,
      ),
      _BlobSpec(
        color: const Color(0xFFFFC8DD).withValues(alpha: 0.30),
        radius: size.width * 0.45,
        orbitA: 0.30,
        orbitB: 0.26,
        speed: 0.7,
      ),
      _BlobSpec(
        color: const Color(0xFFBDE0FE).withValues(alpha: 0.30),
        radius: size.width * 0.50,
        orbitA: 0.35,
        orbitB: 0.20,
        speed: 1.3,
      ),
      _BlobSpec(
        color: const Color(0xFFFFE5A5).withValues(alpha: 0.25),
        radius: size.width * 0.40,
        orbitA: 0.25,
        orbitB: 0.30,
        speed: 0.9,
      ),
    ];

    for (final b in blobs) {
      final t = (progress * tau * b.speed) % tau;
      final cx = size.width * (0.5 + b.orbitA * math.cos(t));
      final cy = size.height * (0.5 + b.orbitB * math.sin(t * 1.1));
      paint
        ..color = b.color
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 60);
      canvas.drawCircle(Offset(cx, cy), b.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BlobPainter old) =>
      old.progress != progress || old.seedColors != seedColors;
}

class _BlobSpec {
  final Color color;
  final double radius;
  final double orbitA;
  final double orbitB;
  final double speed;

  _BlobSpec({
    required this.color,
    required this.radius,
    required this.orbitA,
    required this.orbitB,
    required this.speed,
  });
}
