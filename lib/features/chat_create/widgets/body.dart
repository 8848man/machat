part of '../lib.dart';

class ChatCreateBody extends ConsumerWidget {
  const ChatCreateBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(chatCreateViewModelProvider.notifier);
    final state = ref.watch(chatCreateViewModelProvider);
    return Column(
      children: [
        inputNameField(state, notifier),
        MCSpace().verticalHalfSpace(),
        isOpenChat(ref),
        // inputPwdField(state, notifier),
      ],
    );
  }

  Widget inputNameField(
    ChatCreateModel state,
    ChatCreateViewModel notifier,
  ) {
    return MCTextInput(
      controller: notifier.roomNameController,
      labelText: '채팅방 이름',
      error: state.roomNameErrorText != null ? Container() : null,
      // onChanged: (val) => notifier.emailChangeValidate(),
    );
  }

  Widget isOpenChat(WidgetRef ref) {
    return GestureDetector(
      child: const Row(
        children: [
          MyCheckboxView(),
          Text(
            '채팅방을 공개합니다',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      onTap: () {
        ref.read(checkboxStateProvider.notifier).state =
            !ref.read(checkboxStateProvider.notifier).state;
      },
    );
  }

  // Widget inputPwdField(
  //   LoginModel state,
  //   LoginViewModel notifier,
  // ) {
  //   return MCTextInput(
  //     controller: notifier.pwdController,
  //     labelText: '비밀번호',
  //     errorText: state.pwdErrorText,
  //   );
  // }
}
