part of '../lib.dart';

class RegisterBundleFooter extends ConsumerWidget {
  const RegisterBundleFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final RegisterViewModel notifier =
        ref.read(registerViewModelProvider.notifier);
    final bool loadingState = ref.watch(loadingStateProvider);
    return Column(
      children: [
        MCButtons().getPositiveButton(
            title: '회원가입',
            onTap: () => notifier.registUser(),
            isLoading: loadingState,
            width: double.infinity),
        MCSpace().verticalSpace(),
        MCButtons().getNegativeButton(
          title: '뒤로가기',
          onTap: () => notifier.goLogin(),
          width: double.infinity,
        ),
      ],
    );
  }
}
