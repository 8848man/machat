import 'package:firebase_auth/firebase_auth.dart';
import 'package:machat/features/floating_button/lib.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'floating_button_view_model.g.dart';

@riverpod
class FloatingButtonViewModel extends _$FloatingButtonViewModel {
  final List<String> iconUrl = ['icons/chat-plus.svg'];
  @override
  void build() async {}

  Future<void> functionBrancher(int index) async {
    switch (index) {
      case 0:
        return generateChatRoom();
      default:
        print('invalid index, index is $index');
        return;
    }
  }

  Future<void> generateChatRoom() async {
    try {
      // FirebaseAuth를 이용하여 현재 로그인된 사용자 ID 가져오기
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User is not logged in');
      }
      final userId = currentUser.uid;

      final Map<String, dynamic> qData = {'userId': userId};

      // Repository 호출
      final repository = ref.read(floatingButtonRepositoryProvider);
      await repository.create(qData);

      // 성공 메시지
      print('Chat room created successfully!');
    } catch (e) {
      // 에러 처리
      print('Error creating chat room: $e');
    }
  }
}
