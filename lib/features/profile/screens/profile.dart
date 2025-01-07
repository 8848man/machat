import 'package:flutter/material.dart';
import 'package:machat/features/common/layouts/lib.dart';
import 'package:machat/features/profile/widgets/profile_bundle.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultLayout(child: ProfileBundle());
  }
}
