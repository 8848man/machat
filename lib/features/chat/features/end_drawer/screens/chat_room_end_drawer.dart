import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/extensions.dart';
import 'package:machat/features/chat/features/end_drawer/view_models/end_drawer_view_model.dart';
import 'package:machat/features/chat/providers/chat_room_name_provider.dart';
import 'package:machat/features/common/models/user_data.dart';
import 'package:machat/features/home/lib.dart';

class ChatRoomEndDrawer extends ConsumerWidget {
  const ChatRoomEndDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: Text(
              ref.read(chatRoomNameProvider),
              style: const TextStyle(fontSize: 18),
            ),
          ),
          buildMembers(),
        ],
      ),
    );
  }

  Consumer buildMembers() {
    return Consumer(builder: (context, ref, child) {
      final AsyncValue<UserListModel> state =
          ref.watch(endDrawerViewModelProvider);
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
            child: Text('친구 목록을 가져오는데 실패했습니다.'),
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ).expand();
    });
  }
}
