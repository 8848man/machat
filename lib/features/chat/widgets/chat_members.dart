import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/chat/view_models/member_list_view_model.dart';
import 'package:machat/features/common/models/user_data.dart';
// 추후 변경. home이 아닌 common으로 이동할 예정
import 'package:machat/features/home/lib.dart';

class ChatMembers extends ConsumerWidget {
  const ChatMembers({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<UserListModel> state =
        ref.watch(memberListViewModelProvider);

    return state.when(
      data: (data) {
        return ListView.builder(
          itemCount: data.friends.length,
          itemBuilder: (context, index) {
            final UserData friend = data.friends[index];
            return buildInfo(user: friend, ref: ref, context: context);
          },
        );
      },
      error: (error, stackTrace) {
        return const Center(
          child: Text('멤버 목록을 가져오는데 실패했습니다.\n 다시 시도해주세요.'),
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
