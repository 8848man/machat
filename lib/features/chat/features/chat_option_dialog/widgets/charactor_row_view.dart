import 'package:flutter/material.dart';

class AnimatedHorizontalList extends StatefulWidget {
  const AnimatedHorizontalList({super.key});

  @override
  State<AnimatedHorizontalList> createState() => _AnimatedHorizontalListState();
}

class _AnimatedHorizontalListState extends State<AnimatedHorizontalList>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<Offset>> _animations;
  final int itemCount = 10;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      itemCount,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1000),
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<Offset>(
        begin: const Offset(4, 0), // 오른쪽에서 시작
        end: Offset.zero, // 제자리
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut, // 감속 느낌
      ));
    }).toList();

    _startAnimations();
  }

  void _startAnimations() async {
    for (int i = 0; i < _controllers.length; i++) {
      await Future.delayed(Duration(milliseconds: i * 50)); // 각 아이템 딜레이
      _controllers[i].forward();
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return SlideTransition(
            position: _animations[index],
            child: Container(
              width: 30,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              color: Colors.blueAccent,
              alignment: Alignment.center,
              child: Text(
                'Item $index',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}
