import 'package:flutter_riverpod/flutter_riverpod.dart';

// 채팅방 하단 추가 기능 위젯 확장 여부
final chatExpandTokenProvider = StateProvider<bool>((ref) {
  return false;
});
