part of '../lib.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const DefaultLayout(
      child: Center(
        child: LoginBundle(),
      ),
    );
  }
}
