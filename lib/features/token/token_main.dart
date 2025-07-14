import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/token/features/login/lib.dart';

void main() async {
  await init();

  runApp(
    const ProviderScope(
      child: TokenMain(),
    ),
  );
}

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
}

class TokenMain extends ConsumerWidget {
  const TokenMain({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const TokenLoginPage();
  }
}
