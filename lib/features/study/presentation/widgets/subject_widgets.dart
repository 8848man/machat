import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/design_system/lib.dart';
import 'package:machat/extensions.dart';
import 'package:machat/features/common/animated_widgets/hover_click_animation_box.dart';
import 'package:machat/features/common/animated_widgets/mc_appear.dart';
import 'package:machat/features/common/widgets/mc_check_box_binding_view.dart';
import 'package:machat/features/snack_bar_manager/lib.dart';
import 'package:machat/features/study/data/models/vocabulary_model.dart';
import 'package:machat/features/study/presentation/consts/least_word_count.dart';
import 'package:machat/features/study/presentation/providers/subject_list_length.dart';
import 'package:machat/features/study/presentation/view_models/study_view_model.dart';
import 'package:machat/features/study/presentation/widgets/mastery_progress_bar.dart';
import 'package:machat/router/lib.dart';

class SubjectBundle extends ConsumerWidget {
  final double boxHeight = 80;
  const SubjectBundle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 뷰모델 initialize
    ref.read(studyViewModelProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: buildBundle(ref),
    );
  }

  Widget buildBundle(WidgetRef ref) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          children: [
            buildHeader(ref),
            buildBody().expand(),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(WidgetRef ref) {
    // final notifier = ref.read(studyViewModelProvider.notifier);
    return Row(
      children: [
        buildTitleText('영단어를 외워봐요'),
        const Spacer(),
        // buildTitleText('항목 관리', onTap: () => notifier.goSubjectManagePage()),
      ],
    );
  }

  Widget buildBody() {
    return Consumer(builder: (context, ref, child) {
      final int? vocabListLength = ref.watch(vocabularyListLengthProvider);

      return SingleChildScrollView(
        child: Column(
          children: [
            MCSpace().verticalHalfSpace(),
            // 수업 과목 리스트 생성
            ...subjectGenerator(vocabListLength),
            const SizedBox(height: 8), // 간격 조절
            McAppear(
              delayMs: 300,
              child: GestureDetector(
                onTap: () {
                  final router = ref.read(goRouterProvider);
                  router.pushNamed(RouterPath.addVocabulary.name);
                },
                child: buildFrameBox(
                  child: const Center(
                    child: Text("단어장 새로 등록하기!"),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // 단어장 위젯 생성
  List<Widget> subjectGenerator(int? vocabListLength) {
    // 단어장 리스트가 초기화되지 않았을 경우, 3개의 더미 데이터 보여주기
    if (vocabListLength == null) {
      const int initialLength = 3;
      return List.generate(
        (initialLength * 2) - 1,
        (index) {
          if (index.isOdd) {
            return const SizedBox(height: 8); // 간격 조절
          } else {
            return buildFrameBox(
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      );
    }
    // 단어장이 없을 경우
    if (vocabListLength == 0) {
      return [];
    }
    return List.generate(
      vocabListLength * 2 - 1,
      (index) {
        if (index.isOdd) {
          return const SizedBox(height: 8); // 간격 조절
        } else {
          final realIndex = index ~/ 2;
          return McAppear(
            delayMs: index * 100,
            child: buildFrameBox(
              child: buildVocabBox(realIndex),
            ),
          );
        }
      },
    );
  }

  Widget buildFrameBox({
    double width = 500,
    Widget? child,
  }) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(8),
      color: Colors.transparent, // 배경색 제거 (중첩을 위해)
      shadowColor: Colors.black.withOpacity(0.6), // 연한 그림자
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey, width: 0.1),
          color: Colors.white, // 내부 배경색
        ),
        constraints: const BoxConstraints(minWidth: 200, maxWidth: 500),
        width: width,
        height: boxHeight,
        child: child,
      ),
    );
  }

  Widget buildVocabBox(int index) {
    return Consumer(builder: (context, ref, child) {
      final state = ref.watch(studyViewModelProvider);
      final notifier = ref.read(studyViewModelProvider.notifier);

      return state.when(
        error: (error, stackTrace) => Text("error! $error"),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        data: (data) {
          final VocabularyModel vocabData =
              data.vocabularyModelList!.vocabularyList[index];
          return Stack(
            children: [
              SizedBox(
                height: boxHeight,
                child: Row(
                  children: [
                    buildIcon(),
                    SizedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTitle(vocabData, ref),
                          MCSpace().verticalHalfSpace(),
                          buildProgressBar(
                            vocabData.progressRate,
                            vocabData.progressConfusedRate,
                          ),
                        ],
                      ),
                    ).expand(),
                    // buildHover(),
                    const SizedBox(width: 80),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: HoverClickAnimatedBox(
                  boxHeight: boxHeight,
                  onTap: () => notifier.goEnglishVocaPage(vocabData),
                ),
              ),
            ],
          );
        },
      );
    });
  }
}

Widget buildIcon() {
  return const Padding(
    padding: EdgeInsets.symmetric(horizontal: 8.0),
    child: Icon(Icons.auto_stories),
  );
}

Widget buildTitle(VocabularyModel vocabData, WidgetRef ref) {
  final StudyViewModel notifier = ref.read(studyViewModelProvider.notifier);

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        Text(
          vocabData.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        MCSpace().horizontalHalfSpace(),
        Text(
          '(${vocabData.memorizedWordCount} / ${vocabData.wordCount})',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        getPointRow(notifier: notifier, vocabData: vocabData, ref: ref),
        MCSpace().horizontalHalfSpace(),
        GestureDetector(
            onTap: () =>
                SnackBarCaller().callSnackBar(ref, '오래 눌러서 삭제할 수 있어요!'),
            onLongPress: () => notifier.deleteVocabulary(vocabData),
            child: const Icon(Icons.close, size: 24)),
        MCSpace().horizontalHalfSpace(),
      ],
    ),
  );
}

Widget buildProgressBar(double knowRate, double confusedRate) {
  return Row(
    children: [
      TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: knowRate),
        duration: const Duration(milliseconds: 500),
        builder: (context, animatedKnow, _) {
          return TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: confusedRate),
            duration: const Duration(milliseconds: 700),
            builder: (context, animatedConfused, _) {
              return MasteryProgressBar(
                knowRate: animatedKnow,
                confusedRate: animatedConfused,
              );
            },
          );
        },
      ),
      MCSpace().horizontalHalfSpace(),
      if (knowRate < 1.0)
        Text('${(knowRate * 100).toStringAsFixed(0)}% 만큼 외웠어요!'),
      if (knowRate >= 1.0) const Text('모두 완료!'),
    ],
  );
}

// Widget buildRecentStudy() {
//   return Column(
//     children: [
//       Row(
//         children: [
//           buildTitleText('최근 공부한 항목'),
//           const Spacer(),
//           const Text('항목 관리하기'),
//         ],
//       ),
//       MCSpace().verticalHalfSpace(),
//       buildFrameBox(),
//       MCSpace().verticalHalfSpace(),
//       buildFrameBox(),
//     ],
//   );
// }
Widget buildHover() {
  return HoverClickAnimatedBox(
    boxHeight: 80,
    onTap: () {},
  );
}

Widget buildTitleText(String text, {VoidCallback? onTap}) {
  return GestureDetector(
    onTap: onTap,
    // child: Text(text),
    child: McAppear(
      delayMs: 0,
      child: Text(
        text,
        style: TextStyle(
            color: MCColors.$color_blue_70,
            fontSize: 18,
            fontWeight: FontWeight.bold),
      ),
    ),
  );
}

Widget getPointRow({
  required VocabularyModel vocabData,
  required StudyViewModel notifier,
  required WidgetRef ref,
}) {
  const double boxScale = 0.7;

  // ✅ 1. 이미 포인트 획득했을 경우
  if (vocabData.hasEarnPoints) {
    return buildRow(
      MCCheckBoxBindigView(
        scale: boxScale,
        value: true,
        onTap: () => notifier.earnPoints(vocabData),
      ),
      'already got point',
      MCColors.$color_blue_30,
    );
  }

  // ✅ 2. 단어 수 부족할 경우
  if (vocabData.wordCount < leastWordCount) {
    final remaining = leastWordCount - vocabData.wordCount;
    return buildRow(
      const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 16),
      '$remaining 개만 더 등록해요!',
      Colors.orange,
    );
  }

  // ✅ 3. 아직 외운 단어가 부족할 경우
  if (vocabData.wordCount != vocabData.memorizedWordCount) {
    final remaining = vocabData.wordCount - vocabData.memorizedWordCount;
    return buildRow(
      MCCheckbox(
        scale: boxScale,
        isChecked: false,
        onChanged: (_) {}, // 로직 없는 체크박스
      ),
      '$remaining 개만 더 외워봐요!',
      MCColors.$color_blue_10,
    );
  }

  // ✅ 4. 외운 단어를 다 채운 경우 → 포인트 획득 가능
  return buildRow(
    MCCheckBoxBindigView(
      scale: boxScale,
      value: vocabData.hasEarnPoints,
      onTap: () => notifier.earnPoints(vocabData),
    ),
    'get point',
    MCColors.$color_blue_30,
  );
}

// 공통적으로 Row를 만들어주는 헬퍼
Widget buildRow(Widget icon, String text, Color color) {
  return Row(
    children: [
      MCSpace().horizontalHalfSpace(),
      icon,
      Text(
        text,
        style: TextStyle(fontSize: 12, color: color),
      ),
    ],
  );
}
