import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/token/features/token/screens/lib.dart';

class MCTokenScreen extends ConsumerWidget {
  const MCTokenScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const TokenPage();
  }
}
