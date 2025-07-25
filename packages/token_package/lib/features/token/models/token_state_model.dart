import 'package:freezed_annotation/freezed_annotation.dart';
import '../lib.dart';

part 'token_state_model.freezed.dart';

@freezed
class TokenStateModel with _$TokenStateModel {
  const factory TokenStateModel({
    TokenModel? userToken,
    @Default([]) List<TokenLogModel> tokenLogs,
    @Default(false) bool isLoading,
    String? error,
  }) = _TokenStateModel;
}
