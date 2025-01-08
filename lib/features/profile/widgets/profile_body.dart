import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/design_system/lib.dart';
import 'package:machat/features/common/models/user_data.dart';
import 'package:machat/features/profile/view_models/profile_view_model.dart';

class ProfileBody extends ConsumerWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileViewModelProvider);
    return state.when(
      data: (data) => Column(
        children: [
          gradientAvatar(data),
          MCSpace().verticalSpace(),
          profileInfo(data),
        ],
      ),
      error: (error, stackTrace) => Text(
        error.toString(),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  // 프로필 사진
  Widget gradientAvatar(UserData user) {
    return Container(
      height: 100,
      width: 100,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
          colors: [
            Color(0xff4dabf7),
            Color(0xffda77f2),
            Color(0xfff783ac),
          ],
        ),
        borderRadius: BorderRadius.circular(500),
      ),
      child: const CircleAvatar(
        radius: 30,
        child: Icon(
          Icons.person,
          color: Color(0xffCCCCCC),
          size: 50,
        ),
      ),
    );
  }

  Widget profileInfo(UserData user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Text(user.name),
        Text(user.name),
        // Text(user.phone),
      ],
    );
  }
}
