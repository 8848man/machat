import 'package:flutter/material.dart';
import 'package:machat/design_system/lib.dart';
import 'package:machat/features/ai/widgets/ai_home_body.dart';
import 'package:machat/features/ai/widgets/ai_home_header.dart';
import 'package:machat/features/common/layouts/bundle_layout.dart';
import 'package:machat/features/common/layouts/lib.dart';

class AiHomeScreen extends StatelessWidget {
  const AiHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: BundleLayout(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AiHomeHeader(),
            MCSpace().verticalSpace(),
            const AiHomeBody(),
          ],
        ),
      ),
    );
  }
}
