import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/chat/expand/enums/expand_state.dart';

// expand 위젯의 위젯 상태 관리 프로바이더
final expandWidgetStateProvider = StateProvider<ExpandWidgetState>(
  (ref) => ExpandWidgetState.collapsed,
);
