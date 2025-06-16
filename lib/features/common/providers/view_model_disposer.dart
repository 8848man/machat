import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateProvider<bool> viewModelDisposerProvider =
    StateProvider<bool>((ref) {
  return false;
});
