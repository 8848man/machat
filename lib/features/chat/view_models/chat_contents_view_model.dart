import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:machat/features/chat/models/chat_contents.dart';
import 'package:machat/features/chat/providers/chat_dialog_state_provider.dart';
import 'package:machat/features/chat/providers/chat_tts_provider.dart';
import 'package:machat/features/chat/repository/chat_contents_repository.dart';
import 'package:machat/features/chat/view_models/chat_view_model.dart';
import 'package:machat/features/common/models/chat_room_data.dart';
import 'package:machat/features/snack_bar_manager/lib.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rwkim_tts/rwkim_tts.dart';

part 'chat_contents_view_model.g.dart';

@riverpod
class ChatContentsViewModel extends _$ChatContentsViewModel {
  late final SimpleTTS _tts;
  @override
  Future<ChatContentsModel> build() async {
    // tts 클래스 초기화
    // _tts = ref.watch(simpleTTSProvider);
    final ChatRoomData roomData = await ref.watch(chatViewModelProvider.future);
    final ChatContentsModel initState = await fetchInitialChats(roomData);

    ref.onDispose(() {
      print('test001, view model dispose');
      _tts.dispose();
    });

    return initState;
  }

  Future<ChatContentsModel> fetchInitialChats(ChatRoomData roomData) async {
    final repo = ref.read(chatContentsRepositoryProvider);
    final initialMessages = await repo.getInitialChats(roomData.roomId);

    final ChatContentsModel chatContentsModel = ChatContentsModel(
      contents: initialMessages,
      lastDoc: initialMessages.isNotEmpty
          ? initialMessages.last['lastDoc'] as DocumentSnapshot
          : null,
      isLoading: false,
      hasMore: initialMessages.length == 30,
      roomData: roomData,
    );

    return chatContentsModel;
  }

  Future<void> fetchPreviousChats({
    required String roomId,
    required DocumentSnapshot lastDoc,
  }) async {
    final repo = ref.read(chatContentsRepositoryProvider);
    final previousMessages = await repo.getPreviousChats(
      roomId: roomId,
      lastDoc: lastDoc,
    );

    update((state) {
      if (previousMessages.isEmpty) {
        state = state.copyWith(hasMore: false);
        return state;
      }
      final updatedContents = [
        ...previousMessages,
        ...state.contents,
      ];
      final newLastDoc = previousMessages.last['lastDoc'] as DocumentSnapshot;

      return state = state.copyWith(
        contents: updatedContents,
        lastDoc: newLastDoc,
        hasMore: previousMessages.length == 30,
      );
    });
  }

  Future<void> deleteChatFromMyself({
    required String roomId,
    required String chatId,
  }) async {
    try {
      final repository = ref.read(chatContentsRepositoryProvider);
      final User? currentUser = FirebaseAuth.instance.currentUser;
      final String userId = currentUser != null ? currentUser.uid : '';

      await repository.deleteChatFromMyself(
        roomId: roomId,
        chatId: chatId,
        userId: userId,
      );
      await updateVMStateAfterDelete(chatId, userId);
    } catch (e) {
      SnackBarCaller().callSnackBar(ref, '삭제하는 중 에러가 발생했습니다.');
    }
  }

  Future<void> deleteChatFromAll({
    required String roomId,
    required String chatId,
  }) async {
    try {
      final repository = ref.read(chatContentsRepositoryProvider);

      await repository.deleteChatFromAll(
        roomId: roomId,
        chatId: chatId,
      );
      await updateVMStateAfterDelete(chatId, null);
    } catch (e) {
      SnackBarCaller().callSnackBar(ref, '삭제하는 중 에러가 발생했습니다.');
    }
  }

  Future<void> updateVMStateAfterDelete(String chatId, String? userId) async {
    update((state) {
      List<dynamic> dynamicList = state.contents.toList();

      int index = dynamicList.indexWhere((element) => element['id'] == chatId);

      if (index != -1) {
        Map<String, dynamic> updatedItem =
            Map<String, dynamic>.from(dynamicList[index]);

        if (userId != null) {
          List<String> deletedToList =
              List<String>.from(updatedItem['deletedTo'] ?? []);
          deletedToList.add(userId);
          updatedItem['deletedTo'] = deletedToList;
        } else {
          updatedItem['isDeletedForEveryone'] = true;
        }

        // 4. 수정된 항목을 리스트에 반영
        dynamicList[index] = updatedItem;
      }

      // 5. state 업데이트
      return state.copyWith(contents: dynamicList);
    });
  }

  Future<void> speakChatMessage() async {
    // 다이얼로그에 진입할 때 저장된 채팅 밸류 가져오기
    final chatValue = ref.read(chatDialogValueProvider);

    try {
      await _tts.speakText(
        text: chatValue['message'],
        voiceId: 'c9858bccab131431a5c3c7',
        language: 'ko',
      );
    } catch (e) {
      SnackBarCaller().callSnackBar(ref, '음성 재생 중 에러가 발생했습니다.');
    }
  }
}
