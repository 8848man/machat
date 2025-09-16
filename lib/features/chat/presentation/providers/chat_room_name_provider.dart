import 'package:flutter_riverpod/flutter_riverpod.dart';

StateProvider<String> chatRoomNameProvider = StateProvider<String>((ref) {
  return '채팅방';
});
