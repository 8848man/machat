part of '../lib.dart';

class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const DefaultLayout(
      child: RegisterBundle(),
    );
  }
}
