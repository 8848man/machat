import 'package:firebase_auth/firebase_auth.dart';
import 'package:machat/features/common/models/user_data.dart';
import 'package:machat/features/common/providers/user_cache_providers.dart';
import 'package:machat/features/common/repositories/user_repository.dart';
import 'package:machat/features/common/utils/logout_util.dart';
import 'package:machat/router/lib.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_view_model.g.dart';

@riverpod
class UserViewModel extends _$UserViewModel {
  @override
  Future<UserData> build() async {
    final Map<String, dynamic> cachedData = ref.read(userCacheProvider);
    final UserData data = await getUserData(cachedData);

    return data;
  }

  Future<UserData> getUserData(Map<String, dynamic> cachedData) async {
    // 유저 데이터를 이미 가져왔을 경우,
    // 가지고 있는 상태 리턴
    final UserData cachedUser =
        UserData.fromJson(cachedData['user'] ?? {'name': 'guest'});
    if (cachedUser.id != null) {
      return cachedUser;
    }

    final user = FirebaseAuth.instance.currentUser;

    // user 객체가 없을 경우 에러 처리
    if (user == null) return const UserData(name: 'guest');

    // 현재 로그인된 유저 uid로 유저 정보 가져오기
    final repository = ref.read(userRepository);
    final userData = await repository.read(user.uid);

    // 가져온 유저 정보를 파싱
    final UserData uProfile = UserData.fromJson(userData);

    // 상태에 저장
    ref.read(userCacheProvider.notifier).addCache('user', uProfile.toJson());

    return uProfile;
  }

  // 로그아웃 처리
  Future<void> signOutProcess() async {
    final router = ref.read(goRouterProvider);
    // firebase 계정 로그아웃
    await FirebaseAuth.instance.signOut();
    // 로그인 캐쉬 클리어
    await logout(ref);
    // UserViewModel 재로딩
    await ref.read(userViewModelProvider.notifier).reload();

    router.goNamed(RouterPath.login.name);
  }

  Future<void> reload() async {
    state = const AsyncLoading(); // 상태 초기화
    state = await AsyncValue.guard(() async {
      final cache = ref.read(userCacheProvider);
      return await getUserData(cache);
    });
  }
}
