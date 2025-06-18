import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/design_system/lib.dart';
import 'package:machat/features/common/models/chat_room_data.dart';

class DeleteChatRoomDialog extends ConsumerWidget {
  final Future<void> Function(ChatRoomData) onDelete;
  final ChatRoomData roomData;
  final String title;
  const DeleteChatRoomDialog(
      {super.key,
      required this.onDelete,
      required this.roomData,
      required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      child: Container(
        width: 300,
        height: 150,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              MCSpace().verticalSpace(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
            ],
          ),
        ),
      ),
    );
  }
}
