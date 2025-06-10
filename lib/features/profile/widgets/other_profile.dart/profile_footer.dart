import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/design_system/lib.dart';
import 'package:machat/features/common/models/user_data.dart';
import 'package:machat/features/common/providers/user_cache_providers.dart';
import 'package:machat/features/profile/utils/define_is_friend.dart';
import 'package:machat/features/profile/view_models/profile_view_model.dart';
import 'package:machat/features/profile/widgets/other_profile.dart/profile_auth_button.dart';

class OtherProfileFooter extends ConsumerWidget {
  const OtherProfileFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileViewModelProvider);
    ref.watch(friendListProvider);
    return state.when(
      data: (data) => buildProfileFooter(ref, data),
      error: (error, stackTrace) => Text(
        error.toString(),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget buildProfileFooter(WidgetRef ref, UserData data) {
    return Column(
      children: [
        MCSpace().verticalHalfSpace(),
        const Divider(),
        MCSpace().verticalSpace(),
        buildProfileBottomRow(ref, data),
      ],
    );
  }

  Widget buildProfileBottomRow(WidgetRef ref, UserData data) {
    final bool isFreind = defineIsFriend(ref, data.id ?? '');
    final User? user = FirebaseAuth.instance.currentUser;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (user != null) buildConversation(ref),
        // buildAuthButton(user, ref),
        if (!isFreind) buildAddFriend(ref),
        if (isFreind) buildDeleteFreind(ref),
      ],
    );
  }
}
