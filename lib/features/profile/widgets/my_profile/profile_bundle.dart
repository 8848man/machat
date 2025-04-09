import 'package:flutter/material.dart';
import 'package:machat/extensions.dart';
import 'package:machat/features/profile/widgets/profile_background.dart';
import 'package:machat/features/profile/widgets/my_profile/profile_body.dart';
import 'package:machat/features/profile/widgets/my_profile/profile_footer.dart';
import 'package:machat/features/profile/widgets/my_profile/profile_header.dart';

class MyProfileBundle extends StatelessWidget {
  const MyProfileBundle({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const ProfileBackground(),
        Column(
          children: [
            const MyProfileHeader().expand(flex: 2),
            const MyProfileBody().expand(flex: 5),
            const MyProfileFooter().expand(flex: 3),
          ],
        ),
      ],
    );
  }
}
