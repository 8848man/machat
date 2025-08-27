import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AiCharacterList extends ConsumerWidget {
  const AiCharacterList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: [
        ListTile(
          title: Text('Character 1'),
          onTap: () {
            // Navigate to character detail
          },
        ),
        ListTile(
          title: Text('Character 2'),
          onTap: () {
            // Navigate to character detail
          },
        ),
        // Add more characters as needed
      ],
    );
  }
}
