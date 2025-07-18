import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:machat/features/token/features/token/models/token_log_model.dart';
import 'package:machat/features/token/features/token/models/token_model.dart';

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
