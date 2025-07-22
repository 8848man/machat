part of '../lib.dart';

class LoginBundleFooter extends ConsumerWidget {
  const LoginBundleFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LoginViewModel notifier = ref.read(loginViewModelProvider.notifier);
    final bool loadingState = ref.watch(loadingStateProvider);
    return Column(
      children: [
        MCButtons().getPositiveButton(
          title: '로그인',
          onTap: () => notifier.login(),
          isLoading: loadingState,
          width: double.infinity,
        ),
        MCSpace().verticalSpace(),
        MCButtons().getNegativeButton(
          title: '회원가입',
          onTap: () => notifier.goRegister(),
          width: double.infinity,
        ),
      ],
    );
  }
}
