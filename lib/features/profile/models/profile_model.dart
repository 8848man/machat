import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:machat/features/common/models/user_data.dart';

part 'profile_model.freezed.dart';

@freezed
class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    @Default(UserData(name: 'guest')) UserData user,
  }) = _ProfileModel;
}
