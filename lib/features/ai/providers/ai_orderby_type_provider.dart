import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:machat/features/ai/view_models/ai_character_list_view_model.dart';

// 정렬 기준 변경
final aiOrderByTypeProvider = StateProvider<AiOrderByType>((ref) {
  return AiOrderByType.name;
});
