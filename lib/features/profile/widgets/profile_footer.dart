import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/design_system/lib.dart';
import 'package:machat/features/profile/widgets/profile_auth_button.dart';
import 'package:machat/router/lib.dart';

class ProfileFooter extends ConsumerWidget {
  const ProfileFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        MCSpace().verticalHalfSpace(),
        const Divider(),
        MCSpace().verticalSpace(),
        buildProfileBottomRow(ref),
      ],
    );
  }

  Widget buildProfileBottomRow(WidgetRef ref) {
    final User? user = FirebaseAuth.instance.currentUser;
    final router = ref.read(goRouterProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (user != null) buildConversation(),
        buildAuthButton(user, router),
      ],
    );
  }
}
