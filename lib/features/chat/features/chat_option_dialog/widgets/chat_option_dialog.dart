import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/design_system/lib.dart';
import 'package:machat/extensions.dart';
import 'package:machat/features/chat/features/chat_option_dialog/widgets/read_tts_widget.dart';
import 'package:machat/features/chat/models/chat_dialog_state.dart';
import 'package:machat/features/chat/providers/chat_dialog_state_provider.dart';
import 'package:machat/features/chat/view_models/chat_contents_view_model.dart';
import 'package:machat/features/common/providers/chat_room_id.dart';
import 'package:machat/features/snack_bar_manager/lib.dart';

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

class ChatOptionDialog extends ConsumerWidget {
  const ChatOptionDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dialogState = ref.watch(chatDialogStateProvider);
    return Dialog(
      child: Container(
        // width: 300,
        constraints: BoxConstraints(
          minWidth: 300,
          maxWidth: 400,
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: dialogStateBrancher(
          context: context,
          ref: ref,
          state: dialogState,
        ),
      ),
    );
  }

  Widget buildInitialState(
    BuildContext context,
    WidgetRef ref,
  ) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            '채팅 옵션',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          MCSpace().verticalSpace(),
          const Divider(),
          SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('채팅 삭제'),
                  onTap: () {
                    ref.read(chatDialogStateProvider.notifier).update((state) {
                      return ChatDialogState.delete;
                    });
                  },
                ),
                const ReadTtsTile(),
              ],
            ),
          ).expand(),
        ],
      ),
    );
  }

  Widget buildChatDeleteState(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(chatContentsViewModelProvider.notifier);
    final roomId = ref.read(chatRoomIdProvider);
    // Todo : 타입에 맞도록 파싱
    final dynamic value = ref.read(chatDialogValueProvider);
    final User? currentUser = FirebaseAuth.instance.currentUser;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (value['type'] == 'chat')
            Text('"${value['message']}" 채팅을 삭제하시겠습니까?').center,
          if (value['type'] == 'chat') MCSpace().verticalSpace(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              MCButtons().getPositiveButton(
                width: 100,
                title: '나에게서 삭제',
                onTap: () {
                  notifier.deleteChatFromMyself(
                    roomId: roomId,
                    chatId: value['id'],
                  );
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                },
              ),
              MCSpace().horizontalSpace(),
              MCButtons().getPositiveButton(
                width: 100,
                title: '모두에게서 삭제',
                onTap: () {
                  if (currentUser == null ||
                      value['createdBy'] != currentUser.uid) {
                    SnackBarCaller().callSnackBar(
                      ref,
                      '본인이 작성한 채팅만 모두에게서 삭제할 수 있어요.',
                    );
                    return;
                  }
                  notifier.deleteChatFromAll(
                    roomId: roomId,
                    chatId: value['id'],
                  );
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget dialogStateBrancher({
    required BuildContext context,
    required WidgetRef ref,
    required ChatDialogState state,
  }) {
    // 여기에 상태에 따라 다른 위젯을 반환하는 로직을 추가할 수 있습니다.
    // 예를 들어, 채팅 옵션에 따라 다른 위젯을 보여줄 수 있습니다.
    switch (state) {
      case ChatDialogState.initial:
        return buildInitialState(context, ref);
      case ChatDialogState.delete:
        return buildChatDeleteState(context, ref);
    }
  }
}
