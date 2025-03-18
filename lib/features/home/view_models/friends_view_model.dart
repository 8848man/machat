import 'package:machat/router/lib.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friends_view_model.g.dart';

@riverpod
class FriendsViewModel extends _$FriendsViewModel {
  @override
  void build() {}
  void goProfile() =>
      ref.read(goRouterProvider).goNamed(RouterPath.profile.name);
}
