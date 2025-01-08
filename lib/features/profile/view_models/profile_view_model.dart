import 'package:firebase_auth/firebase_auth.dart';
import 'package:machat/features/common/models/user_data.dart';
import 'package:machat/features/drawer/repository/drawer_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_view_model.g.dart';

@riverpod
class ProfileViewModel extends _$ProfileViewModel {
  @override
  Future<UserData> build() async {
    final UserData data = await initData();

    return data;
  }

  Future<UserData> initData() async {
    final repository = ref.read(drawerRepositoryProvider);
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
