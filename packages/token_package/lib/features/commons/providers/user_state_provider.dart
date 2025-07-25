import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/token_user_data.dart';

StateProvider<TokenUserData> userStateProvider =
    StateProvider<TokenUserData>((ref) {
  return const TokenUserData(
    name: '',
    id: null,
    email: null,
    profileUrl: null,
    nationId: null,
    role: null,
  );
});
