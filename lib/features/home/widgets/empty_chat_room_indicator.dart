import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/design_system/lib.dart';
import 'package:machat/features/chat_list/view_models/chat_list_view_model.dart';

class EmptyChatRoomIndicator extends ConsumerWidget {
  const EmptyChatRoomIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(chatListViewModelProvider.notifier);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('조회되는 채팅방이 없습니다.'),
          MCSpace().horizontalSpace(),
          const Text('+ 버튼을 눌러 채팅방을 생성하거나'),
          MCSpace().horizontalSpace(),
          const Text('입장해주세요'),
          MCSpace().horizontalSpace(),
          MCSpace().horizontalSpace(),
          GestureDetector(
            child: const Text(
              '채팅방 참여 하러 가기',
              style: TextStyle(color: Colors.blue),
            ),
            onTap: () => notifier.goChatRoomListPage(),
          ),
          MCSpace().horizontalSpace(),
          MCSpace().horizontalSpace(),
          GestureDetector(
            child: const Text(
              '채팅방 생성 하러 가기',
              style: TextStyle(color: Colors.blue),
            ),
            onTap: () => notifier.goChatCreate(),
          ),
        ],
      ),
    );
  }
}
