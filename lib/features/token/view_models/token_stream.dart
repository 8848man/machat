import 'package:machat/features/token/interfaces/token_service.dart';
import 'package:machat/features/token/models/token_model.dart';
import 'package:machat/features/token/repositories/token_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'token_stream.g.dart';

@riverpod
class TokenStream extends _$TokenStream {
  TokenService get _tokenService => ref.read(tokenServiceProvider);
  @override
  Stream<TokenModel> build(String userId) {
    return _tokenService.watchUserToken(userId);
  }
}
