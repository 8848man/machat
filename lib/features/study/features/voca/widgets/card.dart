import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VocaCard extends ConsumerWidget {
  const VocaCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Text("voca card!"),
    );
  }
}
