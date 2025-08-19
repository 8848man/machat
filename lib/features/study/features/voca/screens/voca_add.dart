import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/design_system/lib.dart';
import 'package:machat/features/common/animated_widgets/mc_appear.dart';
import 'package:machat/features/common/layouts/bundle_layout.dart';
import 'package:machat/features/common/layouts/lib.dart';

class VocaAdd extends ConsumerWidget {
  const VocaAdd({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController wordController = TextEditingController();
    return DefaultLayout(
      child: BundleLayout(
        child: Column(
          children: [
            const McAppear(
              delayMs: 300,
              child: Text("단어를 등록해볼까요?"),
            ),
            MCSpace().verticalHalfSpace(),
            MCTextInput(
              controller: wordController,
            )
          ],
        ),
      ),
    );
  }
}
