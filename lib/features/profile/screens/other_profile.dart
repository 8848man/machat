import 'package:flutter/material.dart';
import 'package:machat/features/common/layouts/lib.dart';
import 'package:machat/features/profile/widgets/other_profile.dart/profile_bundle.dart';

class OtherProfile extends StatelessWidget {
  const OtherProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultLayout(
      title: '프로필',
      child: OtherProfileBundle(),
    );
  }
}
