// 애니메이션 상태 관리용 Provider (선택 사항)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final animationControllerProvider =
    StateProvider.autoDispose<AnimationController?>((ref) => null);
