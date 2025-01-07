import 'package:flutter/material.dart';
import 'package:machat/extensions.dart';
import 'package:machat/features/profile/widgets/profile_background.dart';
import 'package:machat/features/profile/widgets/profile_body.dart';
import 'package:machat/features/profile/widgets/profile_footer.dart';
import 'package:machat/features/profile/widgets/profile_header.dart';

class ProfileBundle extends StatelessWidget {
  const ProfileBundle({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const ProfileBackground(),
        Column(
          children: [
            const ProfileHeader().expand(flex: 5),
            const ProfileBody().expand(flex: 2),
            const ProfileFooter().expand(flex: 3),
          ],
        ),
      ],
    );
  }
}
