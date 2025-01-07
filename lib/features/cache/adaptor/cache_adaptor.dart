import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/cache/view_models/cache_view_model.dart';

// CacheViewModel 참조자
class CacheAdaptor extends ConsumerWidget {
  final Widget child;
  const CacheAdaptor({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(cacheViewModelProvider);
    return child;
  }
}
