import 'package:firebase_auth/firebase_auth.dart';
import 'package:machat/features/common/models/user_data.dart';
import 'package:machat/features/drawer/models/drawer_model.dart';
import 'package:machat/features/drawer/repository/drawer_repository.dart';
import 'package:machat/router/lib.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mc_drawer_view_model.g.dart';

@riverpod
class MCDrawerViewModel extends _$MCDrawerViewModel {
  @override
  Future<DrawerModel> build() async {
    final DrawerModel data = await initData();

    return data;
  }

  Future<DrawerModel> initData() async {
    final repository = ref.read(drawerRepositoryProvider);
    final user = FirebaseAuth.instance.currentUser;

    // user 객체가 없을 경우 에러 처리
    if (user == null) return const DrawerModel();

    // 현재 로그인된 유저 uid로 유저 정보 가져오기
    final userData = await repository.read(user.uid);
    // 가져온 유저 정보를 파싱
    final userProfile = UserData.fromJson(userData);

    return DrawerModel(user: userProfile);
  }

  void goHome() {
    final router = ref.read(goRouterProvider);
    router.goNamed(RouterPath.home.name);
  }

  void goLogin() {
    final router = ref.read(goRouterProvider);
    router.goNamed(RouterPath.login.name);
  }

  void goChat() {
    final router = ref.read(goRouterProvider);
    router.goNamed(RouterPath.chat.name);
  }
}
