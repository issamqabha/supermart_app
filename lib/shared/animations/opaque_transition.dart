import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OpaqueTransition extends StatelessWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;

  const OpaqueTransition({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  Widget build(BuildContext context) {
    return child.animate().fadeIn(
      duration: duration,
      delay: delay,
    ).scale(
      duration: duration,
      begin: const Offset(0.9, 0.9),
      end: const Offset(1.0, 1.0),
    );
  }
}