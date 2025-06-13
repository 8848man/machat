import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/design_system/lib.dart';
import 'package:machat/features/common/models/user_data.dart';
import 'package:machat/features/common/widgets/profile_avatar.dart';
import 'package:machat/features/profile/view_models/profile_view_model.dart';

class MyProfileBody extends ConsumerWidget {
  const MyProfileBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileViewModelProvider);
    return state.when(
      data: (data) => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          gradientAvatar(user: data),
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
