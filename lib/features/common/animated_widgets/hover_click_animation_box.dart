import 'package:flutter/material.dart';
import 'package:machat/design_system/lib.dart';

class HoverClickAnimatedBox extends StatefulWidget {
  final double boxHeight;
  final VoidCallback onTap;
  const HoverClickAnimatedBox(
      {super.key, required this.onTap, required this.boxHeight});

  @override
  _HoverClickAnimatedBoxState createState() => _HoverClickAnimatedBoxState();
}

class _HoverClickAnimatedBoxState extends State<HoverClickAnimatedBox> {
  bool _isHovered = false;
  bool _isClicked = false;

  void _onEnter(PointerEvent _) => setState(() => _isHovered = true);
  void _onExit(PointerEvent _) => setState(() {
        _isHovered = false;
        _isClicked = false; // 클릭 해제 (선택사항)
      });
  double getOpacity() => _isClicked ? 0.3 : 1.0;

  int getDuration() => _isClicked ? 150 : 600;

  void _onTap() => setState(() {
        _isClicked = !_isClicked;
        widget.onTap();
      });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      child: GestureDetector(
        onTap: _onTap,
        child: AnimatedOpacity(
          opacity: getOpacity(),
          duration: Duration(milliseconds: getDuration()),
          curve: Curves.easeInOut,
          child: AnimatedContainer(
            duration: Duration(milliseconds: getDuration()),
            width: getWidth(),
            height: widget.boxHeight,
            decoration: BoxDecoration(
              color: MCColors.$color_blue_70,
              borderRadius: BorderRadius.circular(8.0),
              // border: Border.all(color: MCColors.$color_blue_30, width: 2.0),
            ),
            curve: Curves.easeInOut,
            child: Center(
              child: Text(
                _isClicked ? "화이팅!" : (_isHovered ? "공부하기" : "공부하기"),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double getWidth() {
    if (_isClicked) return 495;
    if (_isHovered) return 120;
    // return _isHovered || _isClicked ? 500 : 120;
    return 80;
  }
}
