import 'package:machat/features/common/models/user_data.dart';
import 'package:machat/features/common/view_models/user_view_model.dart';
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
    final UserData userData = await ref.read(userViewModelProvider.future);

    return userData;
  }
}
