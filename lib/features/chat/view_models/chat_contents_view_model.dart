import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:machat/features/chat/models/chat_contents.dart';
import 'package:machat/features/chat/repository/chat_contents_repository.dart';
import 'package:machat/features/chat/view_models/chat_view_model.dart';
import 'package:machat/features/common/models/chat_room_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_contents_view_model.g.dart';

@riverpod
class ChatContentsViewModel extends _$ChatContentsViewModel {
  @override
  Future<ChatContentsModel> build() async {
    final ChatRoomData roomData = await ref.watch(chatViewModelProvider.future);
    final ChatContentsModel initState = await fetchInitialChats(roomData);
    // print('initState  : $initState');
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
}
