import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/design_system/lib.dart';
import 'package:machat/features/chat_list/models/chat_list_model.dart';
import 'package:machat/features/chat_list/view_models/chat_list_view_model.dart';
import 'package:machat/features/common/models/chat_room_data.dart';

class HomeChatList extends ConsumerWidget {
  const HomeChatList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ChatListViewModel notifier =
        ref.read(chatListViewModelProvider.notifier);
    final AsyncValue<ChatListModel> state =
        ref.watch(chatListViewModelProvider);
    return state.when(
      data: (ChatListModel data) => buildChatRoom(context, data, notifier),
      error: (error, stackTrace) => Container(),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  // 데이터 갯수만큼 채팅방 리스트타일 생성
  Widget buildChatRoom(
      BuildContext context, ChatListModel data, ChatListViewModel notifier) {
    return Column(
      children: [
        ...List<Widget>.generate(data.roomList.length, (i) {
          return buildChatRoomListTile(context, data.roomList[i], notifier);
        }),
      ],
    );
  }

  // 채팅방 리스트타일 위젯
  Widget buildChatRoomListTile(
      BuildContext context, ChatRoomData data, ChatListViewModel notifier) {
    return ListTile(
      title: Row(
        children: [
          const Icon(IconData(0xe153, fontFamily: 'MaterialIcons')),
          MCSpace().horizontalHalfSpace(),
          Text(data.name != '' ? data.name : '제목 없음'),
          const Spacer(),
          GestureDetector(
            child: const Icon(IconData(0xf317, fontFamily: 'MaterialIcons')),
            onTap: () => notifier.deleteChatRoom(data),
          ),
        ],
      ),
      onTap: () {
        Scaffold.of(context).closeDrawer();
        notifier.goChat(data.roomId);
      },
    );
  }
}
