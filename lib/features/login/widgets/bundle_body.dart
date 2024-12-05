part of '../lib.dart';

class LoginBundleBody extends ConsumerWidget {
  const LoginBundleBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LoginPageViewModel notifier =
        ref.read(loginPageViewModelProvider.notifier);
    return Column(
      children: [idInput(notifier)],
    );
  }

  Widget idInput(LoginPageViewModel notifier) {
    return const TextField();
  }
}
