import 'package:machat/features/common/models/user_data.dart';
import 'package:machat/features/common/view_models/user_view_model.dart';
import 'package:machat/features/profile/view_models/profile_view_model.dart';
import 'package:machat/router/lib.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friends_view_model.g.dart';

@riverpod
class FriendsViewModel extends _$FriendsViewModel {
  @override
  void build() {}
  Future<void> goProfile() async {
    // 유저 데이터가 없을 경우, 유저 데이터 가져오기
    final UserData userData = await ref.read(userViewModelProvider.future);
    // 프로필 상태 업데이트
    ref.read(profileViewModelProvider.notifier).updateUserData(userData);
    // 프로필 페이지로 이동
    ref.read(goRouterProvider).goNamed(RouterPath.profile.name);
  }
}
