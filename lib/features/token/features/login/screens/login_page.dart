part of '../lib.dart';

class TokenLoginPage extends ConsumerWidget {
  const TokenLoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const DefaultLayout(
      child: Center(
        child: LoginBundle(),
      ),
    );
  }
}
