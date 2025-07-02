import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rwkim_tts/features/tts_service/enums/lib.dart';

class CharacterList extends ConsumerStatefulWidget {
  const CharacterList({super.key});

  @override
  ConsumerState<CharacterList> createState() => _AnimatedHorizontalListState();
}

class _AnimatedHorizontalListState extends ConsumerState<CharacterList>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<Offset>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      voiceCharacters.length,
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
        itemCount: voiceCharacters.length,
        itemBuilder: (context, index) {
          return SlideTransition(
            position: _animations[index],
            child: buildCharacterSelectBox(
              // context,
              // ref,
              voiceCharacters[index],
            ),
          );
        },
      ),
    );
  }

  Widget buildCharacterSelectBox(
    // BuildContext context,
    // WidgetRef ref,
    VoiceCharacter character,
  ) {
    return CircleAvatar(
      radius: 30,
      backgroundImage: AssetImage(
        getVoiceImagePath(character, packageName: 'rwkim_tts'), // 캐릭터 이미지 경로
      ), // Replace with your character image
    );
  }
}
