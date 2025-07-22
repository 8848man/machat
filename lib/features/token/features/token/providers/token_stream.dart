import 'package:machat/features/token/features/token/interfaces/token_service.dart';
import 'package:machat/features/token/features/token/models/lib.dart';
import 'package:machat/features/token/features/token/repositories/token_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'token_stream.g.dart';

@riverpod
class TokenStream extends _$TokenStream {
  ITokenService get _tokenService => ref.read(tokenServiceProvider);
  @override
  Stream<TokenModel> build(String userId) {
    return _tokenService.watchUserToken(userId);
  }
}
