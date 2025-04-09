import 'package:flutter/material.dart';
import 'package:machat/features/common/layouts/lib.dart';
import 'package:machat/features/profile/widgets/my_profile/profile_bundle.dart';

class MyProfile extends StatelessWidget {
  const MyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultLayout(
      title: '프로필',
      child: MyProfileBundle(),
    );
  }
}
