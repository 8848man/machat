import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:machat/features/chat/repository/chat_repository.dart';
import 'package:machat/features/common/interfaces/repository_service.dart';
import 'package:machat/features/common/providers/chat_room_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_view_model.g.dart';

@riverpod
class ChatViewModel extends _$ChatViewModel {
  TextEditingController messageController = TextEditingController();

  @override
  void build() {
    ref.watch(chatRoomIdProvider);
  }

  // 채팅방 id, 현재 유저 id, viewModel messageController.text
  // 를 기준으로 해당 채팅방에 메세지를 기록하는 코드
  void sendMessageProcess() {
    final String roomId = ref.read(chatRoomIdProvider);
    final User? currentUser = FirebaseAuth.instance.currentUser;
    // 현재 유저 null 체크
    if (currentUser == null) {
      throw Exception('User is not logged in');
    }
    final String userId = currentUser.uid;
    final RepositoryService repository = ref.read(chatRepositoryProvider);

    // roomId, text, userId 데이터를 Map으로 파싱
    final Map<String, String> data = {
      'roomId': roomId,
      'message': messageController.text,
      'userId': userId,
    };

    // 서버에 데이터 전송
    repository.create(data);

    // 텍스트 초기화
    messageController.text = '';
  }
}
