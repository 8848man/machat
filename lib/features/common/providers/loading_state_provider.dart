import 'package:flutter_riverpod/flutter_riverpod.dart';

// 로딩 상태를 관리하는 프로바이더
final loadingStateProvider =
    StateProvider<bool>((ref) => false);
