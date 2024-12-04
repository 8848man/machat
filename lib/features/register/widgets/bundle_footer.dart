part of '../lib.dart';

class RegisterBundleFooter extends ConsumerWidget {
  const RegisterBundleFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final RegisterViewModel notifier =
        ref.read(registerViewModelProvider.notifier);
    return Column(
      children: [
        loginButton(notifier: notifier),
        MCSpace().verticalSpace(),
        goRegisterButton(notifier: notifier),
      ],
    );
  }

  Widget loginButton({required RegisterViewModel notifier}) {
    return GestureDetector(
      child: Container(
        height: 40,
        width: 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: MCColors.$color_blue_40,
        ),
        child: const Center(child: Text('회원가입')),
      ),
      onTap: () => notifier.registUser(),
    );
  }

  Widget goRegisterButton({required RegisterViewModel notifier}) {
    return GestureDetector(
      child: Container(
        height: 40,
        width: 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: MCColors.$color_grey_40,
        ),
        child: const Center(child: Text('뒤로가기')),
      ),
      onTap: () => notifier.goLogin(),
    );
  }
}
