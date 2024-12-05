part of '../lib.dart';

class LoginBundleBody extends ConsumerWidget {
  const LoginBundleBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LoginViewModel notifier = ref.read(loginViewModelProvider.notifier);
    final LoginModel state = ref.watch(loginViewModelProvider);
    return Column(
      children: [
        inputEmailField(state, notifier),
        MCSpace().verticalHalfSpace(),
        inputPwdField(state, notifier),
      ],
    );
  }

  Widget inputEmailField(
    LoginModel state,
    LoginViewModel notifier,
  ) {
    return MCTextInput(
      controller: notifier.emailController,
      labelText: '이메일',
      error: state.emailErrorText != null ? Container() : null,
      // onChanged: (val) => notifier.emailChangeValidate(),
    );
  }

  Widget inputPwdField(
    LoginModel state,
    LoginViewModel notifier,
  ) {
    return MCTextInput(
      controller: notifier.pwdController,
      labelText: '비밀번호',
      errorText: state.pwdErrorText,
    );
  }
}
