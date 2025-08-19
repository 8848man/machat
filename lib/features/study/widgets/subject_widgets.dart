import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/design_system/lib.dart';
import 'package:machat/extensions.dart';
import 'package:machat/features/common/animated_widgets/hover_click_animation_box.dart';
import 'package:machat/features/common/animated_widgets/mc_appear.dart';
import 'package:machat/features/study/models/vocabulary_model.dart';
import 'package:machat/features/study/providers/subject_list_length.dart';
import 'package:machat/features/study/view_models/study_view_model.dart';
import 'package:machat/features/study/widgets/mastery_progress_bar.dart';
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
      // child: SingleChildScrollView(
      //   child: SizedBox(
      //     width: double.infinity,
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       children: [
      //         buildHeader(ref),
      //         MCSpace().verticalSpace(),
      //         // buildRecentStudy(),
      //       ],
      //     ),
      //   ),
      // ),
      child: buildHeader(ref),
    );
  }

  Widget buildHeader(WidgetRef ref) {
    return Consumer(builder: (context, ref, child) {
      final int? vocabListLength = ref.watch(vocabularyListLengthProvider);
      final StudyViewModel notifier = ref.read(studyViewModelProvider.notifier);
      return Column(
        children: [
          Row(
            children: [
              buildTitleText('영단어를 외워봐요'),
              const Spacer(),
              // buildTitleText('항목 관리',
              //     onTap: () => notifier.goSubjectManagePage()),
            ],
          ),
          SingleChildScrollView(
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
          ).expand(),
        ],
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
              child: buildSubject(realIndex),
            ),
          );
        }
      },
    );
  }

  Widget buildFrameBox({
    double width = 500,
    Widget? child,
  }) 
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

  Widget buildSubject(int index) {
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTitle(vocabData.title),
                        MCSpace().verticalHalfSpace(),
                        buildProgressBar(
                          vocabData.progressRate,
                          vocabData.progressConfusedRate,
                        ),
                      ],
                    ),
                    const Spacer(),
                    // buildHover(),
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

  Widget buildIcon() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Icon(Icons.auto_stories),
    );
  }

  Widget buildTitle(String? title) {
    return Text(
      title ?? '제목 없음!',
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget buildProgressBar(double knowRate, double confusedRate) {
    // const double progress = 1; // 예시로 50% 진행된 상태
    return Row(
      children: [
        // TweenAnimationBuilder<double>(
        //   tween: Tween<double>(begin: 0.0, end: progress), // 목표 value까지
        //   duration: const Duration(milliseconds: 600), // 애니메이션 지속 시간
        //   builder: (context, value, child) {
        //     return SizedBox(
        //       width: 200,
        //       height: 10,
        //       child: LinearProgressIndicator(
        //         value: value,
        //         backgroundColor: Colors.grey[300],
        //         color: Colors.blueAccent,
        //       ),
        //     );
        //   },
        // ),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: knowRate),
          duration: const Duration(milliseconds: 600),
          builder: (context, animatedKnow, _) {
            return TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: confusedRate),
              duration: const Duration(milliseconds: 600),
              builder: (context, animatedConfused, _) {
                // return TweenAnimationBuilder<double>(
                //   tween: Tween<double>(begin: 0, end: masteredRate),
                //   duration: const Duration(milliseconds: 600),
                //   builder: (context, animatedMastered, _) {
                //     return MasteryProgressBar(
                //       knowRate: animatedKnow,
                //       confusedRate: animatedConfused,
                //       masteredRate: animatedMastered,
                //     );
                //   },
                // );
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
          Text('${(knowRate * 100).toStringAsFixed(0)}% 만큼 했어요'),
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
}
