import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/design_system/lib.dart';
import 'package:machat/features/common/animated_widgets/hover_click_animation_box.dart';
import 'package:machat/features/home/enums/subject_enum.dart';
import 'package:machat/features/study/view_models/subject_bundle_view_model.dart';

class SubjectBundle extends ConsumerWidget {
  final double boxHeight = 80;
  const SubjectBundle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        buildHeader(),
        MCSpace().verticalSpace(),
        buildRecentStudy(),
      ],
    );
  }

  Widget buildHeader() {
    return Column(
      children: [
        Row(
          children: [
            buildTitleText('공부하기'),
            const Spacer(),
            const Text('항목 관리'),
          ],
        ),
        MCSpace().verticalHalfSpace(),
        buildFrameBox(),
        MCSpace().verticalHalfSpace(),
        buildFrameBox(),
      ],
    );
  }

  Widget buildFrameBox({double width = 500}) {
    return Container(
      constraints: const BoxConstraints(minWidth: 200, maxWidth: 500),
      width: width,
      height: boxHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.blueAccent, width: 1.0),
      ),
      child: buildRow(),
    );
  }

  Widget buildRow() {
    return Consumer(builder: (context, ref, child) {
      final notifier = ref.read(subjectBundleViewModelProvider.notifier);
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
                    buildTitle(),
                    MCSpace().verticalHalfSpace(),
                    buildProgressBar(),
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
              onTap: () => notifier.goStudyPageByEnum(SubjectEnum.english),
            ),
          ),
        ],
      );
    });
  }

  Widget buildIcon() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Icon(Icons.auto_stories),
    );
  }

  Widget buildTitle() {
    return const Text(
      'Subject Title',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget buildProgressBar() {
    const double progress = 1; // 예시로 50% 진행된 상태
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

  Widget buildRecentStudy() {
    return Column(
      children: [
        Row(
          children: [
            buildTitleText('최근 공부한 항목'),
            const Spacer(),
            const Text('항목 관리하기'),
          ],
        ),
        MCSpace().verticalHalfSpace(),
        buildFrameBox(),
        MCSpace().verticalHalfSpace(),
        buildFrameBox(),
      ],
    );
  }

  Widget buildTitleText(String text) {
    return Text(text);
  }
}
