part of '../lib.dart';

class LoginBundleFooter extends ConsumerWidget {
  const LoginBundleFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LoginPageViewModel notifier =
        ref.read(loginPageViewModelProvider.notifier);
    return Column(
      children: [
        loginButton(notifier: notifier),
        MCSpace().verticalSpace(),
        goRegisterButton(notifier: notifier),
      ],
    );
  }

  Widget loginButton({required LoginPageViewModel notifier}) {
    return GestureDetector(
      child: Container(
        height: 40,
        width: 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: MCColors.$color_blue_40,
        ),
        child: const Center(child: Text('로그인')),
      ),
      onTap: () => notifier.login(),
    );
  }

  Widget goRegisterButton({required LoginPageViewModel notifier}) {
    return GestureDetector(
      child: Container(
        height: 40,
        width: 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: MCColors.$color_grey_40,
        ),
        child: const Center(child: Text('회원가입')),
      ),
      onTap: () => notifier.goRegister(),
    );
  }
}
