part of './lib.dart';

class AnimationSlideUp extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double startOffset;
  final Curve curve;

  const AnimationSlideUp({
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.startOffset = 0.8, // 기본값: 80% 아래
    this.curve = Curves.easeOut, // 기본값: 부드러운 애니메이션
    super.key,
  });

  @override
  _AnimationSlideUpState createState() => _AnimationSlideUpState();
}

class _AnimationSlideUpState extends State<AnimationSlideUp>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..forward();

    _offsetAnimation = Tween<Offset>(
      begin: Offset(0, widget.startOffset), // 시작 위치
      end: const Offset(0, 0), // 종료 위치
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve, // 애니메이션 곡선
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: widget.child, // 애니메이션이 적용될 자식 위젯
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
