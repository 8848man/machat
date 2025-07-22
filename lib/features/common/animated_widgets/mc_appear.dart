import 'package:flutter/material.dart';

class McAppear extends StatefulWidget {
  final Widget child;
  final int delayMs;
  final Duration duration;
  final Curve curve;

  const McAppear({
    super.key,
    required this.child,
    this.delayMs = 0,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeOut,
  });

  @override
  State<McAppear> createState() => _McAppearState();
}

class _McAppearState extends State<McAppear>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _opacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );

    _offset = Tween<Offset>(
      begin: const Offset(0, 0.1), // 약 10px 아래 (dy: 0.1)
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );

    // Delay 후 애니메이션 시작
    Future.delayed(Duration(milliseconds: widget.delayMs), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offset,
      child: FadeTransition(
        opacity: _opacity,
        child: widget.child,
      ),
    );
  }
}
