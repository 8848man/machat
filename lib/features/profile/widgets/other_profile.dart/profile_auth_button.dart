import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:machat/features/profile/view_models/profile_view_model.dart';

Widget buildConversation(WidgetRef ref) {
  final notifier = ref.read(profileViewModelProvider.notifier);
  return Column(
    children: [
      IconButton(
        icon: const Icon(
          IconData(0xe153, fontFamily: 'MaterialIcons'),
          size: 25,
        ),
        tooltip: '대화하기',
        onPressed: () => notifier.createOneToOneChat(),
      ),
      const Text('대화하기'),
    ],
  );
}

Widget buildAddFriend(WidgetRef ref) {
  final notifier = ref.read(profileViewModelProvider.notifier);
  return Column(
    children: [
      IconButton(
        icon: SvgPicture.asset(
          'lib/assets/icons/person_plus.svg',
          width: 25,
          height: 25,
          color: Colors.black, // 필요 시 색상 지정
        ),
        tooltip: '친구 추가하기',
        onPressed: () => notifier.addFriend(),
      ),
      const Text('친구 추가하기'),
    ],
  );
}

Widget buildDeleteFreind(WidgetRef ref) {
  final notifier = ref.read(profileViewModelProvider.notifier);
  return Column(
    children: [
      IconButton(
        icon: SvgPicture.asset(
          'lib/assets/icons/person_minus.svg',
          width: 25,
          height: 25,
          color: Colors.black, // 필요 시 색상 지정
        ),
        tooltip: '친구 삭제하기',
        onPressed: () => notifier.deleteFriend(),
      ),
      const Text('친구 삭제하기'),
    ],
  );
}
