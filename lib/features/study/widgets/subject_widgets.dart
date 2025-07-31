import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/design_system/lib.dart';
import 'package:machat/features/common/animated_widgets/hover_click_animation_box.dart';
import 'package:machat/features/common/animated_widgets/mc_appear.dart';
import 'package:machat/features/study/models/subject.dart';
import 'package:machat/features/study/providers/subject_list_length.dart';
import 'package:machat/features/study/view_models/study_view_model.dart';

class SubjectBundle extends ConsumerWidget {
  final double boxHeight = 80;
  const SubjectBundle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 뷰모델 initialize
    ref.read(studyViewModelProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildHeader(ref),
            MCSpace().verticalSpace(),
            // buildRecentStudy(),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(WidgetRef ref) {
    return Consumer(builder: (context, ref, child) {
      final int? subjectListLength = ref.watch(subjectListLengthProvider);
      final notifier = ref.read(studyViewModelProvider.notifier);
      return Column(
        children: [
          Row(
            children: [
              buildTitleText('공부하기'),
              const Spacer(),
              buildTitleText('항목 관리',
                  onTap: () => notifier.goSubjectManagePage()),
            ],
          ),
          MCSpace().verticalHalfSpace(),
          // 수업 과목 리스트 생성
          ...subjectGenerator(subjectListLength),
        ],
      );
    });
  }

  // 과목 위젯 생성
  List<Widget> subjectGenerator(int? subjectListLength) {
    // subject가 초기화되지 않았을 경우, 3개의 더미 데이터 보여주기
    if (subjectListLength == null) {
      const int initialLength = 3;
      return List.generate(
        (initialLength * 2) - 1,
        (index) {
          if (index.isOdd) {
            return const SizedBox(height: 8); // 간격 조절
          } else {
            final realIndex = index ~/ 2;
            return buildFrameBox(index: realIndex, isValid: false);
          }
        },
      );
    }
    return List.generate(
      subjectListLength * 2 - 1,
      (index) {
        if (index.isOdd) {
          return const SizedBox(height: 8); // 간격 조절
        } else {
          final realIndex = index ~/ 2;
          return McAppear(
            delayMs: index * 100,
            child: buildFrameBox(index: realIndex),
          );
        }
      },
    );
  }

  Widget buildFrameBox({
    double width = 500,
    required int index,
    isValid = true,
  }) {
    return Container(
      constraints: const BoxConstraints(minWidth: 200, maxWidth: 500),
      width: width,
      height: boxHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.blueAccent, width: 1.0),
      ),
      child: isValid == true
          ? buildSubject(index)
          : const Center(
              child: CircularProgressIndicator(),
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
          final SubjectModel subjectData = data.subjectList!.subjectList[index];
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
                        buildTitle(subjectData.title),
                        MCSpace().verticalHalfSpace(),
                        buildProgressBar(subjectData.progressRate),
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
                  onTap: () => notifier.goEnglishPage(),
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

  Widget buildProgressBar(double progress) {
    // const double progress = 1; // 예시로 50% 진행된 상태
    return Row(
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: progress), // 목표 value까지
          duration: const Duration(milliseconds: 600), // 애니메이션 지속 시간
          builder: (context, value, child) {
            return SizedBox(
              width: 200,
              height: 10,
              child: LinearProgressIndicator(
                value: value,
                backgroundColor: Colors.grey[300],
                color: Colors.blueAccent,
              ),
            );
          },
        ),
        MCSpace().horizontalHalfSpace(),
        if (progress < 1.0)
          Text('${(progress * 100).toStringAsFixed(0)}% 만큼 했어요'),
        if (progress >= 1.0) const Text('모두 완료!'),
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
    return GestureDetector(onTap: onTap, child: Text(text));
  }
}
