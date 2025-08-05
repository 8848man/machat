import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/design_system/lib.dart';
import 'package:machat/router/lib.dart';

class AnimatedFabButton extends ConsumerStatefulWidget {
  const AnimatedFabButton({super.key});

  @override
  ConsumerState<AnimatedFabButton> createState() => _AnimatedFabButtonState();
}

class _AnimatedFabButtonState extends ConsumerState<AnimatedFabButton> {
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
          return FloatingActionButton.extended(
            backgroundColor: color,
            onPressed: () {
              ref
                  .read(goRouterProvider)
                  .goNamed(RouterPath.englishAddVoca.name);
            },
            icon: const Icon(Icons.add),
            label: const Text("단어 만들기!"),
          );
        },
      ),
    );
  }
}
