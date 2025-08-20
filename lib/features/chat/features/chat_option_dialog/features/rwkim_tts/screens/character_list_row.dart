import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/config/voice_package_config.dart';
import 'package:machat/features/chat/features/chat_option_dialog/features/rwkim_tts/providers/now_character_provider.dart';
import 'package:machat/features/chat/features/chat_option_dialog/features/rwkim_tts/view_models/rwkim_tts_view_model.dart';
import 'package:rwkim_tts/features/tts_service/enums/lib.dart';

class CharacterListRow extends ConsumerStatefulWidget {
  const CharacterListRow({super.key});

  @override
  ConsumerState<CharacterListRow> createState() => _CharacterListRowState();
}

class _CharacterListRowState extends ConsumerState<CharacterListRow>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<Offset>> _animations;
  late final RwkimTtsViewmodel notifier;
  final double charBoxSize = 30;

  @override
  void initState() {
    super.initState();
    // 노티파이어 할당
    notifier = ref.read(rwkimTtsViewmodelProvider.notifier);
    // 컨트롤러 생성
    _controllers = List.generate(
      voiceCharacters.length,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1000),
      ),
    );

    // 애니메이션 생성
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
    final VoiceCharacter nowCharacter = ref.watch(nowCharacterProvider);
    return SizedBox(
      height: charBoxSize,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: voiceCharacters.length,
        itemBuilder: (context, index) {
          return SlideTransition(
            position: _animations[index],
            child: buildCharacterSelectBox(
              voiceCharacters[index],
              nowCharacter == voiceCharacters[index],
            ),
          );
        },
      ),
    );
  }

  Widget buildCharacterSelectBox(
    VoiceCharacter character,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () => notifier.changeCharacter(character),
      child: SizedBox(
        height: charBoxSize,
        width: charBoxSize + 16,
        child: CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(
            getVoiceImagePath(character, packageName: ttsPackageName),
          ),
        ),
      ),
    );
  }
}
