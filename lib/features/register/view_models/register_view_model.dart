import 'package:machat/router/lib.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'register_view_model.g.dart';

@riverpod
class RegisterViewModel extends _$RegisterViewModel {
  @override
  Future<void> build() async {
    // final LessonAreaData areaData = await getLessonAreaList();

    // return areaData;
  }

  void registUser() {
    final router = ref.read(goRouterProvider);
    router.goNamed(RouterPath.login.name);
  }

  void goLogin() {
    final router = ref.read(goRouterProvider);
    router.goNamed(RouterPath.login.name);
  }
}
