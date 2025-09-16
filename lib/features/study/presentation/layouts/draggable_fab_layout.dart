import 'package:flutter/material.dart';

class DraggableFabLayout extends StatefulWidget {
  final Widget child;
  final Widget fab;

  const DraggableFabLayout({
    super.key,
    required this.child,
    required this.fab,
  });

  @override
  State<DraggableFabLayout> createState() => _DraggableFabLayoutState();
}

class _DraggableFabLayoutState extends State<DraggableFabLayout> {
  Offset position = const Offset(16, 66); // 초기 FAB 위치

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child, // 사용자 정의 본문 위젯

        // FAB 포지션 위젯
        Positioned(
          left: position.dx,
          top: position.dy,
          child: Draggable(
            feedback: Opacity(
              opacity: 0.7,
              child: widget.fab,
            ),
            childWhenDragging: const SizedBox.shrink(),
            onDragEnd: (details) {
              setState(() {
                final size = MediaQuery.of(context).size;
                final maxX = size.width - 56;
                final maxY = size.height - 56;

                final adjustedOffset = Offset(
                  details.offset.dx,
                  details.offset.dy,
                );

                position = Offset(
                  adjustedOffset.dx.clamp(0, maxX),
                  adjustedOffset.dy.clamp(0, maxY),
                );
              });
            },
            child: widget.fab,
          ),
        ),
      ],
    );
  }
}
