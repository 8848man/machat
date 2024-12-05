import 'package:machat/router/lib.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mc_drawer_view_model.g.dart';

@riverpod
class MCDrawerViewModel extends _$MCDrawerViewModel {
  @override
  Future<void> build() async {
    // final LessonAreaData areaData = await getLessonAreaList();

    // return areaData;
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
