import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../interfaces/token_service.dart';
import '../models/lib.dart';
import '../repositories/token_repository.dart';

part 'token_stream.g.dart';

@riverpod
class TokenStream extends _$TokenStream {
  ITokenService get _tokenService => ref.read(tokenServiceProvider);
  @override
  Stream<TokenModel> build(String userId) {
    return _tokenService.watchUserToken(userId);
  }
}
