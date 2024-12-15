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
        // MCSpace().verticalHalfSpace(),
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
