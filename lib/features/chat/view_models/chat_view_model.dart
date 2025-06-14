import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:machat/features/chat/features/expand/enums/expand_state.dart';
import 'package:machat/features/chat/features/expand/providers/expand_widget_state_provider.dart';
import 'package:machat/features/chat/interface/chat_view_model_interface.dart';
import 'package:machat/features/chat/providers/chat_focus_node_provider.dart';
import 'package:machat/features/chat/repository/chat_repository.dart';
import 'package:machat/features/common/interfaces/repository_service.dart';
import 'package:machat/features/common/models/chat_room_data.dart';
import 'package:machat/features/common/models/user_data.dart';
import 'package:machat/features/common/providers/chat_room_id.dart';
import 'package:machat/features/profile/view_models/profile_view_model.dart';
import 'package:machat/features/snack_bar_manager/lib.dart';
import 'package:machat/router/lib.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_view_model.g.dart';

@riverpod
class ChatViewModel extends _$ChatViewModel implements ChatViewModelInterface {
  TextEditingController messageController = TextEditingController();
  late FocusNode focusNode;

  @override
  Future<ChatRoomData> build() async {
    ref.watch(chatRoomIdProvider);

    focusNode = ref.read(chatFocusNodeProvider);
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        // 입력 필드가 포커스를 받으면 chatExpandTokenProvider를 false로 변경
        ref.read(expandWidgetStateProvider.notifier).state =
            ExpandWidgetState.collapsed;
      }
    });

    final ChatRoomData data = await initData();
    return data;
  }

  Future<ChatRoomData> initData() async {
    try {
      // 채팅방 Id를 가져옴
      final String roomId = ref.read(chatRoomIdProvider);
      // 서버 통신 레포지토리 할당
      final RepositoryService repository = ref.read(chatRepositoryProvider);
      // 서버에서 데이터를 가져옴
      final dynamic data = await repository.read(roomId);
      // 데이터 파싱
      final ChatRoomData chatRoomData = ChatRoomData.fromJson(data);

      return chatRoomData;
    } catch (e) {
      ref.read(goRouterProvider).goNamed(RouterPath.home.name);
      Future.delayed(const Duration(seconds: 1), () {
        showSnackBar(ref, '채팅방 정보를 가져오는데 실패했습니다. 잠시 후에 다시 시도해주세요.');
      });
      throw Exception('Chat room not found');
    }
  }

  // 채팅방 id, 현재 유저 id, viewModel messageController.text
  // 를 기준으로 해당 채팅방에 메세지를 기록하는 코드
  void sendMessageProcess() {
    if (messageController.text.isEmpty) {
      return;
    }
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

  void closeExpand() {
    ref.read(expandWidgetStateProvider.notifier).state =
        ExpandWidgetState.collapsed;
  }

  void goProfile(RoomUserData? userData) {
    if (userData == null) {
      return;
    }
    // 프로필 화면으로 이동
    // 프로필 화면으로 이동하기 전에, 프로필 정보를 업데이트
    ref
        .read(profileViewModelProvider.notifier)
        .updateUserData(userData.toUserData());
    ref.read(goRouterProvider).goNamed(RouterPath.chatProfile.name);
  }

  @override
  Future<void> sendData() async => sendMessageProcess();
}
