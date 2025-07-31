import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/design_system/lib.dart';
import 'package:machat/extensions.dart';
import 'package:machat/features/common/animated_widgets/mc_appear.dart';
import 'package:machat/features/common/layouts/bundle_layout.dart';
import 'package:machat/features/common/layouts/lib.dart';

class AddVocabulary extends ConsumerWidget {
  const AddVocabulary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleEditor = TextEditingController();
    final memoEditor = TextEditingController();

    return DefaultLayout(
      child: BundleLayout(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildHeader(),
            const SizedBox(height: 50),
            buildBody(titleEditor, memoEditor),
            const SizedBox(height: 50),
            Row(
              children: [
                MCButtons().getNegativeButton(title: '뒤로 가기').expand(),
                MCSpace().horizontalSpace(),
                MCButtons().getPositiveButton(title: '만들기').expand(),
              ],
            ),
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

  Widget buildFooter() {
    return Consumer(builder: (context, ref, child) {
      return Row(
        children: [
          MCButtons().getNegativeButton(title: '뒤로 가기').expand(),
          MCSpace().horizontalSpace(),
          MCButtons().getPositiveButton(title: '만들기').expand(),
        ],
      );
    });
  }
}

// class AddVoca extends ConsumerWidget {
//   const AddVoca({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final wordTextEditor = TextEditingController();
//     final meaningTextEditor = TextEditingController();
//     final explainTextEditor = TextEditingController();

//     return DefaultLayout(
//       child: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(8),
//           child: Column(
//             children: [
//               MCTextInput(
//                 controller: wordTextEditor,
//                 labelText: '단어',
//               ),
//               MCTextInput(
//                 controller: meaningTextEditor,
//                 labelText: '뜻',
//               ),
//               MCTextInput(
//                 controller: explainTextEditor,
//                 labelText: '설명',
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
