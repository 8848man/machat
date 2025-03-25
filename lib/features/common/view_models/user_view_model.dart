import 'package:firebase_auth/firebase_auth.dart';
import 'package:machat/features/common/models/user_data.dart';
import 'package:machat/features/common/providers/user_profile_state.dart';
import 'package:machat/features/common/repositories/user_repository.dart';
import 'package:machat/router/lib.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_view_model.g.dart';

@riverpod
class UserViewModel extends _$UserViewModel {
  @override
  Future<UserData> build() async {
    final UserData data = await getUserData();

    return data;
  }

  Future<UserData> getUserData() async {
    // 유저 데이터를 이미 가져왔을 경우,
    // 가지고 있는 상태 리턴
    final UserData userProfile = ref.read(userProfileProvider);
    if (userProfile.id != null) {
      return userProfile;
    }

    final repository = ref.read(userRepository);
    final user = FirebaseAuth.instance.currentUser;

    // user 객체가 없을 경우 에러 처리
    if (user == null) return const UserData(name: 'guest');

    // 현재 로그인된 유저 uid로 유저 정보 가져오기
    // 후에 캐싱처리하도록 개선
    final userData = await repository.read(user.uid);

    // 가져온 유저 정보를 파싱
    final UserData uProfile = UserData.fromJson(userData);

    // 상태에 저장
    ref.read(userProfileProvider.notifier).state = uProfile;

    return uProfile;
  }

  // 로그아웃 처리
  Future<void> signOutProcess() async {
    final router = ref.read(goRouterProvider);
    await FirebaseAuth.instance.signOut();
    router.goNamed(RouterPath.login.name);
  }
}
