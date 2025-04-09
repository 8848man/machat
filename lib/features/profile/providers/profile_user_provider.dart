import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/common/models/user_data.dart';

final profileUserProvider = StateProvider<UserData>((ref) {
  return const UserData(name: '알 수 없는 사용자');
});
