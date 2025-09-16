import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/core/models/chat.dart';
import 'package:machat/features/chat/data/models/chat_dialog_state.dart';

AutoDisposeStateProvider<ChatDialogState> chatDialogStateProvider =
    StateProvider.autoDispose<ChatDialogState>((ref) {
  return ChatDialogState.initial; // Default state is initial
});
// 채팅 다이얼로그에 진입할 때 저장하는 채팅 밸류
StateProvider<Chat> chatDialogValueProvider = StateProvider<Chat>((ref) {
  return const Chat();
});
