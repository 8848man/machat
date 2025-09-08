import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/ai/presentation/enums/ai_orderby_type.dart';

// 정렬 기준 변경
final aiOrderByTypeProvider = StateProvider<AiOrderByType>((ref) {
  return AiOrderByType.name;
});
