import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:machat/features/chat_create/lib.dart';
import 'package:machat/features/chat_create/models/chat_create_model.dart';
import 'package:machat/router/lib.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_create_view_model.g.dart';

@riverpod
class ChatCreateViewModel extends _$ChatCreateViewModel {
  TextEditingController roomNameController = TextEditingController();
  @override
  ChatCreateModel build() {
    return const ChatCreateModel();
  }

  void create() {}

  /// 라우팅
  void goHome() {
    final router = ref.read(goRouterProvider);

    router.goNamed(RouterPath.home.name);
  }

  /// 라우팅/

  Future<void> createChatRoomProcess() async {
    print('test001');
    final router = ref.read(goRouterProvider);
    await createChatRoom();

    router.goNamed(RouterPath.home.name);
  }

  Future<void> createChatRoom() async {
    try {
      // FirebaseAuth를 이용하여 현재 로그인된 사용자 ID 가져오기
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User is not logged in');
      }
      final userId = currentUser.uid;

      final Map<String, dynamic> qData = {
        'userId': userId,
        'name': roomNameController.text,
      };

      // Repository 호출
      final repository = ref.read(chatCreateRepositoryProvider);
      await repository.create(qData);

      // 성공 메시지
      print('Chat room created successfully!');
    } catch (e) {
      // 에러 처리
      print('Error creating chat room: $e');
    }
  }
}
