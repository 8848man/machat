part of '../lib.dart';

class RegisterBundleBody extends ConsumerWidget {
  const RegisterBundleBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final RegisterModel state = ref.watch(registerViewModelProvider);
    final RegisterViewModel notifier =
        ref.read(registerViewModelProvider.notifier);

    return Column(
      children: [
        inputEmailField(state, notifier),
        MCSpace().verticalHalfSpace(),
        inputPwdField(state, notifier),
        MCSpace().verticalHalfSpace(),
        inputNameField(state, notifier),
      ],
    );
  }

  Widget inputEmailField(
    RegisterModel state,
    RegisterViewModel notifier,
  ) {
    return MCTextInput(
      controller: notifier.emailController,
      labelText: '이메일',
      errorText: state.emailErrorText,
      onChanged: (val) => notifier.emailChangeValidate(),
      onSubmitted: (a) => notifier.registUser(),
    );
  }

  Widget inputPwdField(
    RegisterModel state,
    RegisterViewModel notifier,
  ) {
    return MCTextInput(
      controller: notifier.pwdController,
      labelText: '비밀번호',
      errorText: state.pwdErrorText,
      isObscure: true,
      onSubmitted: (a) => notifier.registUser(),
    );
  }

  Widget inputNameField(
    RegisterModel state,
    RegisterViewModel notifier,
  ) {
    return MCTextInput(
      controller: notifier.nameController,
      labelText: '이름',
      errorText: state.nameErrorText,
      onChanged: (val) => notifier.nameChangeValidate(),
      onSubmitted: (a) => notifier.registUser(),
    );
  }
}
