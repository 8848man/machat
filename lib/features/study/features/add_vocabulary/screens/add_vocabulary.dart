import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/design_system/lib.dart';
import 'package:machat/extensions.dart';
import 'package:machat/features/common/animated_widgets/mc_appear.dart';
import 'package:machat/features/common/layouts/bundle_layout.dart';
import 'package:machat/features/common/layouts/lib.dart';
import 'package:machat/features/study/features/add_vocabulary/view_models/add_vocabulary_view_model.dart';

class AddVocabulary extends ConsumerWidget {
  const AddVocabulary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleEditor = TextEditingController();
    final memoEditor = TextEditingController();

    return DefaultLayout(
      child: BundleLayout(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildHeader(),
            const SizedBox(height: 50),
            buildBody(titleEditor, memoEditor),
            const SizedBox(height: 50),
            buildFooter(titleEditor, memoEditor),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        McAppear(
          delayMs: 200,
          child: Text(
            '새로 배우고싶은 단어장을',
            style: TextStyle(
                color: MCColors.$color_blue_70,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
        ),
        McAppear(
          delayMs: 600,
          child: Text(
            '등록해주세요',
            style: TextStyle(
                color: MCColors.$color_blue_70,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget buildBody(
      TextEditingController titleEditor, TextEditingController memoEditor) {
    return Column(
      children: [
        MCTextInput(
          controller: titleEditor,
          labelText: '제목',
        ),
        MCSpace().verticalHalfSpace(),
        MCTextInput(
          controller: memoEditor,
          labelText: '메모',
        ),
      ],
    );
  }

  Widget buildFooter(
      TextEditingController titleEditor, TextEditingController memoEditor) {
    return Consumer(builder: (context, ref, child) {
      final notifier = ref.read(addVocabularyViewModelProvider.notifier);

      return Row(
        children: [
          MCButtons()
              .getPositiveButton(
                onTap: () => notifier.saveVocabulary(
                  title: titleEditor.text,
                  memo: memoEditor.text,
                ),
                title: '만들기',
              )
              .expand(),
        ],
      );
    });
  }
}
