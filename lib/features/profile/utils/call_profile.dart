import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/common/models/user_data.dart';
import 'package:machat/features/common/view_models/user_view_model.dart';
import 'package:machat/features/profile/screens/my_profile.dart';
import 'package:machat/features/profile/screens/other_profile.dart';

Future<void> showProfile(
    BuildContext context, WidgetRef ref, UserData userData) async {
  bool isMyProfile = await defineIsMyProfile(
      ref, userData); // 예시로 true로 설정, 실제로는 조건에 따라 다를 수 있음
  if (context.mounted) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 중요!!
      backgroundColor: Colors.transparent, // 선택사항
      builder: (context) {
        return Scaffold(
          // appBar: AppBar(
          //   title: const Text('프로필'),
          //   leading: IconButton(
          //     icon: const Icon(Icons.arrow_back),
          //     onPressed: () {
          //       if (Navigator.canPop(context)) {
          //         Navigator.pop(context);
          //       }
          //     },
          //   ),
          // ),
          body: isMyProfile ? const MyProfile() : const OtherProfile(),
        );
      },
    );
  }
}

Future<bool> defineIsMyProfile(WidgetRef ref, UserData userData) async {
  final UserData myUserData = await ref.read(userViewModelProvider.future);
  if (userData.id == myUserData.id) {
    return true; // 내 프로필
  } else {
    return false; // 다른 사람 프로필
  }
}
