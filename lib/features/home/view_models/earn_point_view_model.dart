import 'package:machat/router/lib.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'earn_point_view_model.g.dart';

@riverpod
class EarnPointViewModel extends _$EarnPointViewModel {
  @override
  void build() {}

  void goStudyEnglish() {
    final router = ref.read(goRouterProvider);
    router.pushNamed(RouterPath.study.name);
  }

  void goAiCreate() {
    final router = ref.read(goRouterProvider);
    router.pushNamed(RouterPath.ai.name);
  }
}
