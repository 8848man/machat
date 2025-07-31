import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/common/animated_widgets/mc_appear.dart';
import 'package:machat/features/common/layouts/lib.dart';
import 'package:machat/router/lib.dart';

class SubjectManage extends ConsumerWidget {
  const SubjectManage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: buildWrapper(ref),
        ),
      ),
    );
  }

  Widget buildWrapper(WidgetRef ref) {
    const int itemCount = 5;
    return GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(
        itemCount,
        (index) => McAppear(
          delayMs: index * 100,
          child: buildManagerContainer(
              ref: ref,
              child: Text('Item $index'),
              isLast: index + 1 == itemCount),
        ),
      ),
    );
  }

  Widget buildManagerContainer({
    required WidgetRef ref,
    required Widget child,
    bool isLast = false,
  }) {
    if (isLast) {
      return GestureDetector(
        onTap: () {
          final router = ref.read(goRouterProvider);
          router.goNamed(RouterPath.addVoca.name);
        },
        child: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: const Text("단어장 만들기"),
        ),
      );
    }
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: child,
    );
  }
}
