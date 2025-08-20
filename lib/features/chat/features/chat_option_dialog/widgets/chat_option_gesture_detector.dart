import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/chat/features/chat_option_dialog/screens/chat_option_dialog.dart';
import 'package:machat/features/chat/providers/chat_dialog_state_provider.dart';

class ChatOptionGestureDetector extends ConsumerWidget {
  final dynamic chatValue;
  final Widget child;
  const ChatOptionGestureDetector({
    super.key,
    required this.child,
    required this.chatValue,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onLongPress: () {
        // provider value에 채팅 값 할당
        ref.read(chatDialogValueProvider.notifier).update(
              (state) => chatValue,
            );
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const ChatOptionDialog();
          },
        );
      },
      child: child,
    );
  }
}
