import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/common/models/user_data.dart';
import 'package:machat/features/common/view_models/user_view_model.dart';
import 'package:machat/features/common/widgets/mc_pop_scope.dart';
import 'package:machat/features/profile/screens/my_profile.dart';
import 'package:machat/features/profile/screens/other_profile.dart';

Future<void> showProfile(
  BuildContext context,
  WidgetRef ref,
  UserData userData,
) async {
  bool isMyProfile = await defineIsMyProfile(ref, userData);

  if (!context.mounted) return;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return mcPopScope(
        context: context,
        child: isMyProfile ? const MyProfile() : const OtherProfile(),
      );
    },
  );
}

Future<bool> defineIsMyProfile(WidgetRef ref, UserData userData) async {
  final UserData myUserData = await ref.read(userViewModelProvider.future);
  if (userData.id == myUserData.id) {
    return true; // 내 프로필
  } else {
    return false; // 다른 사람 프로필
  }
}
