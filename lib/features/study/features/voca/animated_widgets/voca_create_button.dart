import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/design_system/lib.dart';

class MouseHoverAnimationButton extends ConsumerStatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;

  const MouseHoverAnimationButton({
    super.key,
    required this.child,
    this.onPressed,
  });

  @override
  ConsumerState<MouseHoverAnimationButton> createState() =>
      _AnimatedFabButtonState();
}

class _AnimatedFabButtonState extends ConsumerState<MouseHoverAnimationButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: TweenAnimationBuilder<Color?>(
        tween: ColorTween(
          begin: MCColors.$color_grey_20,
          end: _hovered ? MCColors.$color_blue_40 : MCColors.$color_grey_20,
        ),
        duration: const Duration(milliseconds: 300),
        builder: (context, color, child) {
          // return FloatingActionButton.extended(
          //   backgroundColor: color,
          //   onPressed: () {
          //     ref
          //         .read(goRouterProvider)
          //         .pushNamed(RouterPath.englishAddVoca.name);
          //   },
          //   icon: const Icon(Icons.add),
          //   label: const Text("단어 만들기!"),
          // );
          return FloatingActionButton.extended(
            backgroundColor: color,
            onPressed: widget.onPressed,
            label: widget.child,
          );
        },
      ),
    );
  }
}
