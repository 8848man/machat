import 'package:flutter_riverpod/flutter_riverpod.dart';

StateProvider<bool> isSelectingCharacterProvider = StateProvider<bool>((ref) {
  return false;
});
