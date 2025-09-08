import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatMenu extends ConsumerWidget {
  const ChatMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Builder(
      builder: (context) => IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          Scaffold.of(context).openEndDrawer(); // ✅ 작동함
        },
      ),
    );
  }
}
