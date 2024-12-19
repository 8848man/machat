part of '../lib.dart';

class LoginBundleFooter extends ConsumerWidget {
  const LoginBundleFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LoginViewModel notifier = ref.read(loginViewModelProvider.notifier);
    return Column(
      children: [
        MCButtons().getPositiveButton(
          title: '로그인',
          onTap: () => notifier.login(),
        ),
        MCSpace().verticalSpace(),
        MCButtons().getNegativeButton(
          title: '회원가입',
          onTap: () => notifier.goRegister(),
        ),
      ],
    );
  }
}
