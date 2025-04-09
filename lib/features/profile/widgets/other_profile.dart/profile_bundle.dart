import 'package:flutter/material.dart';
import 'package:machat/extensions.dart';
import 'package:machat/features/profile/widgets/profile_background.dart';
import 'package:machat/features/profile/widgets/other_profile.dart/profile_body.dart';
import 'package:machat/features/profile/widgets/other_profile.dart/profile_footer.dart';
import 'package:machat/features/profile/widgets/other_profile.dart/profile_header.dart';

class OtherProfileBundle extends StatelessWidget {
  const OtherProfileBundle({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const ProfileBackground(),
        Column(
          children: [
            const OtherProfileHeader().expand(flex: 2),
            const OtherProfileBody().expand(flex: 5),
            const OtherProfileFooter().expand(flex: 3),
          ],
        ),
      ],
    );
  }
}
