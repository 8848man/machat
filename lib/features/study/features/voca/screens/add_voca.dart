import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/design_system/lib.dart';
import 'package:machat/features/common/animated_widgets/mc_appear.dart';
import 'package:machat/features/common/layouts/bundle_layout.dart';
import 'package:machat/features/common/layouts/lib.dart';
import 'package:machat/features/common/providers/loading_state_provider.dart';
import 'package:machat/features/common/utils/comma_seperator.dart';
import 'package:machat/features/study/features/voca/models/word_model.dart';
import 'package:machat/features/study/features/voca/view_models/add_voca_view_model.dart';

class AddVoca extends ConsumerWidget {
  const AddVoca({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    FocusNode wordFocusNode = FocusNode();
    TextEditingController wordController = TextEditingController();
    TextEditingController meaningController = TextEditingController();
    TextEditingController tagController = TextEditingController();
    TextEditingController enExController = TextEditingController();
    TextEditingController koExController = TextEditingController();
    final AddVocaViewModel notifier =
        ref.read(addVocaViewModelProvider.notifier);
    // 단어 검색 이벤트 추가
    wordFocusNode.addListener(() async {
      if (!wordFocusNode.hasFocus) {
        final WordModel? getWord =
            await notifier.getWordInFirebase(wordController.text);
        if (getWord != null) {
          meaningController.text = getWord.meanings.join(', ');
          tagController.text = getWord.tags.join(', ');
          enExController.text = getWord.exampleSentence ?? '';
          koExController.text = getWord.exampleTranslation ?? '';
        }
      }
    });

    WordModel getNowWordModel() {
      return WordModel(
        id: wordController.text,
        word: wordController.text,
        meanings: getCommaSeperatedList(meaningController.text),
        tags: getCommaSeperatedList(tagController.text),
        exampleSentence: enExController.text,
        exampleTranslation: koExController.text,
        createdAt: DateTime.now(),
      );
    }

    return DefaultLayout(
      needLogin: true,
      child: BundleLayout(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            McAppear(
              delayMs: 300,
              child: Text(
                '단어를 등록해볼까요?',
                style: TextStyle(
                    color: MCColors.$color_blue_70,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            MCTextInput(
              labelText: '단어',
              controller: wordController,
              focusNode: wordFocusNode,
            ),
            MCSpace().verticalHalfSpace(),
            MCTextInput(
              labelText: '뜻',
              controller: meaningController,
            ),
            MCSpace().verticalHalfSpace(),
            MCTextInput(
              labelText: "태그(','로 분류해주세요)",
              controller: tagController,
            ),
            MCSpace().verticalHalfSpace(),
            MCTextInput(
              labelText: "예문(영어)",
              controller: enExController,
            ),
            MCSpace().verticalHalfSpace(),
            MCTextInput(
              labelText: "예문(뜻)",
              controller: koExController,
            ),
            const SizedBox(height: 10),
            Consumer(builder: (context, ref, child) {
              final bool loadingState = ref.watch(loadingStateProvider);
              return MCButtons().getPositiveButton(
                title: '등록하기',
                isLoading: loadingState,
                onTap: () => notifier.registerWord(getNowWordModel()),
              );
            }),
          ],
        ),
      ),
    );
  }
}
