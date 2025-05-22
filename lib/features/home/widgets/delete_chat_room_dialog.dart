import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/common/models/chat_room_data.dart';

class DeleteChatRoomDialog extends ConsumerWidget {
  final Future<void> Function(ChatRoomData) onDelete;
  final ChatRoomData roomData;
  const DeleteChatRoomDialog(
      {super.key, required this.onDelete, required this.roomData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Row(
        children: [
          TextButton(
            child: const Text('취소'),
            onPressed: () {
              Navigator.of(context).pop(); // 다이얼로그 닫기
            },
          ),
          TextButton(
            child: const Text('확인'),
            onPressed: () async {
              await onDelete(roomData);
              // 확인 로직
              Navigator.of(context).pop(); // 다이얼로그 닫기
            },
          ),
        ],
      ),
    );
  }
}
