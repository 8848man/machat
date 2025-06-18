import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/chat/models/chat_dialog_state.dart';

AutoDisposeStateProvider<ChatDialogState> chatDialogStateProvider =
    StateProvider.autoDispose<ChatDialogState>((ref) {
  return ChatDialogState.initial; // Default state is initial
});

StateProvider<dynamic> chatDialogValueProvider = StateProvider<dynamic>((ref) {
  return null;
});
