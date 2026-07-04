import 'package:flutter/material.dart';

/// Wraps a child in a smooth focus glow. Used to highlight form fields when
/// they receive focus without re-implementing Flutter's default decorations.
class GlowFocus extends StatefulWidget {
  final Widget child;
  final double radius;
  final double blur;
  final Duration duration;

  const GlowFocus({
    super.key,
    required this.child,
    this.radius = 18,
    this.blur = 18,
    this.duration = const Duration(milliseconds: 220),
  });

  @override
  State<GlowFocus> createState() => _GlowFocusState();
}

class _GlowFocusState extends State<GlowFocus>
    with SingleTickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
    value: 0,
  );

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final t = Curves.easeOut.transform(_controller.value);
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.35 * t),
                  blurRadius: widget.blur * t,
                  spreadRadius: widget.radius * t * 0.10,
                ),
              ],
            ),
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
