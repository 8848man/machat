import 'package:firebase_auth/firebase_auth.dart';
import 'package:machat/features/cache/repositories/user_data_repository.dart';
import 'package:machat/features/common/models/user_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_cache.g.dart';

@riverpod
class ProfileCache extends _$ProfileCache {
  @override
  Future<UserData> build() async {
    final UserData data = await initData();

    return data;
  }

  Future<UserData> initData() async {
    final repository = ref.read(profileCacheRepositoryProvider);
    final user = FirebaseAuth.instance.currentUser;

    // user 객체가 없을 경우 에러 처리
    if (user == null) return const UserData(name: 'guest');

    // 현재 로그인된 유저 uid로 유저 정보 가져오기
    // 후에 캐싱처리하도록 개선
    final userData = await repository.read(user.uid);

    // 가져온 유저 정보를 파싱
    final UserData userProfile = UserData.fromJson(userData);

    return userProfile;
  }
}
