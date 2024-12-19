part of '../lib.dart';

class RegisterBundleFooter extends ConsumerWidget {
  const RegisterBundleFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final RegisterViewModel notifier =
        ref.read(registerViewModelProvider.notifier);
    return Column(
      children: [
        MCButtons().getPositiveButton(
          title: '회원가입',
          onTap: () => notifier.registUser(),
        ),
        MCSpace().verticalSpace(),
        MCButtons().getNegativeButton(
          title: '뒤로가기',
          onTap: () => notifier.goLogin(),
        ),
      ],
    );
  }
}
