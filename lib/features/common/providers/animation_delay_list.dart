import 'package:flutter_riverpod/flutter_riverpod.dart';

final animationDelayListProvider = StateProvider<List<int>>((ref) {
  return List.generate(10, (index) => index * 100);
});
