// import 'package:flutter/material.dart';
// import 'package:machat/design_system/lib.dart';
// import 'package:machat/extensions.dart';
// import 'package:machat/router/lib.dart';

// class StudyContentsLayout extends StatelessWidget {
//   const StudyContentsLayout({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ConstrainedBox(
//         constraints: const BoxConstraints(maxHeight: 250, maxWidth: 500),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 buildTitleText('단어 외우기'),
//                 const Spacer(),
//                 buildTitleText('항목 관리',
//                     onTap: () => notifier.goSubjectManagePage()),
//               ],
//             ),
//             SingleChildScrollView(
//               child: Column(
//                 children: [
//                   MCSpace().verticalHalfSpace(),
//                   // 수업 과목 리스트 생성
//                   ...subjectGenerator(vocabListLength),
//                   const SizedBox(height: 8), // 간격 조절
//                   McAppear(
//                     delayMs: 300,
//                     child: GestureDetector(
//                       onTap: () {
//                         final router = ref.read(goRouterProvider);
//                         router.pushNamed(RouterPath.addVocabulary.name);
//                       },
//                       child: buildFrameBox(
//                         child: const Center(
//                           child: Text("단어장 새로 등록하기!"),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ).expand();
//   }
// }
