import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LikeAnimationView extends StatefulWidget {
  final Widget child;
  final bool isAnimating;
  final Duration duration;
  final VoidCallback? onEnd;
  final bool smallLike;

  const LikeAnimationView({
    super.key,
    required this.child,
    required this.isAnimating,
    this.duration = const Duration(milliseconds: 150),
    this.onEnd,
    this.smallLike = false,
  });

  @override
  State<LikeAnimationView> createState() => _LikeAnimationViewState();
}

class _LikeAnimationViewState extends State<LikeAnimationView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> scale;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration.inMilliseconds ~/ 2),
    );

    scale = Tween<double>(begin: 1, end: 1.2).animate(_controller);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant LikeAnimationView oldWidget) {
    if (widget.isAnimating != oldWidget.isAnimating) {
      startAnimation();
    }
    super.didUpdateWidget(oldWidget);
  }

  startAnimation() async {
    if (widget.isAnimating || widget.smallLike) {
      await _controller.forward();
      await _controller.reverse();
      await Future.delayed(
        const Duration(milliseconds: 200),
      );
      if (widget.onEnd != null) {
        widget.onEnd!();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}
